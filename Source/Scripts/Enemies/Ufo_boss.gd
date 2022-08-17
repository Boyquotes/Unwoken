extends KinematicBody2D

#Music
onready var laser_beam_sound = get_node("/root/MainEffectSounds")

#Camera
onready var camera = get_node("/root/MainCamera/Camera2D")

#Preloading Audio
const AUDIO = preload("res://Scenes/ControllingScenes/MainAudio.tscn")
const LIFEBAR = preload("res://Scenes/ParralaxBGScenes/Health_bar.tscn")
#Getting direction of up
const UP = Vector2(0,-1)

#Getting access to nodes
onready var Player= get_parent().get_node("Player")
onready var Line2D_Collision = get_node("Beam/Area2D/Line2D_Collision")
onready var Music = get_node("/root/MainAudio")
onready var Health_bar = get_parent().get_node("MainBackground/Hp_bar/Health_bar")
onready var death_timer = get_node("Death_timer")
onready var cd_timer = get_node("CooldownTimer")

# General 
var shoot_enabled = true
var hit = null

#Collision setup init
var my_array3 = Vector2(-10,-0)
var my_array4 = Vector2(0,-0)
var vector_array = [Vector2(0,0), Vector2(-10,0), my_array3, my_array4]

#Fire mode
var Beam_mode = 1

var motion = Vector2()

#General Move

export var max_speed_x = 50
export var max_speed_y = 50
export var acceleration = 10

# X Axis react time
export var react_time_x = 300
var dir_x = 0
var next_dir_x = 0
var next_dir_time_x = 0
export var target_player_dist_x = 0

# Y Axis react time
export var react_time_y = 50
var dir_y = 0
var next_dir_y = 0
var next_dir_time_y = 0
export var target_player_dist_y = 100

#Camera

var smooth_zoom = 1
var target_zoom = 1.75

const ZOOM_SPEED = 1

#Boss health related variables

var is_dead = false
export var hp = 100
var damaged = false

func player_died():
	get_tree().call_group("need_ufo_boss_ref","ufo_boss_died")
	death_timer.start()


#On start

func _ready():
	get_tree().call_group("need_ufo_boss_ref","ufo_boss_alive")
	
	position = Player.global_position + Vector2(0,-200)
	
	#Hp bar setup
	Health_bar.init(hp, hp)
	
	
	#timer between beam mode
	cd_timer.start()
	
	#Start music on spawn
	Music.start_Boss_fight_music()
	
	#LINE2D
	Line2D_Collision.set_polygon(vector_array)

# warning-ignore:unused_argument


#Called after timer timeout
func _on_CooldownTimer_timeout():
	Beam_mode = Beam_mode * -1

#Calculating directions for movement

func set_dir_x(target_dir_x):
	if next_dir_x != target_dir_x :
		next_dir_x = target_dir_x
		next_dir_time_x = OS.get_ticks_msec() + react_time_x

func set_dir_y(target_dir_y):
	if next_dir_y != target_dir_y :
		next_dir_y = target_dir_y
		next_dir_time_y = OS.get_ticks_msec() + react_time_y

var play = true

var target_position

func get_player_position(p):
	target_position = p
	

