extends Node

#Contains the party member's stats, hp, level, etc.
#Initially set by accessing a resource
export var statResource : Resource

onready var abilities = $Abilities

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
	setStats()


func setStats():
	#Set the party member's stats using the resource
	stats.maxhealth = statResource.health
	stats.health = statResource.health
	stats.mana = statResource.mana
	stats.strength = statResource.strength
	stats.dexterity = statResource.dexterity
	stats.constitution = statResource.constitution
	stats.intelligence = statResource.intelligence
	stats.wisdom = statResource.wisdom
	stats.charisma = statResource.charisma
