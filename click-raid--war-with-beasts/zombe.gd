extends Node2D

@export var speed: float = 120.0
@export var max_health: int = 30
@export var damage_to_player: int = 20
@export var attack_rate: float = 1.5 # Как часто (в секундах) зомби будет кусать игрока

var current_health: int
var target_player: Node2D = null
var move_tween: Tween
var attack_timer: Timer

func _ready():
	current_health = max_health
	
	await get_tree().process_frame
	target_player = get_tree().current_scene.find_child("player", true, false)
	
	start_moving_to_player()

func start_moving_to_player():
	if target_player == null:
		return
		
	var distance = global_position.distance_to(target_player.global_position)
	var duration = distance / speed
	
	move_tween = create_tween()
	move_tween.tween_property(self, "global_position", target_player.global_position, duration)
	move_tween.finished.connect(_on_reached_player)

func _on_reached_player():
	# 1. Наносим первый урон сразу, как подошли вплотную
	attack_player()
	
	# 2. Запускаем бесконечный таймер укусов (функцию смерти die() отсюда убрали)
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_rate
	attack_timer.one_shot = false
	add_child(attack_timer)
	
	attack_timer.timeout.connect(attack_player)
	attack_timer.start()

func attack_player():
	# Наносим урон, если игрок еще жив
	if target_player and target_player.has_method("take_damage"):
		target_player.take_damage(damage_to_player)

func take_damage(amount: int):
	current_health -= amount
	print("Зомби получил урон! Осталось ХП: ", current_health)
	
	if current_health <= 0:
		die()

func die():
	# Безопасно уничтожаем Твин движения, если он еще активен
	if move_tween and move_tween.is_valid():
		move_tween.kill()
		
	# ИСПРАВЛЕНО: Безопасно останавливаем глобальный таймер укусов
	if is_instance_valid(attack_timer):
		attack_timer.stop()
		
	# Удаляем зомби со сцены (он умирает только от пули!)
	queue_free()
