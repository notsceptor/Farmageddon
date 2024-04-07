extends Projectile

enum ProjectileState {
	MOVING_UP,
	MOVING_TO_TARGET,
	ARRIVED
}

var state := ProjectileState.MOVING_UP
var peak_height: float = 10.0 # Adjust this value to control how high the projectile goes
var time_elapsed: float = 0.0
var time_to_reach_peak: float = 1.5 # Time in seconds to reach the peak height
var initial_position: Vector3

func _ready():
	initial_position = global_position
	if target != null:
		update_direction()

func _process(delta):
	match state:
		ProjectileState.MOVING_UP:
			time_elapsed += delta
			if time_elapsed >= time_to_reach_peak:
				state = ProjectileState.MOVING_TO_TARGET
			else:
				global_position.y = initial_position.y + ease_out_quad(time_elapsed, 0, peak_height, time_to_reach_peak)
				rotate(Vector3(1, 0, 0), -delta * 10) # Rotate upwards
		ProjectileState.MOVING_TO_TARGET:
			if target != null:
				global_position += direction * speed * delta
				update_direction()
				if global_position.distance_to(target.global_position) < 0.1:
					state = ProjectileState.ARRIVED
			else:
				state = ProjectileState.ARRIVED
		ProjectileState.ARRIVED:
			queue_free()

func update_direction():
	direction = (target.global_position - global_position).normalized()
	look_at(target.global_position, Vector3.UP)

func ease_out_quad(t, b, c, d):
	t /= d
	return -c * t * (t - 2) + b
