extends "res://EndCondition.gd"

var element

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func is_fulfilled(battleground):
	return !battleground.elements.has(element)