extends Control

onready var logic = Button_Logic.new()

func _ready():
	add_child(logic) 

func _process(delta):
	if get_global_mouse_position().x <= 52 and $Side_bar.rect_position.x < 0 and $AnimationPlayer.current_animation != "Show":
		$AnimationPlayer.play("Show")
	elif get_global_mouse_position().x > 52 and $Side_bar.rect_position.x > -55 and $AnimationPlayer.current_animation != "Hide":
		$AnimationPlayer.play("Hide")

func go_to_tab(tab_value):
	
	for n in $TabContainer.get_child($TabContainer.current_tab).get_children():
		if n.is_class("VBoxContainer"):
			for h in n.get_children():
				logic.hide_anim(h)
		else:
			logic.hide_anim(n)
	yield(get_tree().create_timer(0.7),"timeout")
	$TabContainer.current_tab = tab_value
	for n in $TabContainer.get_child($TabContainer.current_tab).get_children():
		if n.is_class("VBoxContainer"):
			for h in n.get_children():
				logic.show_anim(h)
		else:
			logic.show_anim(n)

func go_back():
	go_to_tab(0)
