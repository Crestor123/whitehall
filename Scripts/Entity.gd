extends KinematicBody

#Entities are objects in the overworld that do something when the player interacts with it

class_name Entity

onready var collision = $CollisionShape
onready var global = get_tree().get_root().get_node("Main")

export(Resource) var data

signal collide(params)

var enemyParty = null
var collide = false

func _ready():
	if data == null:
		return
	if data.collide == false:
		collision.disable = true
	print("type is", data.entityType)
	if data.entityType == "battle":
		print("here")
		enemyParty = data.enemyParty
		connect("collide", global, "start_combat", [self, enemyParty])

func on_collide():
	if collide == false:
		emit_signal("collide")
		collide = true
	pass
	
func _on_interact():
	pass
	
func move():
	pass
