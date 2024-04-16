extends EnemyParent

var _path_progress: float = 0.0

@onready var _path_follow_3d: PathFollow3D
@onready var health_bar = $SubViewport/HealthBar3D
@onready var area_damage_timer = get_node("../../../AreaDamageTimer")
@onready var vulture_model: AnimationPlayer = $AnimationPlayer # Reference to the vulture's model and animation player

var _health = 35
var _max_health = 35
var _speed = 1.5
var _size = 1
var _can_revive = true  # Flag to track if the vulture can revive
var _revive_duration = 3.0  # Duration of the upside-down state before reviving
var _is_reviving = false  # Flag to track if the vulture is currently reviving
var _deathsound = false

# Called when the node enters the scene tree for the first time.
func _ready():
	health_bar.max_value = _max_health
	health_bar.value = _health
	_path_follow_3d = get_node("../")
	health_bar.visible = false  # Hide the health bar initially

func _process(delta):
	if in_constant_aoe_damage_zone and area_damage_timer.time_left == 0:
		area_damage_timer.start()
	if _health <= 0:
		if _can_revive:
			_start_revive()
		if !_can_revive and !_is_reviving:
			GlobalAudioPlayer.play_snail_death_sound()
			remove_enemy()

func _on_moving_state_processing(delta):
	_path_progress += delta * _speed
	_path_follow_3d.progress = _path_progress

func _on_area_3d_area_entered(area):
	if area.is_in_group("AOE") and not _is_reviving:
		in_constant_aoe_damage_zone = true
		area_damage_to_take += area.damage
	else:
		if area.damage and not _is_reviving:
			health_bar.visible = true # Show the health bar when taking damage
			_health -= area.damage
			health_bar.value -= area.damage

func _on_area_3d_area_exited(area):
	if area.is_in_group("AOE") and not _is_reviving:
		in_constant_aoe_damage_zone = false
		area_damage_to_take -= area.damage

func _on_area_damage_timer_timeout():
	health_bar.visible = true
	_health -= area_damage_to_take
	health_bar.value -= area_damage_to_take

func get_size() -> int:
	return _size

func _start_revive():
	_can_revive = false
	_is_reviving = true
	vulture_model.stop()  # Pause the "Flap" animation
	_speed = 0
	vulture_model.play("Revival")  # Resume the "Flap" animation
	await get_tree().create_timer(_revive_duration).timeout
	_health = _max_health
	health_bar.value = _health
	vulture_model.play("Flap")  # Resume the "Flap" animation
	_speed = 1.5
	_is_reviving = false
