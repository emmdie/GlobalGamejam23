extends AudioStreamPlayer2D

class_name AudioCue2D

@export var sources : Array[AudioStream]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	stream = sources[randi() % sources.size()]
	pass

func playQueue():
	if sources.size() > 1:
		stream = sources[randi() % sources.size()]
		play()
	else:
		randPitch()

func randPitch(from: float = 0.9, to: float = 1.1):
	var last_pitch = pitch_scale
	var new_pitch = randf_range(from, to)
	pitch_scale = new_pitch
	play()

