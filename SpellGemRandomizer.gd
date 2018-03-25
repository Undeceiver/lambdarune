extends "GemRandomizer.gd"

const class_damage_gem = preload("res://Elemental gems/Damage.gd")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func getRandomElementalGem(power):
	var damage = ceil(rand_range(0,power))
	var dmg_gem = class_damage_gem.new()
	dmg_gem.damage = damage
	return dmg_gem