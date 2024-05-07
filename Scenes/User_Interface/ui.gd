extends CanvasLayer

@onready var wave_number_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/WaveNumber
@onready var next_wave_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/NextWaveButton
@onready var refresh_wave_button: Button = $MarginContainer2/TestRefreshMapButton
@onready var upcoming_enemies_label: Label = $MarginContainer/VBoxContainer/UpcomingEnemies

@onready var claim_rewards_button: Button = $PanelContainer/VBoxContainer/ClaimRewardsButton
@onready var claim_countdown_text: Label = $PanelContainer/VBoxContainer/RewardCountdownText

@export var debug_enemy: PackedScene

signal next_wave_button_pressed
signal refresh_map_button_pressed
signal place_turret(turret_scene, location)

func _ready():
	next_wave_button.visible = false
	upcoming_enemies_label.visible = false
	await get_tree().create_timer(1).timeout
	next_wave_button.visible = true
	upcoming_enemies_label.visible = true
	get_upcoming_enemies()
	
func _process(_delta):
	if $ClaimRewardsTimer.is_stopped() == false:
		if $ClaimRewardsTimer.time_left >= 4:
			claim_countdown_text.text = "5s"
		elif $ClaimRewardsTimer.time_left >= 3 and $ClaimRewardsTimer.time_left < 4:
			claim_countdown_text.text = "4s"
		elif $ClaimRewardsTimer.time_left >= 2 and $ClaimRewardsTimer.time_left < 3:
			claim_countdown_text.text = "3s"
		elif $ClaimRewardsTimer.time_left >= 1 and $ClaimRewardsTimer.time_left < 2:
			claim_countdown_text.text = "2s"
		else:
			claim_countdown_text.text = "1s"

func _on_next_wave_button_pressed():
	next_wave_button_pressed.emit()
	
func _on_test_refresh_map_button_pressed():
	refresh_map_button_pressed.emit()

func _on_activity_button_place_turret(turret_scene, location):
	place_turret.emit(turret_scene, location)

func _on_debug_enemy_button_pressed():
	var enemy = debug_enemy.instantiate()
	add_child(enemy)

func _on_map_parent_node_wave_ended():
	rewards_popup()
	get_upcoming_enemies()

func get_upcoming_enemies():
	var upcoming_text = "Upcoming:\n"
	for enemy_name in WaveManager.debug_enemy_dictionary.keys():
		var qty_str = str(WaveManager.debug_enemy_dictionary[enemy_name])
		upcoming_text += qty_str + " " + enemy_name + "\n"
	upcoming_enemies_label.text = upcoming_text
	
func rewards_popup():
	$PanelContainer.visible = true
	claim_countdown_text.visible = true
	$ClaimRewardsTimer.start()
	# While timer is ongoing (5s timer) I want to set the countdown text to be 5s 4s 3s 2s 1s in relation to time remaining how do i do it

func _on_claim_rewards_timer_timeout():
	claim_countdown_text.visible = false
	claim_rewards_button.visible = true

func _on_claim_rewards_button_pressed():
	upcoming_enemies_label.visible = true
	claim_rewards_button.visible = false
	$PanelContainer.visible = false
