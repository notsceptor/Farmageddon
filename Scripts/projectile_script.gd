extends Area3D
class_name Projectile
var projectile_type: String = "projectile"

@export var speed := 10.0
@export var acceleration := 2.0
var damage: int

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
	# if at any point the projectile would "hit" underneath the map floor, delete it
	if global_position.y < -1:
		queue_free()
	if target != null:
		# Accelerate the projectile towards the end
		modified_projectile_speed = min(modified_projectile_speed + acceleration * delta, speed * 2)
		global_position += direction * modified_projectile_speed * delta
		update_direction()
		
		if global_position.distance_to(target.global_position) < 0.1:
			queue_free()
	else:
		modified_projectile_speed = min(modified_projectile_speed + acceleration * delta, speed * 2)
		global_position += direction * modified_projectile_speed * delta
		update_direction_lkp()
		if global_position.distance_to(last_known_position) < 0.1:
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
