extends MeshInstance3D

var collisions = []

func _ready():
	pass

func generateZone(battler, enemy):
	#Sweep a raycast around the node to find any blockages, then draw a zone marking the movement range
	var raycast = battler.raycast
	#raycast.enabled = true
	#raycast.target_position.z = battler.moveRange
	
	raycast.rotate_ray()
	
	#raycast.target_position = raycast.target_position.rotated(Vector3.UP, PI)
	#raycast.force_raycast_update()
	#if raycast.is_colliding():
		#var obj = raycast.get_collider()
		#print("raycast collision with ", obj)

	#raycast.set_rotation(Vector3.ZERO)
	#raycast.enabled = false
