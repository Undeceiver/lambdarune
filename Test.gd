extends Node2D

var class_rune = load("Rune.gd")
var class_elemental_gem = load("Elemental_Gem.gd")
var class_main_gem = load("Main_Gem.gd")
var class_composite_gem = load("Composite_Gem.gd")
var class_efficiency_gem = load("Efficiency_Gem.gd")

const class_2dbattleground = preload("2DBattleground.gd")
const class_tb2dbattleground = preload("TurnBased2DBattleground.gd")
const class_element = preload("Element.gd")
const class_position = preload("Effects/Position.gd")
const class_movement = preload("Effects/MoveEffect.gd")
const class_graphic = preload("Effects/GraphicEffect.gd")
const class_animation = preload("Effects/AnimationEffect.gd")
const class_life = preload("Effects/LifeEffect.gd")
const class_actor = preload("Effects/ActorEffect.gd")

const class_1on1_scenario = preload("Scenarios/OneOnOneScenario.gd")
const class_battle = preload("Battle.gd")
const class_spell_input = preload("SpellInput.gd")
const class_spell_repertoire = preload("SpellRepertoire.gd")
const class_spell = preload("Spell.gd")
const class_decision_ai = preload("DecisionAI.gd")
const class_playervsaibattle = preload("PlayerVsAIBattle.gd")

const class_gem_parser = preload("GemParser.gd")
const class_gem_randomizer = preload("SpellGemRandomizer.gd")
const class_repertoire_randomizer = preload("SpellRepertoireRandomizer.gd")

const class_damage_decorator = preload("Decorators/DamageDecorator.gd")

var g_battleground
var g_element1
var g_element2
var g_battle

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
	
	if g_battle == null:
	#processBattleground(g_battleground,10)
		g_battleground.processAllActions()
		g_battleground.processGraphics()
	else:
		g_battle.processBattle()
		g_battleground.processGraphics()

func test_random_runes():
	randomize()
	var randomizer = class_gem_randomizer.new()
	
	var gem = randomizer.getRandomGem(5)
	print(gem.to_string())

func test_scenario():
	randomize()
	
	var scenario = class_1on1_scenario.new()
	
	var battle = class_battle.new()
	var battleground = class_2dbattleground.new()
	
	add_child(battle)
	
	var position1 = class_position.new()
	var position2 = class_position.new()
	
	position1.x = 2
	position1.y = 2
	position2.x = 4
	position2.y = 5
		
	var graphic1 = class_graphic.new()
	graphic1.node = get_node("test_element").duplicate()
	graphic1.node.show()
	
	var graphic2 = class_graphic.new()
	graphic2.node = get_node("test_element").duplicate()
	graphic2.node.show()
	
	var life1 = class_life.new()
	life1.hp = 50
	
	var life2 = class_life.new()
	life2.hp = 75
	
	scenario.player_effects = [position1,graphic1,life1]
	scenario.monster_effects = [position2,graphic2,life2]
	
	battle.setBattleground(battleground)
	battle.loadScenario(scenario)
	
	battleground.processGraphics()
	
	g_battle = battle
	g_battleground = battleground
	g_element1 = scenario.player_scenario.element
	g_element2 = scenario.monster_scenario.element
	
	yield(battle,"battle_ended")
	
	get_tree().quit()

