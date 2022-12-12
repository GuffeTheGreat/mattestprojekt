extends Control
class_name Button_Logic

func show_anim(node : Control):
	node.modulate.a = 0
	node.rect_position.y += 10
	var tw = create_tween()
	
	tw.tween_interval(float(node.get_index())*0.1)
	tw.tween_property(node,"modulate:a",1.0,0.4)
	tw.set_ease(Tween.EASE_OUT)
	tw.set_trans(Tween.TRANS_QUINT)
	tw.parallel().tween_property(node,"rect_position:y",node.rect_position.y - 10,0.8)

func hide_anim(node : Control):
	var tw = create_tween()
	
	tw.tween_interval(float(node.get_index())*0.1)
	tw.set_ease(Tween.EASE_OUT)
	tw.set_trans(Tween.TRANS_QUINT)
	tw.tween_property(node,"modulate:a",0.0,0.4)
	tw.parallel().tween_property(node,"rect_position:y",node.rect_position.y - 10,0.8)
