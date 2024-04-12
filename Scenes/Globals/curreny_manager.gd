extends Node

var gold: int = 0
var scrap_metal: int = 0
var gems: int = 0

func add_gold(amount: int) -> void:
	gold += amount
	
func add_scrap_metal(amount: int) -> void:
	scrap_metal += amount
	
func add_gems(amount: int) -> void:
	gems += amount
	
func remove_gold(amount: int) -> bool:
	if gold >= amount:
		gold-=amount
		return true
	return false

func remove_scrap_metal(amount: int) -> bool:
	if scrap_metal >= amount:
		scrap_metal-=amount
		return true
	return false

func remove_gems(amount: int) -> bool:
	if gold >= amount:
		gold-=amount
		return true
	return false
		
