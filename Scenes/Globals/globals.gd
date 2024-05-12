extends Node

# Turret RID area to exclude from raycasting
var turret_rid_list: Array = []
var turret_locations_list: Array = []

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

#region Music Decibals ranges
const MUSIC_MIN_VALUE = -80
const MUSIC_MAX_VALUE = -22
const MUSIC_RANGE = MUSIC_MIN_VALUE - MUSIC_MAX_VALUE
#endregion
