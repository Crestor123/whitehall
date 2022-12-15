extends CanvasLayer

signal input

export(PackedScene) var abilityButton

onready var abilityContainer = $MarginContainer/HBoxContainer/VBoxContainer
onready var targetMarker = $Sprite3D

var enemyList = []
var partyList = []
var target = null
var targetIndex = 0

func initialize(party, enemies):
	#Create lists of the combatants sorted by position, so that the player can
	#select targets
	for member in party:
		partyList.append(member)
	partyList.sort_custom(self, "sort")
	
	for enemy in enemies:
		enemyList.append(enemy)
	enemyList.sort_custom(self, "sort")
	
	setTarget(enemyList[0])

static func sort(a : Battler, b : Battler):
	return a.global_transform.origin > b.global_transform.origin

func _input(event):
	if event.is_action_pressed("ui_right"):
		targetIndex = targetIndex - 1
		if targetIndex < 0:
			targetIndex = enemyList.size() - 1
	if event.is_action_pressed("ui_left"):
		targetIndex = targetIndex + 1
		if targetIndex > enemyList.size() - 1:
			targetIndex = 0
	setTarget(enemyList[targetIndex])

func setTarget(battler : Battler):
	target = battler
	if battler != null:
		targetMarker.global_transform.origin = battler.global_transform.origin
		targetMarker.translate(Vector3(0.05, 0.8, 0))
	pass

func show(partyMember):
	set_process(true)
	for child in partyMember.abilities.get_children():
		var newButton = abilityButton.instance()
		abilityContainer.add_child(newButton)
		newButton.text = child.attackName
		newButton.connect("pressed", self, "_on_Button_pressed", [child])
	#attackButton.connect("pressed", self, "_on_Button_pressed", [partyMember.abilities.get_child(0)])
	for child in get_children():
		child.visible = true
	pass
	
func hide():
	set_process(false)
	for child in abilityContainer.get_children():
		child.queue_free()
	for child in get_children():
		child.visible = false
	pass

func _on_Button_pressed(ability):
	emit_signal("input", ability, target)
	pass # Replace with function body.
