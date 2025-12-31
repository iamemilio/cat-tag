extends CharacterBody2D

const SPEED = 700.0
const JUMP_VELOCITY = -1200.0
const alloted_jumps = 1
var last_direction = 1.0
var jumps = alloted_jumps

func _ready():
	pass
	

func wall_jump(speed, delta, dir):
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var decision_direction = input_direction.angle()
	if dir == 1:
		if input_direction.angle() >= PI/2 or input_direction.angle() <= -PI/2:
			#If you jump towards the wall at any angle, then 
			input_direction = Vector2.from_angle(-PI/2)
		if input_direction.angle() >= -PI/2 + .1 and input_direction.angle() <= -PI/4:
			#Its hard to jump near straight up it seems to stick towards up directly so im adding a buffer
			input_direction = Vector2.from_angle(-PI/4)
	else:
		if input_direction.angle() <= PI/2 and input_direction.angle() >= -PI/2:
			#If you jump towards the wall at any angle, then 
			input_direction = Vector2.from_angle(-PI/2)
		if input_direction.angle() <= -PI/2 + .1 and input_direction.angle() >= -PI:
			#Its hard to jump near straight up it seems to stick towards up directly so im adding a buffer
			input_direction = Vector2.from_angle(-3*PI/4)
	
	var target_velocity = input_direction * (SPEED + 100) 
	velocity = velocity.lerp(target_velocity, speed * delta)

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("Joystick_Left", "Joystick_Right")
	#print(Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").angle())
	
	var wall_dir = get_wall_normal().x
	
	if not is_on_floor():
		velocity += get_gravity() * delta * 1.5
	
	if is_on_floor():
		jumps = alloted_jumps
		
	if is_on_wall():
		if wall_dir == 1:
			$AnimatedSprite2D.play("on wall")
		elif wall_dir == -1:
			$AnimatedSprite2D.play("on wall rotated")
	else:
		$AnimatedSprite2D.play("default")
		
		
		
	# Handle jump and double jump
	if Input.is_action_just_pressed("A Button"):
		if is_on_floor() and not is_on_wall():
			velocity.y = JUMP_VELOCITY
		elif not is_on_floor() and jumps >0 and not is_on_wall():
			velocity.y = JUMP_VELOCITY + 200
			jumps = jumps - 1
		elif is_on_wall():
			jumps = min(jumps + 1, alloted_jumps)
			wall_jump(100,delta,get_wall_normal().x)
	
	
	if direction and not is_on_wall():
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	
