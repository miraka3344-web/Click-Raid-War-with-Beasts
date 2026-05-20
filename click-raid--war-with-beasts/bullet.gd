extends Area2D

const SPEED = 600.0
var start_position: Vector2

func _ready():
	# Запоминаем точку, из которой пуля вылетела изначально
	start_position = global_position

func _physics_process(delta):
	# Пуля летит вперед
	position += Vector2.RIGHT.rotated(rotation) * SPEED * delta

func _on_body_entered(body):
	# Если попали в зомби, он умирает, а пуля исчезает
	if body.has_method("die"):
		body.die()
		queue_free() 

func _on_timer_timeout():
	# Прошло 2 секунды: возвращаем пулю на исходную позицию
	global_position = start_position
