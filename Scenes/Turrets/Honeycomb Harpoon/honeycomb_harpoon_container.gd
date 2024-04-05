extends Turret

# Unique for every turret
var last_fire_time: int
@export var fire_rate_ms: int
@export var projectiles_to_shoot_at_a_time: int 
@export var projectile_speed: float
@export var projectile_type: PackedScene

func _ready():
	turret_model = $HoneycombHarpoon/Node # Assign the turret model node
	shooter_node = $HoneycombHarpoon/Node/HoneycombHarpoon/Aim # Assign the shooter node
	var turret_area_rid = $HoneycombHarpoon/AreaRadius.get_rid()
	Globals.turret_rid_list.append(turret_area_rid)

func _on_attacking_state_entered():
	print("Honeycomb Harpoon attacking")

func _on_honeycomb_harpoon_area_entered(area):
	print(area, " entered")
	if current_enemy == null:
		current_enemy = area
	enemies_in_range.append(area)
	print(enemies_in_range.size())

func _on_honeycomb_harpoon_area_exited(area):
	print(area, " exited")
	enemies_in_range.erase(area)
	print(enemies_in_range.size())
	
func _maybe_fire_turret_projectile():
	if Time.get_ticks_msec() > (last_fire_time+fire_rate_ms):
		print("FIRE HONEYCOMB HARPOON")
		$HoneycombHarpoon/AnimationPlayer.play("Shoot")
		var projectile: Projectile = projectile_type.instantiate()
		projectile.starting_position = $HoneycombHarpoon/Node/HoneycombHarpoon/Aim/ProjectileSpawnMarker.global_position
		projectile.target = current_enemy
		projectile.speed = projectile_speed
		add_child(projectile)
		last_fire_time = Time.get_ticks_msec()
