extends CanvasLayer

@onready var menuPopUp:Node2D = $MenuPopUp

# Called when the node enters the scene tree for the first time.
func _ready():
	menuPopUp.visible=false
	if get_parent().has_node("ninjaFrog"):
		$healt_ProgressBar.value = get_parent().get_node("ninjaFrog").health
		$FruitPointsLabel.text = "FruitPoints: " + str(get_parent().get_node("ninjaFrog").fruit_count)

func _process(_delta):
	$healt_ProgressBar.value = get_parent().get_node("ninjaFrog").health
	$FruitPointsLabel.text = "FruitPoints: " + str(get_parent().get_node("ninjaFrog").fruit_count)

	




func _on_music_pressed() -> void:
	pass # Replace with function body.


func _on_sounds_pressed() -> void:
	pass # Replace with function body.


func _on_resume_pressed() -> void:
	get_tree().reload_current_scene()
	get_tree().paused = false


func _on_restart_pressed() -> void:
	get_tree().paused = false
	menuPopUp.visible = get_tree().paused

func _on_menu_pressed() -> void:
	get_tree().paused = true
	menuPopUp.visible= true
	print("hola")
