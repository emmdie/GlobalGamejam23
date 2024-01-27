extends Control

func _on_texture_button_pressed():
	get_tree().paused = false
	queue_free()
