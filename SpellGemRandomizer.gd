extends "GemRandomizer.gd"

var class_damage_gem = load("res://Elemental gems/Damage.gd")
var class_repeat_gem = load("res://Elemental gems/Repeat.gd")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

# Parameters for specific elemental gems

# Maximum parameter an ondamage effect may have.
var ondamage_base = 30

# Base probability that repeat effect is infinite (at power 1)
var base_repeat_inf = 0.03
# Average number of repetitions at power 1
var avg_repetitions = 3
# Average frequency of repeat at power 1
var avg_repeat_freq = 7

func getRandomElementalGem(power,context):
	var reroll = true
	var result = null
	
	while reroll:
		reroll = false
		
		if context[0] == "top":
			var w_ondamage = 0
			var w_damage = 60
			var w_repeat = 0
			
			var r = rand_range(0,w_ondamage+w_damage+w_repeat)
			
			if r < w_ondamage:
				result = getOnDamage(power)
			elif r < w_damage+(w_ondamage):
				result = getDamage(power)
			elif r < w_repeat+(w_damage+w_ondamage):
				result = getRepeat(power)
			
		elif context[0] == "rune":
			var w_ondamage =  45
			var w_damage = 30
			var w_repeat = 15*sqrt(power)
			
			var r = rand_range(0,w_ondamage+w_damage+w_repeat)
			
			if r < w_ondamage:
				result = getOnDamage(power)
			elif r < w_damage+(w_ondamage):
				result = getDamage(power)
			elif r < w_repeat+(w_damage+w_ondamage):
				result = getRepeat(power)
			
		elif context[0] == "head":
			var rec_context = getRecContext(context)
			var w_ondamage = 60
			var w_damage = 0
			var w_repeat = 45*sqrt(power)
			
			var r = rand_range(0,w_ondamage+w_damage)
			
			if r < w_ondamage:
				result = getOnDamage(power)
			elif r < w_damage+(w_ondamage):
				result = getDamage(power)
			elif r < w_repeat+(w_damage+w_ondamage):
				result = getRepeat(power)
			
		elif context[0] == "arg":
			var head = context[1]
			var w_ondamage = 0
			var w_damage = 60
			var w_repeat = 0
			
			var r = rand_range(0,w_ondamage+w_damage)
			
			if r < w_ondamage:
				result = getOnDamage(power)
			elif r < w_damage+(w_ondamage):
				result = getDamage(power)
			elif r < w_repeat+(w_damage+w_ondamage):
				result = getRepeat(power)
			
	
	return result

func getDamage(power):
	var damage = ceil(rand_range(0,power))
	var dmg_gem = class_damage_gem.new()
	dmg_gem.damage = damage
	return dmg_gem

func getOnDamage(power):
	var damage = ceil(rand_range(0,ondamage_base/sqrt(power)))
	var dmg_gem = class_damage_gem.new()
	dmg_gem.damage = damage
	return dmg_gem

func getRepeat(power):
	var p_repeat = pow(base_repeat_inf,(1/power))
	var repeat = class_repeat_gem.new()
	var r
	
	r = rand_range(0,1)
	
	if r < p_repeat:
		repeat.repetitions = 0
	else:
		repeat.repetitions = max(1,round(getNormal(avg_repetitions,0.3,50)))
	
	repeat.freq = getGeometric(avg_repeat_freq)
	
	return repeat

# Mean value, the width of each uniform as a proportion of average and the number of uniforms to sum.
func getNormal(avg,w,us):
	# Normal is approximated as a sum of uniforms
	var sum = 0
	var ind_avg = float(avg) / float(us)
	var ind_w = ind_avg * float(w)
	
	for i in range(0,us):
		var nr = rand_range(ind_avg-ind_w,ind_avg+ind_w)
		sum = sum + nr
	
	return sum

# Mean value and number of geometrics to use
func getExponential(avg,gs):
	# Exponential is approximated as an average of geometric distributions (with the same parameters)
	var sum = 0
	var p = (1.0)/float(avg)
	
	for i in range(0,gs):
		var stop = false
		while !stop:
			var nr = rand_range(0,1)
			if nr < p:
				stop = true
			sum = sum + 1
	
	return sum

# Mean value
func getGeometric(avg):
	var n = 0
	var p = (1.0)/float(avg)
	
	var stop = false
	while !stop:
		var nr = rand_range(0,1)
		if nr < p:
			stop = true
		n = n + 1
	
	return n

func getRecContext(context):
	if context[0] == "head":
		return getRecContext(context[1])
	else:
		return context
