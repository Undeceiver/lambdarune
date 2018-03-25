extends "res://Effect.gd"

var types = ["turnbased"]

# A very simple schematic AI that has:
#	- A target finding function. Chooses a target or none.
#	- A range checking function. Decides whether to "move" or "attack".
#	- A moving function. Tries to move towards the target until it is in range.
#	- An attacking function. Attacks while the target is in range.
 
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

# Return null if no target, or an element.
func findTarget():
	return null

func inRange(element):
	return false

func moveTowards(element):
	pass

func attack(element):
	pass

func runTurn():
	var target = findTarget()
	if target != null:
		if inRange(target):
			attack(target)
		else:
			moveTowards(target)