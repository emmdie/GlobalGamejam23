extends Control


@onready var crosshair = get_node("CrossHair")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play_weapon_fire():
	$HudAnimPlayer.play("weapon_fire")

func bump_crosshair():
	var t = create_tween()
	t.tween_property(crosshair, "scale", Vector2(1.5,1.5), 0.05)
	t.tween_property(crosshair, "scale", Vector2(1,1), 0.1)
	
