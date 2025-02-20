extends Node2D

# Tamaño de cada anilla: 6 píxeles

var floorDetected = false
var rayCastInitValue = 30 # píxeles iniciales raycast
var safeTime = false

func _ready():
	$raycast_floor_detection.target_position.y = rayCastInitValue

func _process(delta):
	if not floorDetected || safeTime:
		$raycast_floor_detection.target_position.y += 1
		if $raycast_floor_detection.is_colliding():
			floorDetected = true
			$raycast_floor_detection.target_position.y -= 3
			init_spikeball()

func init_spikeball():
	var numberOfChains = int(($raycast_floor_detection.target_position.y - rayCastInitValue) / 6)
	$SpikedBall.position.y += (numberOfChains * 6)
	for i in range(numberOfChains):
		var newRing = preload("res://Scenes/Enemys/oneChain.tscn").instantiate()
		newRing.position = Vector2(0, (6*(i+1)))
		self.add_child(newRing)
	$Animation_rotation.play("regular_move")

func _on_safe_time_timeout() -> void:
	safeTime = true


func _on_area_colision_with_map_body_entered(body):
	$Animation_rotation.speed_scale *=-1
