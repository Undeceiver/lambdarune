extends Gem

class_name Rune

var var_num = -1
var efficiency_gem
var body
const base = 2.0

func subst(rune, main_gem):
	var result = load(get_script().resource_path).new()
	var result_main_gem = Main_Gem.new()
	result_main_gem.gem_rune = result
	result.efficiency_gem = efficiency_gem 
	result.body = self.body.subst(rune,main_gem).subst(self,result_main_gem)
	return result

# main_gem indicates by which gem the main gem is to be replaced
# energy indicates the energy with which to evaluate the rune
# filler_gem is the filler gem
func eval_rune(main_gem, energy, filler_gem):
	#var energy_left = energy*efficiency_gem.efficiency
	var energy_left = pow(energy,1.0-log(base)/log(efficiency_gem.efficiency*base))
	#print("Evaluating rune: " + self.to_string())
	var eval_rune = self.subst(self,main_gem)
	var eval_rune_s = eval_rune.to_string()
	var result = eval_rune.body.eval(energy_left,filler_gem)
	#print("Result: " + result.to_string())
	return result

# Var num is ONLY used to pretty print. It may be changed at some point to make it better.
func getvarnum():
	if var_num == -1:
		var_num = floor(rand_range(1,500))
	return var_num

func to_string():	
	return "(\\"+String(getvarnum())+"("+String(efficiency_gem.efficiency)+")."+body.to_string()+")"

func to_text():
	return "Rune. This is meant for fully evaluated gems."

func getType(variables, runes):
	var tvar = Types.getFreeVariable(variables)
	runes[self] = tvar
	var tres = body.getType(variables, runes)
	
	return ["func", ["var", tvar], tres]
