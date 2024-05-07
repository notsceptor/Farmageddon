extends Node

func play_battle_music():
	$BattleThemeMusic.play()
	
func stop_battle_music():
	$BattleThemeMusic.stop()

func play_menu_click_sound():
	$MenuClick.pitch_scale = randf_range(1.2, 1.6)
	$MenuClick.play()

func play_snail_death_sound():
	$SnailDeathSound.pitch_scale = randf_range(1.1, 1.3)
	$SnailDeathSound.play()

func play_scumbug_death_sound():
	$ScumbugDeathSound.pitch_scale = randf_range(3.4, 4.1)
	$ScumbugDeathSound.play()
	
func play_beetle_death_sound():
	$BeetleDeathSound.pitch_scale = randf_range(0.7, 1.0)
	$BeetleDeathSound.play()
	
func play_earthquake_sound():
	$EarthquakeSound.play()
	
func play_fish_nom_sound():
	$FishNom.pitch_scale = randf_range(0.7, 1.0)
	$FishNom.play()
	
func play_shark_chomp_sound():
	$SharkChomp.pitch_scale = randf_range(0.7, 1.0)
	play_fish_nom_sound()
	$SharkChomp.play()
	

func play_fail_sound():
	$FailSound.play()
	
func play_placement_sound():
	$Placement.pitch_scale = randf_range(1.2, 1.3)
	$Placement.play()

func play_strawberry_projectile_sound():
	$StrawberryProjectile.pitch_scale = randf_range(1.2, 1.5)
	$StrawberryProjectile.play()
