extends MapParent

var easy_map_config = preload("res://Resources/easy_map_config.res")

func _init():
	PathGenInstance.path_config = easy_map_config
	
func _ready():
	current_level_difficulty = "easy"
	current_level_wave_number = Globals.easy_map_current_level
	current_level_wave_number_label.text = str(current_level_wave_number)
	current_level_wave_size = Globals.easy_map_spawn_size
	PathGenInstance.generate_new_path()
	_complete_grid()
