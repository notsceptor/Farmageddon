extends Node
# Each wave won increase wave size by 1.07x
# Each boss wave won instead increase wave size by 1.2x

# General enemy array logic
var full_enemy_array: Array[String] = ["Scumbug", "Giant Zombie Snail", "Brasher Beetle", "Trundle Boar", "Goliath Spider"]
var sliced_enemy_array: Array[String] = full_enemy_array.slice(0, 5) # Defaults to just one enemy to begin with

# Enemy array for the current wave (to be populated BEFORE wave start and shown to user before pressing start wave)
# Enemies inside the array will be populated at random however
var current_wave_enemy_array: Array[PackedScene]
var remaining_enemies_to_spawn: Array[PackedScene]

var debug_enemy_dictionary: Dictionary

var current_level: int

var current_wave_is_boss_wave: bool = false
var current_level_wave_spawn_size: int

# Wave win/loss logic
var enemies_on_map: int = 0
var wave_ongoing: bool = false
var wave_won: bool

func _process(_delta):
	if wave_ongoing and !wave_won:
		remaining_enemies_to_spawn.clear()

# Function that will get map difficulty data
func get_map_difficulty_data():
	match Globals.current_selected_map:
		"easy":
			current_level_wave_spawn_size = Globals.easy_map_spawn_size
			current_level = Globals.easy_map_current_level
		"medium":
			current_level_wave_spawn_size = Globals.medium_map_spawn_size
			current_level = Globals.medium_map_current_level
		"hard":
			current_level_wave_spawn_size = Globals.hard_map_spawn_size
			current_level = Globals.medium_map_current_level

	if current_level % 5 == 0:
		current_wave_is_boss_wave = true
		
	# To populate the array on level load so that there is a wave preloaded on loading map for first time
	repopulate_current_wave_enemy_array(current_level_wave_spawn_size)

# Function that wil update sliced enemy array to add more enemies at certain wave thresholds
func update_sliced_enemy_array(wave_number: int):
	sliced_enemy_array = full_enemy_array.slice(0, 5)  # Include the first three enemies initially
	if wave_number > 10:
		pass

# Function that will populate an array of enemies for the upcoming wave
func repopulate_current_wave_enemy_array(wave_size: int):
	current_wave_enemy_array.clear()
	remaining_enemies_to_spawn.clear()
	debug_enemy_dictionary.clear()
	update_sliced_enemy_array(current_level_wave_spawn_size)
	while wave_size > 0:
		var randomly_chosen_enemy_and_size: Array = _choose_random_enemy(sliced_enemy_array, wave_size)
		current_wave_enemy_array.append(randomly_chosen_enemy_and_size[0])
		remaining_enemies_to_spawn.append(randomly_chosen_enemy_and_size[0])
		wave_size -= randomly_chosen_enemy_and_size[1]

# Function that will start the wave
func start_wave():
	wave_ongoing = true
	wave_won = true
	print("Starting wave of:")
	for key in debug_enemy_dictionary.keys(): # Iterate over keys
		var value = debug_enemy_dictionary[key] # Access value using the key
		print(key, ": ", value)
	spawn_enemy_array_slowly(remaining_enemies_to_spawn)

# Function that will check win/loss conditions
func check_win_loss_conditions():
	if current_wave_is_boss_wave == false and enemies_on_map == 0 and remaining_enemies_to_spawn.size() == 0:
		wave_ongoing = false
		enemies_on_map = 0
		if wave_won:
			print("WAVE WON")
			wave_won_increase_level_and_size()
			get_map_difficulty_data()
		else:
			print("WAVE LOST TRY AGAIN")
			if current_level % 5 == 0:
				current_wave_is_boss_wave = true
			for enemy in current_wave_enemy_array:
				remaining_enemies_to_spawn.append(enemy)

