extends "res://Elemental_Gem.gd"

var class_damage_effect = preload("res://Effects/DamageEffect.gd")
var class_ondamage_effect = preload("res://Effects/OnDamageEffect.gd")
var class_multieffect = preload("res://Effects/MultiEffect.gd")

var damage

func express_elemental(args):
	var result
	if args.size() > 0:
		result = class_multieffect.new()
		result.effects = []
		for arg in args:
			var eff = class_ondamage_effect.new()
			eff.effect = arg
			eff.damage = damage
			result.effects.append(eff)
	else:
		result = class_damage_effect.new()
		result.damage = damage
	
	return result

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func to_string():
	return "dmg"+String(damage)