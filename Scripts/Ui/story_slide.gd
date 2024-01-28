extends Control

enum STATE {PLAYING, FINISHED}

@onready var text = $ParallaxBackground/ParallaxLayer/SlideTextDisplay
@onready var parallax = $ParallaxBackground
@onready var keyboardSound = $keyBoardSound
@onready var state = STATE.PLAYING

signal next_slide

func _ready():
	text.visible_characters = 0

func _process(delta):
	parallax.scroll_offset = get_global_mouse_position()*0.14
	
func _on_character_timer_timeout():
	if text.get_total_character_count() == text.visible_characters:
		state = STATE.FINISHED
		$CharacterTimer.queue_free()
		return
	text.visible_characters += 1
	keyboardSound.play()

func _on_next_button_pressed():
	go_on()
	
func go_on():
	if state == STATE.PLAYING:
		state = STATE.FINISHED
		text.visible_characters = text.get_total_character_count()
	else:
		next_slide.emit()
		
func _input(event):
	if event is InputEventKey and event.pressed:
		go_on()
	elif event is InputEventMouseButton and event.pressed:
		print(event)
		go_on()
