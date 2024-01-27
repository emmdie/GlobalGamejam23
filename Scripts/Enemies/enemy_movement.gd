extends CharacterBody3D

class_name EnemyBase

@export var health: int = 100
@export var points: int = 10
@export var death_free_time: float = 5
@export var speed: float = 4.0
@export var sense_radius: float = 20
@export var hit_radius = 20

@onready var player
@onready var free_timer = Timer.new()
@onready var push_force: float = 0

var SELF_PUSH_MOD = 1.5
var PUSH_FORCE = 90
var push_vel: Vector3 = Vector3.ZERO

var dead = false

signal enemy_died

@export var smiles : Array[CompressedTexture2D]

func _ready():
	free_timer.one_shot = true
	add_to_group("enemies")
	add_child(free_timer)
	player = get_tree().get_nodes_in_group("players")[0]

	add_to_group("crawlers")
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5
	speed += randf_range(-2,1.4)
	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func hit(dmg, normal):
	if dead: return
	$Sprite/EnemySprite/AnimationPlayer.stop()
	die()
	var smileTex = smiles[randi_range(0, smiles.size()-1)]
	$Sprite/EnemySprite/Smile.texture = smileTex
	push_vel = -velocity.normalized() * 240
	$Sprite/EnemySprite/Smile.visible = true
	$SFX/Hit.playQueue()
	health -= dmg
	await get_tree().create_timer(0.2).timeout
	$SFX/Laugth.playQueue()

func die(give_points: bool = true):
	if dead: return
	dead = true
	emit_signal("enemy_died")
	return

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

var should_move = false

func collision() -> CollisionObject3D:
	return $CollisionShape3D

func _physics_process(delta):
	if dead: return
	if global_position.distance_to(player.global_position) < sense_radius:
		look_at(player.global_position)
		var mt = player.global_position
		mt.x += randf_range(-0.4, 0.4)
		mt.z += randf_range(-0.4, 0.4)
		set_movement_target(mt)
	if global_position.distance_to(player.global_position) < hit_radius:
		pass#explode()
	if navigation_agent.is_navigation_finished():
		should_move = false
		return
	
	#if !$sfx_crawl.playing: $sfx_crawl.play() 
	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()

	var new_velocity: Vector3 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * speed

	if !is_on_floor():
		velocity.y = velocity.y * 15*delta

	velocity = new_velocity + push_vel
	push_vel = Vector3.ZERO
	should_move = true


func _process(delta):
	if dead || !should_move: return
	move_and_slide()
	test_collisions()


func push_back(vec: Vector3, force: int):
	velocity = velocity + vec.normalized() * (force * SELF_PUSH_MOD)

func test_collisions():
	if get_slide_collision_count() > 0:
		for i in get_slide_collision_count() - 1:
			var col = get_slide_collision(i)
			if col.get_collider() is Player:
				if $HitCoolDown.is_stopped():
					$HitCoolDown.start()
					col.get_collider().hit(col.get_normal())
