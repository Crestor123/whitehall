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
signal dead

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
	
var resistances = {
	"fire": 0,
	"light": 0,
	"heat": 0,
	"electricity": 0,
	"earth": 0,
	"metal": 0,
	"crystal": 0,
	"wood": 0,
	"air": 0,
	"sound": 0,
	"motion": 0,
	"void": 0,
	"water": 0,
	"cold": 0,
	"acid": 0,
	"darkness": 0,
	"mind": 0,
	"soul": 0,
	"flesh": 0,
	"time": 0
}
	
var buffs = []

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
		for stat in resource.resistances:
			resistances[stat] = resource.resistances[stat]
		
	healthBar.updateBar(100 * (stats.health / stats.maxhealth))
	pass

func setActive():
	print(self, "active")
	#For party members, need to wait for the player's selection of move
	#For enemies, need to select one of their moves
	if partyMember == false:
		var timer = Timer.new()
		#timer.connect("timeout", self, "turnTest")
		timer.one_shot = true
		add_child(timer)
		timer.start()
		yield(timer, "timeout")
		if abilities.get_child_count() == 1:
			useAbility(abilities.get_child(0))
	pass

func turnTest():
	emit_signal("turnFinished")

func chooseTarget():
	var target : Battler
	for child in targetList.get_children():
		if child != self and child.partyMember == true:
			target = child
	return target
	pass

func useAbility(ability, target = null):
	var damage = stats[ability.mainStat] * ability.multiplier + ability.baseDamage
	if target == null:
		chooseTarget().takeDamage(damage, ability.type)
	else:
		target.takeDamage(damage, ability.type)
	emit_signal("turnFinished")
	pass
	
#Positive values denote damage, and negative values are healing
func takeDamage(damage, type):
	var damageValue = 0
	if damage > 0:
		damageValue = damage - int(float(damage * (float(resistances[type]) / 100)))
	else: damageValue = damage
	print(damageValue)
	stats.health -= damageValue
	if stats.health > stats.maxhealth:
		stats.health = stats.maxhealth
	if stats.health < 0:
		die()
	healthBar.updateBar(100 * (stats.health / stats.maxhealth))
	pass

func addBuff(stat : String, value : int, type : String, turns : int):
	#Add a persistent effect to the battler's list of buffs
	var buff = {"stat": stat, "value": value, "type": type, "turns": turns}
	if stat != "health":
		stats[stat] += value
	buffs.append(buff)
	pass
	
func stepBuff():
	#Checks each buff and evaluates the effects
	for buff in buffs:
		buff["turns"] -= 1
		if buff["stat"] == "health":
			takeDamage(-buff["value"], buff["type"])
		if buff["turns"] <= 0:  #The buff has expired
			if buff["stat"] != "heatlh":
				stats[buff["stat"]] -= buff["value"]
			buffs.erase(buff)
	pass

func die():
	print(self, " dead")
	emit_signal("dead", self)
	queue_free()
	pass