func _physics_process(delta):
	
	#Zooming out on spawn
	
	if target_position != null:
		smooth_zoom = lerp(smooth_zoom, target_zoom, ZOOM_SPEED * delta)
		if smooth_zoom != target_zoom:
			camera.set_zoom(Vector2(smooth_zoom, smooth_zoom))
		#If getting damaged
		
		if damaged:
			$AnimatedSprite.play("Damaged")
		else:
			$AnimatedSprite.play("Idle")
		
		
		#Movement
		
		if target_position.y < position.y + target_player_dist_y -2:
			set_dir_y(-1)
		elif target_position.y > position.y + target_player_dist_y + 2:
			set_dir_y(1)
		else:
			set_dir_y(0)
			motion.y = 0
		
		if target_position.x + 10 < position.x - target_player_dist_x:
			set_dir_x(-1)
		elif target_position.x + 10 > position.x + target_player_dist_x:
			set_dir_x(1)
		else:
			set_dir_x(0)
			motion.x = 0
		
		#Movement delay
		
		if OS.get_ticks_msec() > next_dir_time_x:
			dir_x = next_dir_x
		
		
		if OS.get_ticks_msec() > next_dir_time_y:
			dir_y = next_dir_y
		
		
		#Movement speed + direction
		
		if dir_x == 1:
			motion.x = min(motion.x+acceleration, max_speed_x)
		elif dir_x == -1:
			motion.x = max(motion.x-acceleration, -max_speed_x)
		
		if dir_y == 1:
			motion.y = min(motion.y+acceleration, max_speed_y)
		elif dir_y == -1:
			motion.y = max(motion.y-acceleration, -max_speed_y)
	
	#Beam modes
	
	if shoot_enabled:
		if Beam_mode == 1:
			play = true
			shot_finished()
		if Beam_mode == -1:
			if play == true:
				laser_beam_sound.laser_beam_sound()
				play = false
			shoot()
	
	#If collision detected
	if hit:
		hit = cast_beam()
		
	
	#Damage update
	damaged = false
	
	#General move on a vector
	motion = move_and_slide(motion, UP)



func shoot():
	#start beam
	hit = cast_beam()

func shot_finished():
	
	#Remove direction
	if $Beam/Line2D.get_point_count() == 2:
		$Beam/Line2D.remove_point(1)
	
	#Collision reset
	vector_array = [Vector2(0,0),Vector2(-10,0),Vector2(-10,-0), Vector2(0,-0)]
	Line2D_Collision.set_polygon(vector_array)
	
	# Target reset
	hit = null


func cast_beam():
	#Getting the world collisions
	var space_state = get_world_2d().direct_space_state
	
	#Searching for collisions in a direction
	var result = space_state.intersect_ray($Beam/Muzzle.global_position, $Beam/Muzzle.global_position - $Beam.transform.y * -1000, [self, Line2D_Collision, $Beam, $CollisionPolygon2D])
	
	#If collision detected
	if result:
		if !hit:
			#Line2d
			$Beam/Line2D.add_point(transform.xform_inv(result.position  + Vector2(0,-30) ))
			
			#Collision
			my_array3 = Vector2(-10, $Beam/Line2D.get_point_position(1).y)
			my_array4 = Vector2(0, $Beam/Line2D.get_point_position(1).y)
			
			vector_array = [Vector2(0,0),Vector2(-10,0), my_array3, my_array4]
			
			Line2D_Collision.set_polygon(vector_array)
		else:
			#Line2D
			$Beam/Line2D.set_point_position(1, Vector2(0,transform.xform_inv(result.position  + Vector2(0,-34)).y) )
			#Collision
			my_array3 = Vector2(-10, $Beam/Line2D.get_point_position(1).y)
			my_array4 = Vector2(0, $Beam/Line2D.get_point_position(1).y)
			
			vector_array = [Vector2(0,0),Vector2(-10,0), my_array3, my_array4]
			
			Line2D_Collision.set_polygon(vector_array)
		
	return result


#Getting damaged

func being_shoot_at():
	
	#Lose hp + get damaged
	damaged = true
	hp = hp -1
	
	#Init hp bar
	Health_bar.set_health(hp)
	
	#If no more hp
	if hp  <  0:
		get_tree().call_group("need_ufo_boss_ref","ufo_boss_died")
		
		is_dead = true
		
		call_deferred("queue_free")
		
		Music.stop_Boss_fight_music()
		
		laser_beam_sound.laser_beam_sound_stop()
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/LevelScenes/Victory.tscn")


#Collision entered effects

func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		Player.dead()
		laser_beam_sound.laser_beam_sound_stop()
		Music.stop_Boss_fight_music()



func _on_Death_timer_timeout():
	queue_free()
