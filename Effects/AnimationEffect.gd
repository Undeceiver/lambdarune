extends "res://Effect.gd"

var types = ["animation"]

var node
var animation
# Name of the animation in the animation player.
var animation_name

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func isImmediate():
	return true

func cloneFields(other):
	node = other.node
	animation = other.animation
	animation_name = other.animation_name