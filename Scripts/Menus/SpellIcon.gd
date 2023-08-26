extends TextureRect

func _get_drag_data(at_position):
	var data = {}
	var drag_texture = TextureRect.new()
	drag_texture.expand = true
	drag_texture.texture = texture
	drag_texture.size = Vector2(64, 64)

	var preview = Control.new()
	preview.add_child(drag_texture)
	#print(-0.5 * drag_texture.size)
	drag_texture.position = -0.5 * drag_texture.size

	set_drag_preview(preview)
	return data
	pass

func _can_drop_data(at_position, data):
	return true
	return false
	pass

func _drop_data(at_position, data):
	pass
