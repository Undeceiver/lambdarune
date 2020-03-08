extends "res://Effect.gd"

# This effect is meant to be run on the Battleground, whenever an effect is removed from one of the elements in it.
# This is essentially used to allow having reactive behaviour to the effects of the elements in the battleground,
# rather than simply polling constantly.
# This is essential, for example, for graphic drawing.
# The effect itself is not reacted to, only to its addition and removal, but this allows us to keep track of what
# we should we pay attention to.

var types = ["effect_removed"]
var sub_effect
var sub_element

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func isImmediate():
	return true

func cloneFields(other):
	sub_effect = other.sub_effect
	sub_element = other.sub_element
