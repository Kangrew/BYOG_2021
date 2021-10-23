extends Area2D

onready var blockSprite : Sprite = $Sprite;
onready var tween : Tween = $Tween;
onready var collisionShape : CollisionShape2D = $CollisionShape2D;

var HasTicket : bool = false;

func _ready():
	pass

func reset():
	HasTicket = false;
	pass

func _on_OneWay_area_shape_entered(area_id, area, area_shape, local_shape):
	if area.is_in_group("Player") and !HasTicket:
		var player : Player = area.get_parent();
		player.die();
		pass

func _on_OneWay_area_shape_exited(area_id, area, area_shape, local_shape):
	if area.is_in_group("Player"):
		HasTicket = false;
		pass
	pass

func _on_Entry_area_shape_entered(area_id, area, area_shape, local_shape):
	if area.is_in_group("Player"):
		HasTicket = true;
		pass
	pass # Replace with function body.

func _on_Entry_area_shape_exited(area_id, area, area_shape, local_shape):
	if area.is_in_group("Player") and HasTicket:
		HasTicket = false;
		pass
	pass # Replace with function body.
