extends "res://Effect.gd"

var types = []

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func effectIn(effect):
	# Whenever a graphic effect is added, or a node with graphic effects, add the node to the battleground.
	if effect.hasType("effect_added"):
		if effect.sub_effect.hasType("graphic"):
			element.add_graphic_element(effect.sub_effect)
	
	if effect.hasType("element_added"):
		for subeffect in effect.element_added.findEffects("graphic"):
			element.add_graphic_element(subeffect)
	
	# Whenever a graphic effect is removed, or a node with graphic effects, remove the node from the battleground.
	if effect.hasType("effect_removed"):
		if effect.sub_effect.hasType("graphic"):
			element.remove_graphic_element(effect.sub_effect)
	
	if effect.hasType("element_removed"):
		for subeffect in effect.element_removed.findEffects("graphic"):
			element.remove_graphic_element(subeffect)
	
	# Whenever an effect with an animation is added, play its animation
	if effect.hasType("effect_added"):
		if effect.sub_effect.hasType("animation"):
			element.play_animation(effect.sub_effect)
