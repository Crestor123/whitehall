extends Node

#Contains the party member's stats, hp, level, etc.
#Initially set by accessing a resource
@export var statResource : Resource

@onready var abilities = $Abilities

var characterName : String = ""

var sprite : Texture2D = null

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

func _ready():
	setStats()


func setStats():
	#Set the party member's stats using the resource
	characterName = statResource.name
	sprite = statResource.sprite
	stats.maxhealth = statResource.health
	stats.health = statResource.health
	stats.mana = statResource.mana
	stats.strength = statResource.strength
	stats.dexterity = statResource.dexterity
	stats.constitution = statResource.constitution
	stats.intelligence = statResource.intelligence
	stats.wisdom = statResource.wisdom
	stats.charisma = statResource.charisma
