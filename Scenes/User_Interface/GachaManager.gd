extends CanvasLayer

const RARITY_PROBABILITIES = {
	"common": 0.6,
	"uncommon": 0.3,
	"rare": 0.1,
	"epic": 0.05,
	"legendary": 0.01
}

var last_rolled_rarity: String = ""

const ROLL_COST: int = 100

@onready var turret_preview: TextureRect = $GachaRoll/HBoxContainer/TurretPreview
@onready var roll_button: Button = $GachaRoll/HBoxContainer/RollButton

#currency system implementation
@onready var gold_label: Label = $ResourcesContainer/GoldLabel
@onready var scrap_metal_label: Label = $ResourcesContainer/ScrapMetalLabel
@onready var gems_label: Label = $ResourcesContainer/GemsLabel

#currency progress bars
@onready var gold_progress_bar: ProgressBar = $ResourcesContainer/GoldProgress
@onready var scrap_metal_progress_bar: ProgressBar = $ResourcesContainer/ScrapProgress
@onready var gems_progress_bar: ProgressBar = $ResourcesContainer/GemsProgress

func _ready():
	roll_button.connect("pressed", Callable(self, "_on_roll_button_pressed"))
	CurrencyManager.ui_node = self
	
func update_UI():
	gold_label.text = str(Globals.gold)
	scrap_metal_label.text = str(Globals.scrap_metal)
	gems_label.text = str(Globals.gems)
	update_progress_bars()
	
func update_progress_bars():
	gold_progress_bar.max_value = 1000
	gold_progress_bar.value = Globals.gold
	
	scrap_metal_progress_bar.max_value = 1000
	scrap_metal_progress_bar.value = Globals.scrap_metal
	
	gems_progress_bar.max_value = 1000
	gems_progress_bar.value = Globals.gems

func _on_roll_button_pressed():
	if CurrencyManager.remove_gold(ROLL_COST):
		last_rolled_rarity = _roll_for_turret()
		
		var turret_icon = _get_turret_by_rarity(last_rolled_rarity)
		
		if turret_icon:
			turret_preview.texture = turret_icon
		
		$GachaRoll/HBoxContainer/RarityDisplay.text = last_rolled_rarity.capitalize()
	else:
		$GachaRoll/HBoxContainer/ErrorMessage.text = "Insufficient gold to roll for a new turret."

func _roll_for_turret() -> String:
	var random_value = randf()
	var cumulative_probability = 0.0
	
	var rarities = RARITY_PROBABILITIES.keys()
	
	for rarity in rarities:
		cumulative_probability += RARITY_PROBABILITIES[rarity]
		if random_value <= cumulative_probability:
			return rarity
	
	return "common"

func _get_turret_by_rarity(rarity: String):
	match rarity:
		"common":
			return load("res://Models/Turrets/Pea Shooter/pea_shooter_cover.png")
		"uncommon":
			return load("res://Models/Turrets/Carrot Cannon/carrot_cannon_cover.png")
		"rare":
			return load("res://Models/Turrets/Honeycomb Harpoon/honeycomb_harpoon_cover.png")
		"epic":
			return load("res://Models/Turrets/Haybale Barrage/haybale_barrage_cover.png")
		"legendary":
			return load("res://Models/Turrets/Strawberry Artillery/strawberry_artillery_cover.png")
		_:
			return null
