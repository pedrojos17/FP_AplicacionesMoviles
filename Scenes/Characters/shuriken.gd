extends Node2D

var velocidad=Vector2(450, -200)
var gravity = 9.8
var isFlip=false

signal shuriken_destroyed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start()
	if isFlip:
		velocidad.x *= -1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocidad.y += gravity
	position += velocidad * delta


func _on_area_2d_body_entered(body):
	$AnimationPlayer.stop()
	velocidad=Vector2(0,0)
	$ShurikenPronta.play("die")
	gravity=0


func _on_shuriken_pronta_animation_finished():
	_destroy_myself()


func _on_timer_timeout():
	_destroy_myself()

func _destroy_myself():
	emit_signal("shuriken_destroyed")
	self.queue_free()
