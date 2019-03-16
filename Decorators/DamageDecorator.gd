extends "res://EffectDecorator.gd"

const class_animation_effect = preload("res://Effects/AnimationEffect.gd")

func _init():
	._init()
	types = ["decorator","turnbased"]

var cur_strs = {}

func decorate(effect,element):
	if effect.hasType("damage"):
		#print("Damage dealt: " + str(effect.damage))
		var text = "-" + str(effect.damage)
		#var cur_str = cur_strs.get(element,"")
		var cur_str
		if cur_strs.has(element):
			cur_str = cur_strs[element]
		else:
			cur_str = ""
		cur_str = cur_str + text
		cur_strs[element] = cur_str
		
	return null

func runTurn():
	for element in cur_strs:
		var text = cur_strs[element]
		var animation = class_animation_effect.new()
		animation.node = element.battleground.get_node("/root/Root/damage_label").duplicate()
		animation.node.show()
		animation.node.get_node("damage_label_text").parse_bbcode(text)
		animation.animation = animation.node.get_node("damage_label_animation_player")
		animation.animation_name = "damage"
		
		element.battleground.addEffect(animation,element)
	
	cur_strs = {}