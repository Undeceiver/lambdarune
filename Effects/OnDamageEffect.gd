extends "res://Effect.gd"

var types = ["ondamage"]

var damage
var effect

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func effectIn(effect):
	if effect.hasType("damage"):
		if effect.damage >= damage:
			var effect_instance = effect.clone()
			element.battleground.addEffect(effect_instance,element)

func cloneFields(other):
	effect = other.effect.clone()