extends Spatial

class_name Battler

#Contains the data used by a particular battler
export var data : String
export(PackedScene) var abilityObject

onready var targetList = get_parent()
onready var healthBar = $HealthBar

var isActive = false
var partyMember = false

signal turnFinished

#For party members, this is set to point to their ability node
#For enemies, it points to this node's child
var abilities : Node
var resource : Resource

var stats = {
	"maxhealth": 0,
	"health": 0, 
	"mana": 0, 
	"strength": 0, 
	"dexterity": 0, 
	"constitution": 0, 
	"intelligence": 0,
	"wisdom": 0,
	"charisma": 0
	}

func _ready():
	if abilities == null:
		abilities = $Abilities

func initialize():
	if data:
		resource = load(data)
		for ability in resource.abilities:
			var newAbility = abilityObject.instance()
			newAbility.data = ability
			newAbility.initialize()
			abilities.add_child(newAbility)
		stats.maxhealth = resource.health
		stats.health = resource.health
		stats.mana = resource.mana
		stats.strength = resource.strength
		stats.dexterity = resource.dexterity
		stats.constitution = resource.constitution
		stats.intelligence = resource.intelligence
		stats.wisdom = resource.wisdom
		stats.charisma = resource.charisma
		
	healthBar.updateBar(100 * (stats.health / stats.maxhealth))
	pass

func setActive():
	print(self, "active")
	#For party members, need to wait for the player's selection of move
	#For enemies, need to select one of their moves
	if partyMember == false:
		var timer = Timer.new()
		timer.connect("timeout", self, "turnTest")
		timer.one_shot = true
		add_child(timer)
		timer.start()
	pass

func turnTest():
	emit_signal("turnFinished")

func chooseTarget():
	var target : Battler
	for child in targetList:
		if child != self:
			target = child
	return target
	pass

func useAbility(ability):
	emit_signal("turnFinished")
	pass
	
func takeDamage(damage):
	stats.health -= damage
	healthBar.updateBar(100 * (stats.health / stats.maxhealth))
	pass

func die():
	print(self, " dead")
	queue_free()
	pass
