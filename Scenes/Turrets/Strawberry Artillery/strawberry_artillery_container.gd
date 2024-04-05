extends Turret

func _ready():
	turret_model = $StrawberryArtillery/Node # Assign the turret model node
	shooter_node = $StrawberryArtillery/Node/StrawberryArtillery/Aim # Assign the shooter node
	var turret_area_rid = $StrawberryArtillery/AreaRadius.get_rid()
	Globals.turret_rid_list.append(turret_area_rid)

func _on_attacking_state_entered():
	print("Strawberry Artillery attacking")
	$StrawberryArtillery/AnimationPlayer.play("Fire In The Hole") #working

func _on_strawberry_artillery_area_entered(area):
	print(area, " entered")
	if current_enemy == null:
		current_enemy = area
	enemies_in_range.append(area)
	print(enemies_in_range.size())

func _on_strawberry_artillery_area_exited(area):
	print(area, " exited")
	enemies_in_range.erase(area)
	print(enemies_in_range.size())
