# rune indicates in the context of which rune the gem is being evaluated.
# main_gem indicates by which gem the main gem is to be replaced
func subst(rune, main_gem):
	return self

# # energy indicates the energy with which to evaluate the rune
# filler_gem is the filler gem
func eval(energy, filler_gem):
	return self

# There should only be elemental gems and composite gems left after evaluation. Find the head, find the arguments, 
# and express them in order.
func express():
	return null

func directly_expressed():
	return false

func to_string():
	return ""