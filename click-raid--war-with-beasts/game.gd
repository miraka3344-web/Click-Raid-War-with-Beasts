extends Node2D

@export var zombie_scene: PackedScene

func _on_spawn_timer_timeout():
	if zombie_scene:
		var zombie = zombie_scene.instantiate()
		
		# Выбираем случайную точку на созданной линии Path2D
		var zombie_spawn_location = $SpawnLocation
		zombie_spawn_location.progress_ratio = randf()
		
		# Задаем позицию зомби
		zombie.position = zombie_spawn_location.position
		add_child(zombie)
