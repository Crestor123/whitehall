extends RayCast3D

func rotate_ray():
	target_position.z = get_parent().moveRange
	
	var vertices = PackedVector3Array()
	vertices.push_back(Vector3.ZERO)
	
	var nextAngle = 0
	var rayLength = 0
	
	for i in range (0, 360):
		#Rotate the raycast 360 degrees
		rotation_degrees.y = i
		force_raycast_update()
		
		if i != nextAngle: continue
		
		if is_colliding():
			#If there is a collision, rotate back until a corner is found
			while is_colliding():
				rotation_degrees.y -= 0.1
				force_raycast_update()
			rotation_degrees.y += 0.1
			force_raycast_update()
			rayLength = (get_collision_point() - global_transform.origin).length()
			vertices.push_back((Vector3(0, 0, rayLength).rotated(Vector3.UP, deg_to_rad(i))))
			force_raycast_update()
			
			#Find the other corner
			while is_colliding():
				rotation_degrees.y += 0.1
				force_raycast_update()
			rotation_degrees.y -= 0.1
			force_raycast_update()
			rayLength = (get_collision_point() - global_transform.origin).length()
			vertices.push_back((Vector3(0, 0, rayLength).rotated(Vector3.UP, deg_to_rad(i))))
			
			#Move the iterator to the next whole degree
			nextAngle = ceil(rotation_degrees.y)
			
		#If there is no collision, add a vertex at the end of the movement range
		else:
			vertices.push_back((Vector3(0, 0, (get_parent().moveRange)).rotated(Vector3.UP, deg_to_rad(i))))
			nextAngle += 1
		
	rotation_degrees.y = 0
	return vertices
