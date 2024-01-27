extends Control

signal main_menu

var next_level: PackedScene

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _on_main_menu_button_pressed():
	get_tree().paused = false
	main_menu.emit()


func _on_next_level_button_pressed():
	get_tree().change_scene_to_packed(next_level)


func _on_retry_pressed():
	get_tree().reload_current_scene()
