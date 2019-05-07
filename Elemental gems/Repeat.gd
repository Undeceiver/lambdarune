extends "res://Elemental_Gem.gd"

const class_repeat_effect = preload("res://Effects/RepeatEffect.gd")
const class_multieffect = preload("res://Effects/MultiEffect.gd")

var freq
var repetitions = 0

func express_elemental(args):
	var result = class_repeat_effect.new()
	var sub_effect = class_multieffect.new()
	for arg in args:
		sub_effect.effects.append(arg)
	
	result.sub_effect = sub_effect
	result.freq = freq
	result.repetitions = repetitions
	
	return result

func to_text_elemental(args):
	var result
	result = "\nrepeat every " + str(freq) + " turns"
	if repetitions > 0:
		result = result + " (to a maximum of " + str(repetitions) + " times)"
	result = result + ":"
	for arg in args:
		var sres = indent_all(arg)
		result = result + sres
	
	return result

func to_string():
	var result = "rep[" + str(freq)
	if repetitions > 0:
		result = result + ", " + str(repetitions)
	result = result + "]"
	
	return result