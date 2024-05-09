extends MapParent

var hard_map_config = preload("res://Resources/hard_map_config.res")

func _init():
	PathGenInstance.path_config = hard_map_config
	
func _ready():
	super()
	Globals.current_selected_map = "hard"
	WaveManager.get_map_difficulty_data()
	current_level_wave_number_label.text = str(Globals.hard_map_current_level)
	Globals.turret_locations_list = []
	Globals.turret_rid_list = []
	PathGenInstance.generate_new_path()
	_complete_grid()
