extends Node

const class_order_effect = preload("Effects/OrderEffect.gd")
const class_endturn_effect = preload("Effects/EndTurnEffect.gd")

# Translates actions into effects to be passed to actors.
# Code indicates the code that the actor will use to identify that the order is directed at it.
# Includes a dictionary from actions to [gem,cooldown,cur_cooldown,repeatable,already].
# The gems are expressed each time the spell is cast, to generate the effect, but only after checkinng
# if the spell is not on cooldown and has not been cast if it is not repeatable.

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
			runAction(action)
	
	# This should probably be changed in the future, when turn system is implemented.
	if event.is_action_pressed("end_turn"):
		endTurn()

func endTurn():
	for action in spells.keys():
		var array = spells[action]
		var gem = array[0]
		var cooldown = array[1]
		var cur_cooldown = array[2]
		var repeatable = array[3]
		var already = array[4]
		if cur_cooldown != 0:
			cur_cooldown = cur_cooldown - 1
		
		spells[action] = [gem,cooldown,cur_cooldown,repeatable,already]
	
	if to_cast != null:
		var action = to_cast[0]
		var effect = to_cast[1]
		var gem = to_cast[2]
		var cooldown = to_cast[3]
		var cur_cooldown = to_cast[4]
		var repeatable = to_cast[5]
		var already = to_cast[6]
		
		spells[action] = [gem,cooldown,cur_cooldown,repeatable,already]
		
		battle.battleground.addEffect(effect,battle.battleground)
		
		battle.processBattle()
		
		var endturn = class_endturn_effect.new()
		battle.battleground.addEffect(endturn,battle.battleground)
		
		battle.processBattle()
		
		to_cast = null
	

func isReady(action):
	var array = spells[action]
	var cur_cooldown = array[2]
	var already = array[4]
	
	return (!already && cur_cooldown == 0)

func runAction(action):
	var array = spells[action]
	var gem = array[0]
	var cooldown = array[1]
	var cur_cooldown = array[2]
	var repeatable = array[3]
	var already = array[4]
	if !already && cur_cooldown == 0:
		var effect = gem.express()
		var wrapper = class_order_effect.new()
		wrapper.effect = effect
		wrapper.code = code
		var n_cur_cooldown = cooldown
		var n_already
		if !repeatable:
			n_already = true
		else:
			n_already = false
		
		to_cast = [action,wrapper,gem,cooldown,n_cur_cooldown,repeatable,n_already]
