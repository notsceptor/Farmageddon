extends CanvasLayer

const RARITY_PROBABILITIES = {
	"common": 0.6,
	"uncommon": 0.3,
	"rare": 0.1,
	"epic": 0.05,
	"currency": 0.03,
	"legendary": 0.01,
}

var last_rolled_rarity: String = ""
var last_rolled_currency: Dictionary

const ROLL_COST_GOLD: int = 500
const ROLL_COST_GEMS: int = 100

@onready var turret_preview: TextureRect = $GachaRoll/GachaContainer/TurretPreview
@onready var roll_button_gold: Button = $GachaRoll/GachaContainer/HBoxContainer/RollButtonGold
@onready var roll_button_gems: Button = $GachaRoll/GachaContainer/HBoxContainer/RollButtonGems
@onready var confirm_button = $GachaRoll/GachaContainer/HBoxContainer/ConfirmButton
@onready var rarity_display: Label = $GachaRoll/GachaContainer/RarityDisplay

func _ready():
	roll_button_gems.connect("pressed", Callable(self, "_on_gems_roll_button_pressed"))

func _on_gems_roll_button_pressed():
	GlobalAudioPlayer.play_menu_click_sound()
	if ROLL_COST_GEMS <= Globals.gems:
		roll_button_gems.visible = false
		roll_button_gold.visible = false
		rarity_display.visible = false
		CurrencyDistributor.subtractGems(ROLL_COST_GEMS)
		var roll_result = _roll_for_reward()
		if roll_result is String:
			last_rolled_rarity = roll_result
			var new_turret = _create_turret_data(last_rolled_rarity)
			var turret_icon = await _start_spin_animation(new_turret)
			if turret_icon:
				turret_preview.texture = turret_icon
				rarity_display.text = last_rolled_rarity.capitalize()
				rarity_display.add_theme_stylebox_override("normal", _get_rarity_texture_banner(last_rolled_rarity))
				rarity_display.visible = true
				var available_slot = Inventory.items.size() - 1
				Inventory.add_item(new_turret)
		else:
			last_rolled_currency = roll_result
			rarity_display.text = str(roll_result["amount"]) + " " + str(roll_result["currency"])
			rarity_display.visible = true
			match roll_result["currency"]:
				"gold":
					turret_preview.texture = load("res://Textures/gold_piece.png")
					Globals.gold += roll_result["amount"]
				"scrap":
					turret_preview.texture = load("res://Textures/scrap_piece.png")
					Globals.scrap += roll_result["amount"]
				"gems":
					turret_preview.texture = load("res://Textures/gem.png")
					Globals.gems += roll_result["amount"]
		confirm_button.visible = true
	else:
		$GachaRoll/GachaContainer/ErrorMessage.text = "Insufficient gems to roll for a new turret."

func _roll_for_reward():
	var random_value = randf()
	var cumulative_probability = 0.0
	var rewards = RARITY_PROBABILITIES.keys()
	for reward in rewards:
		cumulative_probability += RARITY_PROBABILITIES[reward]
		if random_value <= cumulative_probability:
			if reward == "currency":
				return _get_random_currency()
			else:
				return reward
	return "common"

func _get_random_currency() -> Dictionary:
	var currencies = ["gems", "gold", "scrap"]
	var currency = currencies[randi() % currencies.size()]
	var amount = randi_range(10, 100)  # Adjust the range as needed
	return {"currency": currency, "amount": amount}

func _create_turret_data(rarity: String) -> Dictionary:
	var turret_name = _get_turret_name_by_rarity(rarity)
	var turret_data = Turrets.get_turret_data(turret_name)
	
	var new_turret_data = {
		"ID": _get_random_id(),
		"name": turret_name,
		"damage": turret_data["damage"],
		"turret_level": 1,
		"placed": false
	}
	
	return new_turret_data

func _get_turret_name_by_rarity(rarity: String) -> String:
	var turret_names = []
	for turret in Turrets.turret_data[rarity]:
		turret_names.append(turret["name"])
	return turret_names[randi() % turret_names.size()]

func _get_random_id() -> String:
	var characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	var id = ""
	var existing_ids = []
	
	for item in Inventory.items:
		existing_ids.append(item.get("ID", ""))
	
	while true:
		id = ""
		for _i in range(5):
			id += characters[randi() % characters.length()]
		
		if not id in existing_ids:
			break
	
	return id

