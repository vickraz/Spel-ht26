extends Node2D


const PLAYER_SCENE = preload("res://Scenes/player.tscn")

@onready var player: Player = $Player
@onready var player_spawn_pos: Marker2D = $PlayerSpawnPos


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.connect("dead", _on_player_dead)


func _on_player_dead() -> void:
	player = PLAYER_SCENE.instantiate()
	player.connect("dead", _on_player_dead)
	player.global_position = player_spawn_pos.global_position
	add_child(player)
