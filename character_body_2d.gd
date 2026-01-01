extends CharacterBody2D


const JUMP_VELOCITY = -1200.0
const alloted_jumps = 1
const default_speed = 700
var SPEED = default_speed
var last_direction = 1.0
var jumps = alloted_jumps
@export var PowerupX: Powerup
@export var PowerupB: Powerup

func _ready():
	pass
	

func wall_jump(speed, delta, dir):
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if dir == 1:
		if input_direction.angle() >= PI/2 or input_direction.angle() <= -PI/2:
			#If you jump towards the wall at any angle, then 
			input_direction = Vector2.from_angle(-PI/2)
			speed = speed/2
		if input_direction.angle() >= -PI/2 + .1 and input_direction.angle() <= -PI/4:
			#Its hard to jump near straight up it seems to stick towards up directly so im adding a buffer
			input_direction = Vector2.from_angle(-PI/4)
	else:
		if input_direction.angle() <= PI/2 and input_direction.angle() >= -PI/2:
			#If you jump towards the wall at any angle, then 
			input_direction = Vector2.from_angle(-PI/2)
			speed = speed/2
		if input_direction.angle() <= -PI/2 + .1 and input_direction.angle() >= -PI:
			#Its hard to jump near straight up it seems to stick towards up directly so im adding a buffer
			input_direction = Vector2.from_angle(-3*PI/4)
	
	var target_velocity = input_direction * (SPEED + 100) 
	velocity = velocity.lerp(target_velocity, speed * delta)

func slow():
	var debuff_timer = $DebuffTimer
	SPEED = 450
	debuff_timer.start(2.5)



func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("Joystick_Left", "Joystick_Right")
	#print(Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").angle())
	
	var wall_dir = get_wall_normal().x
	
	if not is_on_floor():
		velocity += get_gravity() * delta * 1.5
	
	if is_on_floor():
		jumps = alloted_jumps
		
	if not is_on_wall():
		$AnimatedSprite2D.play("default")
	elif is_on_wall() and not is_on_floor():
		if wall_dir == 1:
			$AnimatedSprite2D.play("on wall")
		elif wall_dir == -1:
			$AnimatedSprite2D.play("on wall rotated")
		
		
		
		
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
	
	if Input.is_action_just_pressed("B Button"):
		print("B Press")
		if PowerupB.has_method("use_power"):
			PowerupB.use_power(self)
	
	if Input.is_action_just_pressed("X Button"):
		print("X Press")
		if PowerupX.has_method("use_power"):
			PowerupX.use_power(self)
	
	if direction and not is_on_wall():
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	


func _on_debuff_timer_timeout() -> void:
	SPEED = default_speed
	jumps = alloted_jumps
