extends MapParent

var medium_map_config = preload("res://Resources/medium_map_config.res")

func _init():
	PathGenInstance.path_config = medium_map_config
	
func _ready():
	current_level_difficulty = "medium"
	Globals.turret_locations_list = []
	Globals.turret_rid_list = []
	PathGenInstance.generate_new_path()
	_complete_grid()
