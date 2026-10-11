extends Area2D

@export var heat_restore := 25.0

func _on_body_entered(body):

	if body.name != "Player":
		return

	var main = get_tree().current_scene

	main.heat = max(main.heat - heat_restore, 0)

	main.get_node("DrinkSound").play()

	hide()
	$CollisionShape2D.set_deferred("disabled", true)

	await get_tree().create_timer(1.0).timeout
	main.get_node("DrinkSound").stop()
	queue_free()
