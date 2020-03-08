extends "res://Effect.gd"

var types = ["repeat","turnbased"]

var sub_effect
var freq
var repetitions = 0

var nexec = 0
var waiting = 0

func isImmediate():
	return false

func myselfIn():
	castOnce()

func cloneFields(other):
	sub_effect = other.sub_effect
	freq = other.freq
	repetitions = other.repetitions

func castOnce():
	var new_effect = sub_effect.clone()
	element.battleground.addEffect(new_effect,element)
	nexec = nexec + 1
	
	if !castAgain():
		element.battleground.removeEffect(self,element)

func castAgain():
	return (repetitions == 0 or nexec < repetitions)

func runTurn():
	waiting = waiting + 1
	if waiting >= freq:
		waiting = 0
		castOnce()
