extends StaticBody2D

#Sound effect

onready var shoot_sound = get_node("/root/MainEffectSounds")
onready var shoot_timer = get_node("ShootTimer")
onready var visibility = get_node("VisibilityNotifier2D")

const LASER = preload("res://Scenes/Projectiles/Small_laser.tscn") #másik scene betöltése


export var laser_speed = 100

var dir1
var dir2
var can_shoot = false
export var fire_delay = 0.1


var target_position
# warning-ignore:unused_class_variable

func get_player_position(p):
	target_position = p


func _ready():
	#uj Timer, 1 szer fut le, nem indul el egyből, fire_delay ig tart, meghivja timeout-kor : on_timeout_complete függvényt, uj timer nodeot hozz létre
	shoot_timer.set_wait_time(fire_delay)
	shoot_timer.start()


func _on_ShootTimer_timeout():
	can_shoot = true



# warning-ignore:unused_argument

# warning-ignore:unused_argument
func _physics_process(delta):
	
	if visibility.is_on_screen():
		if target_position: 
			aim(delta)

func aim(delta):
	var aim_speed = deg2rad(1)
	dir1 = $dir1.get_global_position()
	dir2 = $dir2.get_global_position()
	
	var dir
	
	if( $Head.get_angle_to(dir1) < $Head.get_angle_to(dir2)):
		dir = dir1
	else:
		dir = dir2
	
	#print($Head.get_angle_to(dir1)," -  ",$Head.get_angle_to(dir2), "   dir:",$Head.get_angle_to(dir))
	
	if $Head.get_angle_to(dir) > 0:
		$Head.rotation += aim_speed
	if $Head.get_angle_to(dir) < 0:
		$Head.rotation -= aim_speed
	
	var space_state = get_world_2d().direct_space_state
	var player_extents = Vector2(5.086, 7.55)
	var nw = target_position - player_extents
	var se = target_position + player_extents
	var ne = target_position + Vector2(player_extents.x, -player_extents.y)
	var sw = target_position + Vector2(-player_extents.x, player_extents.y)
	
	
	for pos in [target_position, nw, se, ne, sw]:
		var result = space_state.intersect_ray(position, pos, [self], collision_mask)
		if result:
			if "Player" in result.collider.name:
				locked_in(delta, pos)
				pass


func locked_in(delta, pos): 
	var aim_speed = deg2rad(1)
	
	if $Head.get_angle_to(target_position) > 0:
		$Head.rotation += aim_speed
	if $Head.get_angle_to(target_position) < 0:
		$Head.rotation -= aim_speed
		
		if $Head.get_angle_to(target_position) < 0.1 && $Head.get_angle_to(target_position) > 0:
			shoot(pos)
	



func shoot(pos):
	if can_shoot: # ha lőhet
	
		shoot_sound.double_laser_sound()
		var laser1 = LASER.instance() #létrehozz egy lézert
		var laser2 = LASER.instance()
		get_owner().add_child(laser1) # hozzáad egy lézert
		get_owner().add_child(laser2)
		
		laser1.SPEED = laser_speed
		laser2.SPEED = laser_speed
		
		laser1.shoot(pos, $Head/Barrel1.get_global_position())
		laser2.shoot(pos, $Head/Barrel2.get_global_position())
		# timer inditása
		can_shoot = false
		shoot_timer.start()


