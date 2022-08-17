extends Control

var state = 1

func _ready():
	set_visible(false)

# warning-ignore:unused_argument

func _input(event):
	if Input.is_action_just_pressed("esc"):
# warning-ignore:return_value_discarded
		pause_button_pressed()
		state = state * -1


func pause_button_pressed():
	if state == 1:
		get_tree().paused = true
		set_visible(true)
	if state == -1:
		get_tree().paused = false
		set_visible(false)


func _on_Restart_pressed():
	get_tree().change_scene("res://Scenes/LevelScenes/World_boss_fight.tscn")


func _on_Menu_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/LevelScenes/StartMenu.tscn")

