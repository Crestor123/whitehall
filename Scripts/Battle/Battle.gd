extends Spatial

#Controls flow of battle
#Handles evaluating ability uses and updating UI
export(PackedScene) var battlerScene

onready var turnOrder = $TurnOrder
onready var UI = $UILayer

func initialize(party, enemies):
	#Populate the turn order with the list of battlers
	for member in party:
		var newBattler = battlerScene.instance()
		turnOrder.add_child(newBattler)
		newBattler.translation = Vector3(5 * turnOrder.get_child_count(), 2, 10)
		newBattler.abilities = member.abilities
		newBattler.stats = member.stats
		newBattler.partyMember = true
		newBattler.initialize()
		newBattler.connect("turnFinished", self, "turnFinished")
		
	for enemy in enemies:
		var newBattler = battlerScene.instance()
		turnOrder.add_child(newBattler)
		newBattler.translation = Vector3(-5 * (turnOrder.get_child_count() - party.size()), 2, 10)
		newBattler.data = enemy
		newBattler.initialize()
		newBattler.connect("turnFinished", self, "turnFinished")
		
	turnOrder.sortTurn()
	turnOrder.activeBattler.setActive()
	pass

func turnFinished():
	#Called when the current battler has finished its turn
	print("here")
	turnOrder.nextBattler()
	turnOrder.activeBattler.setActive()
	pass

func _ready():
	pass


func _on_Button_pressed():
	print("attack button pressed")
	pass # Replace with function body.
