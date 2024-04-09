extends Node
# Each wave won increase wave size by 1.07x
# Each boss wave won instead increase wave size by 1.2x

# General enemy array logic
var full_enemy_array: Array[String] = ["Scumbug", "Giant Zombie Snail"]
var sliced_enemy_array: Array[String] = full_enemy_array.slice(0, 2) # Defaults to just one enemy to begin with

# Enemy array for the current wave (to be populated BEFORE wave start and shown to user before pressing start wave)
# Enemies inside the array will be populated at random however
var current_wave_enemy_array: Array[PackedScene]
var current_wave_is_boss_wave: bool = false

func _ready():
	populate_current_wave_enemy_array(20)
	
func _process(_delta):
	pass

# Function that wil update sliced enemy array to add more enemies at certain wave thresholds
func update_sliced_enemy_array(wave_number: int):
	if wave_number >= 5:
		sliced_enemy_array = full_enemy_array.slice(0, 2)

# Function that will populate an array of enemies for the upcoming wave
func populate_current_wave_enemy_array(wave_size: int):
	while wave_size > 0:
		var randomly_chosen_enemy_and_size: Array = _choose_random_enemy(sliced_enemy_array)
		current_wave_enemy_array.append(randomly_chosen_enemy_and_size[0])
		wave_size -= randomly_chosen_enemy_and_size[1]
	print(current_wave_enemy_array)

# Function that will start the wave
func start_wave():
	pass

# Function that will check win/loss conditions
func check_win_loss_conditions():
	pass

# Now that the size of enemy is being grabbed -> Need to add a check to ensure that the enemy size fits within the map wave size remaining to fill
func _choose_random_enemy(enemy_array_to_choose_from: Array) -> Array:
	var chosen_enemy_scene: PackedScene
	var chosen_enemy_size: int
	var random_chosen_enemy: String = enemy_array_to_choose_from[randi() % enemy_array_to_choose_from.size()]
	match random_chosen_enemy:
		"Scumbug":
			chosen_enemy_scene = preload("res://Scenes/Enemies/Scumbug/scumbug_container.tscn")
			chosen_enemy_size = preload("res://Scenes/Enemies/Scumbug/scumbug_model.tscn").instantiate().get_size()
		"Giant Zombie Snail":
			chosen_enemy_scene = preload("res://Scenes/Enemies/Giant_Zombie_Snail/giant_zombie_snail_container.tscn")
			chosen_enemy_size = preload("res://Scenes/Enemies/Giant_Zombie_Snail/giant_zombie_snail_model.tscn").instantiate().get_size()
	return [chosen_enemy_scene, chosen_enemy_size]

func spawn_enemy_array_slowly():
	while current_wave_enemy_array.size() > 0:
		await get_tree().create_timer(1).timeout
		var random_chosen_enemy_from_array = current_wave_enemy_array[randi() % current_wave_enemy_array.size()]
		add_child(random_chosen_enemy_from_array.instantiate())
		current_wave_enemy_array.erase(random_chosen_enemy_from_array)





















var current_level_wave_number: int
var current_level_wave_size: int

signal end_of_wave

# Inside ready
"""
current_level_difficulty = "easy"
current_level_wave_number = Globals.easy_map_current_level
current_level_wave_number_label.text = str(current_level_wave_number)
current_level_wave_size = Globals.easy_map_spawn_size
"""

# WaveManager will be responsible for:
	# Getting map difficulty and associated size / level
	# Generating an array of enemies to be shown to user
	# Starting wave
	# Handling wave logic
	# Win / Loss condition

# Old on next wave button pressed
"""
func _on_ui_next_wave_button_pressed():
	print("Next wave button pressed")
	print("Starting wave level: " + str(current_level_wave_number))
	print("Total wave size for this level: " + str(current_level_wave_size))
	next_wave_button.visible = false
	Globals.wave_idle = false
	Globals.wave_ongoing = true
	Globals.wave_won = false
	
	while current_level_wave_size > 0:
		await get_tree().create_timer(1).timeout
		var randomly_chosen_enemy = _choose_random_enemy(full_enemy_array, current_level_wave_size)
		_spawn_enemy(randomly_chosen_enemy)
		current_level_wave_size -= Globals.temp_enemy_size
		print("After spawn wave size: " + str(current_level_wave_size))
	
	Globals.wave_ongoing = false
	Globals.wave_won = true
	"""
	
# Old functions
"""
func _spawn_enemy(chosen_enemy: PackedScene):
	var enemy_to_spawn = chosen_enemy.instantiate()
	add_child(enemy_to_spawn)
		
func _choose_random_enemy(enemy_array: Array, wave_size: int) -> PackedScene:
	var chosen_enemy_scene: PackedScene
	var random_chosen_enemy: String = enemy_array[randi() % enemy_array.size()]
	if wave_size > 1:
		match random_chosen_enemy:
			"Scumbug":
				chosen_enemy_scene = preload("res://Scenes/Enemies/Scumbug/scumbug_container.tscn")
			"Giant Zombie Snail":
				chosen_enemy_scene = preload("res://Scenes/Enemies/Giant_Zombie_Snail/giant_zombie_snail_container.tscn")
	else: # Since size is 1
		chosen_enemy_scene = preload("res://Scenes/Enemies/Scumbug/scumbug_container.tscn")
	return chosen_enemy_scene
"""

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
