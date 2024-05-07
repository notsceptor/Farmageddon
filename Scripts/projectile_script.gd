extends Area3D
class_name Projectile

var projectile_type: String = "projectile"

@export var speed := 10.0
@export var acceleration := 2.0
var damage: int
var slow: float

var starting_position: Vector3
var target: Node3D
var direction: Vector3

var modified_projectile_speed: float
var last_known_position: Vector3

func _ready():
	modified_projectile_speed = 10.0
	global_position = starting_position
	if target != null:
		update_direction()

func _process(delta):
	modified_projectile_speed = min(modified_projectile_speed + acceleration * delta, speed * 2)
	global_position += direction * modified_projectile_speed * delta
	if target != null:
		# Check if the target's y-position is below -1
		if target.global_position.y < -1:
			last_known_position = Vector3(target.global_position.x, 0, target.global_position.z)
			update_direction_lkp()
		else:
			update_direction()
	else:
		update_direction_lkp()
		if global_position.distance_to(last_known_position) < 0.5:
			queue_free()

func update_direction():
	last_known_position = target.global_position
	direction = (target.global_position - global_position).normalized()
	look_at(target.global_position, Vector3.UP)

func update_direction_lkp():
	direction = (last_known_position - global_position).normalized()
	look_at(last_known_position, Vector3.UP)

func _on_area_entered(_area):
	queue_free()
