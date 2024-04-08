extends Turret

# Unique for every turret
var last_fire_time: int
@export var fire_rate_ms: int
@export var projectiles_to_shoot_at_a_time: int
@export var projectile_speed: float
@export var projectile_type: PackedScene

@onready var gunshot = $gunshot
@onready var turret_placement = $placement

var modified_projectile_speed: float

func _ready():
	turret_placement.play()
	turret_model = $PotatoLauncher/Node # Assign the turret model node
	shooter_node = $PotatoLauncher/Node/CarrotCannon/Aim # Assign the turret shooter node
	var turret_area_rid = $PotatoLauncher/AreaRadius.get_rid()
	Globals.turret_rid_list.append(turret_area_rid)
	
	#set the individual projectile speed
	modified_projectile_speed = 10

func _on_potato_launcher_area_entered(area):
	if current_enemy == null:
		current_enemy = area
	enemies_in_range.append(area)

func _on_potato_launcher_area_exited(area):
	enemies_in_range.erase(area)

func _maybe_fire_turret_projectile():
	if Time.get_ticks_msec() > (last_fire_time+fire_rate_ms):
		$PotatoLauncher/AnimationPlayer.play("Gatling Fire")
		gunshot.pitch_scale = randf_range(1.3, 1.5)
		gunshot.play()
		_spawn_projectiles(projectiles_to_shoot_at_a_time)
		last_fire_time = Time.get_ticks_msec()

func _spawn_projectiles(num: int):
	var projectile_markers: Array[Marker3D] = [
		$PotatoLauncher/Node/CarrotCannon/Aim/ProjectileSpawnMarker1,
		$PotatoLauncher/Node/CarrotCannon/Aim/ProjectileSpawnMarker2,
		$PotatoLauncher/Node/CarrotCannon/Aim/ProjectileSpawnMarker3,
		$PotatoLauncher/Node/CarrotCannon/Aim/ProjectileSpawnMarker4]
	var projectile_marker_index: int = 0
	for n in num:
		var projectile: Projectile = projectile_type.instantiate()
		projectile.starting_position = projectile_markers[projectile_marker_index].global_position
		projectile.target = current_enemy
		projectile.speed = modified_projectile_speed #set the new modified projectile speed down here
		add_child(projectile)
		projectile_marker_index += 1
		await get_tree().create_timer(0.15625).timeout
