extends MapParent

var medium_map_config = preload("res://Resources/medium_map_config.res")

func _init():
	PathGenInstance.path_config = medium_map_config
	
func _ready():
	Globals.current_selected_map = "medium"
	WaveManager.get_map_difficulty_data()
	current_level_wave_number_label.text = str(Globals.medium_map_current_level)
	Globals.turret_locations_list = []
	Globals.turret_rid_list = []
	PathGenInstance.generate_new_path()
	_complete_grid()
