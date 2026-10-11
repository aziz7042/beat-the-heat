extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var footstep_sound = $FootstepSound

const SPEED = 250.0
const JUMP_VELOCITY = -450.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):

	if !is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$JumpSound.play()
		call_deferred("_stop_jump_sound")

	var direction = Input.get_axis("move_left", "move_right")
	
	if direction != 0 and is_on_floor():
		if !footstep_sound.playing:
			footstep_sound.play()
	else:
			footstep_sound.stop()

	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true

	if direction != 0:
		if sprite.animation != "walk":
			sprite.play("walk")

		velocity.x = direction * SPEED
	else:
		if sprite.animation != "idle":
			sprite.play("idle")

		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func _stop_jump_sound():
	await get_tree().create_timer(0.74).timeout
	$JumpSound.stop()
