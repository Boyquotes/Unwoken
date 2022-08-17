extends Node2D

export (bool) var display_health_text = true
onready var health_text = get_node("health_text")

#Health values
var max_value
var current_value
var player_is_dead = true
#Health
onready var health = get_node("Health")

var ufo_is_dead = true

func ufo_boss_died():
	ufo_is_dead = true

func ufo_boss_alive():
	ufo_is_dead = false

func player_died():
	player_is_dead = true

func player_respawned():
	player_is_dead = false

#Start
func _ready():
	set_visible(false)
	
	if(!display_health_text):
		health_text.hide()
	pass 

#Initializes the health bar
func init(max_value, current_value):
	self.max_value = max_value * 1.0
	self.current_value = clamp(current_value * 1.0, 0, max_value)
	
	#Update health bar
	update()

#Set current health value
func set_health(value):
	#Update value
	current_value = clamp(value, 0, max_value)
	
	#Update health bar
	update()

# warning-ignore:unused_argument
func _physics_process(delta):
	
		if !ufo_is_dead:
			set_visible(true)
		if ufo_is_dead or player_is_dead:
			set_visible(false)


func update():
	
	var percentage = current_value / max_value
	
	#Update the health bar scale
	health.set_scale(Vector2(percentage, 1))
	
	#Update the label
	var percentage_text = str(percentage * 100) + "%"
	health_text.set_text(percentage_text.pad_decimals(0))
	
	#Update the health bar scale
	health.set_scale(Vector2(percentage, 1))
	