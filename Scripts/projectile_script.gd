extends Area3D
class_name Projectile

@export var speed := 10.0

var starting_position: Vector3
var target: Node3D
var direction: Vector3

func _ready():
	global_position = starting_position
	if target != null:
		update_direction()

func _process(delta):
	if target != null:
		global_position += direction * speed * delta
		update_direction()
		if global_position.distance_to(target.global_position) < 0.1:
			queue_free()
	else:
		queue_free()

func update_direction():
	direction = (target.global_position - global_position).normalized()
	look_at(target.global_position, Vector3.UP)
