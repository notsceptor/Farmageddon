extends Projectile

enum ProjectileState {
	RISING,
	FALLING
}

var state := ProjectileState.RISING
var peak_height: float = 12.0
var time_elapsed: float = 0.0
var time_to_reach_peak: float = 1.5
var initial_position: Vector3
var target_position: Vector3
var last_known_target_position: Vector3

func _ready():
	super._ready()
	initial_position = global_position
	if target != null:
		target_position = target.global_position
		last_known_target_position = target_position
	else:
		# Use the last known position of the enemy as the target
		target_position = last_known_target_position

func _process(delta):
	match state:
		ProjectileState.RISING:
			time_elapsed += delta
			if time_elapsed >= time_to_reach_peak:
				state = ProjectileState.FALLING
			else:
				global_position.y = initial_position.y + ease_out_quad(time_elapsed, 0, peak_height, time_to_reach_peak)
				global_position = global_position.move_toward(target_position, delta * 5)
				rotate(Vector3(0, 0, 1), -delta * 10)
		ProjectileState.FALLING:
			if is_instance_valid(target):
				target_position = target.global_position
				last_known_target_position = target_position
			global_position = global_position.move_toward(last_known_target_position, delta * 15)
			rotate(Vector3(0, 0, 1), -delta * 10)
			if global_position.distance_to(last_known_target_position) < 0.1:
				GlobalAudioPlayer.play_strawberry_projectile_sound()
				queue_free()

func ease_out_quad(t, b, c, d):
	t /= d
	return -c * t * (t - 2) + b
