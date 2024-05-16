extends GridContainer

@onready var item_preview: Control = $"../../../../../UpgradeContainer/PanelContainer/MarginContainer/VBoxContainer/TurretPreview"
@onready var stat_change_label: Label = $"../../../../../UpgradeContainer/PanelContainer/MarginContainer/VBoxContainer/StatChange"
@onready var resources_to_upgrade_label: Label = $"../../../../../UpgradeContainer/PanelContainer/MarginContainer/VBoxContainer/ResourcesNeeded"
@onready var turret_name_label: Label = $"../../../../../UpgradeContainer/PanelContainer/MarginContainer/VBoxContainer/TurretName"
@onready var upgrade_button: Button = $"../../../../../UpgradeContainer/PanelContainer/MarginContainer/VBoxContainer/UpgradeButton"
@onready var scrap_button: Button = $"../../../../../UpgradeContainer/PanelContainer/MarginContainer/VBoxContainer/ScrapButton"


var upgrade_levels: Dictionary = {}

var currently_selected_turret_rarity
var currently_selected_turret_level
var currently_selected_turret_id

func _ready():
	populate_grid()
	upgrade_button.visible = false
	scrap_button.visible = false

func populate_grid():
	self.columns = 7
	
	for child in get_children():
		child.queue_free()

	for row in range(7):
		for col in range(7):
			var background = ColorRect.new()
			background.color = Color(0, 0, 0, 0.5)
			background.custom_minimum_size = Vector2(114, 114)
			background.show_behind_parent = true

			var square = TextureRect.new()
			var index = row * 7 + col
			if index < Inventory.items.size():
				var item_data = Inventory.items[index]
				if item_data is Dictionary:
					var turret_data = Turrets.get_turret_data(item_data.name)
					square.texture = load(turret_data.icon)
					print(item_data)
					var turret_metadata = {
						"description": turret_data.description,
						"rarity": turret_data.rarity,
						"turret_to_instantiate": turret_data.turret_to_instantiate,
						"icon": turret_data.icon,
						"damage": item_data.damage,
						"ID": item_data.ID,
						"name": item_data.name,
						"turret_level": item_data.turret_level
					}
					square.set_meta("turret_data", turret_metadata)

			square.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			square.custom_minimum_size = Vector2(114, 114)
			background.add_child(square)
			square.connect("gui_input", Callable(self, "_on_gui_input").bind(square))
			add_child(background)
			
func _on_gui_input(event: InputEvent, node: TextureRect):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if !node.get_meta("turret_data"):
			return

		if event.is_pressed():
			GlobalAudioPlayer.play_menu_click_sound()
			var item_data = node.get_meta("turret_data")
			display_item_preview(item_data)
			upgrade_button.visible = true
			scrap_button.visible = true

func display_item_preview(turret_metadata: Dictionary):
	for child in item_preview.get_children():
		child.queue_free()

	var enlarged_icon = TextureRect.new()
	enlarged_icon.texture = load(turret_metadata.icon)
	enlarged_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	enlarged_icon.custom_minimum_size = Vector2(256, 256)

	item_preview.add_child(enlarged_icon)

	turret_name_label.text = turret_metadata.name

	var base_turret_data = Turrets.get_turret_data(turret_metadata.name)
	var base_damage = base_turret_data.damage
	var current_damage = turret_metadata.damage
	var damage_increase = calculate_damage_increase(base_damage, current_damage)
	var new_damage = current_damage + damage_increase
	
	currently_selected_turret_rarity = turret_metadata.rarity
	currently_selected_turret_level = turret_metadata.turret_level
	currently_selected_turret_id = turret_metadata.ID

	stat_change_label.text = "Damage: %d" % new_damage

	var upgrade_cost = calculate_upgrade_cost(turret_metadata.rarity, turret_metadata.turret_level + 1)
	resources_to_upgrade_label.text = "Upgrade Cost: %d Gold" % upgrade_cost

	upgrade_button.text = "Upgrade"

	upgrade_button.disconnect("pressed", Callable(self, "_on_upgrade_button_pressed"))
	upgrade_button.connect("pressed", Callable(self, "_on_upgrade_button_pressed").bind(turret_metadata))

