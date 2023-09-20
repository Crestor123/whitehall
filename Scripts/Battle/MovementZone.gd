extends MeshInstance3D

func _ready():
	visible = false
	pass

func generateZone(battler, enemy):
	visible = false
	#Sweep a raycast around the node to find any blockages, then draw a zone marking the movement range
	var raycast = battler.raycast

	#collisions contains a dictionary of the collided objects, the point, and angle in degrees
	var collisions = raycast.rotate_ray()
	
	#Generate the array mesh based on the collision dictionary
	var vertices = PackedVector3Array()
	var colors = PackedColorArray()
	var array = []
	var index = PackedInt32Array()
	var normals = PackedVector3Array()
	var material = StandardMaterial3D.new()
	
	array.resize(Mesh.ARRAY_MAX)
	
	vertices.push_back(Vector3.ZERO)
	normals.push_back(Vector3(0, 1, 0))
	#colors.push_back(Color.CORNFLOWER_BLUE)
	for i in range(0, 360, 1):
		var collisionsAtAngle = []
		
		#Find any collisions that happened at the given angle
		for item in collisions:
			if item.rotation == i:
				collisionsAtAngle.append(item)
				
		#if collisionsAtAngle.is_empty(): 
		var vertex = Vector3.ZERO
		vertex += (Vector3(0, 0, battler.moveRange).rotated(Vector3.UP, deg_to_rad(i)))
		index.push_back(0)
		index.push_back(i + 1)
		if i == 359:
			index.push_back(1)
		else: index.push_back(i + 2)
			
		#vertices.push_back(Vector3(0, 1, battler.moveRange).rotated(Vector3.UP ,deg_to_rad(i)))
		
		vertices.push_back(vertex)
		normals.push_back(Vector3(0, 1, 0))
	
	#array[Mesh.ARRAY_VERTEX] = PackedVector3Array ([
		#Vector3(10, 0, 10),
		#Vector3(10, 0, 0),
		#Vector3(10, 10, 10)
	#])
	index.reverse()
	vertices.reverse()
	
	material.transparency = true
	material.albedo_color = Color(Color.CORNFLOWER_BLUE, 0.25)
	
	array[Mesh.ARRAY_VERTEX] = vertices
	array[Mesh.ARRAY_INDEX] = index
	#array[Mesh.ARRAY_COLOR] = colors
	
	#Create the mesh
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)
	mesh.surface_set_material(0, material)
	
	global_position = battler.global_position
	global_position.y -= 0.8
	visible = true
	#look_at(get_parent().camera.global_position)
	look_at((Vector3.UP))
	rotation_degrees.x = 180
	#rotation_degrees.y = 90
