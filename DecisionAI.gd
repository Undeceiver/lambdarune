extends Node

# This class represents the high level interface of an AI that decides what spells to cast from a repertoire.

var repertoire
var spell_input
var battle

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func makeDecision():
	var action = getDecision()
	if action != null:
		spell_input.runAction(action)
	
	spell_input.endTurn()

# Returns the action to run, or null if no action should be run.
func getDecision():
	# By default, just a random ready spell.
	var ready_spells = []
	for action in repertoire.spells:
		if spell_input.isReady(action):
			ready_spells.append(action)
	
	if ready_spells.empty():
		return null
	else:
		var r = floor(rand_range(0,ready_spells.size()))
		return ready_spells[r]