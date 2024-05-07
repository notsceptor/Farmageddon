extends Control

# Currency amounts
var gold = 0
var scrapMetal = 0 
var gems = 0

# UI elements

func _ready():
	# Update currency display initially
	UpdateCurrencyDisplay()

func AddGold(amount):
	gold += amount
	StartCountUpAnimation(gold - amount, gold, goldText)

func AddScrapMetal(amount):
	scrapMetal += amount
	StartCountUpAnimation(scrapMetal - amount, scrapMetal, scrapMetalText)

func AddGems(amount):
	gems += amount
	StartCountUpAnimation(gems - amount, gems, gemsText)

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
