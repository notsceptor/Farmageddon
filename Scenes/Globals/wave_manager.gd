extends Node
# Each wave won increase wave size by 1.07x
# Each boss wave won instead increase wave size by 1.2x

# General enemy array logic
var full_enemy_array: Array[String] = ["Scumbug", "Giant Zombie Snail"]
var sliced_enemy_array: Array[String] = full_enemy_array.slice(0, 2) # Defaults to just one enemy to begin with

# Enemy array for the current wave (to be populated BEFORE wave start and shown to user before pressing start wave)
# Enemies inside the array will be populated at random however
var current_wave_enemy_array: Array[PackedScene]
var remaining_enemies_to_spawn: Array[PackedScene]

var current_wave_is_boss_wave: bool = false
var current_level_wave_spawn_size: int

# Wave win/loss logic
var enemies_on_map: int = 0
var wave_ongoing: bool = false
var wave_won: bool

#func _process(_delta):
	#if wave_ongoing:
		#check_win_loss_conditions()

# Function that will get map difficulty data
func get_map_difficulty_data():
	match Globals.current_selected_map:
		"easy":
			current_level_wave_spawn_size = Globals.easy_map_spawn_size
		"medium":
			current_level_wave_spawn_size = Globals.medium_map_spawn_size
		"hard":
			current_level_wave_spawn_size = Globals.hard_map_spawn_size
			
	# To populate the array on level load so that there is a wave preloaded on loading map for first time
	repopulate_current_wave_enemy_array(current_level_wave_spawn_size)

# Function that wil update sliced enemy array to add more enemies at certain wave thresholds
func update_sliced_enemy_array(wave_number: int):
	sliced_enemy_array = full_enemy_array.slice(0, 2) # Default slice
	if wave_number > 10:
		pass # Change the slice to allow for more enemies

# Function that will populate an array of enemies for the upcoming wave
func repopulate_current_wave_enemy_array(wave_size: int):
	current_wave_enemy_array.clear()
	update_sliced_enemy_array(current_level_wave_spawn_size)
	while wave_size > 0:
		var randomly_chosen_enemy_and_size: Array = _choose_random_enemy(sliced_enemy_array, wave_size)
		current_wave_enemy_array.append(randomly_chosen_enemy_and_size[0])
		wave_size -= randomly_chosen_enemy_and_size[1]
	for enemy in current_wave_enemy_array:
		remaining_enemies_to_spawn.append(enemy)

# Function that will start the wave
func start_wave():
	match Globals.current_selected_map:
		"easy":
			print("Current easy map level: ", Globals.easy_map_current_level)
			print("Current easy map spawn size: ", Globals.easy_map_spawn_size)
		"easy":
			print("Current easy map level: ", Globals.medium_map_current_level)
			print("Current easy map spawn size: ", Globals.medium_map_spawn_size)
		"easy":
			print("Current easy map level: ", Globals.hard_map_current_level)
			print("Current hard map spawn size: ", Globals.hard_map_spawn_size)
	spawn_enemy_array_slowly(remaining_enemies_to_spawn)

# Function that will check win/loss conditions
func check_win_loss_conditions():
	if enemies_on_map == 0 and remaining_enemies_to_spawn.size() == 0:
		wave_ongoing = false
		enemies_on_map = 0
		if wave_won:
			print("WAVE WON")
			wave_won_increase_level_and_size()
			get_map_difficulty_data()
		else:
			print("WAVE LOST TRY AGAIN")

func wave_won_increase_level_and_size():
	match Globals.current_selected_map:
		"easy":
			if Globals.easy_map_current_level % 5 == 0:
				Globals.easy_map_spawn_size = ceilf(Globals.easy_map_spawn_size * 1.20)
			else:
				Globals.easy_map_spawn_size = ceilf(Globals.easy_map_spawn_size * 1.07)
			Globals.easy_map_current_level += 1
		"medium":
			if Globals.medium_map_current_level % 5 == 0:
				Globals.medium_map_spawn_size = ceilf(Globals.medium_map_spawn_size * 1.20)
			else:
				Globals.medium_map_spawn_size = ceilf(Globals.medium_map_spawn_size * 1.07)
			Globals.medium_map_current_level += 1
		"hard":
			if Globals.easy_hard_current_level % 5 == 0:
				Globals.easy_hard_spawn_size = ceilf(Globals.hard_map_spawn_size * 1.20)
			else:
				Globals.easy_hard_spawn_size *= 1.07
			Globals.easy_hard_current_level = ceilf(Globals.hard_map_spawn_size * 1.07)
			

# Function that takes an array of enemies and wave size as parameter and ensures it returns an enemy that fits within the remaining wave size
func _choose_random_enemy(enemy_array: Array, wave_size: int) -> Array:
	var enemy_array_to_choose_from = enemy_array
	var enemy_selected: bool = false
	
	var chosen_enemy_scene: PackedScene
	var chosen_enemy_size: int
	
	while enemy_selected == false:
		var random_chosen_enemy: String = enemy_array_to_choose_from[randi() % enemy_array_to_choose_from.size()]
		match random_chosen_enemy:
			"Scumbug":
				chosen_enemy_scene = preload("res://Scenes/Enemies/Scumbug/scumbug_container.tscn")
				chosen_enemy_size = preload("res://Scenes/Enemies/Scumbug/scumbug_model.tscn").instantiate().get_size()
			"Giant Zombie Snail":
				chosen_enemy_scene = preload("res://Scenes/Enemies/Giant_Zombie_Snail/giant_zombie_snail_container.tscn")
				chosen_enemy_size = preload("res://Scenes/Enemies/Giant_Zombie_Snail/giant_zombie_snail_model.tscn").instantiate().get_size()
		if chosen_enemy_size > wave_size:
			enemy_array_to_choose_from.erase(random_chosen_enemy)
		else:
			enemy_selected = true

	return [chosen_enemy_scene, chosen_enemy_size]

func spawn_enemy_array_slowly(wave_enemy_array: Array[PackedScene]):
	while wave_enemy_array.size() > 0:
		await get_tree().create_timer(1).timeout
		var random_chosen_enemy_from_array = wave_enemy_array[randi() % wave_enemy_array.size()]
		add_child(random_chosen_enemy_from_array.instantiate())
		wave_enemy_array.erase(random_chosen_enemy_from_array)
		if !wave_ongoing:
			wave_ongoing = true
			wave_won = true


"""
func _on_end_of_wave():
	if Globals.wave_won:
		# If boss wave was won (every 5 for now) - Regenerates new map
		if current_level_wave_number % 5 == 0:
			_regenerate_new_map_layout(current_level_difficulty)
		print("Wave won! Moving up")
		Globals.easy_map_current_level += 1
		Globals.easy_map_spawn_size += 2
	else:
		print("Wave lost! Staying same")
	current_level_wave_number = Globals.easy_map_current_level
	current_level_wave_number_label.text = str(current_level_wave_number)
	current_level_wave_size = Globals.easy_map_spawn_size
	
	if current_level_wave_number % 5 != 1:
		next_wave_button.visible = true
"""
