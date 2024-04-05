extends Turret

var last_fire_time: int
@export var fire_rate_ms: int = 2000
@export var peas_to_shoot_at_a_time: int = 4
@export var projectile_type: PackedScene

func _ready():
	turret_model = $PeaShooter/Node  # Assign the turret model node
	shooter_node = $PeaShooter/Node/PeaShooter/ShooterTop  # Assign the shooter node
	var turret_area_rid = $PeaShooter/AreaRadius.get_rid()
	Globals.turret_rid_list.append(turret_area_rid)

func _on_attacking_state_entered():
	print("Pea shooter attacking")
	last_fire_time = 0
	peas_to_shoot_at_a_time = 4
	
func _on_pea_shooter_area_entered(area):
	print(area, " entered")
	if current_enemy == null:
		current_enemy = area
	enemies_in_range.append(area)
	print(enemies_in_range.size())

func _on_pea_shooter_area_exited(area):
	print(area, " exited")
	enemies_in_range.erase(area)
	print(enemies_in_range.size())

func _maybe_fire_turret_projectile():
	if Time.get_ticks_msec() > (last_fire_time+fire_rate_ms):
		print("FIRE PEA SHOOTER")
		$PeaShooter/AnimationPlayer.play("Shoot")
		_spawn_projectiles(peas_to_shoot_at_a_time)
		last_fire_time = Time.get_ticks_msec()
		
func _spawn_projectiles(num: int):
	for n in num:
		var projectile: DebugProjectile = projectile_type.instantiate()
		projectile.starting_position = $PeaShooter/Node/PeaShooter/ShooterTop/ProjectileSpawnMarker.global_position
		projectile.target = current_enemy
		add_child(projectile)
		await get_tree().create_timer(0.25).timeout
