extends Control

signal main_menu

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _on_continue_button_pressed():
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	queue_free()
	
func _on_quit_game_button_2_pressed():
		get_tree().quit()

func _on_main_menu_button_pressed():
	get_tree().paused = false
	main_menu.emit()
	queue_free()
