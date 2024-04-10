extends Projectile

enum ProjectileState {
	MOVING_UP,
	TELEPORTING,
	FALLING,
	ARRIVED
}

var state := ProjectileState.MOVING_UP
var peak_height: float = 10.0
var time_elapsed: float = 0.0
var time_to_reach_peak: float = 1.5
var initial_position: Vector3
var target_position: Vector3

func _ready():
	super._ready()
	damage = 20
	initial_position = global_position
	if target != null:
		update_target_position()

func _process(delta):
	match state:
		ProjectileState.MOVING_UP:
			time_elapsed += delta
			if time_elapsed >= time_to_reach_peak:
				state = ProjectileState.TELEPORTING
				update_target_position()
			else:
				global_position.y = initial_position.y + ease_out_quad(time_elapsed, 0, peak_height, time_to_reach_peak)
				rotate(Vector3(1, 0, 0), -delta * 10)
		ProjectileState.TELEPORTING:
			global_position = target_position + Vector3(0, peak_height, 0)
			state = ProjectileState.FALLING
		ProjectileState.FALLING:
			if global_position.y <= target_position.y:
				state = ProjectileState.ARRIVED
			else:
				global_position.y -= delta * 15  # Adjust falling speed as needed
		ProjectileState.ARRIVED:
			queue_free()

func update_target_position():
	if target != null:
		target_position = target.global_position
	else:
		target_position = global_position  # If no target, fall at current position

func ease_out_quad(t, b, c, d):
	t /= d
	return -c * t * (t - 2) + b
