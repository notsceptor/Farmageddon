extends Projectile

var initial_direction: Vector3
var projectile_range: int = 15
var height_of_projectile: float = 0.7

func _ready():
	# Calculate initial direction towards the target
	if target != null:
		initial_direction = (target.global_position - global_position).normalized()
	else:
		# If target is null, use default forward direction
		initial_direction = global_transform.basis.z.normalized()

	# Rotate the projectile to face the initial direction
	look_at(global_position + initial_direction, Vector3.UP)
	
	var projectile_spawn_point = get_node("../HaybaleBarrage/Node/HaybaleBarrage/Aim/ProjectileSpawnMarker") # Marker on haybale launcher
	if projectile_spawn_point != null:  # Assuming ProjectileSpawnMarker is a child node named "ProjectileSpawnMarker"
		global_position = projectile_spawn_point.global_position

func _process(delta):
	global_position += initial_direction * speed * delta
	
	# So projectile spawns in the spawn location and falls to floor slowly then rolls
	if height_of_projectile > 0.4:
		height_of_projectile -= 0.005
	# Maintain constant height of projectile when shot
	global_position.y = height_of_projectile
	
	# Check if the projectile has moved too far from the starting position and destroy it if necessary
	if global_position.distance_to(starting_position) > projectile_range:
		queue_free()
