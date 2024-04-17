extends EnemyParent

var _path_progress: float = 0.0

@onready var _path_follow_3d: PathFollow3D
@onready var health_bar = $SubViewport/HealthBar3D
@onready var area_damage_timer = get_node("../../../AreaDamageTimer")
@onready var animation_player = $AnimationPlayer

var _health = 60
var _speed = 0.5
var _size = 4
var _deathsound = false


# Charge mechanic variables
var _charge_duration = 2.5  # Duration of the charge in seconds-
var _charge_cooldown = 6.0  # Cooldown between charges in seconds
var _charge_speed_multiplier = 3.0  # Multiplier for the enemy's speed during the charge
var _is_charging = false  # Flag to track if the enemy is currently charging
var _charge_timer = 0.0  # Timer to track the charge duration
var _charge_cooldown_timer = 0.0  # Timer to track the charge cooldown

func _ready():
	health_bar.max_value = _health
	health_bar.value = _health
	_path_follow_3d = get_node("../")
	health_bar.visible = false  # Hide the health bar initially

func _process(delta):
	if in_constant_aoe_damage_zone and area_damage_timer.time_left == 0:
		area_damage_timer.start()
	if _health <= 0:
		_speed = 0
		remove_enemy()
		if _deathsound == false:
			_deathsound = true
			WaveManager.enemies_on_map -= 1
			GlobalAudioPlayer.play_beetle_death_sound()

	# Handle charging
	if _is_charging:
		_charge_timer += delta
		# Gradually increase the speed multiplier towards the end of the charge
		var speed_multiplier = lerp(1.0, _charge_speed_multiplier, _charge_timer / _charge_duration)
		_path_follow_3d.progress += delta * _speed * speed_multiplier
		animation_player.set_speed_scale(4)
		if _charge_timer >= _charge_duration:
			_is_charging = false
			_charge_timer = 0.0
			_speed = 0.5  # Reset the speed to the default value
			animation_player.set_speed_scale(1.0)  # Reset the animation playback speed
	else:
		_charge_cooldown_timer += delta
		if _charge_cooldown_timer >= _charge_cooldown and randf() < 0.1:  # 10% chance to start charging
			_is_charging = true
			_charge_timer = 0.0
			_charge_cooldown_timer = 0.0
			_speed = _speed * _charge_speed_multiplier

func _on_moving_state_processing(delta):
	_path_progress += delta * _speed
	_path_follow_3d.progress = _path_progress

func _on_area_3d_area_entered(area):
	if area.is_in_group("AOE"):
		in_constant_aoe_damage_zone = true
		area_damage_to_take += area.damage
	else:
		if area.damage:
			health_bar.visible = true # Show the health bar when taking damage
			_health -= area.damage
			health_bar.value -= area.damage

func _on_area_3d_area_exited(area):
	if area.is_in_group("AOE"):
		in_constant_aoe_damage_zone = false
		area_damage_to_take -= area.damage

func _on_area_damage_timer_timeout():
	health_bar.visible = true
	_health -= area_damage_to_take
	health_bar.value -= area_damage_to_take

func get_size() -> int:
	return _size
