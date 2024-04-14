extends Node

var ui_node: CanvasLayer

func add_gold(amount: int) -> void:
	Globals.gold += amount
	ui_node.update_UI()
	
func add_scrap_metal(amount: int) -> void:
	Globals.scrap_metal += amount
	ui_node.update_UI()
	
func add_gems(amount: int) -> void:
	Globals.gems += amount
	ui_node.update_UI()
	
func remove_gold(amount: int) -> bool:
	if Globals.gold >= amount:
		Globals.gold-=amount
		ui_node.update_UI()
		return true
	return false

func remove_scrap_metal(amount: int) -> bool:
	if Globals.scrap_metal >= amount:
		Globals.scrap_metal-=amount
		ui_node.update_UI()
		return true
	return false

func remove_gems(amount: int) -> bool:
	if Globals.gold >= amount:
		Globals.gold-=amount
		ui_node.update_UI()
		return true
	return false
		
