extends PanelContainer

@onready var start_gold
@onready var start_scrap
@onready var start_gems

@onready var gold_gained
@onready var scrap_gained
@onready var gems_gained

@onready var gold_text: Label = $VBoxContainer/HBoxContainer/VBoxContainer/Label
@onready var scrap_text: Label = $VBoxContainer/HBoxContainer/VBoxContainer/Label2
@onready var gems_text: Label = $VBoxContainer/HBoxContainer/VBoxContainer/Label3
@onready var wave_outcome_text: Label = $VBoxContainer/WaveOutcome

func _ready():
	start_gold = Globals.gold
	start_scrap = Globals.scrap
	start_gems = Globals.gems

func _process(_delta):
	if visible:
		calculate_and_show_currency_gain()

func _on_next_wave_button_pressed():
	start_gold = Globals.gold
	start_scrap = Globals.scrap
	start_gems = Globals.gems
	
func _on_ui_wave_ended_from_map_parent():
	wave_outcome_text.text = "WAVE WON" 
	if !WaveManager.wave_won:
		wave_outcome_text.text = "WAVE LOST"
	calculate_and_show_currency_gain()

func calculate_and_show_currency_gain():
	gold_gained = Globals.gold - start_gold
	scrap_gained = Globals.scrap - start_scrap
	gems_gained = Globals.gems - start_gems
	
	gold_text.text = "Gold: " + str(gold_gained)
	scrap_text.text = "Scrap: " + str(scrap_gained)
	gems_text.text = "Gems: " + str(gems_gained)
	
	if gold_gained > 0:
		gold_text.visible = true
	else:
		gold_text.visible = false
		
	if scrap_gained > 0:
		scrap_text.visible = true
	else:
		scrap_text.visible = false
		
	if gems_gained > 0:
		gems_text.visible = true
	else:
		gems_text.visible = false
	
func _on_ui_advert_finished():
	if gold_gained > 0:
		CurrencyDistributor.addGold(gold_gained)
	if scrap_gained > 0:
		CurrencyDistributor.addScrapMetal(scrap_gained)
	if gems_gained > 0:
		CurrencyDistributor.addGems(gems_gained)

func _on_ui_confirmed_rewards():
	gold_gained = 0
	scrap_gained = 0
	gems_gained = 0
