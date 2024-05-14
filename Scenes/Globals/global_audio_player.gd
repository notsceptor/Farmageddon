extends Node

# Music

func play_battle_music():
	$BattleThemeMusic.play()
	
func stop_battle_music():
	$BattleThemeMusic.stop()
	
func play_idle_music():
	$IdleThemeMusic.play()
	
func stop_idle_music():
	$IdleThemeMusic.stop()

func play_title_music():
	$TitleThemeMusic.play()
	
func stop_title_music():
	$TitleThemeMusic.stop()
	
func play_main_music():
	$MainThemeMusic.play()
	
func stop_main_music():
	$MainThemeMusic.stop()

# Sound Effects

func play_menu_click_sound():
	$MenuClick.pitch_scale = randf_range(1.2, 1.6)
	$MenuClick.play()

func play_snail_death_sound():
	$SnailDeathSound.pitch_scale = randf_range(1.1, 1.3)
	$SnailDeathSound.play()

func play_scumbug_death_sound():
	$ScumbugDeathSound.pitch_scale = randf_range(4.1, 4.7)
	$ScumbugDeathSound.play()
	
func play_beetle_death_sound():
	$BeetleDeathSound.pitch_scale = randf_range(0.7, 1.0)
	$BeetleDeathSound.play()
	
func play_vulture_death_sound():
	$VultureDeathSound.pitch_scale = randf_range(0.9, 1.2)
	$VultureDeathSound.play()
	
func play_boar_death_sound():
	$VultureDeathSound.pitch_scale = randf_range(0.5, 0.7)
	$VultureDeathSound.play()
	
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
	$FailSound.pitch_scale = randf_range(0.7, 1.0)
	$FailSound.play()
	
func play_win_sound():
	$WinSound.pitch_scale = randf_range(0.7, 1.0)
	$WinSound.play()
	
func play_placement_sound():
	$Placement.pitch_scale = randf_range(1.2, 1.3)
	$Placement.play()

func play_strawberry_projectile_sound():
	$StrawberryProjectile.pitch_scale = randf_range(1.2, 1.5)
	$StrawberryProjectile.play()
	
func play_wave_smash():
	$Cockerel.pitch_scale = randf_range(1.2, 1.5)
	$WaveSmash.pitch_scale = randf_range(1.2, 1.5)
	$WaveSmash.play()
	$Cockerel.play()
