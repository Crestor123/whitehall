extends MeshInstance3D

func _ready():
	visible = false
	pass

func generateZone(battler, enemy):
	mesh.clear_surfaces()
	visible = false
	#Sweep a raycast around the node to find any blockages, then draw a zone marking the movement range
	var raycast = battler.raycast

	#collisions contains a dictionary of the collided objects, the point, and angle in degrees
	var vertices = raycast.rotate_ray()
	
	#Generate the array mesh based on the collision dictionary
	#var vertices = PackedVector3Array()
	var colors = PackedColorArray()
	var array = []
	var index = PackedInt32Array()
	var normals = PackedVector3Array()
	var uvs = PackedVector2Array()
	var material = StandardMaterial3D.new()
	
	array.resize(Mesh.ARRAY_MAX)
	
	#for i in range(vertices.size()):
		#normals.push_back(vertices[i].normalized())
		#uvs.push_back(Vector2(vertices[i].x, vertices[i].z))
	#colors.push_back(Color.CORNFLOWER_BLUE)
	
	
	#for i in range(vertices.size()):
		#index.push_back(0)
		#index.push_back(i + 1)
		#if i == vertices.size() - 1:
			#index.push_back(1)
		#else: index.push_back(i + 2)
	
	
	for i in range(vertices.size(), 0, -1):
		index.push_back(0)
		index.push_back(i - 1)
		if i == 2:
			index.push_back(vertices.size() - 1)
		else: index.push_back(i - 2)

	#index.reverse()
	#vertices.reverse()
	
	material.transparency = true
	material.albedo_color = Color(Color.CORNFLOWER_BLUE, 0.1)
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	
	array[Mesh.ARRAY_VERTEX] = vertices
	array[Mesh.ARRAY_INDEX] = index
	#array[Mesh.ARRAY_NORMAL] = normals
	#array[Mesh.ARRAY_TEX_UV] = uvs
	#array[Mesh.ARRAY_COLOR] = colors
	
	#Create the mesh
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)
	mesh.surface_set_material(0, material)
	
	global_position = battler.global_position
	global_position.y -= 0.8
	visible = true
	#look_at(get_parent().camera.global_position)
	#look_at((Vector3.UP))
	rotation_degrees = (Vector3(0, 0, 0))
