extends Turret

# Unique for every turret
var last_fire_time: int
@export var fire_rate_ms: int
@export var projectiles_to_shoot_at_a_time: int
@export var projectile_speed: float
@export var projectile_type: PackedScene

var modified_projectile_speed: float

func _ready():
	turret_model = $RadishRocket/Node # Assign the turret model node
	shooter_node = $RadishRocket/Node/RadishRocket/Aim # Assign the turret shooter node
	var turret_area_rid = $RadishRocket/AreaRadius.get_rid()
	Globals.turret_rid_list.append(turret_area_rid)
	
	#set the individual projectile speed
	modified_projectile_speed = 4

func _on_attacking_state_entered():
	print("Radish Rocket attacking")

func _on_radish_rocket_area_entered(area):
	print(area, " entered")
	if current_enemy == null:
		current_enemy = area
	enemies_in_range.append(area)
	print(enemies_in_range.size())

func _on_radish_rocket_area_exited(area):
	print(area, " exited")
	enemies_in_range.erase(area)
	print(enemies_in_range.size())

func _maybe_fire_turret_projectile():
	if Time.get_ticks_msec() > (last_fire_time+fire_rate_ms):
		print("FIRE RADISH ROCKET")
		$RadishRocket/AnimationPlayer.play("Shoot")
		_spawn_projectiles(projectiles_to_shoot_at_a_time)
		last_fire_time = Time.get_ticks_msec()

func _spawn_projectiles(num: int):
	var projectile_markers: Array[Marker3D] = [
		$RadishRocket/Node/RadishRocket/Aim/ProjectileSpawnMarker1,
		$RadishRocket/Node/RadishRocket/Aim/ProjectileSpawnMarker2,
		$RadishRocket/Node/RadishRocket/Aim/ProjectileSpawnMarker3,
		$RadishRocket/Node/RadishRocket/Aim/ProjectileSpawnMarker4,
		$RadishRocket/Node/RadishRocket/Aim/ProjectileSpawnMarker5,
		$RadishRocket/Node/RadishRocket/Aim/ProjectileSpawnMarker6]
	var projectile_marker_index: int = 0
	for n in num:
		var projectile: Projectile = projectile_type.instantiate()
		projectile.starting_position = projectile_markers[projectile_marker_index].global_position
		projectile.target = current_enemy
		projectile.speed = modified_projectile_speed #set the new modified projectile speed down here
		add_child(projectile)
		projectile_marker_index += 1
		await get_tree().create_timer(0.275).timeout





