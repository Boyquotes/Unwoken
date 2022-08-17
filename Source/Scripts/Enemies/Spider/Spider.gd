extends KinematicBody2D

# Direction of up
const UP = Vector2(0,-1)

# Move
var motion = Vector2()
export var speed = 50
export var gravity_force = 20

#Direction
var direction = 1

export var hp = 15

onready var shoot_sound = get_node("/root/MainEffectSounds")
onready var shoot_timer = get_node("ShootTimer")
onready var visibility = get_node("VisibilityNotifier2D")
onready var Health_bar = get_node("Health_bar_spider")

const LIFEBAR = preload("res://Scenes/ParralaxBGScenes/Health_bar.tscn")
const LASER = preload("res://Scenes/Projectiles/Spider_laser.tscn") #másik scene betöltése

export var laser_speed = 100

var can_shoot = false
export var fire_delay = 0.1

var target_position

func get_player_position(p):
	target_position = p


func _ready():
	#Hp bar setup
	Health_bar.init(hp, hp)
	
	shoot_timer.set_wait_time(fire_delay)
	shoot_timer.start()


func _on_ShootTimer_timeout():
	can_shoot = true


func aim():
	
	var space_state = get_world_2d().direct_space_state
	var player_extents = Vector2(5.086, 7.55)
	var nw = target_position - player_extents
	var se = target_position + player_extents
	var ne = target_position + Vector2(player_extents.x, -player_extents.y)
	var sw = target_position + Vector2(-player_extents.x, player_extents.y)
	
	
	for pos in [target_position, nw, se, ne, sw]:
		var result = space_state.intersect_ray(position, pos, [self], collision_mask)
		if result:
			if result.collider.name == "Player":
				shoot(pos)



func shoot(pos):
	if can_shoot: # ha lőhet
		shoot_sound.double_laser_sound()
		var laser = LASER.instance() #létrehozz egy lézert
		get_parent().add_child(laser) # hozzáad egy lézert
		
		laser.SPEED = laser_speed
		
		laser.shoot(pos, $Spider/Barrel1.get_global_position())
		# timer inditása
		can_shoot = false
		shoot_timer.start()


# warning-ignore:unused_argument
func _physics_process(delta):
	if visibility.is_on_screen():
		if target_position:
			aim()
	
	#Moving direction
	if !$RayCast2D.is_colliding():
		direction = direction * -1
	
	motion.x = speed * direction
	
	#Gravity
	motion.y += gravity_force
	
	#Flip Sprite if changing direction
	if(direction == 1):
		$Spider.flip_h = false
		$RayCast2D.set_rotation_degrees(-60)
		
	else:
		$Spider.flip_h = true
		$RayCast2D.set_rotation_degrees(60)
	
	# Moving on a vector
	motion = move_and_slide(motion, UP)  
	
	#If collided with wall, change direction
	if (is_on_wall()):
		direction = direction * -1
	
	
	pass

func being_shoot_at():
	
	#Lose hp + get damaged
	hp = hp -1
	
	#Init hp bar
	Health_bar.set_health(hp)
	
	#If no more hp
	if hp  <  0:
		call_deferred("queue_free")