func wave_won_increase_level_and_size():
	match Globals.current_selected_map:
		"easy":
			if Globals.easy_map_current_level % 5 == 0:
				Globals.easy_map_spawn_size = ceilf(Globals.easy_map_spawn_size * 1.20)
			else:
				Globals.easy_map_spawn_size = ceilf(Globals.easy_map_spawn_size * 1.07)
			Globals.easy_map_current_level += 1
			current_level = Globals.easy_map_current_level
			if current_level % 5 == 0:
				current_wave_is_boss_wave = true
		"medium":
			if Globals.medium_map_current_level % 5 == 0:
				Globals.medium_map_spawn_size = ceilf(Globals.medium_map_spawn_size * 1.20)
			else:
				Globals.medium_map_spawn_size = ceilf(Globals.medium_map_spawn_size * 1.07)
			Globals.medium_map_current_level += 1
			current_level = Globals.medium_map_current_level
			if current_level % 5 == 0:
				current_wave_is_boss_wave = true
		"hard":
			if Globals.easy_hard_current_level % 5 == 0:
				Globals.easy_hard_spawn_size = ceilf(Globals.hard_map_spawn_size * 1.20)
			else:
				Globals.easy_hard_spawn_size = ceilf(Globals.hard_map_spawn_size * 1.07)
			Globals.easy_hard_current_level += 1
			current_level = Globals.hard_map_current_level
			if current_level % 5 == 0:
				current_wave_is_boss_wave = true
			

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
			"Brasher Beetle":
				chosen_enemy_scene = preload("res://Scenes/Enemies/Brasher_Beetle/brasher_beetle_container.tscn")
				chosen_enemy_size = preload("res://Scenes/Enemies/Brasher_Beetle/brasher_beetle_model.tscn").instantiate().get_size()
			"Trundle Boar":
				chosen_enemy_scene = preload("res://Scenes/Enemies/Trundle_Boar/trundle_boar_container.tscn")
				chosen_enemy_size = preload("res://Scenes/Enemies/Trundle_Boar/trundle_boar_model.tscn").instantiate().get_size()
			"Goliath Spider":
				chosen_enemy_scene = preload("res://Scenes/Enemies/Goliath_Spider/goliath_spider_container.tscn")
				chosen_enemy_size = preload("res://Scenes/Enemies/Goliath_Spider/goliath_spider_model.tscn").instantiate().get_size()

		if chosen_enemy_size > wave_size:
			enemy_array_to_choose_from.erase(random_chosen_enemy)
		else:
			if random_chosen_enemy not in debug_enemy_dictionary.keys():
				debug_enemy_dictionary[random_chosen_enemy] = 1
			else:
				debug_enemy_dictionary[random_chosen_enemy] += 1
			enemy_selected = true
	return [chosen_enemy_scene, chosen_enemy_size]
	
func _choose_random_boss_enemy_and_spawn(enemy_array: Array):
	var boss_enemy_scene: PackedScene
	var boss_enemy_scene_instantiated: Node3D
	var boss_enemy_string_name: String = enemy_array[randi() % enemy_array.size()]
	match boss_enemy_string_name:
		"Scumbug":
			boss_enemy_scene = preload("res://Scenes/Enemies/Scumbug/scumbug_container.tscn")
		"Giant Zombie Snail":
			boss_enemy_scene = preload("res://Scenes/Enemies/Giant_Zombie_Snail/giant_zombie_snail_container.tscn")
		"Brasher Beetle":
			boss_enemy_scene = preload("res://Scenes/Enemies/Brasher_Beetle/brasher_beetle_container.tscn")
		"Trundle Boar":
			boss_enemy_scene = preload("res://Scenes/Enemies/Trundle_Boar/trundle_boar_container.tscn")
		"Goliath Spider":
			boss_enemy_scene = preload("res://Scenes/Enemies/Goliath_Spider/goliath_spider_container.tscn")

	boss_enemy_scene_instantiated = boss_enemy_scene.instantiate()
	boss_enemy_scene_instantiated.get_node("Path3D/PathFollow3D").get_children()[0].scale = Vector3(2,2,2)
	boss_enemy_scene_instantiated.get_node("Path3D/PathFollow3D").get_children()[0]._health *= 5
	add_child(boss_enemy_scene_instantiated)

func spawn_enemy_array_slowly(wave_enemy_array: Array[PackedScene]):
	while wave_enemy_array.size() > 0:
		if wave_ongoing:
			var random_chosen_enemy_from_array = wave_enemy_array[randi() % wave_enemy_array.size()]
			add_child(random_chosen_enemy_from_array.instantiate())
			wave_enemy_array.erase(random_chosen_enemy_from_array)
			await get_tree().create_timer(1).timeout
		else:
			break
	if current_wave_is_boss_wave and wave_won == true and wave_ongoing:
		print("BOSS SPAWNING")
		await get_tree().create_timer(2).timeout
		_choose_random_boss_enemy_and_spawn(sliced_enemy_array)
		current_wave_is_boss_wave = false
	current_wave_is_boss_wave = false
