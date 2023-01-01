extends KinematicBody

export var speed = 14
export var fall_acceleration = 75

var velocity = Vector3.ZERO


func _physics_process(delta):
	
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.z += 1
	if Input.is_action_pressed("move_up"):
		direction.z -= 1
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity.y -= fall_acceleration * delta
	
	velocity = move_and_slide(velocity, Vector3.UP)
	
	for index in range(get_slide_count()):
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("entities"):
			print("collision")
			collision.collider.on_collide()
		
