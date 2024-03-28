extends Node

var wave_idle: bool = true
var wave_won: bool = false
var wave_ongoing: bool = false
var wave_spawning: bool = false

var temp_enemy_size: int # I have no idea how else to access this it's driving me insane

var enemies_on_map: int = 0

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
