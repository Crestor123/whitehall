extends Node

@onready var activeBattler : Battler

func addTurn(battler : Battler):
	#Adds a node to the turn order
	pass
	
func removeTurn(battler : Battler):
	#Removes a node from the turn order
	var currentBattler = activeBattler
	#remove_child(battler)
	#sortTurn()
	#var nextBattlerIndex = (currentBattler.get_index() + 1) % get_child_count()
	#var nextBattlerIndex = currentBattler.get_index()
	activeBattler = get_child(currentBattler.get_index())
	if activeBattler == battler:
		activeBattler = get_child(currentBattler.get_index() + 1 % get_child_count())
	pass
	
func sortTurn():
	#Sorts the nodes in the turn order by dexterity
	var battlers = get_children()
	battlers.sort_custom(Callable(self,'sort'))
	for battler in battlers:
		#battler.raise()
		self.move_child(battler, 0)
	activeBattler = get_child(0)
	pass
	
func nextBattler():
	var done = false
	var i = 0
	for child in get_children():
		if child.stats.health <= 0:
			remove_child(child)
	while !done:
		i = i + 1
		var nextBattlerIndex: int = (activeBattler.get_index() + i) % get_child_count()
		activeBattler = get_child(nextBattlerIndex)
		if activeBattler.stats.health > 0: done = true
	#emit_signal('queue_changed', get_battlers(), active_battler)

static func sort(a : Battler, b : Battler):
	return a.stats.dexterity > b.stats.dexterity
