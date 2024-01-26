extends TextureRect

class_name WeaponSprite

@export var horizontal_sway: Curve
@export var vertical_sway: Curve
@export var sway_factor = 80
@export var sway_speed = 0.017

@onready var initial_position := position

var _sway_step = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func do_bob(delta):
	var t := wrapf(_sway_step, 0.0, 1.0)
	position = initial_position + Vector2(horizontal_sway.sample(t) * sway_factor, -vertical_sway.sample(t) * sway_factor)
	_sway_step += sway_speed
