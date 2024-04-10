extends Node

var temp_enemy_size: int # I have no idea how else to access this it's driving me insane

# Turret RID area to exclude from raycasting
var turret_rid_list: Array = []
var turret_locations_list: Array = []

var current_selected_map: String
#region Easy Map Section
var easy_map_current_level: int = 1
var easy_map_spawn_size: int = 10
#endregion

#region Medium Map Section
var medium_map_current_level: int = 1
var medium_map_spawn_size: int = 10
#endregion

#region Hard Map Section
var hard_map_current_level: int = 1
var hard_map_spawn_size: int = 10
#endregion
