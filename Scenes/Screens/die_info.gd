extends CanvasLayer

# Se oculta al inicio
func _ready() -> void:
	self.visible = false
	print("CanvasLayer cargado correctamente")
	print(get_tree().current_scene)


func _on_restart_pressed() -> void:
	var tree = get_tree()
	print("hola")
	if tree:
		tree.reload_current_scene()
		# Esperar un pequeño tiempo antes de cambiar el estado de pausa
		tree.paused = false

func _on_exit_pressed() -> void:
	get_tree().quit()
