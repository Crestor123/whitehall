extends Node

#Contains the data for a given ability

export(Resource) var data = null

var attackName : String
var description : String
var type : String
var mainStat : String
var element : String
var cost : int
var baseDamage : int
var multiplier : float
var turns : int = 0

var additionalEffects : Dictionary

func initialize():
	#If the data resource is not null, set the script's variables to match it
	attackName = data.name
	description = data.description
	type = data.type
	mainStat = data.mainStat
	element = data.element
	cost = data.cost
	baseDamage = data.baseDamage
	multiplier = data.multiplier
	turns = data.turns
	additionalEffects = data.additionalEffects
	
func _ready():
	initialize()
