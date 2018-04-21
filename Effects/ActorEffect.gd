extends "res://Effect.gd"

var types = ["actor"]

var code

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func effectIn(effect):
	if effect.hasType("order"):
		if effect.code == self.code:
			element.battleground.addEffect(effect.effect,element)