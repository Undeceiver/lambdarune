extends "res://Effect.gd"

var types = ["graphic"]
# Each instance of a graphic effect has a node associated, which is the one to be drawn.
var node

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func cloneFields(other):
	node = other.node.duplicate()
