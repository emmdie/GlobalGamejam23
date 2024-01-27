extends Control

@onready var slides = SceneList.story_slides.duplicate()

var current_slide = null

func _ready():
	show_next_slide()
	
func show_next_slide():
	if slides.is_empty():
		var main_menu = load(SceneList.title_screen).instantiate()
		get_tree().root.add_child(main_menu)
		queue_free()
	else:
		if current_slide != null:
			current_slide.queue_free()
			current_slide = null
		var slide = slides.pop_front()
		slide = load(slide)
		slide = slide.instantiate()
		add_child(slide)
		current_slide = slide
		slide.next_slide.connect(show_next_slide)
		
