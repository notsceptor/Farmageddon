extends Turret

# Unique for every turret
var last_fire_time: int
@export var fire_rate_ms: int
@export var projectiles_to_shoot_at_a_time: int 
@export var projectile_speed: float
@export var projectile_type: PackedScene

var modified_projectile_speed: float

func _ready():
	GlobalAudioPlayer.play_placement_sound()
	turret_model = $SeedSniper/Node # Assign the turret model node
	shooter_node = $SeedSniper/Node/SeedSniper/Aim # Assign the shooter node
	var turret_area_rid = $SeedSniper/AreaRadius.get_rid()
	Globals.turret_rid_list.append(turret_area_rid)
	
	# set the individual projectile speed
	modified_projectile_speed = 15

func _on_seed_sniper_area_entered(area):
	if current_enemy == null:
		current_enemy = area
	enemies_in_range.append(area)

func _on_seed_sniper_area_exited(area):
	enemies_in_range.erase(area)

func _maybe_fire_turret_projectile():
	if Time.get_ticks_msec() > (last_fire_time+fire_rate_ms):
		$SeedSniper/AnimationPlayer.play("Shoot")
		GlobalAudioPlayer.play_seed_shot()
		var projectile: Projectile = projectile_type.instantiate()
		projectile.starting_position = $SeedSniper/Node/SeedSniper/Aim/ProjectileSpawnMarker.global_position
		projectile.target = current_enemy
		projectile.speed = modified_projectile_speed #set the new modified projectile speed down here
		add_child(projectile)
		last_fire_time = Time.get_ticks_msec()
