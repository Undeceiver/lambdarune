extends "res://Effect.gd"

var types = ["decorator"]

# The purpose of this class is to add aesthetic elements to gameplay effects.
# So, for example, a damage effect can be decorated with different animations like explosions happening on the character, and so on.
# A targetting effect can be decorated with a projectile, which looks at the type of its targetted effect to decide what type of projectile to draw.
# And the list keeps on going.
# The way that it works is that it takes an effect, and returns a new effect, which usually will be a multieffect including 
# added aesthetic effects, but NOT the original effect. This is to prevent infinite recursion (decorating the effect over and over without ever actually applying it).
# If it returns null, it means no decorations are necessary. This is important.
# This is to be used at the outer-most level of gem expressing. The ultimate gem being expressed, after being expressed, is decorated.

# This class is, of course, to be extended with particular decorators, it defines an API.

# It is implemented as an effect that is added to the battleground. This both simplifies its usage and allows for additional
# effect mechanics (such as turn-based) on decorators.

# This may mean that some decorators do not directly use the decorate function to RETURN a decoration, but instead display it later on using its effect mechanics.
# Each decorator should be aware of how it does these things on its own.

func effectIn(effect):
	if effect.hasType("effect_added"):
		var decoration = decorate(effect.sub_effect,effect.sub_element)
		if decoration != null:
			element.battleground.addEffect(decoration,effect.sub_element)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func decorate(effect,element):
	return null
