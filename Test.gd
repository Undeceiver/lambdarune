extends Node2D

const class_rune = preload("Rune.gd")
const class_elemental_gem = preload("Elemental_Gem.gd")
const class_main_gem = preload("Main_Gem.gd")
const class_composite_gem = preload("Composite_Gem.gd")
const class_efficiency_gem = preload("Efficiency_Gem.gd")

const class_2dbattleground = preload("2DBattleground.gd")
const class_element = preload("Element.gd")
const class_position = preload("Effects/Position.gd")
const class_movement = preload("Effects/MoveEffect.gd")
const class_graphic = preload("Effects/GraphicEffect.gd")
const class_animation = preload("Effects/AnimationEffect.gd")
const class_life = preload("Effects/LifeEffect.gd")

const class_gem_parser = preload("GemParser.gd")
const class_gem_randomizer = preload("SpellGemRandomizer.gd")

var g_battleground
var g_element1
var g_element2

func test_runes_1():
	var rune = class_rune.new()
	var rune2 = class_rune.new()
	var elem = class_elemental_gem.new()
	var main = class_main_gem.new()
	var main2 = class_main_gem.new()
	var composite = class_composite_gem.new()
	var composite2 = class_composite_gem.new()
	var composite3 = class_composite_gem.new()
	var composite4 = class_composite_gem.new()
	var composite5 = class_composite_gem.new()
	var composite6 = class_composite_gem.new()
	var eff = class_efficiency_gem.new()
	
	main.gem_rune = rune
	main2.gem_rune = rune2
	rune.body = composite3
	rune.efficiency_gem = eff
	eff.efficiency = 0.8
	rune2.body = composite5
	rune2.efficiency_gem = eff
	composite.f = main
	composite.x = main
	composite2.f = composite
	composite2.x = main
	composite3.f = elem
	composite3.x = composite2
	composite4.f = elem
	composite4.x = elem
	composite5.f = composite4
	composite5.x = main2
	composite6.f = rune
	composite6.x = rune2
	var res = composite6.eval(2.0,elem)
	get_node("Label").set_text(res.to_string())

func processBattleground(battleground,times):
	for i in range(times):
		battleground.processActions()

func test_positions_1():
	var battleground = class_2dbattleground.new()
	var element1 = class_element.new()
	var element2 = class_element.new()
	var position1 = class_position.new()
	var position2 = class_position.new()
	
	position1.x = 3
	position1.y = 4
	position2.x = 5
	position2.y = 6
	
	battleground.addElement(element1)
	battleground.addElement(element2)
	processBattleground(battleground,10)
	
	print("Elements added, no position:")
	for element in battleground.findElements("position"):
		for position in element[1]:
			print("Position: " + String(position.x) + ", " + String(position.y))
	
	battleground.addEffect(position1,element1)
	battleground.addEffect(position2,element2)
	processBattleground(battleground,10)
	
	print("Positions added:")
	for element in battleground.findElements("position"):
		for position in element[1]:
			print("Position: " + String(position.x) + ", " + String(position.y))
	
	var movement = class_movement.new()
	movement.x = 666
	movement.y = 666
	
	battleground.addEffect(movement,element1)
	processBattleground(battleground,10)
	
	print("Position changed:")
	for element in battleground.findElements("position"):
		for position in element[1]:
			print("Position: " + String(position.x) + ", " + String(position.y))
	
	var movement2 = class_movement.new()
	movement2.x = 5
	movement2.y = 6
	
	battleground.addEffect(movement2,element1)
	processBattleground(battleground,10)
	
	print("Position illegally changed:")
	for element in battleground.findElements("position"):
		for position in element[1]:
			print("Position: " + String(position.x) + ", " + String(position.y))
	

func test_positions_2():
	var battleground = class_2dbattleground.new()
	
	add_child(battleground)
	
	var element1 = class_element.new()
	var element2 = class_element.new()
	
	battleground.addElement(element1)
	battleground.addElement(element2)
	
	processBattleground(battleground,10)
	
	var position1 = class_position.new()
	var position2 = class_position.new()
	
	position1.x = 2
	position1.y = 2
	position2.x = 4
	position2.y = 5
	
	battleground.addEffect(position1,element1)
	battleground.addEffect(position2,element2)
	
	processBattleground(battleground,10)
	
	var graphic1 = class_graphic.new()
	graphic1.node = get_node("test_element").duplicate()
	graphic1.node.show()
	
	var graphic2 = class_graphic.new()
	graphic2.node = get_node("test_element").duplicate()
	graphic2.node.show()
	
	battleground.addEffect(graphic1,element1)
	battleground.addEffect(graphic2,element2)
	
	processBattleground(battleground,10)
	
	battleground.processGraphics()
	
	g_battleground = battleground
	g_element1 = element1
	g_element2 = element2
	
	#graphic2.node.connect("pressed",self,"test_positions_2_on_press")

