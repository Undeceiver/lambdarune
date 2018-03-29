extends "res://Scenario.gd"

const class_cond = preload("res://Scenarios/SingleMonsterEndCondition.gd")
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
	for effect in effects:
		battleground.addEffect(effect,element)

func get_conditions():
	var cond = class_cond.new()
	cond.element = element
	return [cond]