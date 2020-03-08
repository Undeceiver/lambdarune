extends "res://Effect.gd"

var types = ["death"]

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func isImmediate():
	return true

func myselfIn():
	# Remove the element.
	element.battleground.removeElement(element)
