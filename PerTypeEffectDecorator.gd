extends "res://EffectDecorator.gd"

const class_multieffect = preload("res://Effects/MultiEffect.gd")

# Keys are types, values are decorators.
var decorators = {}

# Combination strategy is just defined to be multieffect. This could be more general, but I don't see how that could really be interesting, at least for now.

func decorate(effect,parameters):
	var result = class_multieffect.new()
	result.effects = []
	for type in decorators.keys():
		if effect.hasType(type):
			var decoration = decorators[type].decorate(effect,parameters)
			if decoration != null:
				result.effects.append(decoration)
	
	if result.effects.empty():
		return null
	else:
		return result