extends Node

func add_gold(amount: int) -> void:
	Globals.gold += amount
	
func add_scrap_metal(amount: int) -> void:
	Globals.scrap_metal += amount
	
func add_gems(amount: int) -> void:
	Globals.gems += amount
	
func remove_gold(amount: int) -> bool:
	if Globals.gold >= amount:
		Globals.gold-=amount
		return true
	return false

func remove_scrap_metal(amount: int) -> bool:
	if Globals.scrap_metal >= amount:
		Globals.scrap_metal-=amount
		return true
	return false

func remove_gems(amount: int) -> bool:
	if Globals.gold >= amount:
		Globals.gold-=amount
		return true
	return false
		
