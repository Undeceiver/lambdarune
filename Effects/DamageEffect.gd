extends "res://Effect.gd"

var types = ["damage"]

var damage

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func isImmediate():
	return true

func myselfIn():
	var lives = element.findEffects("life")
	for life in lives:
		life.hp = life.hp - damage
		life.reeval()