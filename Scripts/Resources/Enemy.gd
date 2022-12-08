extends Resource

#Contains a given enemy's stats and abilities
class_name Enemy

export var name : String

export var health : int
export var mana : int
export var strength : int
export var dexterity : int
export var constitution : int
export var intelligence : int
export var wisdom : int
export var charisma : int

export(Array, Resource) var abilities
