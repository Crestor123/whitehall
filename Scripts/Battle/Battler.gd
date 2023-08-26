extends Node3D

class_name Battler

#Contains the data used by a particular battler
@export var data : String
@export var abilityObject: PackedScene

@export var sprite : Texture2D
@export var battlerName : String

@onready var targetList = get_parent()
@onready var healthBar = $HealthBar
@onready var mesh = $CharacterBody3D/Pivot/MeshInstance3D

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
var buffSources = []

func _ready():
	if abilities == null:
		abilities = $Abilities

func initialize():
	if data:
		resource = load(data)
		battlerName = resource.name
		for ability in resource.abilities:
			var newAbility = abilityObject.instantiate()
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
		if resource.sprite != null:
			set_sprite(resource.sprite)
		for stat in resource.resistances:
			resistances[stat] = resource.resistances[stat]
		
	healthBar.updateBar(100 * (stats.health / stats.maxhealth))
	pass

func set_sprite(newSprite : Texture2D):
	mesh.mesh.material.albedo_color = Color.WHITE
	mesh.mesh.material.albedo_texture = newSprite

func setActive():
	print(self, "active")
	if stats.health <= 0:
		emit_signal("turnFinished")
	isActive = true
	if stats.health <= 0:
		return
	#For party members, need to wait for the player's selection of move
	#For enemies, need to select one of their moves
	if partyMember == false:
		var timer = Timer.new()
		#timer.connect("timeout",Callable(self,"turnTest"))
		timer.one_shot = true
		add_child(timer)
		timer.start()
		await timer.timeout
		if abilities.get_child_count() == 1:
			useAbility(abilities.get_child(0))
	stepBuff()
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
	if ability.name == "Defend": target = self
	if ability.type == "buff":
		addBuff(ability.attackName, ability.mainStat, damage, ability.element, ability.turns)
		pass
	if ability.type == "attack":
		if target == null:
			chooseTarget().takeDamage(damage, ability.element)
		else:
			target.takeDamage(damage, ability.element)
	
	if ability.additionalEffects.size() > 0:
		for effect in ability.additionalEffects:
			if effect == "resistances":
				for i in ability.additionalEffects[effect]:
					if i == "all":
						for j in resistances:
							addBuff(ability.attackName, j, ability.additionalEffects[effect][i], 
								ability.element, ability.turns)
					else: addBuff(ability.attackName, i, ability.additionalEffects[effect][i], 
						ability.element, ability.turns)
				
	emit_signal("turnFinished")
	isActive = false
	pass
	
#Positive values denote damage, and negative values are healing
func takeDamage(damage, element):
	if partyMember == true:
		print("Player taking ", damage, "damage")
	var damageValue = 0
	if damage > 0:
		damageValue = damage - ceil(float(damage * (float(resistances[element]) / 100)))
	else: damageValue = damage
	print(damageValue)
	stats.health -= damageValue
	if stats.health > stats.maxhealth:
		stats.health = stats.maxhealth
	if stats.health < 0:
		die()
	healthBar.updateBar(100 * (stats.health / stats.maxhealth))
	pass

func addBuff(source: String, stat : String, value : int, element : String, turns : int):
	#Add a persistent effect to the battler's list of buffs
	var exists = false
	for item in buffs:
		if item["source"] == source and item["stat"] == stat and item["element"] == element:
			item["turns"] == turns
			exists = true
	if exists == true: 
		print("found buff")
		return
	var buff = {"source": source, "stat": stat, "value": value, "element": element, "turns": turns}
	if stats.has(stat) and stat != "health":
		stats[stat] += value
	if resistances.has(stat):
		resistances[stat] += value
	buffs.append(buff)
	pass
	
func stepBuff():
	#Checks each buff and evaluates the effects 
	for i in buffs.size():
		var buff = buffs[i]
		buff["turns"] -= 1
		if buff["stat"] == "health":
			takeDamage(-buff["value"], buff["type"])
		if buff["turns"] <= 0:  #The buff has expired
			if stats.has(buff["stat"]) and buff["stat"] != "heatlh":
				stats[buff["stat"]] -= buff["value"]
			if resistances.has(buff["stat"]):
				resistances[buff["stat"]] -= buff["value"]
	
	var removedBuffs = buffs.duplicate()
	for buff in removedBuffs:
		if buff["turns"] <= 0:
			buffs.erase(buff)
	pass

func die():
	print(self, " dead")
	emit_signal("dead", self)
	if isActive == true:
		#emit_signal("turnFinished")
		isActive = false
	await(healthBar.updateBar(0))
	#get_parent().remove_child(self)
	queue_free()
	pass
