extends CharacterBody3D

#Entities are objects in the overworld that do something when the player interacts with it

class_name Entity

@onready var collisionShape = $CollisionShape3D
@onready var global = get_tree().get_root().get_node("Main")

@export var data: Resource

signal collide(params)

var enemyParty = null
var collision = false

func _ready():
	if data == null:
		return
	if data.collide == false:
		collision.disable = true
	print("entity type is ", data.entityType)
	if data.entityType == "battle":
		print("here")
		enemyParty = data.enemyParty
		connect("collide",Callable(global,"start_combat").bind(self, enemyParty))

func on_collide():
	if collision == false:
		emit_signal("collide")
		collision = true
	pass
	
func _on_interact():
	pass
	
func move():
	pass
