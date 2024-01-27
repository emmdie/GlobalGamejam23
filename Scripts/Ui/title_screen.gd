extends Control
@onready var parallax = $ParallaxBackground

func _process(delta):
	parallax.scroll_offset = get_global_mouse_position()*0.14

func _on_repo_link_button_pressed():
	OS.shell_open("https://github.com/emmdie/GlobalGamejam23")

func _on_credits_button_pressed():
	OS.shell_open("https://github.com/emmdie/GlobalGamejam23/blob/main/credits.md")

func _on_exit_button_pressed():
	get_tree().quit()

func load_level(level_scene):
	var scene = load(level_scene)
	var level = scene.instantiate()
	get_tree().root.add_child(level)
	queue_free()
	
func _on_test_level_button_pressed():
	load_level(SceneList.test_level)
	
func _on_level_0_button_pressed():
	load_level(SceneList.Tutorial)
