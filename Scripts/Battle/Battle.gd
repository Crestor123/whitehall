extends Spatial

#Controls flow of battle
#Handles evaluating ability uses and updating UI
export(PackedScene) var battlerScene

onready var turnOrder = $TurnOrder
onready var UI = $UILayer

var partyList = []
var enemyList = []

signal combatFinished

func _ready():
	pass

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
		newBattler.connect("dead", self, "battlerDead")
		partyList.append(newBattler)
		#newBattler.connect("turnFinished", self, "turnFinished")
		
	for enemy in enemies:
		var newBattler = battlerScene.instance()
		turnOrder.add_child(newBattler)
		newBattler.translation = Vector3(-5 * (turnOrder.get_child_count() - party.size()), 2, 10)
		newBattler.data = enemy
		newBattler.initialize()
		newBattler.connect("dead", self, "battlerDead")
		#newBattler.connect("turnFinished", self, "turnFinished")
		enemyList.append(newBattler)
		
	turnOrder.sortTurn()
	UI.initialize(partyList, enemyList)
	while(!enemyList.empty()):
		yield(startTurn(), "completed")
	pass

func startTurn():
	turnOrder.activeBattler.setActive()
	if turnOrder.activeBattler.partyMember == true:
		UI.show(turnOrder.activeBattler)
		UI.connect("input", turnOrder.activeBattler, "useAbility")
		yield(turnOrder.activeBattler, "turnFinished")
		UI.disconnect("input", turnOrder.activeBattler, "useAbility")
		#yield(UI, "input")
		UI.hide()
		turnFinished()
	else:
		UI.hide()
		yield(turnOrder.activeBattler, "turnFinished")
		turnFinished()
	pass

func battlerDead(battler : Battler):
	#Remove the battler from the turn order
	turnOrder.removeTurn(battler)
	if battler.partyMember == true:
		partyList.erase(battler)
	else: enemyList.erase(battler)
	
	if enemyList.empty() == true:
		#Won the battle, go back to previous scene
		emit_signal("combatFinished")
		pass
	if partyList.empty() == true:
		#Lost the battle
		pass
	pass

func turnFinished():
	#Called when the current battler has finished its turn
	#print("here")
	turnOrder.nextBattler()
	#startTurn()
	pass
