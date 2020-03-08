extends Gem

class_name Composite_Gem

var f
var x

#var class_rune = load("res://Rune.gd")

const to_fill = 2.0

func subst(rune, main_gem):
	var eval_f = f.subst(rune, main_gem)
	var eval_x = x.subst(rune, main_gem)
	
	var result = load(get_script().resource_path).new()
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
		if eval_f is class_rune:
			var result = eval_f.eval_rune(eval_x,energy,filler_gem)
			var result_s = result.to_string()
			#print("Result: " + result.to_string())
			return result
		else:
			var result = load(get_script().resource_path).new()
			result.f = maybe_fill(eval_f, filler_gem)
			result.x = maybe_fill(eval_x, filler_gem)
			#print("Result: " + result.to_string())
			return result

func maybe_fill(gem, filler_gem):
	if gem is class_rune:
		return filler_gem
	else:
		return gem

func express():
	# Find the head and the arguments
	var to_express = head_and_args()

	# Express.
	var head = to_express[0]
	var args = to_express[1]
	
	return head.express_elemental(args)

func head_and_args():
	if f.directly_expressed():
		return [f,[x.express()]]
	else:
		var parc = f.head_and_args()
		var rf = parc[0]
		var args = parc[1]
		args.append(x.express())
		return [rf,args]

func to_text():
	# Find the head and the arguments
	var to_txt = head_and_args_text()
	
	# To text
	var head = to_txt[0]
	var args = to_txt[1]
	
	return head.to_text_elemental(args)

func head_and_args_text():
	if f.directly_expressed():
		return [f,[x.to_text()]]
	else:
		var parc = f.head_and_args_text()
		var rf = parc[0]
		var args = parc[1]
		args.append(x.to_text())
		return [rf,args]

func to_string():
	return "("+f.to_string()+" "+x.to_string()+")"

func getType(variables, runes):
	var real_head_t = f.getType(variables,runes)
	var real_arg_t = x.getType(variables,runes)
	
	if real_head_t == null or real_arg_t == null:
		return null
	
	var res_v = Types.getFreeVariable(variables)
	var to_unify = ["func",real_arg_t,["var",res_v]]
	
	if (!Types.unify([[to_unify,real_head_t]], variables)):
		return null
	else:
		return variables[res_v]
