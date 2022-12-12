extends CanvasLayer

signal input

export(PackedScene) var abilityButton

onready var abilityContainer = $MarginContainer/HBoxContainer/VBoxContainer

func show(partyMember):
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
	for child in abilityContainer.get_children():
		child.queue_free()
	for child in get_children():
		child.visible = false
	pass

func _on_Button_pressed(ability):
	emit_signal("input", ability)
	pass # Replace with function body.
