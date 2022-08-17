extends CanvasLayer

onready var FPS_text = get_node("Label")

var timer = 0.0
var percentage_text


# warning-ignore:unused_argument
func _process(delta):
	timer = 0.0
	percentage_text = "fps: " + str(Engine.get_frames_per_second())
	FPS_text.set_text(percentage_text.pad_decimals(0))