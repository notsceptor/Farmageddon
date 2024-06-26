extends Turret

@onready var spray_node_one = $SporeSprayer/Node/Spore/Aim/SprayEffect/SporeSpray
@onready var spray_node_two = $SporeSprayer/Node/Spore/Aim/SprayEffect/SporeSpray2
@onready var sporesprayer_spray = $SporeSprayer/Node/Spore/Aim/SprayEffect

var damage = null

func _ready():
	GlobalAudioPlayer.play_placement_sound()
	turret_model = $SporeSprayer/Node # Assign the turret model node
	shooter_node = $SporeSprayer/Node/Spore/Aim # Assign the shooter node
	var turret_area_rid = $SporeSprayer/AreaRadius.get_rid()
	Globals.turret_rid_list.append(turret_area_rid)

func _on_spore_sprayer_area_entered(area):
	sporesprayer_spray.damage = damage
	if current_enemy == null:
		current_enemy = area
	enemies_in_range.append(area)
	
func _on_spore_sprayer_area_exited(area):
	enemies_in_range.erase(area)

func _maybe_fire_turret_projectile():
	$SporeSprayer/AnimationPlayer.play("animation")
