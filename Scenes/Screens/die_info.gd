extends CanvasLayer

@onready var menuPopUp: Node2D = $MenuPopUp

func _ready() -> void:
	self.visible = false
	self.process_mode = Node.PROCESS_MODE_ALWAYS  # Mantener eventos incluso cuando está oculto
	print("CanvasLayer cargado correctamente")

	# Asegurar que el botón de restart esté correctamente conectado
	if has_node("MenuPopUp/restart"):
		var restart_button = $MenuPopUp/restart
		if not restart_button.is_connected("pressed", Callable(self, "_on_restart_pressed")):
			restart_button.connect("pressed", Callable(self, "_on_restart_pressed"))
			print("Botón restart conectado correctamente")
	else:
		print("ERROR: No se encontró el nodo 'restart' en 'MenuPopUp'.")

# Pausar el juego y mostrar el menú
func _on_button_menu_pressed() -> void:
	get_tree().paused = true
	menuPopUp.visible = true

# Reiniciar el nivel correctamente
func _on_restart_pressed() -> void:
	print("Reiniciando nivel...")
	get_tree().paused = false  # Despausar antes de reiniciar
	await get_tree().create_timer(0.1).timeout  # Evita conflictos de referencia
	get_tree().reload_current_scene()

# Salir al menú principal de forma limpia
func _on_exit_pressed() -> void:
	print("Regresando al menú principal...")
	get_tree().paused = false  # Despausar antes de salir
	await get_tree().create_timer(0.1).timeout  # Pequeño retraso para evitar problemas
	get_tree().change_scene_to_file("res://Scenes/Screens/menu_info.tscn")


func _on_touch_screen_button_pressed() -> void:
	pass # Replace with function body.
