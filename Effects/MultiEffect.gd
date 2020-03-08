extends "res://Effect.gd"

var types = ["multieffect"]
var effects

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func isImmediate():
	return true

func myselfIn():
	for effect in effects:
		element.battleground.addEffect(effect,element)

func cloneFields(other):
	effects = []
	for effect in other.effects:
		effects.append(effect.clone())