func test_positions_2_on_press():
	var moveEffect = class_movement.new()
	moveEffect.x = 7
	moveEffect.y = 2
	
	g_battleground.addEffect(moveEffect,g_element1)
	
	processBattleground(g_battleground,10)
	g_battleground.processGraphics()

func test_rune_parsing_1():
	randomize()
	
	var parser = class_gem_parser.new()
	
	var text = "(\\x 0.65 ((\\y 0.74 (y (y x))) dmg5)) dmg12;"
	#var text = "(\\x 0.65 ((\\y 0.74 x) (dmg5;))) dmg12;"
	var gem = parser.read_gem(text)
	print("Parsed this:")
	print(gem.to_string())
	var finalgem = gem.eval(100,gem)
	print("Evaluated to this:")
	print(finalgem.to_string())

func test_rune_parsing_2():
	randomize()
	var parser = class_gem_parser.new()
	
	var text = "(\\x 3 (x (x x))) (\\x 3 (x (x x)));"
	var gem = parser.read_gem(text)
	var filler_text = "dmg1;;"
	var filler_gem = parser.read_gem(filler_text)
	print("Parsed this:")
	print(gem.to_string())
	var finalgem = gem.eval(20,filler_gem)
	print("Evaluated to this:")
	print(finalgem.to_string())

func test_spell_expressing():
	randomize()
	
	var battleground = class_2dbattleground.new()
	
	add_child(battleground)
	
	var element1 = class_element.new()
	var element2 = class_element.new()
	
	battleground.addElement(element1)
	battleground.addElement(element2)
	
	processBattleground(battleground,10)
	
	var position1 = class_position.new()
	var position2 = class_position.new()
	
	position1.x = 2
	position1.y = 2
	position2.x = 4
	position2.y = 5
	
	battleground.addEffect(position1,element1)
	battleground.addEffect(position2,element2)
	
	processBattleground(battleground,10)
	
	var graphic1 = class_graphic.new()
	graphic1.node = get_node("test_element").duplicate()
	graphic1.node.show()
	
	var graphic2 = class_graphic.new()
	graphic2.node = get_node("test_element").duplicate()
	graphic2.node.show()
	
	battleground.addEffect(graphic1,element1)
	battleground.addEffect(graphic2,element2)
	
	processBattleground(battleground,10)
	
	var life1 = class_life.new()
	life1.hp = 50
	
	var life2 = class_life.new()
	life2.hp = 75
	
	battleground.addEffect(life1,element1)
	battleground.addEffect(life2,element2)
	
	processBattleground(battleground,10)
	
	battleground.processGraphics()
	
	g_battleground = battleground
	g_element1 = element1
	g_element2 = element2
	
	#graphic2.node.connect("pressed",self,"test_positions_2_on_press")

func test_spell_expressing_onpress():
	var parser = class_gem_parser.new()
	var spell = "dmg10;;"
	var gem = parser.read_gem(spell)
	var filler_spell = "dmg1;;"
	var filler_gem = parser.read_gem(filler_spell)
	var eval_spell = gem.eval(20,filler_gem)
	
	var spell_cast = eval_spell.express()
	
	g_battleground.addEffect(spell_cast,g_element1)
	
	var anim_node = get_node("test_element").duplicate()
	anim_node.show()
	var anim_anim = anim_node.get_node("test_animation_player")
	var anim_name = "spell_effect"
	var anim_effect = class_animation.new()
	anim_effect.node = anim_node
	anim_effect.animation = anim_anim
	anim_effect.animation_name = anim_name
	
	g_battleground.addEffect(anim_effect,g_element1)
	
	processBattleground(g_battleground,10)
	g_battleground.processGraphics()

func test_random_runes():
	randomize()
	var randomizer = class_gem_randomizer.new()
	
	var gem = randomizer.getRandomGem(5)
	print(gem.to_string())

func _ready():
	#test_runes_1()
	#test_positions_1()
	#test_positions_2()
	#test_rune_parsing_1()
	#test_rune_parsing_2()
	test_spell_expressing()
	#test_random_runes()