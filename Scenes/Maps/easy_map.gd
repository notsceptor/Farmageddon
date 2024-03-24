extends MapParent

var wave_won: bool = false
var enemy_array: Array = ["Scumbug", "Giant Zombie Snail"]
@onready var next_wave_button: Button = $UI/MarginContainer/HBoxContainer/NextWaveButton

func _ready():
	_display_path()
	_complete_grid()

func _process(_delta):
	if enemies_on_map <= 0:
		next_wave_button.visible = true
		temp_enemy_size = 0

func _on_ui_next_wave_button_pressed(wave_number, wave_size):
	next_wave_button.visible = false
	
	while wave_size > 0:
		var chosen_enemy = _choose_random_enemy(enemy_array, wave_size)
		_spawn_enemy(chosen_enemy)
		wave_size -= temp_enemy_size
		await get_tree().create_timer(2).timeout
		
	# Below would be at end state of wave such as if wave_won == true and % 5 since that'd be boss wave
	if wave_number % 5 == 0:
		_regenerate_new_map_layout()
		
func _regenerate_new_map_layout():
	$UI/ReloadSceneText.visible = true
	$UI/MarginContainer/HBoxContainer/NextWaveButton.visible = false
	TransitionLayer.reload_level("res://Scenes/Maps/easy_map.tscn")

