extends Node3D

@export var next_stage: PackedScene

var enemies_left = 0
var gong_player = AudioStreamPlayer3D.new()

func _ready():
	get_tree().paused = false
	$Player.player_died.connect(player_died)
	gong_player.stream = load("res://Assets/Sounds/gong.wav")
	gong_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(gong_player)
	for enemy in $Enemies.get_children():
		enemies_left += 1
		enemy.enemy_died.connect(enemy_died)
	SceneList.totalEnemies = enemies_left
	SceneList.currentEnemies = 0

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
	gong_player.play()
	await $Player.fade_to_wheat()
	var level_won_screen = load(SceneList.level_won_screen).instantiate()
	level_won_screen.next_level = next_stage
	add_child(level_won_screen)
	level_won_screen.main_menu.connect(change_to_main_menu)
	get_tree().paused = true
	
func enemy_died():
	print("Enemies left: " + str(enemies_left))
	enemies_left -= 1
	if enemies_left <= 0:
		level_won()
	SceneList.currentEnemies += 1

func player_died():
	var level_loose_screen = load(SceneList.level_loose_screen).instantiate()
	add_child(level_loose_screen)
	level_loose_screen.main_menu.connect(change_to_main_menu)
	get_tree().paused = true

func change_to_main_menu():
	var main_menu = load(SceneList.title_screen).instantiate()
	get_tree().root.add_child(main_menu)
	queue_free()
