extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Screens/Screen1.tscn")

func _on_exit_pressed() -> void:
	print("Saliendo del juego...")  # Mensaje de depuración en consola
	get_tree().quit()
