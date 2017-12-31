extends 'Gem.gd'

const class_main_gem = preload("Main_Gem.gd")

var efficiency_gem
var body

func subst(rune, main_gem):
	var result = get_script().new()
	var result_main_gem = class_main_gem.new()
	result_main_gem.gem_rune = result
	result.efficiency_gem = efficiency_gem
	result.body = self.body.subst(rune,main_gem).subst(self,result_main_gem)
	return result

# main_gem indicates by which gem the main gem is to be replaced
# energy indicates the energy with which to evaluate the rune
# filler_gem is the filler gem
func eval_rune(main_gem, energy, filler_gem):
	var energy_left = energy*efficiency_gem.efficiency
	#print("Evaluating rune: " + self.to_string())
	var eval_rune = self.subst(self,main_gem)
	var result = eval_rune.body.eval(energy_left,filler_gem)
	#print("Result: " + result.to_string())
	return result

func to_string():
	return "(\\x."+body.to_string()+")"