extends Sprite3D

@export var movement_speed = 100

var direction
var target

func _process(delta):
	if target != null:
		move_towards_player(delta)
		
func move_towards_player(delta):
	pass
