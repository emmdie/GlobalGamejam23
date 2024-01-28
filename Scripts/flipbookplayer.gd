extends Sprite3D

var t = Timer.new()

func _ready():
	add_child(t)
	t.start(0.1)
	t.timeout.connect(_on_timeout)

func _on_timeout():
	if frame + 1 >= hframes * vframes:
		frame = 0
	else:
		frame += 1
