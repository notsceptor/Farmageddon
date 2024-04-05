extends Turret

# Unique for every turret
var last_fire_time: int
@export var fire_rate_ms: int
@export var projectiles_to_shoot_at_a_time: int
@export var projectile_speed: float
@export var projectile_type: PackedScene

func _ready():
	turret_model = $PotatoLauncher/Node # Assign the turret model node
	shooter_node = $PotatoLauncher/Node/CarrotCannon/Aim # Assign the turret shooter node
	var turret_area_rid = $PotatoLauncher/AreaRadius.get_rid()
	Globals.turret_rid_list.append(turret_area_rid)

func _on_attacking_state_entered():
	print("Potato Launcher attacking")

func _on_potato_launcher_area_entered(area):
	print(area, " entered")
	if current_enemy == null:
		current_enemy = area
	enemies_in_range.append(area)
	print(enemies_in_range.size())

func _on_potato_launcher_area_exited(area):
	print(area, " exited")
	enemies_in_range.erase(area)
	print(enemies_in_range.size())

func _maybe_fire_turret_projectile():
	if Time.get_ticks_msec() > (last_fire_time+fire_rate_ms):
		print("FIRE POTATO LAUNCHER")
		$PotatoLauncher/AnimationPlayer.play("Gatling Fire")
		_spawn_projectiles(projectiles_to_shoot_at_a_time)
		last_fire_time = Time.get_ticks_msec()

func _spawn_projectiles(num: int):
	for n in num:
		var projectile: Projectile = projectile_type.instantiate()
		projectile.starting_position = $PotatoLauncher/Node/CarrotCannon/Aim/ProjectileSpawnMarker.global_position
		projectile.target = current_enemy
		projectile.speed = projectile_speed
		add_child(projectile)
		await get_tree().create_timer(0.15625).timeout
