extends Node

# Declare variables for the coroutine
var update_duration = 0.5  # Duration of the update animation in seconds

signal gold_updated
signal gems_updated
signal scrap_updated

func addGold(amount):
	Globals.gold += amount
	gold_updated.emit()

func subtractGold(amount):
	if amount > Globals.gold:
		amount = Globals.gold
	Globals.gold -= amount

func addScrapMetal(amount):
	Globals.scrap += amount

func subtractScrapMetal(amount):
	if amount > Globals.scrap:
		amount = Globals.scrap
	Globals.scrap -= amount

func addGems(amount):
	Globals.gems += amount

func subtractGems(amount):
	if amount > Globals.gems:
		amount = Globals.gems
	Globals.gems -= amount


#func start_coroutine(amount, resource_name):
	#match resource_name:
		#"gold":
			#await update_resource(amount, "gold")
		#"scrap":
			#await update_resource(amount, "scrap")
		#"gems":
			#await update_resource(amount, "gems")
#
#func update_resource(amount, resource_name):
	#var start_value = Globals.get(resource_name)
	#var target_value = start_value + amount
	#var elapsed_time = 0.0
	#
	#while elapsed_time < update_duration:
		#elapsed_time += get_process_delta_time()
		#Globals.set(resource_name, round(lerp(start_value, target_value, elapsed_time / update_duration)))
		#await get_tree().process_frame
	#
	#Globals.set(resource_name, target_value)
