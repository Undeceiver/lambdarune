extends Node

class_name Effect
# Here we include the possible types we are using so far. The typing of effects is multiple.
# While it is only labels, we exploit the dynamic nature of the language to actually *expect* certain fields
# in effects with certain types. Moreover, types should be used for this purpose, and types only created when we
# wish to have a set of fields associated under a certain tag.
# 	- "actor": An effect that is waiting for order effects coming from the battleground to run effects on its actor. Has field "code" indicating the code of the order effects to listen to.
#	- "alignment": Has fields "factions", "allies" and "enemies", each of which are an array of strings of factions that the element belongs to, considers as allies and considers as enemies, respectively.
#	- "animation": Has field "node" indicating the node to animate and "animation", which must be a sub-node of "node" of type animation player. When the effect is added, it is played once and then execution continues. The name of the animation to play is contained in the field "animation_name".
#	- "damage": Has field "damage". Deals damage to the living being.
#	- "death": No specific fields, it identifies the death of a living being.
#	- "decorator": Effect decorators are effects themselves.
# 	- "effect_added": Has field sub_effect and sub_element, indicating what effect was added and to what element.
#	- "effect_removed": Has field sub_effect and sub_element, indicating what effect was removed and from what element.
# 	- "element_added": Has field element_added, indicating which element was added into the battleground.
#	- "element_removed": Has field element_removed, indicating which element was removed from the battleground.
#	- "end_turn": Sent by controllers to indicate to the battleground that a turn has ended. The turn-based battleground finds turnbased effects and runs a turn on them.
#	- "graphic": Has field "node" indicating the node to draw alongside this effect.
#	- "life": Has field "hp" indicating the hitpoints left.
#	- "multieffect": Simply an effect used to pack several effects. Has field "effects" with obvious meaning.
#	- "ondamage": When receiving damage, applies an effect. Has field "effect", which is an effect that is cloned and applied each time damage is received, and damage, which indicates the minimum damage to trigger the damage.
#	- "order": Effect that contains another effect that is ordered to be produced on a particular element. Contains field "effect" indicating the sub-effect, and "code" including a text code to identify who is it ordered to.
#	- "position": Has fields x and y, indicating the position of the element.
#	- "repeat": Has field "sub_effect", an effect that is applied on the element every "freq" turns and at most "repetitions" times (0 means unbounded number of times).
#	- "turnbased": Has a function "runTurn" which runs a turn on the effect.
# var types = []
var element
var exclusions = []

enum Permission {ALLOW, DENY, FORCE_ALLOW, FORCE_DENY}

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func mayEffectGoIn(effect):
	return Permission.ALLOW

func mayIGoIn():
	return Permission.ALLOW

func modifyIn(effect):
	return effect

func effectIn(effect):
	pass

func myselfIn():
	pass

func isImmediate():
	return false

func mayIGoOut():
	return Permission.ALLOW

func mayEffectGoOut(effect):
	return Permission.ALLOW

func myselfOut():
	pass

func effectOut(effect):
	pass

# To be called by other effects when they modify the values of this effect.
func reeval():
	pass

func hasType(type):
	return self.types.has(type)

func clone():
	var eff = duplicate()
	eff.cloneFields(self)
	return eff

func cloneFields(other):
	pass
