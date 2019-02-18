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
			doRunOrder(effect.effect)

func doRunOrder(effect):
	element.battleground.addEffect(effect,element)

func cloneFields(other):
	code = other.code