extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var direction: float = 0.0
var health = 100
var fruit_count = 0
var allow_animation: bool = false
var leaved_floor: bool = false
var had_jump: bool = false
var max_jump: int = 2
var count_jumps: int = 0
var double_jump: bool = false
var ray_cast_dimension = 12  
var stuck_on_wall: bool = false
var gotShuriken = false

@export var shuriken: PackedScene
var colision_suelo  # Referencia a la colisión del suelo

func _ready():
	$animaciones.play("appear")
	$rayCast_wallJump.target_position.x = ray_cast_dimension

	# Buscar el nodo colisionSuelo en la escena
	colision_suelo = get_tree().current_scene.get_node_or_null("colisionSuelo")

	if colision_suelo:
		colision_suelo.connect("body_entered", Callable(self, "_on_colisionSuelo_body_entered"))

func _physics_process(delta: float) -> void:
	if is_on_floor():
		leaved_floor = false
		had_jump = false
		count_jumps = 0

	# Verifica si el personaje está tocando el colisionSuelo y muere automáticamente
	if colision_suelo and self.get_collision_mask_value(colision_suelo.collision_layer):
		health = 0
		muerte()
		return

	if not is_on_floor():
		if not leaved_floor:
			$salto_timer.start()
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta

	if Input.is_action_just_pressed("ui_accept") and right_to_jump():
		if count_jumps == 1:
			double_jump = true
			$audioDobleJump.play()
		else:
			$audiojump.play()
		velocity.y = JUMP_VELOCITY
		count_jumps += 1

	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	decide_animation()

	if $rayCast_wallJump.is_colliding():
		var collider = $rayCast_wallJump.get_collider()
		if collider and collider.is_in_group("wall_jump"):
			if velocity.y > 0:
				velocity.y = 0
				stuck_on_wall = true
				count_jumps = 0
		else:
			stuck_on_wall = false
	else:
		stuck_on_wall = false

func decide_animation():
	if direction < 0:
		$animaciones.flip_h = true
		$rayCast_wallJump.target_position = -Vector2(ray_cast_dimension, $rayCast_wallJump.target_position.y)
	elif direction > 0:
		$animaciones.flip_h = false
		$rayCast_wallJump.target_position = Vector2(ray_cast_dimension, $rayCast_wallJump.target_position.y)

	if double_jump:
		double_jump = false
		allow_animation = false
		$animaciones.play("doble_jump")

	if not allow_animation:
		return

	if stuck_on_wall:
		$animaciones.play("wall_jump")
	else:
		if is_on_floor():
			if velocity.x == 0:
				$animaciones.play("idle")
			else:
				$animaciones.play("run")
		else:
			if velocity.y > 0:
				$animaciones.play("jump_down")
			else:
				$animaciones.play("jump_up")

func _input(event):
	if event.is_action_pressed("shuriken"):
		if gotShuriken: return
		gotShuriken = true
		allow_animation = false
		$animaciones.play("shuriken_launch")
		var newShuriken = shuriken.instantiate()
		newShuriken.position = self.position
		newShuriken.isFlip = $animaciones.flip_h
		newShuriken.connect("shuriken_destroyed", _on_shuri_destroyed)
		add_sibling(newShuriken)

func _on_shuri_destroyed():
	gotShuriken = false

func right_to_jump():
	if had_jump:
		return count_jumps < max_jump
	if is_on_floor() or stuck_on_wall:
		had_jump = true
		return true
	elif not $salto_timer.is_stopped() and not had_jump:
		had_jump = true
		return true
	return false

func _on_animaciones_animation_finished() -> void:
	allow_animation = true

func _on_salto_timer_timeout() -> void:
	pass

func _on_damage_detection_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.name == "colisionSuelo":
		health = 0
		muerte()
	else:
		if health > 0:
			health -= 30
			$audioDamage.play()
			allow_animation = false
			$animaciones.play("hit")
			velocity.y = -300
			muerte()

func collectFruit(fruitType):
	var auxString = fruitType + "Points"
	var gaindePoints = GeneralRules[auxString]
	fruit_count += gaindePoints
	$audiojump.play()

# -------------------- DETECTAR MUERTE -------------------- #

func muerte():
	if health <= 0:
		ejecutar_muerte()

func _on_colisionSuelo_body_entered(body):
	if body == self:
		health = 0
		muerte()

func ejecutar_muerte():
	get_tree().paused = true  
	$animaciones.play("hit")  

	var canvas_layer = get_tree().current_scene.get_node_or_null("dieInfo")
	if canvas_layer:
		canvas_layer.visible = true
