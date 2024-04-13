extends Node

func play_snail_death_sound():
	$SnailDeathSound.pitch_scale = randf_range(0.5, 0.7)
	$SnailDeathSound.play()

func play_scumbug_death_sound():
	$ScumbugDeathSound.pitch_scale = randf_range(2.7, 3.1)
	$ScumbugDeathSound.play()
	
func play_earthquake_sound():
	$EarthquakeSound.play()

func play_fail_sound():
	$FailSound.play()
	
func play_placement_sound():
	$Placement.pitch_scale = randf_range(1.2, 1.3)
	$Placement.play()

func play_strawberry_projectile_sound():
	$StrawberryProjectile.pitch_scale = randf_range(1.2, 1.5)
	$StrawberryProjectile.play()
