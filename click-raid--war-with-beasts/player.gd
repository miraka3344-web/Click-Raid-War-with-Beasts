extends CharacterBody2D
@export var bullet_scene: PackedScene
const SPEED = 200.0

func _physics_process(_delta):
	# Движение игрока
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * SPEED
	move_and_slide()


	# Стрельба на левую кнопку мыши
	if Input.is_action_just_pressed("click"):
		shoot()

func shoot():
	if bullet_scene:
		var bullet = bullet_scene.instantiate()
		bullet.global_position = $Weapon.global_position
		bullet.global_rotation = global_rotation
		get_tree().current_scene.add_child(bullet)
