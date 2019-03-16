extends "res://Effect.gd"

var types = ["ondamage"]

var damage
var to_do

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func effectIn(effect):
	if effect.hasType("damage"):
		if effect.damage <= damage:
			var effect_instance = to_do.clone()
			for exc in exclusions:
				effect_instance.exclusions.append(exc)
			effect_instance.exclusions.append(self)
			element.battleground.addEffect(effect_instance,element)

func cloneFields(other):
	to_do = other.to_do.clone()