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
	var projectile_marker_index: int = 0
	for n in num:
		if current_enemy != null:
			var projectile: Projectile = projectile_type.instantiate()
			projectile.starting_position = projectile_markers[projectile_marker_index].global_position
			projectile.target = current_enemy
			projectile.speed = modified_projectile_speed
			if damage != null:
				projectile.damage = damage
			add_child(projectile)
			projectile_marker_index += 1