func calculate_damage_increase(base_damage: int, current_damage: int) -> int:
	var damage_increase = (base_damage + current_damage) / 10 + 1
	return damage_increase

func calculate_upgrade_cost(rarity: String, upgrade_level: int) -> int:
	var base_cost = 0
	match rarity:
		"common":
			base_cost = 100
		"uncommon":
			base_cost = 200
		"rare":
			base_cost = 300
		"epic":
			base_cost = 400
		"legendary":
			base_cost = 500

	var level_multiplier = 1.0
	if upgrade_level > 1:
		level_multiplier = pow(1.2, upgrade_level - 1)

	return int(base_cost * level_multiplier)

func _on_upgrade_button_pressed(turret_metadata: Dictionary):
	GlobalAudioPlayer.play_menu_click_sound()
	var current_upgrade_level = turret_metadata.turret_level
	var next_upgrade_level = current_upgrade_level + 1
	var upgrade_cost = calculate_upgrade_cost(turret_metadata.rarity, next_upgrade_level)

	if Globals.gold >= upgrade_cost:
		Globals.gold -= upgrade_cost

		var base_turret_data = Turrets.get_turret_data(turret_metadata.name)
		var base_damage = base_turret_data.damage
		var current_damage = turret_metadata.damage
		var damage_increase = calculate_damage_increase(base_damage, current_damage)

		turret_metadata.damage += damage_increase
		turret_metadata.turret_level += 1

		for i in range(Inventory.items.size()):
			var inventory_item = Inventory.items[i]
			if inventory_item is Dictionary and inventory_item.name == turret_metadata.name and inventory_item.ID == turret_metadata.ID:
				Inventory.items[i].damage = turret_metadata.damage
				Inventory.items[i].turret_level = next_upgrade_level
				break

		Inventory._save_items()

		display_item_preview(turret_metadata)
	else:
		print("Not enough gold to upgrade")

@onready var upgrade_container = $"../../../../../UpgradeContainer"
@onready var scrap_notification_container = $"../../../../../../ScrapNotification"
@onready var scrap_title = $"../../../../../../ScrapNotification/VBoxContainer/ScrapTitle"
@onready var scrap_confirmation = $"../../../../../../ScrapNotification/VBoxContainer/ScrapConfirmation"

func _on_scrap_button_pressed():
	var scrap_confirmation_text = "ARE YOU SURE YOU WANT TO SCRAP THIS\nTURRET FOR %d SCRAP?"
	scrap_title.text = "SCRAPPING " + turret_name_label.text
	scrap_confirmation.text = scrap_confirmation_text % _calculate_scrap_cost(currently_selected_turret_rarity, currently_selected_turret_level)
	GlobalAudioPlayer.play_menu_click_sound()
	upgrade_button.visible = false
	scrap_button.visible = false
	scrap_notification_container.visible = true

func _on_yes_scrap_button_pressed():
	GlobalAudioPlayer.play_menu_click_sound()
	CurrencyDistributor.addScrapMetal(_calculate_scrap_cost(currently_selected_turret_rarity, currently_selected_turret_level))
	for i in range(Inventory.items.size()):
		if Inventory.items[i]["ID"] == currently_selected_turret_id:
			Inventory.remove_item(i)
			_reset_turret_preview()
			populate_grid()
			break
	scrap_notification_container.visible = false

func _on_no_scrap_button_pressed():
	GlobalAudioPlayer.play_menu_click_sound()
	scrap_notification_container.visible = false
	upgrade_button.visible = true
	scrap_button.visible = true

func _calculate_scrap_cost(turret_rarity: String, turret_level: int) -> int:
	var scrap_amount = 0
	match turret_rarity:
		"common":
			scrap_amount = 50
		"uncommon":
			scrap_amount = 75
		"rare":
			scrap_amount = 125
		"epic":
			scrap_amount = 200
		"legendary":
			scrap_amount = 300
	if turret_level == 1:
		return scrap_amount
	else:
		return scrap_amount + ((ceilf(0.5*scrap_amount)) * turret_level)
		
func _reset_turret_preview():
	item_preview.get_child(0).queue_free()
	turret_name_label.text = "SELECT TURRET"
	resources_to_upgrade_label.text = "SELECT A TURRET FROM THE LEFT TO VIEW"
	stat_change_label.text = ""
