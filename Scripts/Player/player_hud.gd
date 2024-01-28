extends Control


@onready var crosshair = get_node("CrossHair")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func flash_overlay(color: Color):
	var t = create_tween()
	t.tween_property($ColorRect, "color", color, 0.02)
	t.tween_property($ColorRect, "color", Color.TRANSPARENT, 0.1)

func fade(color: Color, time: float):
	var t = create_tween()
	t.tween_property($ColorRect, "color", color, time)
	return t.finished

func update_health(curr):
	var h = $HeartBar.get_children()[curr]
	var t = create_tween()
	t.tween_property(h, "scale", h.scale*1.1, 0.2).set_trans(Tween.TRANS_ELASTIC)
	t.chain().tween_property(h, "scale", Vector2.ZERO, 0.1)
	await t.finished
	h.visible = false
	
func play_weapon_fire():
	$HudAnimPlayer.play("weapon_fire")

func bump_crosshair():
	var t = create_tween()
	t.tween_property(crosshair, "scale", Vector2(1.5,1.5), 0.05)
	t.tween_property(crosshair, "scale", Vector2(1,1), 0.1)
	
