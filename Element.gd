extends Node

var battleground
var effects = []

# Elements do not have types. EVERYTHING in an element is specified by their effects, so the "type" of an element
# really is the signature of the types of effects it has. For example, if we want to find "living elements", we look
# for elements with the type "life", or "elements with a position", we look for elements with the type "position".

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func findEffects(type):
	var result = []
	for effect in effects:
		if effect.hasType(type):
			result.append(effect)
	
	return result

# Returns the first one, for when in theory there should only be one.
func findSingleEffect(type):
	var result = findEffects(type)
	if result.size() == 0:
		return null
	else:
		return result[0]