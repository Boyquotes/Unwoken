extends Node2D

onready var camera = get_node("/root/MainCamera")

var state = 1

# warning-ignore:unused_argument
func _input(event):
	if Input.is_action_just_pressed("esc"):
# warning-ignore:return_value_discarded
		pause_button_pressed()
		state = state * -1


func pause_button_pressed():
	if state == 1:
		get_tree().paused = true
		$Label.global_position = camera.global_position
		$Label.visible(true)
	if state == -1:
		get_tree().paused = false
		$Label.visible(false)