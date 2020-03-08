extends "res://Battle.gd"

var player_input
var decision_ai
# true if it is the players turn, false otherwise.
var cur_turn = true

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _unhandled_input(event):
	# Right now, we ask for the player to input an end_turn action on the AI's turn too, to make them able to control when the AI actions occur.
	# If we receive an end of turn action and it is the player's turn, we set the turn to AI and pass the event over for the input to process it.
	# If we receive an end of turn action and it is the AI's turn, we process the action and run it, and then set the player's turn.
	# Any other events received during the AI's turn are intentionally ignored.
	if event.is_action_pressed("end_turn"):
		if cur_turn:
			cur_turn = false
			player_input._unhandled_input(event)
		else:
			decision_ai.makeDecision()
			cur_turn = true
			#get_tree().set_input_as_handled()
	else:
		if cur_turn:
			player_input._unhandled_input(event)
		else:
			pass
			# Ignore it.
			#get_tree().set_input_as_handled()

func setPlayerInput(pi):
	player_input = pi
	# Because Godot for some reason is calling input events in the wrong order, we actually manually call the input for the spell input exactly when necessary
	#add_child(player_input)

func setDecisionAI(ai):
	decision_ai = ai
	decision_ai.battle = self
	#add_child(decision_ai)
