extends Area3D

class_name EnemyHitbox

@export var parent: EnemyBase

func hit(dmg):
	parent.hit(dmg)
