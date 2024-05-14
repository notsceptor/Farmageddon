extends Projectile

var initial_direction: Vector3
var projectile_range: int = 15
var height_of_projectile: float = 0.4
var bounce_amplitude: float = 0.005
var bounce_frequency: float = 10.0
var time_elapsed: float = 0.0  # New variable to track elapsed time
var start_at_peak: bool = true  # Flag to start at the peak of the bounce cycle
var initial_height_offset: float = 0.1  # Offset to add to the initial height

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

	var projectile_spawn_point = get_node("../HaybaleBarrage/Node/HaybaleBarrage/Aim/ProjectileSpawnMarker") # Marker on haybale launcher
	if projectile_spawn_point != null:  # Assuming ProjectileSpawnMarker is a child node named "ProjectileSpawnMarker"
		global_position = projectile_spawn_point.global_position

	# Start at the peak of the bounce cycle with an initial height offset
	if start_at_peak:
		height_of_projectile += bounce_amplitude + initial_height_offset

func _process(delta):
	global_position += initial_direction * speed * delta

	# Calculate bouncing motion
	time_elapsed += delta  # Increment elapsed time
	var bounce_offset = sin(time_elapsed * bounce_frequency) * bounce_amplitude

	# Apply bouncing motion
	var current_height = height_of_projectile + bounce_offset
	global_position.y = current_height

	# Update projectile height for next frame
	height_of_projectile = current_height

	# Check if the projectile has moved too far from the starting position and destroy it if necessary
	if global_position.distance_to(starting_position) > projectile_range:
		queue_free()

	# Rotate the haybale to make it roll forward
	var roll_axis = initial_direction.cross(Vector3.UP).normalized()  # Calculate roll axis
	var roll_speed = -5.0  # Adjust this value to control the speed of rolling
	var roll_amount = roll_speed * delta
	rotate(roll_axis, roll_amount)
