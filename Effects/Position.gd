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
		return DENY
	else:
		return ALLOW

func mayIGoIn():
	return ALLOW

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
	return ALLOW

func mayEffectGoOut(effect):
	return ALLOW

func myselfOut():
	pass

func effectOut(effect):
	pass
