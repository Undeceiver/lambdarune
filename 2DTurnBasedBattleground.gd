extends "2DBattleground.gd"


func _ready():
	._ready()

func runTurn():
	for element_effect in findElements("turnbased"):
		var element = element_effect[0]
		for effect in element_effect[1]:
			effect.runTurn()