extends Camera2D
class_name MainCamera

export var player_path : NodePath;

onready var player : Sprite = get_node(player_path);

onready var pos_x_offset : float = global_position.x - player.global_position.x;

func _process(_delta):
	position = Vector2(player.global_position.x + pos_x_offset, global_position.y);
