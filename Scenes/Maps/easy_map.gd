extends MapParent

var enemy_array: Array = ["Scumbug", "Giant Zombie Snail"]
@onready var next_wave_button: Button = $UI/MarginContainer/HBoxContainer/NextWaveButton

var easy_map_config = preload("res://Resources/easy_map_config.res")

func _init():
	PathGenInstance.path_config = easy_map_config
	
func _ready():
	PathGenInstance.generate_new_path()
	_complete_grid()
	
# Placeholder wave spawner -> Probably be its own global script always available
func _on_ui_next_wave_button_pressed(wave_number, wave_size):
	#Globals.wave_ongoing = true
	#print("Starting wave: " + str(wave_number))
	#print("Wave size of: " + str(wave_size))
	#
	#while wave_size > 0:
		#var chosen_enemy = _choose_random_enemy(enemy_array, wave_size)
		#_spawn_enemy(chosen_enemy)
		#wave_size -= temp_enemy_size
		#await get_tree().create_timer(0.2).timeout
		
	_spawn_enemy(debug_enemy)
		
# Placeholder regeneration of map/path layout after 5 waves (boss) for now
func _regenerate_new_map_layout():
	$UI/ReloadSceneText.visible = true
	$UI/MarginContainer/HBoxContainer/NextWaveButton.visible = false
	TransitionLayer.reload_level("res://Scenes/Maps/easy_map.tscn")

# Placeholder implementation of map regeneration
func _on_no_enemies_left_on_map():
	next_wave_button.visible = true
	if Globals.easy_map_current_level % 5 == 0:
		_regenerate_new_map_layout()
		next_wave_button.visible = false

func _on_ui_refresh_map_button_presesd():
	_regenerate_new_map_layout()
