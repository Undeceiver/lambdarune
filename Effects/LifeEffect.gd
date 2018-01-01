extends "res://Effect.gd"

var class_death = preload("DeathEffect.gd")

var types = ["life"]

var hp

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func reeval():
	print("Life left: " + String(hp))
	if hp <= 0:
		# Die
		var death = class_death.new()
		element.battleground.addEffect(death,element)