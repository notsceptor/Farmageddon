extends Projectile

var initial_direction: Vector3
var projectile_range: int = 3

func _ready():
	super._ready()
	# Calculate initial direction towards the target
	if target != null:
		initial_direction = (target.global_position - global_position).normalized()
	else:
		# If target is null, use default forward direction
		initial_direction = global_transform.basis.z.normalized()

	# Rotate the projectile to face the initial direction
	look_at(global_position + initial_direction, Vector3.UP)

	var projectile_spawn_point = get_node("../BlueberryBlaster/Node/BlueberryBlaster/Aim/ProjectileSpawnMarker1")
	if projectile_spawn_point != null:
		global_position = projectile_spawn_point.global_position

func _process(delta):
	global_position += initial_direction * speed * delta

	# Check if the projectile has moved too far from the starting position and destroy it if necessary
	if global_position.distance_to(starting_position) > projectile_range:
		queue_free()
