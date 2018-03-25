extends Node

const class_composite = preload("Composite_Gem.gd")
const class_rune = preload("Rune.gd")
const class_main_gem = preload("Main_Gem.gd")
const class_eff_gem = preload("Efficiency_Gem.gd")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

# How many of runes/composites are runes
const rune_composite_prop = 0.35
# Exponent on the proportion between the probability of rune/composite and the probability of elemental
const prob_exponent = 0.7
const prob_base = 0.2
# Probability of being a true elemental, compared to each of the available variables.
const weight_true_elemental = 1.5
# Composite decay
const composite_decay = 0.85
# Rune decay
const rune_decay = 0.8

# Returns three values: [prob of rune,prob of composite,prob of elemental],
# adding up to 1.
func getGemTypeProbs(power):
	# Proportion between chance of rune/composite and chance of elemental
	# is polynomial on power (with fractional exponent, e.g. square root)
	var prop = prob_base*pow(power,prob_exponent)
	var total = 1+prop
	return [prop*rune_composite_prop/total,prop*(1-rune_composite_prop)/total,1/total]

func getRandomGem(power):
	return getRandomGemWithVars([],power)

func getRandomGemWithVars(vars,power):
	var type_probs = getGemTypeProbs(power)
	var rem_power
	
	var r = rand_range(0,1)
	
	# There is a chance that it is a rune
	if r < type_probs[0]:
		var rune = class_rune.new()
		var main_gem = class_main_gem.new()
		main_gem.gem_rune = rune
		vars.push_back(main_gem)
		# The efficiency is simply a random value between 1 and power. The scaling of efficiency done when evaluating runes
		# should make this a decent choice.
		var eff = ceil(rand_range(0,power))
		var eff_gem = class_eff_gem.new()
		eff_gem.efficiency = eff
		rune.efficiency_gem = eff_gem
		
		rem_power = power*rune_decay
		var body = getRandomGemWithVars(vars,rem_power)		
		rune.body = body
		
		# Remove the variable
		vars.pop_back()
		
		return rune
		
	# A chance that it is a composite
	elif r < type_probs[0]+type_probs[1]:
		# Get two gems of lower power.
		rem_power = power*composite_decay;
		var f = getRandomGemWithVars(vars,rem_power)
		var x = getRandomGemWithVars(vars,rem_power)
		
		var composite = class_composite.new()
		composite.f = f
		composite.x = x
		
		return composite
	# And a chance that it is just an elemental gem. This case includes variables.
	else:
		return getRandomSingleGem(vars,power)

func getRandomSingleGem(vars,power):
	var total = vars.size()+weight_true_elemental
	
	var r = rand_range(0,total)
	
	if r > vars.size():
		# True elemental
		return getRandomElementalGem(power)
	else:
		# Variable
		return vars[floor(r)]

# Override
func getRandomElementalGem(power):
	return null