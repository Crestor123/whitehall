extends CanvasLayer

signal input

onready var attackButton = $MarginContainer/HBoxContainer/VBoxContainer/Button

func show(partyMember):
	attackButton.connect("pressed", self, "_on_Button_pressed", [partyMember.abilities.get_child(0)])
	for child in get_children():
		child.visible = true
	pass
	
func hide():
	for child in get_children():
		child.visible = false
	pass

func _on_Button_pressed(ability):
	emit_signal("input", ability)
	pass # Replace with function body.
