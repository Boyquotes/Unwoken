#WorldComplete
extends Area2D

onready var Music = get_node("/root/MainAudio")
#preload scenes
const PLAYER = preload("res://Scenes/Player/Player.tscn")

# warning-ignore:unused_argument

var player_is_dead = false

func player_died():
	player_is_dead = true

func _ready():
	_spawn_proceed()

"""
func _spawn_player():
	if player_is_dead:
		_spawn_proceed()
"""

func _spawn_proceed():
	get_tree().paused = false
	Music.start_music()
	var Player = PLAYER.instance() 
	Player.position = position
	get_parent().call_deferred("add_child", Player)
	player_is_dead = false
