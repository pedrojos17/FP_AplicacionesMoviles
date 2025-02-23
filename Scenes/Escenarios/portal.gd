extends Node2D

var send_ninja_to = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	var portals = get_tree().get_nodes_in_group("portal")
	for i in range (portals.size()):
		if portals[i].position != position:
			send_ninja_to = portals[i].position
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_teletransport_area_entered(area):
	if area.get_parent().is_in_group("ninja"):
		area.get_parent().position = send_ninja_to
		$audioPortal.play()
