extends CanvasLayer

@onready var wave_number_label: Label = $MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/WaveNumber
@onready var next_wave_button: Button = $MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/NextWaveButton

# Rewards screen section
@onready var upcoming_enemies: Label = $MarginContainer/VBoxContainer/PanelContainer2/UpcomingEnemies
@onready var upcoming_enemies_container: PanelContainer = $MarginContainer/VBoxContainer/PanelContainer2
@onready var enemies_game_tracker: PanelContainer = $MarginContainer/VBoxContainer/EnemiesTracker
@onready var watch_ad_button: Button = $RewardsContainer/VBoxContainer/HBoxContainer/WatchAdvertButton
@onready var advert_hint_label: Label = $RewardsContainer/VBoxContainer/AdvertHintLabel
@onready var countdown_text: Label = $RewardsContainer/VBoxContainer/RewardsCountdownLabel
@onready var confirm_rewards_button: Button = $RewardsContainer/VBoxContainer/ConfirmRewardsButton
@onready var reward_timer: Timer = $RewardCountdownTimer
@onready var advert_timer: Timer = $ShowAdvertTimer

signal next_wave_button_pressed
signal place_turret(turret_scene, location)

signal wave_ended_from_map_parent
signal advert_finished
signal confirmed_rewards

func _ready():
	next_wave_button.visible = false
	upcoming_enemies_container.visible = false
	enemies_game_tracker.visible = false
	await get_tree().create_timer(1).timeout
	next_wave_button.visible = true
	upcoming_enemies_container.visible = true
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
	upcoming_enemies_container.visible = false
	enemies_game_tracker.visible = true

func _on_activity_button_place_turret(turret_scene, location):
	place_turret.emit(turret_scene, location)
	
func get_upcoming_enemies():
	var upcoming_text = "Upcoming:\n"
	for enemy in WaveManager.debug_enemy_dictionary.keys():
		var qty_str = str(WaveManager.debug_enemy_dictionary[enemy])
		upcoming_text += qty_str + " " + enemy + "\n"
	if WaveManager.current_wave_is_boss_wave:
		upcoming_text += "1 Boss Enemy (Random)"
	upcoming_enemies.text = upcoming_text
	
func show_rewards_screen():
	advert_hint_label.text = "Watch an ad to double rewards"
	watch_ad_button.visible = false
	advert_hint_label.visible = false
	$RewardsContainer.visible = true
	reward_timer.start()
	advert_timer.start()
	
func _on_watch_advert_button_pressed():
	watch_ad_button.visible = false
	advert_hint_label.text = "Enjoy double the rewards!"
	advert_finished.emit()

func _on_confirm_rewards_button_pressed():
	GlobalAudioPlayer.play_idle_music()
	$RewardsContainer.visible = false
	countdown_text.visible = true
	confirm_rewards_button.visible = false
	enemies_game_tracker.visible = false
	get_upcoming_enemies()
	next_wave_button.visible = true
	upcoming_enemies_container.visible = true
	confirmed_rewards.emit()
	
func _on_reward_countdown_timer_timeout():
	countdown_text.visible = false
	confirm_rewards_button.visible = true

func _on_map_parent_node_wave_ended():
	show_rewards_screen()
	wave_ended_from_map_parent.emit()

func _on_show_advert_timer_timeout():
	watch_ad_button.visible = true
	advert_hint_label.visible = true
