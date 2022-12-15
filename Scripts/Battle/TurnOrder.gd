extends Node

onready var activeBattler : Battler

func addTurn(battler : Battler):
	#Adds a node to the turn order
	pass
	
func removeTurn(battler : Battler):
	#Removes a node from the turn order
	var currentBattler = activeBattler
	remove_child(battler)
	sortTurn()
	var nextBattlerIndex = (currentBattler.get_index() + 1) % get_child_count()
	activeBattler = get_child(nextBattlerIndex)
	pass
	
func sortTurn():
	#Sorts the nodes in the turn order by dexterity
	var battlers = get_children()
	battlers.sort_custom(self, 'sort')
	for battler in battlers:
		battler.raise()
	activeBattler = get_child(0)
	pass
	
func nextBattler():
	var nextBattlerIndex: int = (activeBattler.get_index() + 1) % get_child_count()
	activeBattler = get_child(nextBattlerIndex)
	#emit_signal('queue_changed', get_battlers(), active_battler)

static func sort(a : Battler, b : Battler):
	return a.stats.dexterity > b.stats.dexterity
