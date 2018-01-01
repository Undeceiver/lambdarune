extends 'Gem.gd'

# Rune to which this main gem belongs
var gem_rune

func subst(rune, main_gem):
	if rune == self.gem_rune:
		return main_gem
	else:
		return self

func to_string():
	return String(gem_rune.getvarnum())