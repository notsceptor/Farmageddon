extends Node

func play_snail_death_sound():
	$SnailDeathSound.play()

func play_scumbug_death_sound():
	$ScumbugDeathSound.pitch_scale = randf_range(1.1, 1.3)
	$ScumbugDeathSound.play()
