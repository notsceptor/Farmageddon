extends Turret

# Unique for every turret
var last_fire_time: int
@export var fire_rate_ms: int
@export var projectiles_to_shoot_at_a_time: int
@export var projectile_speed: float
@export var projectile_type: PackedScene
@export var large_projectile_type: PackedScene
@export var extra_large_projectile_type: PackedScene
@onready var fish_launcher_anim: AnimationPlayer = $FishLauncher/AnimationPlayer

@onready var gunshot = $gunshot

var modified_projectile_speed: float


func _ready():
	GlobalAudioPlayer.play_placement_sound()
	turret_model = $FishLauncher/Node # Assign the turret model node
	shooter_node = $FishLauncher/Node/FishLauncher/Aim # Assign the shooter node
	var turret_area_rid = $FishLauncher/AreaRadius.get_rid()
	Globals.turret_rid_list.append(turret_area_rid)
	modified_projectile_speed = 5

func _on_fish_launcher_area_entered(area):
	if current_enemy == null:
		current_enemy = area
	enemies_in_range.append(area)

func _on_fish_launcher_area_exited(area):
	enemies_in_range.erase(area)

func _maybe_fire_turret_projectile():
	var targeted_enemy = current_enemy
	if Time.get_ticks_msec() > (last_fire_time + fire_rate_ms):
		if current_enemy:
			fish_launcher_anim.play("Toss")
			if fish_launcher_anim.current_animation_position >= 0.8 && current_enemy == targeted_enemy:
				gunshot.pitch_scale = randf_range(1.3, 1.5)
				gunshot.play()
				var projectile_type_to_use
				var projectile_chance = randf()
				if projectile_chance < 0.6:
					projectile_type_to_use = projectile_type
				elif projectile_chance < 0.9:
					projectile_type_to_use = large_projectile_type
				else:
					projectile_type_to_use = extra_large_projectile_type
				var projectile: Projectile = projectile_type_to_use.instantiate()
				projectile.starting_position = $FishLauncher/Node/FishLauncher/Aim/CannonTop/BackEnd/Arm/Barrel/ProjectileSpawnMarker.global_position
				projectile.target = current_enemy
				projectile.speed = modified_projectile_speed
				add_child(projectile)
				last_fire_time = Time.get_ticks_msec()
