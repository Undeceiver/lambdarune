extends Node

const class_rune = preload("Rune.gd")
const class_composite = preload("Composite_Gem.gd")
const class_main_gem = preload("Main_Gem.gd")
const class_efficiency_gem = preload("Efficiency_Gem.gd")

var end = ";"
var separator = " "
var abstraction = "\\"
var open = "("
var close = ")"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func read_gem(expr):
	var res = read_expression({},expr)
	return res[0]

# Returns an array of two elements. First one is the gem corresponding to the expression,
# the second one is the remnant of the string.
func read_expression(vars,expr):
	# Read first token
	var res = read_token(vars,expr)
	var rest = res[2]
	
	# If it is none, something went very wrong:
	if res[0] == "none":
		print("EMPTY EXPRESSION!!")
		return null
	# If it is an abstraction, we know what we are up for.
	elif res[0] == "abs":
		# Build the main gem.
		var rune = res[1][0]
		var name = res[1][1]
		var main_gem = class_main_gem.new()
		main_gem.gem_rune = rune
		
		# Add it to vars
		vars[name] = main_gem
		
		# Parse the efficiency
		res = read_efficiency(rest)
		rest = res[1]
		var efficiency = res[0]
		var eff_gem = class_efficiency_gem.new()
		eff_gem.efficiency = efficiency
		
		# Parse the body
		res = read_token(vars,rest)
		rest = res[2]
		# We assume it will be a subexpression. Anything else would be wrong.
		rune.efficiency_gem = eff_gem
		rune.body = res[1]
		
		return [rune,rest]
	else: # It may be a composite or a single gem.
		var first = res[1]
		res = read_token(vars,rest)
		rest = res[2]
		
		if res[0] == "none": # It was a single gem.
			return [first,rest]
		else: # Composite
			var composite = class_composite.new()
			composite.f = first
			composite.x = res[1]
			return  [composite,rest]

# Returns an array of three elements. First one indicates whether there is no next token ("none"), 
# it is an abstraction ("abs") or other kind of gem ("other")
# and second one is, in case of an abstraction, an array of two elements: the rune, and the variable name for parsing,
# or otherwise the token (a gem).
# The third one is the remnant of the string.
func read_token(vars,expr):
	var first = expr.left(1)
	var rest = expr.right(1)
	
	if first == end or first == close or first == separator:
		return ["none",null,rest]
	# If first is abstraction, then create a rune and return the main gem.
	elif first == abstraction:
		var var_name = ""
		first = rest.left(1)
		rest = rest.right(1)
		while first != end and first != close and first != separator:
			var_name = var_name + first
			first = rest.left(1)
			rest = rest.right(1)
		
		var rune = class_rune.new()
		# No efficiency or body yet.
		return ["abs",[rune,var_name],rest]
	elif first == open: # Subexpression
		var subexpr = read_expression(vars,rest)
		var subexpr_rest = subexpr[1]
		return ["other",subexpr[0],subexpr_rest.right(1)]
	else: # Variable or elemental gem
		var id = ""
		while (first != end and first != close and first != separator):
			id = id + first
			first = rest.left(1)
			rest = rest.right(1)
		
		# Try to find the id in the variables.
		if vars.has(id):
			# Then return the main gem.
			return ["other",vars[id],rest]
		else:
			# Else parse the elemental gem and return it.
			return ["other",read_elemental_gem(id),rest]

const class_dmg = preload("res://Elemental gems/Damage.gd")

func read_elemental_gem(id):
	if id.left(3) == "dmg":
		var gem = class_dmg.new()
		gem.damage = int(id.right(3))
		return gem

func read_efficiency(expr):
	var strn = ""
	var first = expr.left(1)
	var rest = expr.right(1)
	
	while first != end and first != close and first != separator:
		strn = strn + first
		first = rest.left(1)
		rest = rest.right(1)
	
	return [float(strn),rest]