extends "res://Effect.gd"

var types = ["alignment"]

var factions
var allies
var enemies

func isAlly(element):
	var alignments = element.findEffects("alignment")
	for alignment in alignments:
		for faction in alignment.factions:
			for ally in allies:
				if faction == ally:
					return true
	
	return false

func isEnemy(element):
	var alignments = element.findEffects("alignment")
	for alignment in alignments:
		for faction in alignment.factions:
			for enemy in enemies:
				if faction == enemy:
					return true
	
	return false

func cloneFields(other):
	factions = other.factions.duplicate()
	allies = other.factions.duplicate()
	enemies = other.factions.duplicate()