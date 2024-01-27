extends Control

func _on_repo_link_button_pressed():
	OS.shell_open("https://github.com/emmdie/GlobalGamejam23")

func _on_credits_button_pressed():
	OS.shell_open("https://github.com/emmdie/GlobalGamejam23/blob/main/credits.md")

func load_level(level_scene):
	var scene = load(level_scene)
	var level = scene.instantiate()
	get_tree().root.add_child(level)
	queue_free()
	
func _on_test_level_button_pressed():
	load_level(SceneList.test_level)
