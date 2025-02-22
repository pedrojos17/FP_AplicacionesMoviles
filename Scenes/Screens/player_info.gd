extends CanvasLayer

@onready var menuPopUp: Node2D = $MenuPopUp

# Llamado cuando el nodo entra en la escena
func _ready():
	inicia_slider()
	menuPopUp.visible = false
	if get_parent() and get_parent().has_node("ninjaFrog"):
		var ninjaFrog = get_parent().get_node("ninjaFrog")
		if ninjaFrog:
			$healt_ProgressBar.value = ninjaFrog.health
			$FruitPointsLabel.text = "FruitPoints: " + str(ninjaFrog.fruit_count)

# Actualizar cada frame
func _process(_delta):
	if get_parent() and get_parent().has_node("ninjaFrog"):
		var ninjaFrog = get_parent().get_node("ninjaFrog")
		if ninjaFrog:
			$healt_ProgressBar.value = ninjaFrog.health
			$FruitPointsLabel.text = "FruitPoints: " + str(ninjaFrog.fruit_count)

# Botón de menú (Pausa el juego)
func _on_button_menu_pressed() -> void:
	get_tree().paused = true  # Usar get_tree().paused en lugar de stop
	menuPopUp.visible = true

# Botón de reinicio
func _on_restart_pressed() -> void:
	var tree = get_tree()
	if tree:
		tree.reload_current_scene()
		# Esperar un pequeño tiempo antes de cambiar el estado de pausa
		tree.paused = false

# Botón de reanudar
func _on_resume_pressed() -> void:
	get_tree().paused = false
	menuPopUp.visible = false




func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, value-100)


func _on_sound_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, value-100)

func inicia_slider():
	for slider in menuPopUp.get_children():
		if slider is HSlider:
			slider.value=100
	
