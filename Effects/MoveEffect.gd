extends "res://Effect.gd"

var types = []

var x
var y

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func isImmediate():
	return true

func mayIGoIn():
	# If there is already a different element in the same position, do not move.
	var elements = element.battleground.findElements("position")
	for element_effects in elements:
		if element_effects[0] != self:
			var positions = element_effects[1]
			for position in positions:
				if position.x == self.x and position.y == self.y:
					return DENY

func myselfIn():
	# Effects can modify other effects in two ways. "Passively" or "actively".
	# Passively means that the effect to be changed reacts to other effects coming in and acts accordingly.
	# Actively means that when the effect goes in, it searches for existing effects and does something.
	# It is a matter of point of view.
	# In the case of movement, the point of view is active. When movement happens, position is changed, that's what we know for sure,
	# but, is it position that reacts to movement by changing, or movement that changes position actively? We went for the latter.
	var positions = element.findEffects("position")
	for position in positions:
		position.x = x
		position.y = y
		position.reeval()

func cloneFields(other):
	x = other.x
	y = other.y