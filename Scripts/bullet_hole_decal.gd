extends MeshInstance3D

var last_used_ts = 0

func ready():
	last_used_ts = Time.get_ticks_msec()
	material_override = material_override.duplicate()

func place(pos, normal):
	last_used_ts = Time.get_ticks_msec()
	transform = align_with_normal(transform, normal)
	global_transform.origin = pos + (normal * 0.01)
	
func align_with_normal(xform: Transform3D, n2: Vector3) -> Transform3D:
	var n1 = xform.basis.y.normalized()
	var cosa = n1.dot(n2)
	if cosa >= 0.99:
		return xform
	var alpha = acos(cosa)
	var axis = n1.cross(n2).normalized()
	if axis == Vector3.ZERO:
		axis = Vector3.FORWARD # normals are in opposite directions
	return xform.rotated(axis, alpha)

func _on_decay_timer_timeout():
	var tween = create_tween()
	tween.tween_property(material_override, "shader_parameter/alpha", 0, 1)
	await tween.finished
	queue_free()


func _on_cooldown_timer_timeout():
	var tween = create_tween()
	tween.tween_property(material_override, "shader_parameter/emission_mask_color", Color.BLACK, 1)
