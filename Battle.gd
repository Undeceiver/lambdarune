extends Node

# A battle consists of a battleground and a series of end conditions.
signal battle_ended

var ended = false
var end_condition
var battleground
var conditions = []

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
		battleground.processActions()
		for condition in conditions:
			if condition.is_fulfilled():
				ended = true
				end_condition = condition
				emit_signal("battle_ended")
				return