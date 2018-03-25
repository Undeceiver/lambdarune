extends "res://Elemental_Gem.gd"

var class_damage_effect = preload("res://Effects/DamageEffect.gd")

var damage

func express(arg):
	# For now, it ignores its argument.
	# Possible things it may do with the argument in the future are things like having damage types.
	var result = class_damage_effect.new()
	result.damage = damage
	return result

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func to_string():
	return "dmg"+String(damage)