extends 'Gem.gd'

# THIS IS NOT WHAT WE ACTUALLY DO, BUT I SAVE IT BECAUSE IT IS A DECENT IDEA I MAY FALL BACK TO.
# Energy gems are used for two things. The "syntax" and the "semantics".
# In the syntax, they are used to control the depth of evaluation, using efficiency gems for runes.
# In the semantics, each elemental gem, when used, needs to have an energy rune associated, which controls its expression.
# This energy gem goes together with the elemental gem wherever the elemental gem ends up after evaluation, and this includes
# the filler gem.

# INSTEAD, WHAT WE DO IS TO HAVE ELEMENTAL GEMS HAVE PARAMETERS THEMSELVES.

# The arguments are effects, and returns an effect.
# Importantly, it may check the types of the arguments and do different things depending on their types.
func express(args):
	return null

func subst(rune, main_gem):
	return self

func to_string():
	return "E"