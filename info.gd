extends Node2D

@onready var menuPopUp : Node2D = $MenuPopUp
# Called when the node enters the scene tree for the first time.
func _ready():
	menuPopUp.visible=false
	if get_parent().has_node("ninjaFrog"):
		$healt_ProgressBar.value = get_parent().get_node("ninjaFrog").health
		$FruitPointsLabel.text = "FruitPoints: " + str(get_parent().get_node("ninjaFrog").fruit_count)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$healt_ProgressBar.value = get_parent().get_node("ninjaFrog").health
	$FruitPointsLabel.text = "FruitPoints: " + str(get_parent().get_node("ninjaFrog").fruit_count)


func _on_menu_pressed() -> void:
	get_parent().stop = true
	menuPopUp.visible = get_tree().paused


func _on_music_pressed() -> void:
	pass # Replace with function body.


func _on_sounds_pressed() -> void:
	pass # Replace with function body.


func _on_resume_pressed() -> void:
	get_parent().stop = false
	menuPopUp.visible = get_tree().paused


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
