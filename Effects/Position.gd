extends "res://Effect.gd"

const class_move_effect = preload("res://Effects/MoveEffect.gd")

var types = ["position"]

var x
var y

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func mayEffectGoIn(effect):
	if effect.hasType("position"):
		return Permission.DENY
	else:
		return Permission.ALLOW

func mayIGoIn():
	return Permission.ALLOW

func modifyIn(effect):
	return effect

func effectIn(effect):
	# The positions is there first, and movement modifies it, it is not that position reacts to movement.
	#if effect extends class_move_effect:
	#	self.x = effect.x
	#	self.y = effect.y
	pass

func myselfIn():
	pass

func isImmediate():
	return false

func mayIGoOut():
	return Permission.ALLOW

func mayEffectGoOut(effect):
	return Permission.ALLOW

func myselfOut():
	pass

func effectOut(effect):
	pass

# Distance to another position effect.
func distance(position):
	return sqrt((position.x - x)*(position.x - x) + (position.y - y)*(position.y - y))

func cloneFields(other):
	x = other.x
	y = other.y
