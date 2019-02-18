extends Node

var repeatable = false
# In number of turns
var cooldown = 0
var gem

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

# This class is just descriptive, it has no interaction itself.
# It is used for two things:
#	- It is used to generate a spell input object from the spell repertoire.
#	- It is used for generating the UI indicating what spells are in the repertoire.

func to_string():
	var rep
	if repeatable:
		rep = "repeatable"
	else:
		rep = "non-repeatable"
	
	return gem.to_string() + "[" + rep + " | " + String(cooldown) + " turns cd]"