extends Turret

# Unique for every turret
var last_fire_time: int
@export var fire_rate_ms: int
@export var projectiles_to_shoot_at_a_time: int
@export var projectile_speed: float
@export var projectile_type: PackedScene

@onready var gunshot = $gunshot
@onready var reload = $reload

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
		gunshot.pitch_scale = randf_range(0.8,1)
		gunshot.play()
		_spawn_projectiles(projectiles_to_shoot_at_a_time)
		last_fire_time = Time.get_ticks_msec()

func _spawn_projectiles(num: int):
	var projectile_marker = $BlueberryBlaster/Node/BlueberryBlaster/Aim/ProjectileSpawnMarker1
	
	var total_spread_angle = 45.0  # Total spread angle in degrees
	
	# Ensure num is at least 2 to avoid division by zero
	if num < 2:
		return
	
	var angle_step = total_spread_angle / float(num - 1)  # Calculate the angle step between projectiles
	
	for i in range(num):
		if current_enemy != null:
			var projectile: Projectile = projectile_type.instantiate()
			
			var direction_to_target = (current_enemy.global_position - projectile_marker.global_position).normalized()
			
			# Calculate the angle for the current projectile
			var angle_offset = deg_to_rad(-total_spread_angle / 2 + angle_step * i)
			var spread_vector = direction_to_target.rotated(Vector3.UP, angle_offset)
			
			var speed_multiplier = 1.0  # Use a fixed speed multiplier for uniform speed
			
			projectile.starting_position = projectile_marker.global_position
			projectile.target = current_enemy
			projectile.speed = modified_projectile_speed * speed_multiplier
			projectile.initial_direction = spread_vector
			if damage != null:
				projectile.damage = damage
			add_child(projectile)
	reload.play()
