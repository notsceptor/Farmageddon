extends Area3D
class_name Projectile

var starting_position: Vector3
var target: Node3D

var speed: float
var lerp_pos: float

func _ready():
	global_position = starting_position
	if target != null:
		look_at(target.global_position, Vector3.UP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target != null and lerp_pos < 1:
		global_position = starting_position.lerp(target.global_position, lerp_pos)
		lerp_pos += delta * speed
		if global_position != target.global_position:
			look_at(target.global_position, Vector3.UP)
	else:
		queue_free()
