extends "res://Scenario.gd"

const class_single = preload("res://Scenarios/SingleElementScenario.gd")

# Effects that the elements shall have.
var player_effects
var monster_effects

# Internal
var monster_scenario
var player_scenario

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func init(battleground):
	player_scenario = class_single.new()
	player_scenario.effects = player_effects
	monster_scenario = class_single.new()
	monster_scenario.effects = monster_effects
	
	monster_scenario.init(battleground)
	player_scenario.init(battleground)

func get_conditions():
	return player_scenario.get_conditions() + monster_scenario.get_conditions()