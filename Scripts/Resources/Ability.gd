extends Resource

class_name Ability

@export var name : String
@export var description : String

@export var type : String
@export var target : String

@export var mainStat : String
@export var cost : int = 0
@export var baseDamage : int
@export var multiplier : float
@export var turns : int = 0 

@export var element : String

@export var additionalEffects: Dictionary
