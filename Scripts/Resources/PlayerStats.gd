extends Resource

class_name PlayerStats

@export var name : String

@export var health : int
@export var mana : int
@export var strength : int
@export var dexterity : int
@export var constitution : int
@export var intelligence : int
@export var wisdom : int
@export var charisma : int

@export var resistances = {
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
