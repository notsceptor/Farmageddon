extends Node

func play_snail_death_sound():
	$SnailDeathSound.pitch_scale = randf_range(0.5, 0.7)
	$SnailDeathSound.play()

func play_scumbug_death_sound():
	$ScumbugDeathSound.pitch_scale = randf_range(1.1, 1.3)
	$ScumbugDeathSound.play()
	
func play_earthquake_sound():
	$EarthquakeSound.play()

func play_fail_sound():
	$FailSound.play()
	
func play_placement_sound():
	$Placement.play()
