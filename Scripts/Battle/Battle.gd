extends Node3D

#Controls flow of battle
#Handles evaluating ability uses and updating UI
@export var battlerScene: PackedScene

@onready var turnOrder = $TurnOrder
@onready var UI = $UILayer
@onready var movementZone = $Movement
@onready var camera = $Camera3D
@onready var obstacles = $Obstacles

var partyList = []
var enemyList = []

signal combatFinished

func _ready():
	pass

func initialize(party, enemies):
	#Populate the turn order with the list of battlers
	
	#Set up a new battler for each party member
	for member in party:
		var newBattler = battlerScene.instantiate()
		turnOrder.add_child(newBattler)
		newBattler.position = Vector3(5 * turnOrder.get_child_count(), 2, 10)
		newBattler.abilities = member.abilities
		newBattler.stats = member.stats
		newBattler.battlerName = member.characterName
		newBattler.set_sprite(member.sprite)
		newBattler.partyMember = true
		newBattler.initialize()
		newBattler.connect("dead",Callable(self,"battlerDead"))
		partyList.append(newBattler)
		#newBattler.connect("turnFinished",Callable(self,"turnFinished"))
	
	#Set up a new battler for each enemy in the encounter
	for enemy in enemies:
		var newBattler = battlerScene.instantiate()
		turnOrder.add_child(newBattler)
		newBattler.position = Vector3(-5 * (turnOrder.get_child_count() - party.size()), 2, 10)
		newBattler.data = enemy
		newBattler.initialize()
		newBattler.connect("dead",Callable(self,"battlerDead"))
		#newBattler.connect("turnFinished",Callable(self,"turnFinished"))
		enemyList.append(newBattler)
		
	turnOrder.sortTurn()
	UI.initialize(partyList, enemyList)
	while(!enemyList.is_empty()):
		await startTurn()
		#await startTurn().completed
	pass

func startTurn():
	#Sets the current battler to be active, and waits for the battler to finish the turn
	await get_tree().create_timer(0.5).timeout
	turnOrder.activeBattler.setActive()
	movementZone.generateZone(turnOrder.activeBattler, enemyList[0])
	await get_tree().create_timer(0.2).timeout
	
	#If the battler is a party member, set up the UI for that battler
	if turnOrder.activeBattler.partyMember == true:
		UI.showUI(turnOrder.activeBattler)
		UI.connect("input",Callable(turnOrder.activeBattler,"useAbility"))
		await turnOrder.activeBattler.turnFinished
		UI.disconnect("input",Callable(turnOrder.activeBattler,"useAbility"))
		#await UI.input
		UI.hideUI()
		turnFinished()
	else:
		UI.hideUI()
		await turnOrder.activeBattler.turnFinished
		turnFinished()
	pass

func battlerDead(battler : Battler):
	#Remove the battler from the turn order
	turnOrder.removeTurn(battler)
	if battler.partyMember == true:
		partyList.erase(battler)
	else: enemyList.erase(battler)
	
	if enemyList.is_empty() == true:
		#Won the battle, go back to previous scene
		emit_signal("combatFinished")
		pass
	if partyList.is_empty() == true:
		#Lost the battle
		pass
	pass

func turnFinished():
	#Called when the current battler has finished its turn
	print("Turn Finished")
	turnOrder.nextBattler()
	#startTurn()
	pass
