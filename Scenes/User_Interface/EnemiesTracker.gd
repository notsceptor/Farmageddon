extends PanelContainer

var max_enemies: int = 0
var current_enemy_count: int

@onready var enemies_left_label = $HBoxContainer/EnemiesLeft
@onready var max_enemies_label = $HBoxContainer/MaxEnemies

func _process(_delta):
	if max_enemies == 0:
		print("Getting max enemies")
		get_max_enemies()
		max_enemies_label.text = str(max_enemies)
		
	if visible && WaveManager.wave_ongoing:
		print("Should be calculating now")

func get_max_enemies():
	var enemy_count = 0
	for enemy in WaveManager.debug_enemy_dictionary.keys():
		enemy_count += WaveManager.debug_enemy_dictionary[enemy]
	max_enemies = enemy_count
