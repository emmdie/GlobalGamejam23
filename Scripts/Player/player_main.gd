extends CharacterBody3D

class_name Player

# --- MOVEMENT VARS ---
const SPEED = 12
const ACCELERATION = 3
const FRICTION = 11

const AIR_SPEED = 9
const AIR_FRICTION = 8
const AIR_ACCELERATION = 3
const JUMP_VELOCITY = 12
const COYOTE_TIME = 0.3
const JUMP_APEX = 0.0

const DEFALUT_MOUSE_SENSITIVITY = 3.0

var mouse_sensitivity = DEFALUT_MOUSE_SENSITIVITY
var input_dir: Vector2
var in_coyote_time = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 32

@export var bulletHoleScene: PackedScene

@onready var coyoteTimer: Timer = get_node("CoyoteTimer")
@onready var weaponSprite: WeaponSprite = get_node("HUD/Weapon")
@onready var camera: Camera3D = get_node("Camera3D")
@onready var hud = get_node("HUD")
@onready var weaponCooldown: Timer = get_node("WeaponCooldown")

func _ready():
	add_to_group("players")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		in_coyote_time = true

	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if input_dir.y != 0:
		weaponSprite.do_bob(delta)
	
	_calculate_velocity(direction, delta)
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and _can_jump():
		velocity.y = JUMP_VELOCITY
		coyoteTimer.start(COYOTE_TIME)
	move_and_slide()

func _can_jump():
	return is_on_floor() || in_coyote_time

func _calculate_velocity(dir: Vector3, delta: float):
	var yvel = velocity.y
	var firction = FRICTION
	var accel = ACCELERATION
	var speed = SPEED
	
	#air_move
	if !is_on_floor():
		speed = AIR_SPEED
		accel = AIR_ACCELERATION
		firction = AIR_FRICTION

	if dir:
		velocity = lerp(velocity, dir * speed, accel * delta)
	else:
		velocity = lerp(velocity, Vector3.ZERO, firction * delta)
	
	velocity.y = yvel

func _input(event):
	if event.is_action_pressed("fire"):
		_fire_weapon()
		hud.bump_crosshair()

func _fire_weapon():
	if weaponCooldown.is_stopped():
		weaponCooldown.start()
		hud.play_weapon_fire()
		camera.rumble(0.5,0.5)
		var collision: Dictionary = camera.shoot_ray()
		if !collision.is_empty():
			var bh = bulletHoleScene.instantiate()
			get_parent().add_child(bh)
			bh.place(collision.position, collision.normal)


func _on_coyote_timer_timeout():
	in_coyote_time = false
