extends "res://Effects/FindAndKillEffect.gd"

const class_move_effect = preload("res://Effects/MoveEffect.gd")
const class_damage_effect = preload("res://Effects/DamageEffect.gd")

# Very simple find and kill:
#	- Has a vision range, an attack range, a damage and a movement speed.
#	- Targets the closest enemy within vision range.
#	- Moves at its movement speed until it is in range (and stays at the limit of its range, with a 10% extra distance for errors).
#	- Attacks dealing a fixed amount of damage.

const range_epsilon = 1.1

var vision_range
var attack_range
var damage
var movement_speed

func cloneFields(other):
	.cloneFields(other)
	vision_range = other.vision_range
	attack_range = other.attack_range
	damage = other.damage
	movement_speed = other.movement_speed

# Return null if no target, or an element.
func findTarget():
	var alignments = element.findEffects("alignment")
	var cur_target = null
	var cur_dist = 999999999
	var my_position = element.findSingleEffect("position")
	
	if my_position == null:
		return null
	
	var battleground = element.battleground
	var possible_targets = battleground.findElements("alignment")
	for possible_target in possible_targets:
		var target = possible_target[0]
		var position = target.findSingleEffect("position")
		if position != null:
			var distance = my_position.distance(position)
			if distance < cur_dist:
				for alignment in alignments:
					if alignment.isEnemy(target):
						cur_target = target
						cur_dist = distance
	
	return cur_target

func inRange(element):
	var my_position = element.findSingleEffect("position")
	
	if my_position == null:
		return true
	
	var position = element.findSingleEffect("position")
	
	if position == null:
		return true
	
	var distance = my_position.distance(position)
	return (distance <= attack_range)

func moveTowards(element):
	var my_position = element.findSingleEffect("position")
	
	if my_position == null:
		return true
	
	var position = element.findSingleEffect("position")
	
	if position == null:
		return true
	
	var distance = my_position.distance(position)
	var scale = min(range_epsilon*distance, movement_speed)
	var movx = (position.x - my_position.x) * scale / distance
	var movy = (position.y - my_position.y) * scale / distance
	
	var movement = class_move_effect.new()
	movement.x = my_position.x + movx
	movement.y = my_position.y + movy
	
	element.battleground.addEffect(movement,element)

func attack(element):
	var damage_eff = class_damage_effect.new()
	damage_eff.damage = damage
	
	element.battleground.addEffect(damage_eff,element)
