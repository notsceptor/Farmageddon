extends Turret

# Unique for every turret
var last_fire_time: int
@export var fire_rate_ms: int
@export var projectiles_to_shoot_at_a_time: int
@export var projectile_speed: float
@export var projectile_type: PackedScene

@onready var gunshot = $gunshot

var modified_projectile_speed: float
var damage = null

func _ready():
	GlobalAudioPlayer.play_placement_sound()
	turret_model = $BlueberryBlaster/Node # Assign the turret model node
	shooter_node = $BlueberryBlaster/Node/BlueberryBlaster/Aim # Assign the turret shooter node
	var turret_area_rid = $BlueberryBlaster/AreaRadius.get_rid()
	Globals.turret_rid_list.append(turret_area_rid)
	
	#set the individual projectile speed
	modified_projectile_speed = 10

func _on_blueberry_blaster_area_entered(area):
	if current_enemy == null:
		current_enemy = area
	enemies_in_range.append(area)

func _on_blueberry_blaster_area_exited(area):
	enemies_in_range.erase(area)

func _maybe_fire_turret_projectile():
	if Time.get_ticks_msec() > (last_fire_time+fire_rate_ms):
		$BlueberryBlaster/AnimationPlayer.play("Fire")
		gunshot.pitch_scale = randf_range(1.3, 1.5)
		gunshot.play()
		_spawn_projectiles(projectiles_to_shoot_at_a_time)
		last_fire_time = Time.get_ticks_msec()

func _spawn_projectiles(num: int):
	var projectile_markers: Array[Marker3D] = [
		$BlueberryBlaster/Node/BlueberryBlaster/Aim/ProjectileSpawnMarker1,
		$BlueberryBlaster/Node/BlueberryBlaster/Aim/ProjectileSpawnMarker2,
		$BlueberryBlaster/Node/BlueberryBlaster/Aim/ProjectileSpawnMarker3,
		$BlueberryBlaster/Node/BlueberryBlaster/Aim/ProjectileSpawnMarker4,
		$BlueberryBlaster/Node/BlueberryBlaster/Aim/ProjectileSpawnMarker5,
		$BlueberryBlaster/Node/BlueberryBlaster/Aim/ProjectileSpawnMarker6,
		$BlueberryBlaster/Node/BlueberryBlaster/Aim/ProjectileSpawnMarker7,
		$BlueberryBlaster/Node/BlueberryBlaster/Aim/ProjectileSpawnMarker8]
	
	var min_spread_angle = 30.0
	var max_spread_angle = 150.0
	
	var min_speed_multiplier = 0.5
	var max_speed_multiplier = 1.5
	
	for _n in num:
		if current_enemy != null:
			var projectile: Projectile = projectile_type.instantiate()
			
			var direction_to_target = (current_enemy.global_position - projectile_markers[0].global_position).normalized()
			
			var spread_angle = randf_range(min_spread_angle, max_spread_angle)
			
			var random_direction = Vector3(
				direction_to_target.x + randf_range(-spread_angle / 2.0, spread_angle / 2.0),
				direction_to_target.y,
				direction_to_target.z + randf_range(-spread_angle / 2.0, spread_angle / 2.0)
			).normalized()
			
			var offset_distance = randf_range(0.0, 1.0)
			var offset_direction = random_direction.rotated(Vector3.UP, deg_to_rad(randf_range(-spread_angle / 2.0, spread_angle / 2.0)))
			offset_direction = offset_direction.rotated(Vector3.RIGHT, deg_to_rad(randf_range(-spread_angle / 2.0, spread_angle / 2.0)))
			var random_offset = offset_direction * offset_distance
			
			var speed_multiplier = randf_range(min_speed_multiplier, max_speed_multiplier)
			
			projectile.starting_position = projectile_markers[0].global_position + random_offset
			projectile.target = current_enemy
			projectile.speed = modified_projectile_speed * speed_multiplier
			projectile.initial_direction = random_direction
			if damage != null:
				projectile.damage = damage
			add_child(projectile)
