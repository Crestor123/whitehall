extends Resource

#Contains a given enemy's stats and abilities
class_name Enemy

export var name : String
export(String, "fire", "light", "heat", "electricity", "earth", "metal", 
	"crystal", "wood", "air", "sound", "motion", "void", "water", "cold",
	"acid", "darkness", "mind", "soul", "flesh", "time") var type

export var health : int
export var mana : int
export var strength : int
export var dexterity : int
export var constitution : int
export var intelligence : int
export var wisdom : int
export var charisma : int

export(Array, Resource) var abilities

#The amount of damage of a given type that is ignored, as a percentage
export var resistances = {
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
