extends Turret

@onready var spray_node_one = $SporeSprayer/Node/Spore/Aim/SprayEffect/SporeSpray
@onready var spray_node_two = $SporeSprayer/Node/Spore/Aim/SprayEffect/SporeSpray2

func _ready():
	turret_model = $SporeSprayer/Node # Assign the turret model node
	shooter_node = $SporeSprayer/Node/Spore/Aim # Assign the shooter node
	var turret_area_rid = $SporeSprayer/AreaRadius.get_rid()
	Globals.turret_rid_list.append(turret_area_rid)

func _on_attacking_state_entered():
	print("Spore Sprayer attacking")

func _on_spore_sprayer_area_entered(area):
	print(area, " entered")
	if current_enemy == null:
		current_enemy = area
	enemies_in_range.append(area)
	print(enemies_in_range.size())

func _on_spore_sprayer_area_exited(area):
	print(area, " exited")
	enemies_in_range.erase(area)
	print(enemies_in_range.size())

func _maybe_fire_turret_projectile():
	$SporeSprayer/AnimationPlayer.play("animation")
	spray_node_one.emitting = true
	spray_node_two.emitting = true

func _on_attacking_state_exited():
	spray_node_one.emitting = false
	spray_node_two.emitting = false
