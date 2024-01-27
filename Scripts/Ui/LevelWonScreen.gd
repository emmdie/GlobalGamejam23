extends Control

signal main_menu

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
func _on_main_menu_button_pressed():
	get_tree().paused = false
	main_menu.emit()
