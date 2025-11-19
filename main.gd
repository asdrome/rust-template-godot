extends Node2D

@onready var player = $Player

func _ready() -> void:
	player.increase_speed(10.0)

func _on_player_speed_increased() -> void:
	print("Speed increased!")
	pass # Replace with function body.
