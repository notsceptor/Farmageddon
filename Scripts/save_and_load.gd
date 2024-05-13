extends Node

const SAVE_PATH = "user://gamedata.save"

func save_game() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(Globals.easy_map_current_level)
	file.store_var(Globals.easy_map_spawn_size)
	file.store_var(Globals.medium_map_current_level)
	file.store_var(Globals.medium_map_spawn_size)
	file.store_var(Globals.hard_map_current_level)
	file.store_var(Globals.hard_map_spawn_size)
	file.store_var(Globals.master_volume_value)
	file.store_var(Globals.music_volume_value)
	file.store_var(Globals.sfx_volume_value)
	file.store_var(Globals.gold)
	file.store_var(Globals.scrap)
	file.store_var(Globals.gems)
	
func load_game() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		Globals.easy_map_current_level = file.get_var()
		Globals.easy_map_spawn_size = file.get_var()
		Globals.medium_map_current_level = file.get_var()
		Globals.medium_map_spawn_size = file.get_var()
		Globals.hard_map_current_level = file.get_var()
		Globals.hard_map_spawn_size = file.get_var()
		Globals.master_volume_value = file.get_var()
		Globals.music_volume_value = file.get_var()
		Globals.sfx_volume_value = file.get_var()
		Globals.gold = file.get_var()
		Globals.scrap = file.get_var()
		Globals.gems = file.get_var()
	else:
		print("File doesn't yet exist. Continue as normal")
