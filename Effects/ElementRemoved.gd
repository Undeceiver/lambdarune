extends "res://Effect.gd"

var types = ["element_removed"]

var element_removed

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func isImmediate():
	return true

func cloneFields(other):
	element_removed = other.element_removed
