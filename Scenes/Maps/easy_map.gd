extends MapParent

var _wave_number: int = Globals.easy_map_current_level

func _ready():
	_path_generator = PathGenerator.new(map_length, map_height)
	_display_path()
	_complete_grid()

func _on_ui_next_wave_button_pressed(wave_number):
	_wave_number = int(wave_number)
	
	# Below would be at end state of wave such as if wave_won == true and % 5 since that'd be boss wave
	if wave_number % 5 == 0:
		$UI/ReloadSceneText.visible = true
		TransitionLayer.reload_level("res://Scenes/Maps/easy_map.tscn")
