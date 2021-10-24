extends Sprite

func _on_Area2D_area_shape_entered(area_id, area, area_shape, local_shape):
	print("goal");
	if area.is_in_group("Player"):
		get_parent().cur_level_completed();
