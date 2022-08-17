extends Node2D

# On start

# warning-ignore:unused_argument

func start_music():
	$Main_music._set_playing(true)
	

func stop_music():
	$Main_music._set_playing(false)

# If boss is spawned
func start_Boss_fight_music():
	$Main_music._set_playing(false)
	$Boss_fight._set_playing(true)

# If boss is dead
func stop_Boss_fight_music():
	$Boss_fight._set_playing(false)
	$Main_music._set_playing(false)


func stop_Boss_fight_music_delayed():
	if $Main_music.is_playing() == false:
		start_music()

# If boss music is finished -> repeat
func _on_Boss_fight_finished():
	$Boss_fight._set_playing(true)
	pass # Replace with function body.

# If main music is finished -> repeat
func _on_Main_music_finished():
	$Main_music._set_playing(true)
	pass # Replace with function body.

func stop_all_music():
	$Main_music._set_playing(false)
	$Boss_fight._set_playing(false)

func pause_all_music():
	$Main_music.set_stream_paused(false)
	$Main_music.set_stream_paused(false)

func resume_all_music():
	$Main_music.set_stream_paused(true)
	$Main_music.set_stream_paused(true)