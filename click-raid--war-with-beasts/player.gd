extends Node2D

@export var max_health: int = 100
var current_health: int

func _ready():
	current_health = max_health

func take_damage(amount: int):
	current_health -= amount
	print("Игроку нанесен урон! Текущее ХП: ", current_health)
	
	if current_health <= 0:
		die()

func die():
	print("Игрок погиб! Переход в главное меню...")
	
	# Мгновенно меняем текущую игровую сцену на сцену главного меню.
	# Убедитесь, что путь к файлу MainMenu.tscn указан верно!
	get_tree().change_scene_to_file("res://Death.tscn")
