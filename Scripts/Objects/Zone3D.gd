extends Area3D

#A Node that marks the boundaries of an ability
@onready var mesh = $MeshInstance3D
@onready var collisionShape = $CollisionShape3D

var radius = 0
var color = Color.BLUE
var collisions = []

func _ready():
	mesh.mesh.top_radius = radius
	mesh.mesh.bottom_radius = radius
	collisionShape.shape.radius = radius

func initialize(newRadius : float, color):
	radius = newRadius
	mesh.mesh.top_radius = radius
	mesh.mesh.bottom_radius = radius
	collisionShape.shape.radius = radius
	
	mesh.mesh.material.albedo_color = color
	pass

func _on_body_entered(body):
	print("collided with ", body)
	collisions.append(body)

func _on_body_exited(body):
	print(body, " left the area")
	collisions.erase(body)
