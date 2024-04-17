extends EnemyParent

var _path_progress: float = 0.0

@onready var _path_follow_3d: PathFollow3D
@onready var health_bar = $SubViewport/HealthBar3D
@onready var area_damage_timer = get_node("../../../AreaDamageTimer")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var grub_container = get_node("../Area3D")

var _health = 25
var _speed = 1
var _size = 1
var _deathsound = false
var _can_burrow = 2 # Number of times the grub can burrow
var _burrow_cooldown = 10.0 # 15 second cooldown between burrows
var _last_burrow_time = 0.0 # Tracks the time of the last burrow

# Called when the node enters the scene tree for the first time.
func _ready():
	health_bar.max_value = _health
	health_bar.value = _health
	_path_follow_3d = get_node("../")
	health_bar.visible = false  # Hide the health bar initially

func _process(delta):
	if in_constant_aoe_damage_zone and area_damage_timer.time_left == 0:
		area_damage_timer.start()
	if _health <= 0:
		remove_enemy()
		if _deathsound == false:
			_deathsound = true
			WaveManager.enemies_on_map -= 1
			GlobalAudioPlayer.play_snail_death_sound()
	if _can_burrow > 0 and Time.get_ticks_msec() - _last_burrow_time >= _burrow_cooldown * 1000:
		burrow()

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

func burrow():
	if health_bar.visible:
		health_bar.visible = false
	_can_burrow -= 1
	_last_burrow_time = Time.get_ticks_msec()
	animation_player.stop()
	animation_player.play("Burrow")
	await get_tree().create_timer(1.5).timeout
	grub_container.global_position.y -= 100
	await get_tree().create_timer(3.0).timeout
	grub_container.global_position.y += 100
	animation_player.stop()
	animation_player.play("Unburrow")
	await get_tree().create_timer(1.5).timeout
	animation_player.stop()
	animation_player.play("Slither")
	if _health != 25:
		health_bar.visible = true
