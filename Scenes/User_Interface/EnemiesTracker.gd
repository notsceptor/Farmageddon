extends PanelContainer

var max_enemies: int = 0

@onready var enemies_left_label = $HBoxContainer/EnemiesLeft
@onready var max_enemies_label = $HBoxContainer/MaxEnemies

func _process(_delta):
	if visible && WaveManager.wave_ongoing:
		enemies_left_label.text = str(max_enemies - WaveManager.enemies_killed)

func get_max_enemies() -> int:
	var temp_enemy_count = 0
	for enemy in WaveManager.debug_enemy_dictionary.keys():
		temp_enemy_count += WaveManager.debug_enemy_dictionary[enemy]
	return temp_enemy_count

func _on_next_wave_button_pressed():
	max_enemies = get_max_enemies()
	max_enemies_label.text = str(max_enemies)
	enemies_left_label.text = str(max_enemies)

func _on_ui_wave_ended_from_map_parent():
	if WaveManager.wave_won:
		enemies_left_label.text = "0"
