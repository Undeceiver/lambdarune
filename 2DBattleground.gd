extends "Battleground.gd"

const class_2dbg_effect = preload("Effects/2DBattlegroundEffect.gd")

# These have default values, but can be changed.
var bg_start_x = 0
var bg_start_y = 0
var cell_width = 50
var cell_height = 50

# Positions are stored as effects in the elements, so there's no need to keep track of them here.
func processGraphics():
	for element_pos in findElements("position"):
		var element = element_pos[0]
		# We only consider the first position, there should be no more than one position.
		var position = element_pos[1][0]
		for graphic in element.findEffects("graphic"):
			#graphic.node.set_pos(translate_pos(position.x,position.y))
			graphic.node.position = translate_pos(position.x,position.y)

func add_graphic_element(graphic):
	add_child(graphic.node)

func remove_graphic_element(graphic):
	#remove_child(graphic.node)
	#graphic.node.free()
	graphic.node.queue_free()

func translate_pos(x, y):
	return Vector2(bg_start_x + cell_width*x,bg_start_y + cell_height*y)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	var effect = class_2dbg_effect.new()
	addEffect(effect,self)
