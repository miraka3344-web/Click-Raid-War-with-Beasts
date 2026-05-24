extends Node2D

# Указываем путь к сцене зомби, чтобы спавнить её копии.
# Замените путь ниже на ваш реальный путь к файлу зомби (tscn).
@export var zombie_scene: PackedScene = preload("res://Zombe.tscn")

@onready var spawn_timer = $SpawnTimer

func _ready():
	# Подключаем сигнал таймера timeout к нашей функции спавна
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)

func _on_spawn_timer_timeout():
	spawn_zombie()

func spawn_zombie():
	# 1. Создаем экземпляр (копию) зомби
	var new_zombie = zombie_scene.instantiate()
	
	# 2. Задаем ему позицию спавнера
	new_zombie.global_position = global_position
	
	# 3. Добавляем зомби на текущую сцену игры
	get_parent().add_child(new_zombie)
