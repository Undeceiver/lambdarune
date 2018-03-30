extends Node

const class_effect = preload("Effect.gd")
const class_new_element = preload("Effects/NewElement.gd")
const class_element_removed = preload("Effects/ElementRemoved.gd")
const class_effect_added = preload("Effects/SubEffectAdded.gd")
const class_effect_removed = preload("Effects/SubEffectRemoved.gd")

var elements = []
var effects = []

var cur_actions = []
var next_actions = []
var in_process = false
var actions setget ,getActions

enum ActionType {INFORM_ADD_EFFECT, INFORM_REMOVE_EFFECT, ADD_EFFECT, REMOVE_EFFECT, ADD_ELEMENT, REMOVE_ELEMENT}

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func informAddEffect(effect):
	next_actions.append([INFORM_ADD_EFFECT,effect])

func informRemoveEffect(effect):
	next_actions.append([INFORM_REMOVE_EFFECT,effect])

func addEffect(effect, element):
	effect.element = element
	getActions().append([ADD_EFFECT,effect])

func removeEffect(effect):
	getActions().append([REMOVE_EFFECT,effect])

func addElement(element):
	element.battleground = self
	getActions().append([ADD_ELEMENT,element])

func removeElement(element):
	getActions().append([REMOVE_ELEMENT,element])

func getActions():
	if in_process:
		return cur_actions
	else:
		return next_actions

func processActions():
	cur_actions = next_actions
	next_actions = []
	in_process = true
	while cur_actions.size() > 0:
		var action = cur_actions.front()
		cur_actions.pop_front()
		if action[0] == INFORM_ADD_EFFECT:
			doInformAddEffect(action[1])
		elif action[0] == INFORM_REMOVE_EFFECT:
			doInformRemoveEffect(action[1])
		elif action[0] == ADD_EFFECT:
			doAddEffect(action[1])
		elif action[0] == REMOVE_EFFECT:
			doRemoveEffect(action[1])
		elif action[0] == ADD_ELEMENT:
			doAddElement(action[1])
		elif action[0] == REMOVE_ELEMENT:
			doRemoveElement(action[1])
	
	in_process = false

func processAllActions():
	while next_actions.size() > 0:
		processActions()

func getEffectListeners(effect):
	if effect.element == self:
		var result = []
		for other in self.effects:
			result.append(other)
		
		for element in self.elements:
			for effect in element.effects:
				result.append(effect)
		
		return result
	else:
		return effect.element.effects

func doInformAddEffect(effect):
	var listeners = getEffectListeners(effect)
	effect.myselfIn()
	for other in listeners:
		other.effectIn(effect)

func doInformRemoveEffect(effect):
	var listeners = getEffectListeners(effect)
	for other in listeners:
		other.effectOut(effect)
	effect.myselfOut()

func combinePermission(prev,new):
	if prev == class_effect.ALLOW:
		if new == class_effect.DENY:
			return class_effect.DENY
		elif new == class_effect.FORCE_ALLOW:
			return class_effect.FORCE_ALLOW
		elif new == class_effect.FORCE_DENY:
			return class_effect.FORCE_DENY
		else:
			return class_effect.ALLOW
	elif prev == class_effect.DENY:
		if new == class_effect.FORCE_ALLOW:
			return class_effect.FORCE_ALLOW
		elif new == class_effect.FORCE_DENY:
			return class_effect.FORCE_DENY
		else:
			return class_effect.DENY
	elif prev == class_effect.FORCE_ALLOW:
		return class_effect.FORCE_ALLOW
	elif prev == class_effect.FORCE_DENY:
		return class_effect.FORCE_DENY

func doAddEffect(effect):
	var listeners = getEffectListeners(effect)
	var permission = class_effect.ALLOW
	permission = combinePermission(permission,effect.mayIGoIn())
	for other in listeners:
		permission = combinePermission(permission,other.mayEffectGoIn(effect))
	
	if(permission == class_effect.DENY or permission == class_effect.FORCE_DENY):
		return
	
	for other in listeners:
		other.modifyIn(effect)
	
	if !(effect.isImmediate()):
		effect.element.effects.append(effect)
	
	# Only if it is on an element and not the battleground itself
	if effect.element != self:
		var effect_added_effect = class_effect_added.new()
		effect_added_effect.sub_effect = effect
		effect_added_effect.sub_element = effect.element
		addEffect(effect_added_effect,self)
	
	informAddEffect(effect)

func doRemoveEffect(effect):
	var listeners = getEffectListeners(effect)
	var permission = class_effect.ALLOW
	permission = combinePermission(permission,effect.mayIGoOut())
	for other in listeners:
		permission = combinePermission(permission,other.mayEffectGoOut())
	
	if(permission == class_effect.DENY or permission == class_effect.FORCE_DENY):
		return
	
	effect.element.effects.erase(effect)
	
	# Only if it is on an element and not the battleground itself
	if effect.element != self:
		var effect_removed_effect = class_effect_removed.new()
		effect_removed_effect.sub_effect = effect
		effect_removed_effect.sub_element = effect.element
		addEffect(effect_removed_effect,self)
	
	informRemoveEffect(effect)

func doAddElement(element):
	# Note: Maybe we would like to let effects deny the creation of an element.
	self.elements.append(element)
	var element_added_effect = class_new_element.new()
	element_added_effect.element_added = element
	addEffect(element_added_effect,self)

func doRemoveElement(element):	
	if self.elements.has(element):
		self.elements.erase(element)
		var element_removed_effect = class_element_removed.new()
		element_removed_effect.element_removed = element
		addEffect(element_removed_effect,self)

func findElements(effectType):
	var result = []
	for element in elements:
		var result_effects = element.findEffects(effectType)
		if !result_effects.empty():
			result.append([element,result_effects])
	
	return result