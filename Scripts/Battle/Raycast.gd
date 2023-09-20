extends RayCast3D

func rotate_ray():
	target_position.z = get_parent().moveRange
	
	var collisions = []
	
	#print("raycast position: ", global_position)
	#print("raycast length: ", target_position.z)
	for i in range(0, 360):

		#Rotate the raycast 360 degrees, then record any collisions
		rotation_degrees = (Vector3(0, i, 0))
		force_raycast_update()
		if is_colliding():
			var entry = {
				"object": get_collider(),
				"point": get_collision_point(),
				"rotation": i
			}
			collisions.append(entry)
			#print("raycast collision with ", entry.object, " at ", entry.point)
	pass
	
	#Set the rotation back to zero
	rotation_degrees = Vector3.ZERO
	return collisions
