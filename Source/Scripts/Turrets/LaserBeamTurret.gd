extends StaticBody2D

onready var Music = get_node("/root/MainAudio")
onready var shoot_sound = get_node("/root/MainEffectSounds")
onready var visibility = get_node("VisibilityNotifier2D")
onready var Line2D_Collision = get_node("Area2D/Line2D_Collision")
onready var cd_timer = get_node("CooldownTimer")

#Main variables
var hit = null

#Collision arrays
var my_array3 = Vector2(-10,-0)
var my_array4 = Vector2(0,-0)
var vector_array = [Vector2(0,0), Vector2(-10,0), my_array3, my_array4]

#Helping variable for timing
var Beam_mode = 1

func _ready():
	#timer for between beam preparation and beam fire
	cd_timer.start()
	#LINE2D initilization
	$Line2D.remove_point(1)
	Line2D_Collision.set_polygon(vector_array)


# warning-ignore:unused_argument

func _on_CooldownTimer_timeout():
	Beam_mode = Beam_mode * -1

#Beam fire

func shoot():
	#Updating collision
	hit = cast_beam()

#After beam fire

func shot_finished():
	if $Line2D.get_point_count() == 2:
		$Line2D.remove_point(1)
	
	#Collision init
	
	vector_array = [Vector2(0,0),Vector2(-10,0),Vector2(-10,-0), Vector2(0,-0)]
	
	Line2D_Collision.set_polygon(vector_array)
	
	#Detect for collisions reset
	
	hit = null


func cast_beam():
	
	#Getting the area where to search for collisions(Player camera view)
	var space_state = get_world_2d().direct_space_state
	
	# Searching for collisions
	var result = space_state.intersect_ray($Muzzle.global_position, $Muzzle.global_position - transform.y * 1000, [self, Line2D_Collision])
	
	#If collision found
	if result:
		if !hit:
			#Visual
			$Line2D.add_point(transform.xform_inv(result.position))
			
			#Collision
			my_array3 = Vector2(-10, $Line2D.get_point_position(1).y)
			my_array4 = Vector2(0, $Line2D.get_point_position(1).y)
			vector_array = [Vector2(0,0),Vector2(-10,0), my_array3, my_array4]
			Line2D_Collision.set_polygon(vector_array)
			
		else:
			#Visual
			$Line2D.set_point_position(1, transform.xform_inv(result.position))
			
			#Collision
			my_array3 = Vector2(-10, $Line2D.get_point_position(1).y)
			my_array4 = Vector2(0, $Line2D.get_point_position(1).y)
			vector_array = [Vector2(0,0),Vector2(-10,0), my_array3, my_array4]
			Line2D_Collision.set_polygon(vector_array)
			
	return result



# warning-ignore:unused_argument
func _physics_process(delta):
	
		#Prepare for beam fire
	if Beam_mode == 1:
		shoot_sound.laser_turret_beam_sound_stop()
		$Sprite.play("PrepShoot")
		shot_finished()
		
	if visibility.is_on_screen():
		#Beam fire
		if Beam_mode == -1:
			if visibility.is_on_screen():
				shoot_sound.laser_turret_beam_sound()
				$Sprite.play("Shoot")
				shoot()
	
		#If target found
		if hit:
			
			Line2D_Collision.set_polygon(vector_array)
			hit = cast_beam()


#On impact with other collision objects

func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		body.dead()
		Music.stop_Boss_fight_music()



