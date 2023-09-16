extends RayCast3D

func rotate_ray():
	target_position.z = get_parent().moveRange
	
	print("raycast position: ", global_position)
	print("raycast length: ", target_position.z)
	var i = 0 
	while i <= 360:
		#raycast.set_rotation_degrees(Vector3(0, 0, i))
		#target_position = target_position.rotated(Vector3.UP, i)
		rotation_degrees = (Vector3(0, i, 0))
		#print(raycast.target_position)
		force_raycast_update()
		if is_colliding():
			var obj = get_collider()
			print("raycast collision with ", obj)
		i += 1
	pass
	
	rotation_degrees = Vector3.ZERO
