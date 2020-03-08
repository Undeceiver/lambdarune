extends Node

var class_composite = load("Composite_Gem.gd")
var class_rune = load("Rune.gd")
var class_main_gem = load("Main_Gem.gd")
var class_eff_gem = load("Efficiency_Gem.gd")

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
const composite_decay = 0.7
# Rune decay
const rune_decay = 0.55

# Returns three values: [prob of rune,prob of composite,prob of elemental],
# adding up to 1.
func getGemTypeProbs(power):
	# Proportion between chance of rune/composite and chance of elemental
	# is polynomial on power (with fractional exponent, e.g. square root)
	var prop = prob_base*pow(power,prob_exponent)
	var total = 1+prop
	return [prop*rune_composite_prop/total,prop*(1-rune_composite_prop)/total,1/total]

func getRandomGem(power):
	return getRandomGemWithVars([],["top",[]],power)

# Apart from the list of variables that the gem may use, we indicate a context.
# The context could well be a class, but it is only used here so we encode it through lists with strings, where the head indicates what kind of context it is, pretty much like LISP expressions.
# A head "top" indicates that it is a top level gem. No arguments.
# A head "rune" indicates that it is the body of a rune. No arguments (this could end up, after evaluating, essentially anywhere).
# A head "head" indicates that it is the head of a composite gem. Lone argument is the recursive context of the composite gem.
# A head "arg" indicates that it is the argument of a composite gem. Lone argument is the head of the composite gem.
# Contexts are (for now) exclusively used when generating elemental gems. Certain elemental gems should only appear under certain other elemental gems, or viceversa, or at least in most cases, and their power reduced otherwise. That is what we control here.
func getRandomGemWithVars(vars,context,power):
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
		var body = getRandomGemWithVars(vars,["rune"],rem_power)
		rune.body = body
		
		# Remove the variable
		vars.pop_back()
		
		return rune
		
	# A chance that it is a composite
	elif r < type_probs[0]+type_probs[1]:
		# Get two gems of lower power.
		rem_power = power*composite_decay;
		var f = getRandomGemWithVars(vars,["head",context],rem_power)
		var x = getRandomGemWithVars(vars,["arg",f],rem_power)
		
		var composite = class_composite.new()
		composite.f = f
		composite.x = x
		
		return composite
	# And a chance that it is just an elemental gem. This case includes variables.
	else:
		return getRandomSingleGem(vars,context,power)

func getRandomSingleGem(vars,context,power):
	var total = vars.size()+weight_true_elemental
	
	var r = rand_range(0,total)
	
	if r > vars.size():
		# True elemental
		return getRandomElementalGem(power,context)
	else:
		# Variable
		return vars[floor(r)]

# Override
func getRandomElementalGem(power,context):
	return null