func test_scenario_2():
	randomize()
	
	var scenario = class_1on1_scenario.new()
	
	var battle = class_battle.new()
	var battleground = class_2dbattleground.new()
	
	add_child(battle)
	
	var position1 = class_position.new()
	var position2 = class_position.new()
	
	position1.x = 2
	position1.y = 2
	position2.x = 4
	position2.y = 5
		
	var graphic1 = class_graphic.new()
	graphic1.node = get_node("test_element").duplicate()
	graphic1.node.show()
	
	var graphic2 = class_graphic.new()
	graphic2.node = get_node("test_element").duplicate()
	graphic2.node.show()
	
	var life1 = class_life.new()
	life1.hp = 50
	
	var life2 = class_life.new()
	life2.hp = 75
	
	#var actor = class_actor.new()
	#actor.code = "player1"
	
	#var input = class_spell_input.new()
	var repertoire = class_spell_repertoire.new()
	var parser = class_gem_parser.new()
	var spell = "dmg12;;"
	var gem = parser.read_gem(spell)
	#var cooldown = 0
	#var repeatable = true
	var filler_spell = "dmg1;;"
	var filler_gem = parser.read_gem(filler_spell)
	var eval_spell = gem.eval(20,filler_gem)
	var dmg_decorator = class_damage_decorator.new()
	
	#input.code = "player1"
	#input.spells = {"test_action":[eval_spell,cooldown,0,repeatable,false]}
	#input.battle = battle
	var spell1 = class_spell.new()
	spell1.gem = eval_spell
	spell1.cooldown = 0
	spell1.repeatable = true
	
	repertoire.spells = {"test_action":spell1}
	repertoire.battle = battle
	print(repertoire.to_string())
	var inputactor = repertoire.createSpellInput()
	var input = inputactor[0]	
	var actor = inputactor[1]
	
	add_child(input)
	
	scenario.player_effects = [position1,graphic1,life1,actor]
	scenario.monster_effects = [position2,graphic2,life2]
	
	#battleground.decorator = decorator
	#battleground.decorator_args = {}
	battleground.addEffect(dmg_decorator,battleground)
	battle.setBattleground(battleground)
	battle.loadScenario(scenario)
	
	battle.addPeriodicCall(battleground,"processGraphics")
	battle.processBattle()
	
	g_battle = battle
	g_battleground = battleground
	g_element1 = scenario.player_scenario.element
	g_element2 = scenario.monster_scenario.element
	
	yield(battle,"battle_ended")
	
	get_tree().quit()

func test_versus():
	randomize()
	
	var scenario = class_1on1_scenario.new()
	
	var battle = class_playervsaibattle.new()
	#var battleground = class_2dbattleground.new()
	var battleground = class_tb2dbattleground.new()
	
	add_child(battle)
	
	var position1 = class_position.new()
	var position2 = class_position.new()
	
	position1.x = 2
	position1.y = 2
	position2.x = 4
	position2.y = 5
		
	var graphic1 = class_graphic.new()
	graphic1.node = get_node("test_element").duplicate()
	graphic1.node.show()
	
	var graphic2 = class_graphic.new()
	graphic2.node = get_node("test_element").duplicate()
	graphic2.node.show()
	
	var life1 = class_life.new()
	life1.hp = 50
	
	var life2 = class_life.new()
	life2.hp = 75
	
	#var actor = class_actor.new()
	#actor.code = "player1"
	
	#var input = class_spell_input.new()
	var repertoire_player = class_spell_repertoire.new()
	var repertoire_ai = class_spell_repertoire.new()
	var parser = class_gem_parser.new()
	var spell_player = "dmg12;;"
	var gem_player = parser.read_gem(spell_player)
	var spell_ai = "dmg3;;"
	var gem_ai = parser.read_gem(spell_ai)
	#var spell_ai_2 = "dmg30;;"
	var spell_ai_2 = "(dmg4 dmg5;);"
	var gem_ai_2 = parser.read_gem(spell_ai_2)
	#var cooldown = 0
	#var repeatable = true
	var filler_spell = "dmg1;;"
	var filler_gem = parser.read_gem(filler_spell)
	var eval_spell_player = gem_player.eval(20,filler_gem)
	var eval_spell_ai = gem_ai.eval(20,filler_gem)
	var eval_spell_ai_2 = gem_ai_2.eval(20,filler_gem)
	var dmg_decorator = class_damage_decorator.new()
	
	#input.code = "player1"
	#input.spells = {"test_action":[eval_spell,cooldown,0,repeatable,false]}
	#input.battle = battle
	var spell1 = class_spell.new()
	spell1.gem = eval_spell_player
	spell1.cooldown = 0
	spell1.repeatable = true
	
	var spell2 = class_spell.new()
	spell2.gem = eval_spell_ai
	spell2.cooldown = 1
	spell2.repeatable = true
	
	var spell3 = class_spell.new()
	spell3.gem = eval_spell_ai_2
	spell3.cooldown = 0
	spell3.repeatable = false
	
	repertoire_player.spells = {"test_action":spell1}
	#repertoire_player.battle = battle
	print("Player repertoire:")
	print(repertoire_player.to_text())
	repertoire_ai.spells = {"test_action":spell2,"no_action":spell3}
	#repertoire_ai.battle = battle
	print("AI repertoire:")
	print(repertoire_ai.to_text())
	var inputactor_player = repertoire_player.createSpellInput(battle)
	var input_player = inputactor_player[0]	
	var actor_player = inputactor_player[1]
	var inputactor_ai = repertoire_ai.createSpellInput(battle)
	var input_ai = inputactor_ai[0]
	var actor_ai = inputactor_ai[1]	
	var decision_ai = class_decision_ai.new()
	decision_ai.repertoire = repertoire_ai
	decision_ai.spell_input = input_ai	
	battle.setPlayerInput(input_player)
	battle.setDecisionAI(decision_ai)
	
	scenario.player_effects = [position1,graphic1,life1,actor_player]
	scenario.monster_effects = [position2,graphic2,life2,actor_ai]
	
	#battleground.decorator = decorator
	#battleground.decorator_args = {}
	battleground.addEffect(dmg_decorator,battleground)
	battle.setBattleground(battleground)
	battle.loadScenario(scenario)
	
	battle.addPeriodicCall(battleground,"processGraphics")
	battle.processBattle()
	
	#g_battle = battle
	#g_battleground = battleground
	#g_element1 = scenario.player_scenario.element
	#g_element2 = scenario.monster_scenario.element
	
	yield(battle,"battle_ended")
	
	get_tree().quit()

