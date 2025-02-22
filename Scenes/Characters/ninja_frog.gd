extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var direction: float = 0.0
var health = 100
var fruit_count=0
var allow_animation: bool = false
var leaved_floor: bool = false
var had_jump : bool = false
var max_jump : int = 2
var count_jumps: int = 0
var double_jump: bool = false
var ray_cast_dimension = 12  # Mejor float para evitar más errores luego
var stuck_on_wall :bool = false
var gotShuriken =false

@export var shuriken:PackedScene

func _ready():
	$animaciones.play("appear")
	$rayCast_wallJump.target_position.x = ray_cast_dimension

func _physics_process(delta: float) -> void:
	#Si esta en el suelo que la variable leaved_floor se convierta a false para saber que el personaje esta en el suelo
	if is_on_floor(): 
		leaved_floor=false
		had_jump=false
		count_jumps=0
	# Añadir la gravedad.
	if not is_on_floor():
		if not leaved_floor:    
			$salto_timer.start()
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta
		
	# Manejar el salto.
	if Input.is_action_just_pressed("ui_accept") and right_to_jump():
		if count_jumps == 1:
			double_jump = true
			$audioDobleJump.play()
		else:
			$audiojump.play()
		velocity.y = JUMP_VELOCITY
		count_jumps+=1

	# Obtener la dirección y manejar el movimiento/desaceleración.
	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	decide_animation()

	# COMPROBACIÓN CORREGIDA DEL RAYCAST
	if $rayCast_wallJump.is_colliding():
		var collider = $rayCast_wallJump.get_collider()
		if collider.is_in_group("wall_jump"):
			if velocity.y>0:
				velocity.y=0
				stuck_on_wall=true
				count_jumps=0
		else: stuck_on_wall=false
	else: stuck_on_wall = false	

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
		# Eje de las X
		if is_on_floor():
			if velocity.x == 0:
				$animaciones.play("idle")
			elif velocity.x < 0:
				$rayCast_wallJump.target_position.x = -ray_cast_dimension
				$animaciones.play("run")
			elif velocity.x > 0:
				$rayCast_wallJump.target_position.x = ray_cast_dimension
				$animaciones.play("run")

		# Eje de las Y
		if not is_on_floor():
			if velocity.y > 0:
				$animaciones.play("jump_down")
			elif velocity.y < 0:
				$animaciones.play("jump_up")

func _input(event):
	if event.is_action_pressed("shuriken"): #tecla f
		if gotShuriken: return
		gotShuriken = true
		allow_animation=false
		$animaciones.play("shuriken_launch")
		var newShuriken = shuriken.instantiate()
		newShuriken.position = self.position
		newShuriken.isFlip = $animaciones.flip_h
		newShuriken.connect("shuriken_destroyed", _on_shuri_destroyed)
		add_sibling(newShuriken)

func _on_shuri_destroyed():
	gotShuriken=false

func right_to_jump():
	if had_jump:
		if count_jumps < max_jump:
			return true
		else:
			return false
	if is_on_floor() || stuck_on_wall:
		had_jump = true
		return true
	elif not $salto_timer.is_stopped() and not had_jump:
		had_jump = true
		return true
	return false

func _on_animaciones_animation_finished() -> void:
	allow_animation = true

func _on_salto_timer_timeout() -> void:
	pass # Replace with function body.


func _on_damage_detection_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	health-=30
	$audioDamage.play()
	allow_animation=false
	$animaciones.play("hit")
	velocity.y = -300
	muerte()

func collectFruit(fruitType):
	var auxString = fruitType + "Points"
	var gaindePoints = GeneralRules[auxString]
	fruit_count += gaindePoints
	$audiojump.play()

func muerte():
	if health <= 0:
		get_tree().paused = true  # Pausar el juego cuando el personaje muera
		$animaciones.play("hit")  # Si tienes una animación de muerte
		
		# Buscar la CanvasLayer de información y hacerla visible
		var canvas_layer = get_parent().get_node("dieInfo")  # Asegúrate del nombre correcto
		if canvas_layer:
			canvas_layer.visible = true
		else:
			print("ERROR: No se encontró la CanvasLayer de información")
