extends Node2D

@onready var heat_bar = $UI/HeatBar
@onready var player = $Player

var heat = 0.0
var game_is_over = false
var in_shade = false
var game_started = false

var blink_timer = 0.0


func _ready():
	player.set_physics_process(false)


func _input(event):

	if !game_started and event is InputEventKey and event.pressed:

		game_started = true
		$UI/StartPanel.visible = false
		player.set_physics_process(true)


func _process(delta):

	if !game_started:

		blink_timer += delta

		if blink_timer >= 0.5:
			$UI/StartPanel/PressAnyKey.visible = !$UI/StartPanel/PressAnyKey.visible
			blink_timer = 0.0

		return



	if !game_is_over:

		if in_shade:
			if heat > 40:
				heat -= 3 * delta
		else:
			heat += 10 * delta

		heat = clamp(heat, 0, 100)
		heat_bar.value = heat

		if heat >= 100:
			game_over()

		var fill_style = heat_bar.get_theme_stylebox("fill").duplicate()

		if heat < 30:
			fill_style.bg_color = Color(0.2, 1.0, 0.2)
		elif heat < 60:
			fill_style.bg_color = Color(1.0, 1.0, 0.2)
		elif heat < 85:
			fill_style.bg_color = Color(1.0, 0.6, 0.1)
		else:
			fill_style.bg_color = Color(1.0, 0.1, 0.1)

		heat_bar.add_theme_stylebox_override("fill", fill_style)

	if game_is_over and Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()


func game_over(play_burn_sound := false):

	if game_is_over:
		return

	game_is_over = true

	if play_burn_sound:
		$BurnSound.play()
		call_deferred("_stop_burn_sound")

	$GameOverSound.play()
	call_deferred("_stop_game_over_sound")

	if is_instance_valid(player):
		player.velocity = Vector2.ZERO
		player.set_physics_process(false)

	$UI/DeathTitle.visible = true
	$UI/RestartLabel.visible = true


func _stop_game_over_sound():
	await get_tree().create_timer(3.0).timeout
	$GameOverSound.stop()


func _stop_burn_sound():
	await get_tree().create_timer(4.0).timeout
	$BurnSound.stop()


func win_game():

	if game_is_over:
		return

	game_is_over = true

	$WinSound.play()
	call_deferred("_stop_win_sound")

	if is_instance_valid(player):
		player.velocity = Vector2.ZERO
		player.set_physics_process(false)

	$UI/WinTitle.visible = true
	await get_tree().create_timer(3.0).timeout
	$UI/WinTitle.visible = false
	$UI/CreditsPanel.visible = true


func _stop_win_sound():
	await get_tree().create_timer(3.0).timeout
	$WinSound.stop()



func _on_lava_1_body_entered(body):
	if body.name == "Player":
		game_over(true)

func _on_lava_2_body_entered(body):
	if body.name == "Player":
		game_over(true)

func _on_lava_3_body_entered(body):
	if body.name == "Player":
		game_over(true)

func _on_lava_4_body_entered(body):
	if body.name == "Player":
		game_over(true)

func _on_lava_5_body_entered(body):
	if body.name == "Player":
		game_over(true)

func _on_lava_6_body_entered(body):
	if body.name == "Player":
		game_over(true)

func _on_lava_7_body_entered(body):
	if body.name == "Player":
		game_over(true)

func _on_lava_8_body_entered(body):
	if body.name == "Player":
		game_over(true)

func _on_lava_9_body_entered(body):
	if body.name == "Player":
		game_over(true)



func _on_shade_1_body_entered(body):
	if body.name == "Player":
		in_shade = true

		if !$BreathingSound.playing:
			$BreathingSound.play()


func _on_shade_1_body_exited(body):
	if body.name == "Player":
		in_shade = false
		$BreathingSound.stop()


func _on_shade_2_body_entered(body):
	if body.name == "Player":
		in_shade = true

		if !$BreathingSound.playing:
			$BreathingSound.play()


func _on_shade_2_body_exited(body):
	if body.name == "Player":
		in_shade = false
		$BreathingSound.stop()
