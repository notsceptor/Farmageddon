extends Projectile

var initial_direction: Vector3
var projectile_range: int = 2.5
var max_lifetime: float = 1

func _ready():
	super._ready()
	if target != null:
		initial_direction = (target.global_position - global_position).normalized()
	else:
		initial_direction = global_transform.basis.z.normalized()

	look_at(global_position + initial_direction, Vector3.UP)

	var projectile_spawn_point = get_node("../BlueberryBlaster/Node/BlueberryBlaster/Aim/ProjectileSpawnMarker1")
	if projectile_spawn_point != null:
		global_position = projectile_spawn_point.global_position

func _process(delta):
	global_position += initial_direction * speed * delta

	if global_position.distance_to(starting_position) > projectile_range:
		queue_free()

	max_lifetime -= delta
	if max_lifetime <= 0.0:
		queue_free()
