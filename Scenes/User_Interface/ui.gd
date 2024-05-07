extends CanvasLayer

@onready var wave_number_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/WaveNumber
@onready var next_wave_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/NextWaveButton
@onready var refresh_wave_button: Button = $MarginContainer2/TestRefreshMapButton

# Rewards screen section
@onready var upcoming_enemies: Label = $MarginContainer/VBoxContainer/UpcomingEnemies
@onready var watch_ad_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/WatchAdvertButton
@onready var advert_hint_label: Label = $PanelContainer/VBoxContainer/AdvertHintLabel
@onready var countdown_text: Label = $PanelContainer/VBoxContainer/RewardsCountdownLabel
@onready var confirm_rewards_button: Button = $PanelContainer/VBoxContainer/ConfirmRewardsButton
@onready var reward_timer: Timer = $RewardCountdownTimer

@export var debug_enemy: PackedScene 

signal next_wave_button_pressed
signal refresh_map_button_pressed
signal place_turret(turret_scene, location)

func _ready():
	next_wave_button.visible = false
	upcoming_enemies.visible = false
	await get_tree().create_timer(1).timeout
	next_wave_button.visible = true
	upcoming_enemies.visible = true
	get_upcoming_enemies()
	
func _process(_delta):
	if !reward_timer.is_stopped():
		if reward_timer.time_left >= 4:
			countdown_text.text = "5s"
		elif reward_timer.time_left >= 3 and reward_timer.time_left < 4:
			countdown_text.text = "4s"
		elif reward_timer.time_left >= 2 and reward_timer.time_left < 3:
			countdown_text.text = "3s"
		elif reward_timer.time_left >= 1 and reward_timer.time_left < 2:
			countdown_text.text = "2s"
		else:
			countdown_text.text = "1s"

func _on_next_wave_button_pressed():
	next_wave_button_pressed.emit()
	next_wave_button.visible = false
	upcoming_enemies.visible = false
	
func _on_test_refresh_map_button_pressed():
	refresh_map_button_pressed.emit()

func _on_activity_button_place_turret(turret_scene, location):
	place_turret.emit(turret_scene, location)

func _on_debug_enemy_button_pressed():
	var enemy = debug_enemy.instantiate()
	add_child(enemy)
	
func get_upcoming_enemies():
	var upcoming_text = "Upcoming:\n"
	for enemy in WaveManager.debug_enemy_dictionary.keys():
		var qty_str = str(WaveManager.debug_enemy_dictionary[enemy])
		upcoming_text += qty_str + " " + enemy + "\n"
	upcoming_enemies.text = upcoming_text
	
func show_rewards_screen():
	advert_hint_label.text = "Watch an ad to double rewards"
	watch_ad_button.visible = true
	$PanelContainer.visible = true
	$RewardCountdownTimer.start()
	
func _on_watch_advert_button_pressed():
	watch_ad_button.visible = false
	advert_hint_label.text = "Enjoy double the rewards!"

func _on_confirm_rewards_button_pressed():
	GlobalAudioPlayer.play_idle_music()
	$PanelContainer.visible = false
	countdown_text.visible = true
	confirm_rewards_button.visible = false
	get_upcoming_enemies()
	next_wave_button.visible = true
	upcoming_enemies.visible = true
	
func _on_reward_countdown_timer_timeout():
	countdown_text.visible = false
	confirm_rewards_button.visible = true

func _on_map_parent_node_wave_ended():
	show_rewards_screen()
