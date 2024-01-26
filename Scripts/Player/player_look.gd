extends Camera3D


const SWAY_EFFECT = 0.06
const SWAY_LERP = 0.05

@export var y_limit := 90.0
@onready var player: Player = get_parent()
@onready var original_cam_position = position


var mouse_axis := Vector2()
var _mouse_sensitivity: float = 0.0
var _time: float
var _current_recoil: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_parent().ready
	update_mouse_sensitivity()
	y_limit = deg_to_rad(y_limit)

func update_mouse_sensitivity():
	_mouse_sensitivity = player.mouse_sensitivity / 1000


func shoot_ray() -> Dictionary:
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position,global_position - global_transform.basis.z * 100)
	return space.intersect_ray(query)
	

# Called when there is an input event
func _input(event: InputEvent) -> void:
	# Mouse look (only if the mouse is captured).
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_axis = event.relative
		camera_rotation()

# Called every physics tick. 'delta' is constant
func _physics_process(delta: float) -> void:	
	_reset_cam()
	_sway()

func _sway():
	rotation.z = lerp(rotation.z, -clamp(player.input_dir.x, -SWAY_EFFECT, SWAY_EFFECT), SWAY_LERP)

func rumble(x,y):
	position.x = randf_range(position.x-x, position.x+x)
	position.y = randf_range(position.y-y, position.y+y)

func _reset_cam():
	position = lerp(position, original_cam_position, 0.2)

func camera_rotation() -> void:
	get_owner().rotation.y -= mouse_axis.x * _mouse_sensitivity
	rotation.x = clamp(rotation.x + (_current_recoil + (-mouse_axis.y * _mouse_sensitivity)), -y_limit, y_limit)