func _get_damage_by_rarity(rarity: String) -> int:
	var turret_names = []
	for turret in Turrets.turret_data[rarity]:
		turret_names.append(turret["name"])
	
	var turret_name = turret_names[randi() % turret_names.size()]
	var turret_data = Turrets.get_turret_data(turret_name)
	return turret_data["damage"]

func _roll_for_turret() -> String:
	var random_value = randf()
	var cumulative_probability = 0.0
	var rarities = RARITY_PROBABILITIES.keys()
	for rarity in rarities:
		cumulative_probability += RARITY_PROBABILITIES[rarity]
		if random_value <= cumulative_probability:
			return rarity
	return "common"

func _start_spin_animation(new_turret: Dictionary):
	var turret_icons = []
	for rarity in Turrets.turret_data.keys():
		for turret in Turrets.turret_data[rarity]:
			turret_icons.append(load(turret["icon"]))

	var tween = get_tree().create_tween()
	for i in range(10):
		tween.tween_property(turret_preview, "texture", turret_icons[randi() % turret_icons.size()], 0.1) \
			 .set_trans(Tween.TRANS_LINEAR) \
			 .set_ease(Tween.EASE_IN_OUT)
	tween.play()

	await get_tree().create_timer(1.0).timeout

	var turret_data = Turrets.get_turret_data(new_turret["name"])
	var turret_icon = load(turret_data["icon"])

	if turret_icon:
		tween = get_tree().create_tween()
		tween.tween_property(turret_preview, "texture", turret_icon, 0.5) \
			 .set_trans(Tween.TRANS_LINEAR) \
			 .set_ease(Tween.EASE_IN_OUT)
		tween.play()
		await tween.finished

	return turret_icon

func _on_roll_button_gold_pressed():
	GlobalAudioPlayer.play_menu_click_sound()
	if ROLL_COST_GOLD <= Globals.gold:
		roll_button_gems.visible = false
		roll_button_gold.visible = false
		rarity_display.visible = false
		confirm_button.visible = false
		CurrencyDistributor.subtractGold(ROLL_COST_GOLD)
		var roll_result = _roll_for_reward()
		if roll_result is String:
			last_rolled_rarity = roll_result
			var new_turret = _create_turret_data(last_rolled_rarity)
			var turret_icon = await _start_spin_animation(new_turret)
			if turret_icon:
				turret_preview.texture = turret_icon
				rarity_display.text = last_rolled_rarity.capitalize()
				rarity_display.add_theme_stylebox_override("normal", _get_rarity_texture_banner(last_rolled_rarity))
				rarity_display.visible = true
				var available_slot = Inventory.items.size() - 1
				Inventory.add_item(new_turret)
		else:
			last_rolled_currency = roll_result
			rarity_display.text = str(roll_result["amount"]) + " " + str(roll_result["currency"])
			rarity_display.visible = true
			match roll_result["currency"]:
				"gold":
					turret_preview.texture = load("res://Textures/gold_piece.png")
					Globals.gold += roll_result["amount"]
				"scrap":
					turret_preview.texture = load("res://Textures/scrap_piece.png")
					Globals.scrap += roll_result["amount"]
				"gems":
					turret_preview.texture = load("res://Textures/gem.png")
					Globals.gems += roll_result["amount"]
		confirm_button.visible = true
	else:
		$GachaRoll/GachaContainer/ErrorMessage.text = "Insufficient gold to roll for a new turret."

func _on_confirm_button_pressed():
	GlobalAudioPlayer.play_menu_click_sound()
	_prepare_next_roll()
	
func _prepare_next_roll():
	confirm_button.visible = false
	roll_button_gems.visible = true
	roll_button_gold.visible = true
	
func _get_rarity_texture_banner(rarity: String):
	var turret_banner
	match rarity:
		"common":
			turret_banner = preload("res://Scenes/User_Interface/Assets/banners/common_banner.tres")
		"uncommon":
			turret_banner = preload("res://Scenes/User_Interface/Assets/banners/uncommon_banner.tres")
		"rare":
			turret_banner = preload("res://Scenes/User_Interface/Assets/banners/rare_banner.tres")
		"epic":
			turret_banner = preload("res://Scenes/User_Interface/Assets/banners/epic_banner.tres")
		"legendary":
			turret_banner = preload("res://Scenes/User_Interface/Assets/banners/legendary_banner.tres")
	return turret_banner
