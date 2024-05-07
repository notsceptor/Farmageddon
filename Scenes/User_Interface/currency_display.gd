extends Node

# UI elements
@onready var goldText = $ResourcesContainer/GoldLabel
@onready var scrapMetalText = $ResourcesContainer/ScrapMetalLabel
@onready var gemsText = $ResourcesContainer/GemsLabel


func _ready():
	# Update currency display initially
	UpdateCurrencyDisplay()

func UpdateCurrencyDisplay():
	goldText.text = str(Globals.gold)
	scrapMetalText.text = str(Globals.scrap)
	gemsText.text = str(Globals.gems)

func _process(delta):
	# Update currency display every frame
	UpdateCurrencyDisplay()
