extends Area2D


const SPEED = 200


var direction = Vector2()

#Aim at something
func shoot(aim_position, gun_position):
	global_position = gun_position
	direction = (aim_position - gun_position).normalized()
	rotation = direction.angle() + 0.5 *PI


# Setting direction+speed
func _process(delta):
	
	position += direction * SPEED * delta
	
	$AnimatedSprite.play("Shoot")



#If not visible destroy the object
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


# warning-ignore:unused_argument

#Effects on collisions
func _on_Plasma_body_entered(body):
	if "Ufo_boss" in body.name:
		body.being_shoot_at()
		call_deferred("queue_free")
	elif "Tank" in body.name:
		body.being_shoot_at()
		call_deferred("queue_free")
	elif "Spider" in body.name:
		body.being_shoot_at()
		call_deferred("queue_free")
	elif "Player" in body.name:
		pass
	else:
		call_deferred("queue_free")
	pass

