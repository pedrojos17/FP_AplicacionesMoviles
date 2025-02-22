extends CharacterBody2D

const SPEED = 200.0
const RAY_FLOOR_POSITION_X = 16
const RAY_WALL_TARGET_POSITION_X = 12

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: float = 1.0

func _ready():
	velocity.x = SPEED
	$raycast_floor_detection.position.x = RAY_FLOOR_POSITION_X
	$raycast_wall_detection.target_position.x = RAY_WALL_TARGET_POSITION_X

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if not $raycast_floor_detection.is_colliding() or $raycast_wall_detection.is_colliding():
		direction *= -1
		$raycast_floor_detection.position.x *= -1
		$raycast_wall_detection.target_position.x *= -1

	velocity.x = direction * SPEED

	move_and_slide()


func _on_damage_zone_area_entered(area):
	if area.is_in_group("shuriken"):
		$animaciones_saw.play("die")
		


func _on_animaciones_saw_animation_finished() -> void:
	self.queue_free()
