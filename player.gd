extends CharacterBody2D


const SPEED = 100.0
const ACCELERATION = 800.0
const FRICTION = 1000.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	apply_gravity(delta)

	# Handle jump.
	handle_jump()

	# Get the input direction and handle the movement/deceleration.
	var input_axis := Input.get_axis("ui_left", "ui_right")
	handle_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	update_animations(input_axis)
	move_and_slide()


func apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta


func handle_jump():
	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = JUMP_VELOCITY
	else:
		if Input.is_action_just_released("ui_accept") and velocity.y < JUMP_VELOCITY/2:
			velocity.y = JUMP_VELOCITY/2


func handle_acceleration(input_axis, delta):
	if input_axis:
		velocity.x = move_toward(velocity.x, SPEED * input_axis, ACCELERATION * delta)
		velocity.x = input_axis * SPEED


func apply_friction(input_axis, delta):
	if input_axis == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)


func update_animations(input_axis):
	if input_axis != 0:
		animated_sprite_2d.flip_h = (input_axis < 0)
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
	
	if not is_on_floor():
		animated_sprite_2d.play("jump")
