extends Projectile

enum ProjectileState {
	MOVING_UP,
	MOVING_DOWN,
	ARRIVED
}

var state := ProjectileState.MOVING_UP
var peak_height: float = 18.0 # Adjust this value to control how high the projectile goes
var time_elapsed: float = 0.0
var time_to_reach_peak: float = 1.5 # Time in seconds to reach the peak height
var initial_position: Vector3
var target_position: Vector3
var descent_target_position: Vector3 # Store the target position for descent teleportation

func _ready():
	initial_position = global_position

func _process(delta):
	match state:
		ProjectileState.MOVING_UP:
			time_elapsed += delta
			if time_elapsed >= time_to_reach_peak:
				state = ProjectileState.MOVING_DOWN
				time_elapsed = 0.0
			else:
				global_position.y = initial_position.y + ease_out_quad(time_elapsed, 0, peak_height, time_to_reach_peak)
				rotate(Vector3(1, 0, 0), -delta * 10) # Rotate upwards
		ProjectileState.MOVING_DOWN:
			if target == null:  # Check if there is no target
				queue_free()  # Destroy the projectile if there is no target
			else:
				if time_elapsed == 0:
					descent_target_position = target.global_position
				time_elapsed += delta
				var descent_time = time_to_reach_peak * 0.5
				if time_elapsed >= descent_time:
					state = ProjectileState.ARRIVED
				else:
					var progress = time_elapsed / descent_time
					global_position = descent_target_position + Vector3(0, peak_height * (1.0 - progress), 0)
		ProjectileState.ARRIVED:
			queue_free()

func ease_out_quad(t, b, c, d):
	t /= d
	return -c * t * (t - 2) + b
