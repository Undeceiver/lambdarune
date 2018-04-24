extends "res://Effect.gd"

var types = ["element_added"]

var element_added

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func isImmediate():
	return true

func cloneFields(other):
	element_added = other.element_added