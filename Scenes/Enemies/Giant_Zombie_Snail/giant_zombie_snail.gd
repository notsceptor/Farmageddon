extends EnemyParent

var _path_progress: float = 0.0

@onready var _path_follow_3d: PathFollow3D
@onready var health_bar = $SubViewport/HealthBar3D
@onready var area_damage_timer = get_node("../../../AreaDamageTimer")
@onready var health_bar_hide_timer = $HealthBarHideTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	_name = "Giant Zombie Snail"
	_health = 20
	health_bar.max_value = _health
	_size = 2
	Globals.temp_enemy_size = _size
	_speed = 2
	_path_follow_3d = get_node("../")
	health_bar.visible = false  # Hide the health bar initially

func _process(_delta):
	if in_constant_aoe_damage_zone and area_damage_timer.time_left == 0:
		area_damage_timer.start()

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
			health_bar_hide_timer.start()  # Start the timer to hide the health bar
			if _health <= 0:
				remove_enemy()

func _on_area_3d_area_exited(area):
	if area.is_in_group("AOE"):
		in_constant_aoe_damage_zone = false
		area_damage_to_take -= area.damage

func _on_area_damage_timer_timeout():
	health_bar.visible = true
	_health -= area_damage_to_take
	health_bar.value -= area_damage_to_take
	if _health <= 0:
		remove_enemy()

func _on_health_bar_hide_timer_timeout():
	health_bar.visible = false  # Hide the health bar after 3 seconds of not taking damage
