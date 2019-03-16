extends Node

const class_actor = preload("res://Effects/ActorEffect.gd")
const class_spellinput = preload("res://SpellInput.gd")

# Map from actions to spells.
var spells = {}

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

# Returns two values. First, the spell input object. Second, an actor effect that executes the effects from the input.
func createSpellInput(battle):
	# Create a random uuid	
	var uuid = rand_range(0,99999999)
	var code = String(uuid)
	var actor = class_actor.new()
	actor.code = code
	var input = class_spellinput.new()
	input.code = code
	var result_spells = {}
	
	for action in spells:
		var spell = spells[action]
		result_spells[action] = [spell.gem,spell.cooldown,0,spell.repeatable,false]
	
	input.spells = result_spells
	input.battle = battle
	
	return [input,actor]

func to_string():
	var result = ""
	for action in spells:
		var spell = spells[action]
		result = result + action + ": " + spell.to_string() + "\n"
	
	return result

func to_text():
	var result = ""
	for action in spells:
		var spell = spells[action]
		result = result + action + ": " + spell.to_text() + "\n"
	
	return result