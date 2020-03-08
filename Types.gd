extends Node

class_name Types

# Basic type checking.
# We use a very simple approach.
# Types are lists, where the first element is always a string indicating what kind of element it is (a "head").
# A "var" head indicates a forall-quantified type variable. The second and only other element will be a string with the variable name.
# A "basic" head indicates a basic type. The second and only other element will be a string with the type name.
# A "func" head indicates a function type. The second element will indicate the argument type and the third element will indicate the result type.
# For now we do not produce higher-kinded types, but this should be straightforward to implement in this system.

# Note that these functions are unoptimized for now.

# Receives a list of pairs of types to unify, and a map from variables to terms (that should contain all variables, even if just assigned to themselves).
# Updates the map of variable values, and returns true if unification was possible, or false if it was not.
# Recursive
static func unify(constraints, variables):
	if constraints == []:
		return true
	else:
		var constraint1 = constraints.pop_front()
		var t1 = constraint1[0]
		var t2 = constraint1[1]
		
		var v1
		var v2
		var vv1
		var vv2
		var b1
		var b2
		var arg1
		var arg2
		var res1
		var res2
		var vars1
		var vars2
		
		if t1[0] == "var":
			v1 = t1[1]
			vv1 = variables[v1]
			if t2[0] == "var":
				v2 = t2[1]
				vv2 = variables[v2]
				# We put this as a special check before doing anything else because it's the easiest way. If they're already equivalent, leave as is.
				if applyBinding(variables,vv1) == applyBinding(variables,vv2):
					return unify(constraints,variables)
				if vv1 == ["var",v1]:
					if vv2 == ["var",v2]:
						return unifyPair(vv1,vv2,constraints,variables) and unify(constraints,variables)
					else:
						vars2 = findVariables(vv2,variables)
						if v1 in vars2:
							# Occurs check
							return false
						else:
							return unifyPair(vv1,vv2,constraints,variables) and unify(constraints,variables)
				else:
					if vv2 == ["var",v2]:
						vars1 = findVariables(vv1,variables)
						if v2 in vars1:
							# Occurs check
							return false
						else:
							return unifyPair(vv2,vv1,constraints,variables) and unify(constraints,variables)
					else:
						constraints.append([vv1,vv2])
						return unify(constraints,variables)
			elif t2[0] == "basic":
				b2 = t2[1]
				if vv1 == ["var",v1]:
					return unifyPair(vv1,t2,constraints,variables) and unify(constraints,variables)
				else:
					constraints.append([vv1,t2])
					return unify(constraints,variables)
			elif t2[0] == "func":
				arg2 = t2[1]
				res2 = t2[2]
				if vv1 == ["var",v1]:
					vars2 = findVariables(t2,variables)
					if v1 in vars2:
						# Occurs check
						return false
					else:
						return unifyPair(vv1,t2,constraints,variables) and unify(constraints,variables)
				else:
					constraints.append([vv1,t2])
					return unify(constraints,variables)
		elif t1[0] == "basic":
			b1 = t1[1]
			if t2[0] == "var":
				v2 = t2[1]
				vv2 = variables[v2]
				if vv2 == ["var",v2]:
					return unifyPair(vv2,t1,constraints,variables) and unify(constraints,variables)
				else:
					constraints.append([vv2,t1])
					return unify(constraints,variables)
			elif t2[0] == "basic":
				b2 = t2[1]
				return unifyPair(t1,t2,constraints,variables) and unify(constraints,variables)
			elif t2[0] == "func":
				arg2 = t2[1]
				res2 = t2[2]
				return false
		elif t1[0] == "func":
			arg1 = t1[1]
			res1 = t1[2]
			if t2[0] == "var":
				v2 = t2[1]
				vv2 = variables[v2]
				if vv2 == ["var",v2]:
					vars1 = findVariables(t1,variables)
					if v2 in vars1:
						# Occurs check
						return false
					else:
						return unifyPair(vv2,t1,constraints,variables) and unify(constraints,variables)
				else:
					constraints.append([vv2,t1])
					return unify(constraints,variables)
			elif t2[0] == "basic":
				b2 = t2[1]
				return false
			elif t2[0] == "func":
				arg2 = t2[1]
				res2 = t2[2]
				return unifyPair(t1,t2,constraints,variables) and unify(constraints,variables)


# This is mostly an internal utility function. Unifies a specific pair.
# It assumes an ordering between t1 and t2.
# It also assumes that variables have been checked against the map, so that if a free variable appears in t1 and t2, it is truly free.
static func unifyPair(t1, t2, constraints, variables):
	var v1
	var v2
	var b1
	var b2
	var arg1
	var arg2
	var res1
	var res2
	
	if t1[0] == "var":
		v1 = t1[1]
		if t2[0] == "var":
			v2 = t2[1]
			if v1 == v2:
				return true
			else:
				variables[v1] = ["var",v2]
				return true
		elif t2[0] == "basic":
			b2 = t2[1]
			variables[v1] = t2
			return true
		elif t2[0] == "func":
			arg2 = t2[1]
			res2 = t2[2]
			variables[v1] = ["func",arg2,res2]
			return true
	elif t1[0] == "basic":
		b1 = t1[1]
		if t2[0] == "basic":
			b2 = t2[1]
			if b1 == b2:
				return true
			else:
				return false
		elif t2[0] == "func":
			return false
	elif t1[0] == "func":
		arg1 = t1[1]
		res1 = t1[2]
		if t2[0] == "func":
			arg2 = t2[1]
			res2 = t2[2]
			constraints.append([arg1,arg2])
			constraints.append([res1,res2])
			return unify(constraints,variables)

# Utility for occurs checking. Returns all variables recursively appearing in the definition of a term
# IMPORTANT: It assumes that no cycles ever exist on the variables dictionary. Otherwise, it may loop indefinitely.
static func findVariables(t, variables):
	if t[0] == "var":
		var v = t[1]
		var vv = variables[v]
		if vv == ["var",v]:
				return [v]
		else:
			return findVariables(vv,variables) + [v]
	elif t[0] == "basic":
		return []
	elif t[0] == "func":
		var arg = t[1]
		var res = t[2]
		return findVariables(arg, variables) + findVariables(res, variables)
	else:
		print("Not a variable or basic or function!!!")
		return


# After unifying, find out the final value of a term (where all variables remaining in the return of this function are free).
static func applyBinding(variables, t):
	if t[0] == "var":
		var v = t[1]
		var vv = variables[v]
		if vv == ["var",v]:
			return ["var",v]
		else:
			return applyBinding(variables, vv)
	elif t[0] == "basic":
		return t
	elif t[0] == "func":
		var arg = t[1]
		var res = t[2]
		
		var rarg = applyBinding(variables,arg)
		var rres = applyBinding(variables,res)
		
		return ["func",rarg,rres]


static func getFreeVariable(variables):
	var i = 1
	var name = "autogen" + str(i)
	while variables.get(name) != null:
		i = i + 1
		name = "autogen" + str(i)
	
	variables[name] = ["var",name]
	return name


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
