extends Node

const class_gem_parser = preload("GemParser.gd")
const class_order_effect = preload("Effects/OrderEffect.gd")

# Translates actions into effects to be passed to actors.
# Code indicates the code that the actor will use to identify that the order is directed at it.
# Includes a dictionary from actions to gems, which are expressed each time the spell is cast, to generate the effect.

var code
var spells
var battle

# Internal
var to_cast

func _ready():
	pass

func _unhandled_input(event):
	for action in spells.keys():
		if event.is_action_pressed(action):
			var effect = spells[action].express()
			var wrapper = class_order_effect.new()
			wrapper.effect = effect
			wrapper.code = code
			to_cast = wrapper
			
	# This should probably be changed in the future, when turn system is implemented.
	if event.is_action_pressed("end_turn") && to_cast != null:
		battle.battleground.addEffect(to_cast,battle.battleground)
		battle.processBattle()