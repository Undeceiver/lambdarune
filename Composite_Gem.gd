extends "Gem.gd"

var f
var x

const to_fill = 2.0
const class_rune = preload("Rune.gd")

func subst(rune, main_gem):
	var eval_f = f.subst(rune, main_gem)
	var eval_x = x.subst(rune, main_gem)
	
	var result = get_script().new()
	result.f = eval_f
	result.x = eval_x
	return result

func eval(energy, filler_gem):
	if energy < to_fill:
		#print("Filling")
		return filler_gem
	else:
		#print("Evaluating composite: " + self.to_string())
		var eval_f = f.eval(energy, filler_gem)
		var eval_x = x.eval(energy, filler_gem)
		var eval_f_s = eval_f.to_string()
		var eval_x_s = eval_x.to_string()
		
		# This is where the magic happens
		if eval_f extends class_rune:
			var result = eval_f.eval_rune(eval_x,energy,filler_gem)
			var result_s = result.to_string()
			#print("Result: " + result.to_string())
			return result
		else:
			var result = get_script().new()
			result.f = maybe_fill(eval_f, filler_gem)
			result.x = maybe_fill(eval_x, filler_gem)
			#print("Result: " + result.to_string())
			return result

func maybe_fill(gem, filler_gem):
	if gem extends class_rune:
		return filler_gem
	else:
		return gem

func to_string():
	return "("+f.to_string()+" "+x.to_string()+")"