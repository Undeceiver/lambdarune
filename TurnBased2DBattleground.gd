extends "res://2DBattleground.gd"

const class_tb2dbg_effect = preload("TurnBased2DBattlegroundEffect.gd")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here	
	._ready()
	var effect = class_tb2dbg_effect.new()	
	addEffect(effect,self)
	processAllActions()
