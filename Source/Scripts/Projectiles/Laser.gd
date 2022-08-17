extends Area2D

const SPEED = 100

var direction = Vector2()

onready var Music = get_node("/root/MainAudio")

#Aim at something
func shoot(aim_position, gun_position):
	global_position = gun_position
	direction = (aim_position - gun_position).normalized()
	rotation = direction.angle() + 0.5 *PI

# Setting direction+speed
func _physics_process(delta):
	
	position += direction * SPEED * delta

#If not visible destroy the object
func _on_VisibilityNotifier2D_screen_exited():
	call_deferred("queue_free")

# warning-ignore:unused_argument

#Effects on collisions
func _on_Laser_body_entered(body):
	if "Player" in body.name:
		Music.stop_Boss_fight_music()
		body.dead()

	if "Ufo_boss" in body.name:
		pass
	else:
		call_deferred("queue_free")