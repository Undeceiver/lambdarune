extends Gem

# THIS IS NOT WHAT WE ACTUALLY DO, BUT I SAVE IT BECAUSE IT IS A DECENT IDEA I MAY FALL BACK TO.
# Energy gems are used for two things. The "syntax" and the "semantics".
# In the syntax, they are used to control the depth of evaluation, using efficiency gems for runes.
# In the semantics, each elemental gem, when used, needs to have an energy rune associated, which controls its expression.
# This energy gem goes together with the elemental gem wherever the elemental gem ends up after evaluation, and this includes
# the filler gem.

# INSTEAD, WHAT WE DO IS TO HAVE ELEMENTAL GEMS HAVE PARAMETERS THEMSELVES.

# The arguments are effects, and returns an effect.
# Importantly, it may check the types of the arguments and do different things depending on its types.
func express_elemental(args):
	return null

func express():
	return express_elemental([])

func directly_expressed():
	return true

func subst(rune, main_gem):
	return self

func to_string():
	return "E"

func to_text():
	return to_text_elemental([])

func to_text_elemental(args):
	return "Unknown elemental gem"

# Specific for each elemental gem! Although they should generally not depend on runes at all, and on variables only to create new ones.
func getType(variables, runes):
	.getType(variables,runes)

