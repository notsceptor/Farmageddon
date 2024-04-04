extends MapParent

var easy_map_config = preload("res://Resources/easy_map_config.res")

func _init():
	PathGenInstance.path_config = easy_map_config

func _ready():
	Globals.turret_locations_list = []
	Globals.turret_rid_list = []
	current_level_difficulty = "easy"
	current_level_wave_number = Globals.easy_map_current_level
	current_level_wave_number_label.text = str(current_level_wave_number)
	current_level_wave_size = Globals.easy_map_spawn_size
	PathGenInstance.generate_new_path()
	_complete_grid()

func _on_end_of_wave():
	if Globals.wave_won:
		# If boss wave was won (every 5 for now) - Regenerates new map
		if current_level_wave_number % 5 == 0:
			_regenerate_new_map_layout(current_level_difficulty)
		print("Wave won! Moving up")
		Globals.easy_map_current_level += 1
		Globals.easy_map_spawn_size += 2
	else:
		print("Wave lost! Staying same")
	current_level_wave_number = Globals.easy_map_current_level
	current_level_wave_number_label.text = str(current_level_wave_number)
	current_level_wave_size = Globals.easy_map_spawn_size
	
	if current_level_wave_number % 5 != 1:
		next_wave_button.visible = true
	
