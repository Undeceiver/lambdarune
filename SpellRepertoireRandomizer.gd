extends Node

var class_spell_gem_rnd = load("SpellGemRandomizer.gd")
const class_spell_repertoire = preload("SpellRepertoire.gd")
const class_spell = preload("Spell.gd")
var class_rune = load("Rune.gd")

# The idea of this class is as follows: 
#	- The number of spells is a geometric distribution with parameter ps indicating the probability of adding a new spell at each point.
var ps
#	- The power of each spell is approximated as a normal distribution by summing uniform distributions. Parameters are the desired average avg, the width w (as a proportion of avg) and the number of uniforms to sum us.
var avg
var w
var us
#	- Whenever the power is used for following formulas, it is normalized by dividing it with a factor that indicates what should be a "standard" power.
var std_power
# 	- The energy gem applied to the gem to evaluate it is also calculated with a normal distribution.
var eavg
var ew
var eus
#	- A parameter pr controls the probability that a spell is repeatable.
var pr
#	- Parameters pcd and pcdr control the probability that a spell has a cooldown with the formula probability = pcd*pcdr^(1/power)
var pcd
var pcdr
#	- If the spell has a cooldown, the cooldown is a geometric distribution with probability of each turn controlled by parameters pxcd and pxcdr with formula probability = pxcd*pxcdr^(1/power)
var pxcd
var pxcdr
# 	- The spell is then generated using the spell gem randomizer.

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

# Receives a list of actions, and takes the first from them, adding "no_action_X" if there are more spells than actions.
# Also receives a filler gem when evaluating the spells.
func getRandomRepertoire(actions,filler):
	var gem_randomizer = class_spell_gem_rnd.new()
	var result_spells = []
	
	while(getAnotherSpell()):
		# We avoid returning exactly the filler.
		var filling = true
		var spell
		while filling:
			var power = getSpellPower()
			var std = float(power) / float(std_power)
			var repeatable = isRepeatable()
			var hasCooldown = hasCooldown(std)
			var cooldown
			if hasCooldown:
				cooldown = getCooldown(std)
			else:
				cooldown = 0
			var gem = gem_randomizer.getRandomGem(power)
			spell = class_spell.new()
			var energy = getEnergy()
			spell.repeatable = repeatable
			spell.cooldown = cooldown
			spell.gem = gem.eval(energy,filler)
			if spell.gem is class_rune:
				filling = true
			else:
				filling = false
			
		result_spells.append(spell)
	
	var map = {}
	var no_action_i = 1
	
	for i in range(0,len(result_spells)):
		var action
		if len(actions) <= i:
			action = "no_action" + str(no_action_i)
			no_action_i = no_action_i + 1
		else:
			action = actions[i]
		
		map[action] = result_spells[i]
	
	var repertoire = class_spell_repertoire.new()
	repertoire.spells = map
	
	return repertoire

func getAnotherSpell():
	var r = rand_range(0,1)
	
	return (r < ps)

func getSpellPower():
	var sum = 0
	var ind_avg = float(avg) / float(us)
	var ind_w = ind_avg * float(w)
	
	for i in range(0,us):
		var nr = rand_range(ind_avg-ind_w,ind_avg+ind_w)
		sum = sum + nr
	
	return sum

func isRepeatable():
	var r = rand_range(0,1)
	
	return (r < pr)

func hasCooldown(power):
	var fp = pcd*pow(pcdr,float(1)/float(power))
	
	var r = rand_range(0,1)
	
	return (r < fp)

func getCooldown(power):
	var fp = pxcd*pow(pxcdr,float(1)/float(power))
	
	var cd = 1
	
	while(rand_range(0,1) < fp):
		cd = cd + 1
	
	return cd

func getEnergy():
	var sum = 0
	var ind_avg = float(eavg) / float(eus)
	var ind_w = ind_avg * float(ew)
	
	for i in range(0,eus):
		var nr = rand_range(ind_avg-ind_w,ind_avg+ind_w)
		sum = sum + nr
	
	return sum
