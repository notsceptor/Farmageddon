extends MapParent

var easy_map_config = preload("res://Resources/easy_map_config.res")

func _init():
	PathGenInstance.path_config = easy_map_config

func _ready():
	current_level_difficulty = "easy"
	Globals.turret_locations_list = []
	Globals.turret_rid_list = []
	PathGenInstance.generate_new_path()
	_complete_grid()
