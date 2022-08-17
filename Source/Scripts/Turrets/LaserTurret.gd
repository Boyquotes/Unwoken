extends StaticBody2D

const LASER = preload("res://Scenes/Projectiles/Laser.tscn") #másik scene betöltése

onready var shoot_sound = get_node("/root/MainEffectSounds")
onready var visibility = get_node("VisibilityNotifier2D")
onready var shoot_timer = get_node("ShootTimer")


var can_shoot = true 
export var fire_delay = 1.0

func _ready():
	shoot_timer.set_wait_time(fire_delay)

func _on_ShootTimer_timeout():
	can_shoot = true
	pass


# warning-ignore:unused_argument
func _physics_process(delta):
	if can_shoot: # ha lőhet
		shoot()


func shoot():
	if(visibility.is_on_screen()):
		shoot_sound.laser_turret_sound()
	
	var laser = LASER.instance() #létrehozz egy lézert

	get_owner().get_node("Container").call_deferred("add_child", laser) # hozzáad egy lézert
	laser.shoot($Position2D.global_position - transform.y * 1000, $Position2D.global_position)
	
	
	# timer reset
	
	shoot_timer.start()
	can_shoot = false




