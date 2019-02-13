extends "res://EffectDecorator.gd"

const class_animation_effect = preload("res://Effects/AnimationEffect.gd")

func decorate(effect,parameters):
	# Assumed that effect is of type damage.
	#print("Damage dealt: " + str(effect.damage))
	var animation = class_animation_effect.new()
	animation.node = effect.element.battleground.get_node("/root/Root/damage_label").duplicate()
	animation.node.show()
	var text = "-" + str(effect.damage) + ""
	animation.node.get_node("damage_label_text").parse_bbcode(text)
	animation.animation = animation.node.get_node("damage_label_animation_player")
	animation.animation_name = "damage"
	
	return animation