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
	turret_model = $HaybaleBarrage/Node  # Assign the turret model node
	shooter_node = $HaybaleBarrage/Node/HaybaleBarrage/Aim # Assign the shooter node
	var turret_area_rid = $HaybaleBarrage/AreaRadius.get_rid()
	Globals.turret_rid_list.append(turret_area_rid)
	
	#set the individual projectile speed
	modified_projectile_speed = 4

func _on_haybale_barrage_area_entered(area):
	if current_enemy == null:
		current_enemy = area
	enemies_in_range.append(area)

func _on_haybale_barrage_area_exited(area):
	enemies_in_range.erase(area)

func _maybe_fire_turret_projectile():
	var targeted_enemy = current_enemy
	if Time.get_ticks_msec() > (last_fire_time+fire_rate_ms):
		if current_enemy:
			$HaybaleBarrage/AnimationPlayer.play("Shoot", -1, 1.5)
			if $HaybaleBarrage/AnimationPlayer.current_animation_position >= 0.2 && current_enemy == targeted_enemy:
				gunshot.pitch_scale = randf_range(1.3, 1.5)
				gunshot.play()
				var projectile: Projectile = projectile_type.instantiate()
				projectile.starting_position = $HaybaleBarrage/Node/HaybaleBarrage/Aim/ProjectileSpawnMarker.global_position
				projectile.target = current_enemy
				projectile.speed = modified_projectile_speed
				if damage != null:
					projectile.damage = damage
				add_child(projectile)
				last_fire_time = Time.get_ticks_msec()
