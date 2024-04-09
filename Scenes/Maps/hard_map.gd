extends MapParent

var hard_map_config = preload("res://Resources/hard_map_config.res")

func _init():
	PathGenInstance.path_config = hard_map_config
	
func _ready():
	current_level_difficulty = "hard"
	Globals.turret_locations_list = []
	Globals.turret_rid_list = []
	PathGenInstance.generate_new_path()
	_complete_grid()
