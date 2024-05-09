extends MapParent

var easy_map_config = preload("res://Resources/easy_map_config.res")

func _init():
	PathGenInstance.path_config = easy_map_config

func _ready():
	super()
	Globals.current_selected_map = "easy"
	WaveManager.get_map_difficulty_data()
	current_level_wave_number_label.text = str(Globals.easy_map_current_level)
	Globals.turret_locations_list = []
	Globals.turret_rid_list = []
	PathGenInstance.generate_new_path()
	_complete_grid()
