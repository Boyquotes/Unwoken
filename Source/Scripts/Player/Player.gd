extends KinematicBody2D

const RIPANIM = preload("res://Scenes/Animations/PlayerDeathAnimation.tscn")
const GADGET = preload("res://Scenes/Player/Gadget.tscn")
const UP = Vector2(0,-1)
const ZOOM_SPEED = 1


onready var sound = get_node("/root/MainEffectSounds")
onready var camera = get_node("/root/MainCamera/Camera2D")

var gm = -1;
var godmode = false;

#General move

var motion = Vector2()
export var max_speed = 200
export var jump_force = 550
export var gravity_force = 20
export var max_gravity_force = 250
export var acceleration = 50 

var ufo_boss_is_dead = false
# warning-ignore:unused_argument

var is_sliding = false
var jump_counter = 0
var jump_disabled = false

var one_shot = true
var gadget =  null

var l_collided = false
var r_collided = false

#Camera settings

var smooth_zoom = 1.75
var target_zoom = 1


func ufo_boss_died():
	ufo_boss_is_dead = true

func search_player():
	get_tree().call_group("need_player_ref", "set_player", self)

#On start
func _ready():
	
	get_tree().call_group("need_player_ref", "player_respawned")
	get_tree().call_group("need_player_ref", "set_player", self)
	camera.position = position
	camera.set_zoom(Vector2(1,1))
	camera.reset_smoothing()
	
	gadget = GADGET.instance()
	get_parent().add_child(gadget)
	
	pass

#If player died

func dead():
	if !godmode:
		get_tree().call_group("need_player_ref", "player_died")
		camera.global_position = global_position
		var death_anim = RIPANIM.instance()
		get_parent().add_child(death_anim)
		death_anim.position = position
		queue_free()


# warning-ignore:return_value_discarded



func _physics_process(delta):
	
	if gm == 1:
		godmode = true
	else:
		godmode = false
	
	if Input.is_action_just_pressed("godmode"):
		gm = gm * -1;
	
	get_tree().call_group("need_player_ref","get_player_position",global_position)
	
	
	"""
	#Drone
	if Input.is_action_just_pressed("ui_focus_next"):
		if gadget == null:
			gadget = GADGET.instance()
			get_parent().add_child(gadget)
		else:
			gadget.queue_free()
			gadget = null"""


	#Camera
	camera.position = position
	
	if ufo_boss_is_dead:
		smooth_zoom = lerp(smooth_zoom, target_zoom, ZOOM_SPEED * delta)
		if smooth_zoom != target_zoom:
			camera.set_zoom(Vector2(smooth_zoom, smooth_zoom))
	
	else:
		camera.position = position
	
	if position.y > 2000: # ha leesett
		$"/root/MainAudio".stop_Boss_fight_music()
		dead()
	
	if motion.y < max_gravity_force:
		motion.y += gravity_force # gravitacio
	
	if Input.is_action_pressed("ui_right"): #gombnyomásra jobbra
		motion.x = min(motion.x+acceleration, max_speed) #ameddig motion.x+accelearion kisebb mint a max_speed, addig azt kapja meg
		$Sprite.flip_h = false #fordulas false
		$Sprite.play("Run") #Sprite animacio lejatszasa
		
	elif Input.is_action_pressed("ui_left"): #gombnyomásra balra
		motion.x = max(motion.x-acceleration, -max_speed)
		$Sprite.flip_h = true #fordulas true
		$Sprite.play("Run") #Sprite animacio lejatszasa
		
	else:
		$Sprite.play("Idle") #Sprite animacio lejatszasa
		if is_on_floor():
			motion = Vector2(0,0)
		
	
	wall_jump()

	
	

	
	if is_on_floor(): # ugras
		jump_disabled = false
		l_collided = false
		r_collided = false
		is_sliding = false
		jump_counter = 0
		jump()
		
	else:
		if motion.y < 0: # ha még nem kezdett el esni
			double_jump()
			$Sprite.play("Jump") #Sprite animacio lejatszasa
			pass
		else: # ha elkezdett esni
			double_jump()
			$Sprite.play("Fall") #Sprite animacio lejatszasa
			one_shot = true
			pass
			
		motion.x = lerp(motion.x, 0, 0.05) # lassulas motion->0 gyorsabban(csuszas)
	
	print(jump_counter)
	print(l_collided)
	print(r_collided)
	print(is_sliding)
	
	motion = move_and_slide(motion, UP)  # mozgato fuggveny
	pass
	

func jump():
	if jump_counter < 2:
		if Input.is_action_just_pressed("ui_up"): # ha felsőnyil
			"""
			if Input.is_action_pressed("ui_right") && is_on_floor() && $Right.is_colliding():
				jump_counter +=1
			elif Input.is_action_pressed("ui_left") &&	is_on_floor() && $Left.is_colliding():
				jump_counter +=1"""
			motion.y = -jump_force
			sound.jump_sound()
			jump_counter +=1

func double_jump():
	if jump_counter < 2:
		jump()


func wall_jump():
	if !is_on_floor():
		if $Left.is_colliding() || $Right.is_colliding():
			is_sliding = true
		else:
			is_sliding = false
	"""
	if Input.is_action_pressed("ui_left") && is_sliding:
		if !Input.is_action_just_pressed("ui_up") && jump_counter < 2 : 
			motion.y = slide_force
	
	if Input.is_action_pressed("ui_right") && is_sliding:
		if !Input.is_action_just_pressed("ui_up") && jump_counter < 2 : 
			motion.y = slide_force"""
	
	if $Left.is_colliding() && !l_collided:
		l_collided = true
		r_collided = false
		jump_counter -= 1
		
	if $Right.is_colliding() && !r_collided:
		r_collided = true
		l_collided = false
		jump_counter -= 1
