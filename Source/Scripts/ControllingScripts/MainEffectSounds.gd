extends Node2D

onready var death_sound = get_node("Player_death_sound")

onready var gadget_shoot = get_node("Gadget_shoot_sound")

onready var laser_beam = get_node("Laser_beam_sound")

onready var double_laser = get_node("Double_laser_sound")

onready var laser_turret = get_node("Laser_turret_sound")

onready var laser_turret_beam = get_node("Laser_turret_beam_sound")

onready var jump = get_node("Jump")

func death_sound_effect_player():
	death_sound._set_playing(true)

func gadget_shoot_sound():
	gadget_shoot._set_playing(true)

func laser_beam_sound():
	laser_beam.play(2.80)

func laser_beam_sound_stop():
	laser_beam._set_playing(false)

func double_laser_sound():
	double_laser._set_playing(true)

func laser_turret_sound():
	laser_turret._set_playing(true)
	
func laser_turret_beam_sound():
	if !laser_turret_beam.is_playing():
		laser_turret_beam._set_playing(true)

func laser_turret_beam_sound_stop():
	laser_turret_beam._set_playing(false)


func jump_sound():
	if !jump.is_playing():
		jump._set_playing(true)

func stop_all_sound_effects():
	double_laser._set_playing(false)
	death_sound._set_playing(false)
	gadget_shoot._set_playing(false)
	laser_beam._set_playing(false)
	laser_turret_beam._set_playing(false)
	laser_turret._set_playing(false)
	jump._set_playing(false)