func test_repertoire_randomizing():
	randomize()
	
	var randomizer = class_repertoire_randomizer.new()
	
	randomizer.ps = float(49)/float(50)
	randomizer.avg = 50
	randomizer.w = 0.8
	randomizer.us = 5
	randomizer.eavg = 100
	randomizer.ew = 0.6
	randomizer.eus = 5
	randomizer.pr = 0.8
	randomizer.pcd = 0.9
	randomizer.pcdr = 0.2
	randomizer.pxcd = float(3)/float(4)
	randomizer.pxcdr = float(4*0.5)/float(3*1.5)
	randomizer.std_power = 5
	
	var parser = class_gem_parser.new()
	var filler_spell = "dmg1;;"
	var filler_gem = parser.read_gem(filler_spell)
	
	var repertoire = randomizer.getRandomRepertoire(["a1","a2","a3","a4"],filler_gem)
	
	print("Repertoire:\n\n" + repertoire.to_text())
	
	#get_tree().quit()
	

func test_typecheck():
	var t1 = ["func",["var","x"],["func",["var","z"],["basic","a"]]]
	var t2 = ["func",["func",["var","y"],["basic","a"]],["var","y"]]
	
	var variables = {"x":["var","x"], "y":["var","y"], "z":["var","z"]}
	
	var res = Types.unify([[t1,t2]],variables)
	
	print("Unifiable? " + str(res))
	print("x -> " + str(variables["x"]))
	print("x -> " + str(Types.applyBinding(variables,["var","x"])))
	print("y -> " + str(variables["y"]))
	print("y -> " + str(Types.applyBinding(variables,["var","y"])))
	print("z -> " + str(variables["z"]))
	print("z -> " + str(Types.applyBinding(variables,["var","z"])))
	
	var nvar = Types.getFreeVariable(variables)
	print(nvar + " -> " + str(variables[nvar]))
	
	var nvar2 = Types.getFreeVariable(variables)
	print(nvar2 + " -> " + str(variables[nvar2]))
	
	get_tree().quit()

func test_typecheck2():
	var parser = class_gem_parser.new()
	
	#var text = "(\\x 0.65 ((\\y 0.74 (y (y x))) dmg5)) dmg12;"
	#var text = "rep1,3 (rep2,5 dmg6);;"
	#var text = "rep1,3 (dmg77 dmg6);;"
	#var text = "(\\x 0.65 (rep3,3 x));;"
	#var text = "(\\x 0.65 (x dmg7));;"
	#var text = "(\\x 0.65 (x rep4,7));;"
	#var text = "(\\x 0.65 (\\y 0.74 (y x)));;"
	var text = "(\\x 0.65 (\\y 0.74 (y x))) rep4,5;;"
	var gem = parser.read_gem(text)
	print("Parsed this:")
	print(gem.to_string())
	print("Which has type:")
	var variables = {}
	var runes = {}
	print(str(Types.applyBinding(variables,gem.getType(variables,runes))))
	
	get_tree().quit()

func _ready():
	#test_runes_1()
	#test_positions_1()
	#test_positions_2()
	#test_rune_parsing_1()
	#test_rune_parsing_2()
	#test_spell_expressing()
	#test_random_runes()
	#test_scenario()
	#test_scenario_2()
	#test_versus()
	#test_repertoire_randomizing()
	#test_typecheck()
	test_typecheck2()
