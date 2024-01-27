extends Area3D

class_name EnemyHitbox

@export var parent: EnemyBase

func hit(dmg, normal):
	parent.hit(dmg, normal)
