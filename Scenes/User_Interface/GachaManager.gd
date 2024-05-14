extends CanvasLayer

const RARITY_PROBABILITIES = {
	"common": 0.6,
	"uncommon": 0.3,
	"rare": 0.1,
	"epic": 0.05,
	"legendary": 0.01
}

const TURRET_DATA = {
	"common": {
		"icon": "res://Models/Turrets/Pea Shooter/pea_shooter_cover.png",
	},
	"uncommon": {
		"icon": "res://Models/Turrets/Carrot Cannon/carrot_cannon_cover.png",
	},
	"rare": {
		"icon": "res://Models/Turrets/Honeycomb Harpoon/honeycomb_harpoon_cover.png",
	},
	"epic": {
		"icon": "res://Models/Turrets/Haybale Barrage/haybale_barrage_cover.png",
	},
	"legendary": {
		"icon": "res://Models/Turrets/Strawberry Artillery/strawberry_artillery_cover.png",
	}
}

var last_rolled_rarity: String = ""

const ROLL_COST: int = 100

@onready var turret_preview: TextureRect = $GachaRoll/HBoxContainer/TurretPreview
@onready var roll_button: Button = $GachaRoll/HBoxContainer/RollButton
@onready var rarity_display: Label = $GachaRoll/HBoxContainer/RarityDisplay

func _ready():
	roll_button.connect("pressed", Callable(self, "_on_roll_button_pressed"))
	CurrencyDistributor.addGems(1000)

func _on_roll_button_pressed():
	if ROLL_COST < Globals.gems:
		CurrencyDistributor.subtractGems(ROLL_COST)
		last_rolled_rarity = _roll_for_turret()
		var turret_icon = await _start_spin_animation()
		if turret_icon:
			turret_preview.texture = turret_icon
			rarity_display.text = last_rolled_rarity.capitalize()
			
			var new_turret = _create_turret_data(last_rolled_rarity)
			var available_slot = Inventory.items.size()-1
			Inventory.add_item(new_turret)
	else:
		$GachaRoll/HBoxContainer/ErrorMessage.text = "Insufficient gems to roll for a new turret."

func _create_turret_data(rarity: String) -> Dictionary:
	var turret_data = {
		"IV": _get_random_iv(),
		"name": _get_turret_name_by_rarity(rarity),
		"damage": _get_damage_by_rarity(rarity),
		"turret_level": 1
	}
	return turret_data

func _get_turret_name_by_rarity(rarity: String) -> String:
	match rarity:
		"common":
			return "Pea Shooter"
		"uncommon":
			return "Carrot Cannon"
		"rare":
			return "Honeycomb Harpoon"
		"epic":
			return "Haybale Barrage"
		"legendary":
			return "Strawberry Artillery"
		_:
			return ""

func _get_random_iv() -> String:
	var iv = randi_range(50, 100)
	return str(iv) + "%"

func _get_damage_by_rarity(rarity: String) -> int:
	match rarity:
		"common":
			return 1
		"uncommon":
			return 2
		"rare":
			return 3
		"epic":
			return 4
		"legendary":
			return 5
		_:
			return 0

func _get_path_by_rarity(rarity: String) -> String:
	return rarity.to_lower()

func _get_activity_draggable_by_rarity(rarity: String) -> String:
	match rarity:
		"common":
			return "res://Models/Turrets/Pea Shooter/Pea_Shooter.gltf"
		"uncommon":
			return "res://Models/Turrets/Carrot Cannon/Carrot_Cannon.gltf"
		"rare":
			return "res://Models/Turrets/Honeycomb Harpoon/Honeycomb_Harpoon.gltf"
		"epic":
			return "res://Models/Turrets/Haybale Barrage/Haybale_Barrage.gltf"
		"legendary":
			return "res://Models/Turrets/Strawberry Artillery/Strawberry_Artillery.gltf"
		_:
			return ""

func _get_turret_to_instantiate_by_rarity(rarity: String) -> String:
	match rarity:
		"common":
			return "res://Scenes/Turrets/Pea Shooter/pea_shooter_container.tscn"
		"uncommon":
			return "res://Scenes/Turrets/Carrot Cannon/carrot_cannon_container.tscn"
		"rare":
			return "res://Scenes/Turrets/Honeycomb Harpoon/honeycomb_harpoon_container.tscn"
		"epic":
			return "res://Scenes/Turrets/Haybale Barrage/haybale_barrage_container.tscn"
		"legendary":
			return "res://Scenes/Turrets/Strawberry Artillery/strawberry_artillery_container.tscn"
		_:
			return ""

func _generate_unique_key() -> String:
	var key = ""
	for i in range(8):
		key += char(randi() % 26 + 97)
	return key

func _roll_for_turret() -> String:
	var random_value = randf()
	var cumulative_probability = 0.0
	var rarities = RARITY_PROBABILITIES.keys()
	for rarity in rarities:
		cumulative_probability += RARITY_PROBABILITIES[rarity]
		if random_value <= cumulative_probability:
			return rarity
	return "common"

func _start_spin_animation():
	var turret_icons = []
	for rarity in TURRET_DATA.keys():
		turret_icons.append(load(TURRET_DATA[rarity]["icon"]))

	var tween = get_tree().create_tween()
	for i in range(10):
		tween.tween_property(turret_preview, "texture", turret_icons[randi() % turret_icons.size()], 0.1) \
			 .set_trans(Tween.TRANS_LINEAR) \
			 .set_ease(Tween.EASE_IN_OUT)
	tween.play()

	await get_tree().create_timer(1.0).timeout
	var turret_icon = _get_turret_by_rarity(last_rolled_rarity)
	if turret_icon:
		tween = get_tree().create_tween()
		tween.tween_property(turret_preview, "texture", turret_icon, 0.5) \
			 .set_trans(Tween.TRANS_LINEAR) \
			 .set_ease(Tween.EASE_IN_OUT)
		tween.play()
		await tween.finished
	return turret_icon
	
func _get_turret_by_rarity(rarity: String):
	if TURRET_DATA.has(rarity):
		return load(TURRET_DATA[rarity]["icon"])
	else:
		return null
