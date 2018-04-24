extends Node

# The purpose of this class is to add aesthetic elements to gameplay effects.
# So, for example, a damage effect can be decorated with different animations like explosions happening on the character, and so on.
# A targetting effect can be decorated with a projectile, which looks at the type of its targetted effect to decide what type of projectile to draw.
# And the list keeps on going.
# The way that it works is that it takes an effect, and returns a new effect, which usually will be a multieffect including the original effect
# and added aesthetic effects.
# This is to be used at the outer-most level of gem expressing. The ultimate gem being expressed, after being expressed, is decorated.
# To allow for fine-tuning, rather than including things like randomness of choice within the decorator itself, a dictionary of arguments can be passed
# to the decorate function, containing any kind of ad-hoc decoration parameters.

# This class is, of course, to be extended with particular decorators, it defines an API.

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func decorate(effect,parameters):
	return effect