extends Control

@onready var text = $ParallaxBackground/ParallaxLayer/SlideTextDisplay
@onready var parallax = $ParallaxBackground
@onready var keyboardSound = $keyBoardSound
enum STATE {PLAYING, FINISHED}

var state

func _ready():
	text.visible_characters = 0

func _process(delta):
	parallax.scroll_offset = get_global_mouse_position()*0.14
	
func _on_character_timer_timeout():
	if text.get_total_character_count() == text.visible_characters:
		return
	text.visible_characters += 1
	keyboardSound.play()
