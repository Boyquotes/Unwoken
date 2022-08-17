extends AnimatedSprite

func _ready():
	pass

func _look_at_mouse():
	look_at(get_global_mouse_position())
