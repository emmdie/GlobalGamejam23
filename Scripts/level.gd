extends Node3D

var enemies_left = 0

func _ready():
	for enemy in $Enemies.get_children():
		enemies_left += 1
		enemy.enemy_died.connect(enemy_died)
	print("Enemy count: " + str(enemies_left))

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			pause_game()

func pause_game():
	var pause_screen = load(SceneList.pause_screen).instantiate()
	add_child(pause_screen)
	pause_screen.process_mode = PROCESS_MODE_ALWAYS
	pause_screen.main_menu.connect(change_to_main_menu)
	get_tree().paused = true

func level_won():
	await $Player.fade_to_wheat()
	var level_won_screen = load(SceneList.level_won_screen).instantiate()
	add_child(level_won_screen)
	level_won_screen.main_menu.connect(change_to_main_menu)
	get_tree().paused = true
	
func enemy_died():
	print("Enemies left: " + str(enemies_left))
	enemies_left -= 1
	if enemies_left <= 0:
		level_won()

func change_to_main_menu():
	var main_menu = load(SceneList.title_screen).instantiate()
	get_tree().root.add_child(main_menu)
	queue_free()
