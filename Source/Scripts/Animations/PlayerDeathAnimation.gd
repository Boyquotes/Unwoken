extends Particles2D

onready var sound = get_node("/root/MainEffectSounds")
onready var respawn_cooldown = get_node("RespawnCooldown")

func _ready():
	respawn_cooldown.set_wait_time(get_lifetime()-0.7)
	respawn_cooldown.start()
	
	sound.death_sound_effect_player()
	
	set_one_shot(true)
	set_emitting(true)
	pass 

func _on_RespawnCooldown_timeout():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	#get_tree().call_group("need_player_ref", "_spawn_player")
	queue_free()
	pass 
