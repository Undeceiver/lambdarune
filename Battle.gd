extends Node

class_name Battle

# A battle consists of a battleground and a series of end conditions.
signal battle_ended

var ended = false
var end_condition
var battleground
var conditions = []

# Things that are meant to be called each time the battle is processed. Pairs of node and function name. No arguments allowed.
var periodic_calls = []

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func processBattle():
	if !ended:
		battleground.processAllActions()
		for call in periodic_calls:
			call[0].call(call[1])
		
		for condition in conditions:
			if condition.is_fulfilled(battleground):
				ended = true
				end_condition = condition
				emit_signal("battle_ended")
				return

func setBattleground(bg):
	battleground = bg
	add_child(battleground)

func loadScenario(scenario):
	scenario.init(battleground)
	conditions = conditions + scenario.get_conditions()

func addPeriodicCall(node,func_name):
	periodic_calls.append([node,func_name])
