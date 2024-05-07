extends Node

# Currency amounts
var gold = 0
var scrapMetal = 0 
var gems = 0

# UI elements
@onready var goldText = $GoldLabel
@onready var scrapMetalText = $ScrapMetalLabel
@onready var gemsText = $GemsLabel

func _ready():
	# Update currency display initially
	UpdateCurrencyDisplay()

func AddGold(amount):
	Globals.gold += amount
	StartCountUpAnimation(Globals.gold - amount, Globals.gold, goldText)

func AddScrapMetal(amount):
	Globals.scrap += amount
	StartCountUpAnimation(Globals.scrap - amount, Globals.scrap, scrapMetalText)

func AddGems(amount):
	Globals.gems += amount
	StartCountUpAnimation(Globals.gems - amount, Globals.gems, gemsText)

func StartCountUpAnimation(startAmount, endAmount, textElement):
	var tween = create_tween()
	tween.tween_property(textElement, "text", str(startAmount), 0.2)
	tween.tween_property(textElement, "text", str(endAmount), 0.5)

func UpdateCurrencyDisplay():
	goldText.text = str(gold)
	scrapMetalText.text = str(scrapMetal)
	gemsText.text = str(gems)

func _process(delta):
	# Update currency display every frame
	UpdateCurrencyDisplay()
