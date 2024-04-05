extends Area3D
class_name DebugProjectile

var starting_position: Vector3
var target: Node3D

@export var speed: float = 2
var lerp_pos: float = 0

func _ready():
	global_position = starting_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target != null and lerp_pos < 1:
		global_position = starting_position.lerp(target.global_position, lerp_pos)
		lerp_pos += delta * speed
	else:
		queue_free()
