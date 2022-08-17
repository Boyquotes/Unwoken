extends Control

onready var Sound = get_node("/root/MainAudio")
onready var Camera = get_node("/root/MainCamera")
onready var Sfx = get_node("/root/MainEffectSounds")

# warning-ignore:unused_argument
func _physics_process(delta):
	Sound.stop_all_music()

func _ready():
	Sound.stop_all_music()
	Sfx.stop_all_sound_effects()
	$Camera2D.make_current()

func _on_Restart_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/LevelScenes/World_boss_fight.tscn")
	Sound.start_music()
	Camera.make_current()

func _on_Exit_pressed():
	get_tree().quit()
