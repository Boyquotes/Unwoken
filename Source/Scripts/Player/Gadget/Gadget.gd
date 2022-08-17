extends KinematicBody2D

#Music

onready var shoot_sound = get_node("/root/MainEffectSounds")

#get Player + Head nodes
var Player = null

onready var Head = get_node("Head")
onready var shoot_delay = get_node("Shoot_delay")
#Up direction
const UP = Vector2(0,-1)

#Loading in bullet
const PLASMA = preload("res://Scenes/Projectiles/Plasma.tscn") #másik scene betöltése

var can_shoot = true 

var motion = Vector2()

export var fire_delay = 1.0

#General move speed
export var max_speed_x = 125
export var max_speed_y = 125
export var acceleration = 10

# X axis move init
var react_time_x = 0
var dir_x = 0
var next_dir_x = 0
var next_dir_time_x = 0
var target_player_dist_x = 1

# Y axis move init
var react_time_y = 0
var dir_y = 0
var next_dir_y = 0
var next_dir_time_y = 0
var target_player_dist_y = 20


func set_player(p):
	Player = p
	position = Player.global_position
# warning-ignore:unused_argument

func player_died():
	queue_free()


#On start
func _ready():
	get_tree().call_group("Search_for_player","search_player")
	
	shoot_delay.set_wait_time(fire_delay)
	shoot_delay.start()

# Called after timer timeout
func _on_Shoot_delay_timeout():
	can_shoot = true


### A.I FOLLOW
func set_dir_x(target_dir_x):
	if next_dir_x != target_dir_x :
		next_dir_x = target_dir_x
		next_dir_time_x = OS.get_ticks_msec() + react_time_x

func set_dir_y(target_dir_y):
	if next_dir_y != target_dir_y :
		next_dir_y = target_dir_y
		next_dir_time_y = OS.get_ticks_msec() + react_time_y


# warning-ignore:unused_argument
func _physics_process(delta):
	
	
	### HEAD ROTATION
	
	Head._look_at_mouse()
	
	if Head.get_rotation_degrees() > 360 or Head.get_rotation_degrees() < -360:
		Head.set_rotation_degrees(0)
	
	if Head.get_rotation_degrees() > 0:
		if Head.get_rotation_degrees() > 90:
			$Head.flip_v = true
			if Head.get_rotation_degrees() > 270:
				$Head.play("Not_rotated")
			else:
				$Head.play("Rotated")
		elif Head.get_rotation_degrees() < 270:
			$Head.flip_v = true
			if Head.get_rotation_degrees() < 90:
				$Head.play("Not_rotated")
			else:
				$Head.play("Rotated")
		if Head.get_rotation_degrees() < 90:
			$Head.flip_v = false
			$Head.play("Not_rotated")
		if Head.get_rotation_degrees() > 270:
			$Head.flip_v = false
			$Head.play("Not_rotated")
	else:
		if Head.get_rotation_degrees() < -90:
			$Head.flip_v = true
			if Head.get_rotation_degrees() < -270:
				$Head.play("Not_rotated")
			else:
				$Head.play("Rotated")
		if Head.get_rotation_degrees() > -270:
			$Head.flip_v = true
			if Head.get_rotation_degrees() > -90:
				$Head.play("Not_rotated")
			else:
				$Head.play("Rotated")
		if Head.get_rotation_degrees() > -90:
			$Head.flip_v = false
			$Head.play("Not_rotated")
		if Head.get_rotation_degrees() < -270:
			$Head.flip_v = false
			$Head.play("Not_rotated")
	
	
	### A.I FOLLOW
	
	#Setting position of Gadget
	if Player.position.y < position.y + target_player_dist_y -2:
		set_dir_y(-1)
	elif Player.position.y > position.y + target_player_dist_y + 2:
		set_dir_y(1)
	else:
		set_dir_y(0)
		motion.y = 0
	
	if Player.position.x < position.x - target_player_dist_x:
		set_dir_x(-1)
	elif Player.position.x > position.x + target_player_dist_x:
		set_dir_x(1)
	else:
		set_dir_x(0)
		motion.x = 0
	
	#Setting delay
	
	if OS.get_ticks_msec() > next_dir_time_x:
		dir_x = next_dir_x
	
	
	if OS.get_ticks_msec() > next_dir_time_y:
		dir_y = next_dir_y
	
	#Watching direction changing
	
	if dir_x == 1:
		motion.x = min(motion.x+acceleration, max_speed_x)
	elif dir_x == -1:
		motion.x = max(motion.x-acceleration, -max_speed_x)
	
	if dir_y == 1:
		motion.y = min(motion.y+acceleration, max_speed_y)
	elif dir_y == -1:
		motion.y = max(motion.y-acceleration, -max_speed_y)
		
	
	
	### FIREEEE
	if can_shoot and Input.is_action_pressed("ui_mouse_left_button"):
		shoot_sound.gadget_shoot_sound()
		var plasma = PLASMA.instance() #létrehozz egy lézert
		get_parent().add_child(plasma) # hozzáad egy lézert
		plasma.shoot(get_global_mouse_position(), global_position)
		# timer inditása
		can_shoot = false
		shoot_delay.start()
	
	
	motion = move_and_slide(motion, UP)  # mozgato fuggveny
	pass
	



