extends Node

# Turret RID area to exclude from raycasting
var turret_rid_list: Array = []
var turret_locations_list: Array = []

const MAX_PLACEABLE_TURRETS = 7
var current_max_turrets: int = 2
var current_placed_turrets: int = 0

#region Currencies
var gold = 0
var scrap = 0
var gems = 0
#endregion

var current_selected_map: String
#region Easy Map Section
var easy_map_current_level: int = 1
var easy_map_spawn_size: int = 3
#endregion

#region Medium Map Section
var medium_map_current_level: int = 1
var medium_map_spawn_size: int = 6
#endregion

#region Hard Map Section
var hard_map_current_level: int = 1
var hard_map_spawn_size: int = 10
#endregion

var intro_played: bool = false

#region Settings music save values
var master_volume_value: float = 1.0
var music_volume_value: float = 1.0
var sfx_volume_value: float = 1.0
#endregion
