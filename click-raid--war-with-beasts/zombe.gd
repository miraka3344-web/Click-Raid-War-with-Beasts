extends CharacterBody2D

const SPEED = 100.0
var player: CharacterBody2D = null

func _ready():
	# Ищем игрока на сцене
	player = get_tree().current_scene.get_node_or_null("Player")

func _physics_process(_delta):
	if player:
		# Бежим к игроку
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * SPEED
		look_at(player.global_position)
		move_and_slide()

# Этот метод теперь вызывает пуля, когда врезается в Area2D или CharacterBody2D
func die():
	queue_free()
