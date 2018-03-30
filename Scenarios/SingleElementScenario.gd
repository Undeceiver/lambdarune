extends "res://Scenario.gd"

const class_cond = preload("res://Scenarios/SingleElementEndCondition.gd")
const class_element = preload("res://Element.gd")

# Effects that the monster shall have.
var effects

# Generated internally
var element

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func init(battleground):
	element = class_element.new()
	battleground.addElement(element)
	battleground.processAllActions()
	for effect in effects:
		battleground.addEffect(effect,element)
	
	battleground.processAllActions()

func get_conditions():
	var cond = class_cond.new()
	cond.element = element
	return [cond]