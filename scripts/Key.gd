extends Area2D
onready var keySprite     = $Sprite;
onready var tween   = $Tween;

export var anim_duration : float = 0.5;
export var initialScale : float = 1;
export var finalScale : float = 0.7;

export var locks = [];

var isScalingUp : bool = false;

func _ready():
	scalingAnimation(initialScale, finalScale, anim_duration);
	pass

func _on_Area2D_area_shape_entered(area_id, area, area_shape, local_shape):
	if area.is_in_group("Player"):
		tween.stop_all();
		keySprite.scale = Vector2(0.7,0.7);
		unlockAllLock();

func _on_Key_area_shape_exited(area_id, area, area_shape, local_shape):
	if area.is_in_group("Player"):
		scalingAnimation(initialScale, finalScale, anim_duration);
		isScalingUp = true;
	pass

func _on_Tween_tween_completed(object, key):
	if isScalingUp == false:
		scalingAnimation(initialScale, finalScale, anim_duration);
		isScalingUp = true;
	else:
		scalingAnimation(finalScale, initialScale, anim_duration);
		isScalingUp = false;

func unlockAllLock():
	for i in locks.size():
		var lock : Lock = get_node(locks[i]);
		lock.unlock();
	pass

func scalingAnimation(scaleDown, scaleUp, seconds):
	tween.interpolate_property(keySprite, "scale", Vector2(scaleDown,scaleDown), Vector2(scaleUp,scaleUp), seconds, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT);
	tween.start()
	pass
