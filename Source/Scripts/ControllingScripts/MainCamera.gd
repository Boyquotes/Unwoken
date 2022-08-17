extends Node2D

var main_pos = Vector2(160,90)

func set_main_pos():
	$Camera2D.set_position(main_pos)

func reset_smoothing():
	$Camera2D.reset_smoothing()

func make_current():
	$Camera2D.make_current()