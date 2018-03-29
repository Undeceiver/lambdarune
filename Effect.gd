extends Node

# Here we include the possible types we are using so far. The typing of effects is multiple.
# While it is only labels, we exploit the dynamic nature of the language to actually *expect* certain fields
# in effects with certain types. Moreover, types should be used for this purpose, and types only created when we
# wish to have a set of fields associated under a certain tag.
#	- "alignment": Has fields "factions", "allies" and "enemies", each of which are an array of strings of factions that the element belongs to, considers as allies and considers as enemies, respectively.
#	- "animation": Has field "node" indicating the node to animate and "animation", which must be a sub-node of "node" of type animation player. When the effect is added, it is played once and then execution continues. The name of the animation to play is contained in the field "animation_name".
#	- "damage": Has field "damage". Deals damage to the living being.
#	- "death": No specific fields, it identifies the death of a living being.
# 	- "effect_added": Has field sub_effect and sub_element, indicating what effect was added and to what element.
#	- "effect_removed": Has field sub_effect and sub_element, indicating what effect was removed and from what element.
# 	- "element_added": Has field element_added, indicating which element was added into the battleground.
#	- "element_removed": Has field element_removed, indicating which element was removed from the battleground.
#	- "graphic": Has field "node" indicating the node to draw alongside this effect.
#	- "life": Has field "hp" indicating the hitpoints left.
#	- "position": Has fields x and y, indicating the position of the element.
#	- "turnbased": Has a function "runTurn" which runs a turn on the effect.
# var types = []
var element

enum Permission {ALLOW, DENY, FORCE_ALLOW, FORCE_DENY}

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func mayEffectGoIn(effect):
	return ALLOW

func mayIGoIn():
	return ALLOW

func modifyIn(effect):
	return effect

func effectIn(effect):
	pass

func myselfIn():
	pass

func isImmediate():
	return false

func mayIGoOut():
	return ALLOW

func mayEffectGoOut(effect):
	return ALLOW

func myselfOut():
	pass

func effectOut(effect):
	pass

# To be called by other effects when they modify the values of this effect.
func reeval():
	pass

func hasType(type):
	return self.types.has(type)