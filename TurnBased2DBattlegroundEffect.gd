extends "res://Effect.gd"

# Purely listening effect, that checks for end turn effects and calls on turn-based effects when it receives them.
var types = []

func effectIn(effect):
	if effect.hasType("end_turn"):
		var elemeffs = element.battleground.findElements("turnbased")
		for elemeff in elemeffs:
			var effects = elemeff[1]
			for eff in effects:
				eff.runTurn()