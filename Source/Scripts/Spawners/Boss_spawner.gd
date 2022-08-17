#WorldComplete
extends Area2D

#preload scenes
const BOSS = preload("res://Scenes/Enemies/Ufo_boss.tscn")

#onready var Player= get_parent().get_node("Player")
# warning-ignore:unused_argument
var Player = null

func set_player(p):
	Player = p

func _reset_timer():
	var timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(1)
	timer.connect("timeout",self, "_reset")
	add_child(timer)
	timer.start()

func player_respawned():
	$CollisionShape2D.set_disabled(false)

func _physics_process(delta):
	
	#get all colliding bodies
	var bodies = get_overlapping_bodies()
	
	
	#if body collided
	
	for body in bodies:
		if body.name == "Player":
			#Create boss + add to tree
			var boss = BOSS.instance() 
			get_parent().add_child(boss) 
			
			$CollisionShape2D.set_disabled(true)
