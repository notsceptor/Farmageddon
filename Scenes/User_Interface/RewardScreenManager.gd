extends PanelContainer

@onready var start_gold
@onready var start_scrap
@onready var start_gems

@onready var gold_text: Label = $VBoxContainer/HBoxContainer/VBoxContainer/Label
@onready var scrap_text: Label = $VBoxContainer/HBoxContainer/VBoxContainer/Label2
@onready var gems_text: Label = $VBoxContainer/HBoxContainer/VBoxContainer/Label3

func _process(_delta):
	calculate_currency_gain()

func _on_next_wave_button_pressed():
	start_gold = Globals.gold
	start_scrap = Globals.scrap
	start_gems = Globals.gems
	
func _on_ui_wave_ended_from_map_parent():
	calculate_currency_gain()
	show_currencies_that_changed()

func calculate_currency_gain():
	var gold_gained = Globals.gold - start_gold
	var scrap_gained = Globals.scrap - start_scrap
	var gems_gained = Globals.gems - start_gems
	
	gold_text.text = "Gold: " + str(gold_gained)
	scrap_text.text = "Scrap: " + str(scrap_gained)
	gems_text.text = "Gems: " + str(gems_gained)
	
func show_currencies_that_changed():
	pass
