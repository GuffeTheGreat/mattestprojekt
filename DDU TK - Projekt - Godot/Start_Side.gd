extends Control

onready var logic = Button_Logic.new()

func _ready():
	add_child(logic)

func go_to_login():
	
	for n in $TabContainer/Log_Ind_valg/HBoxContainer.get_children():
		logic.hide_anim(n)
	yield(get_tree().create_timer(0.7),"timeout")
	$TabContainer.current_tab = 1
	for n in $TabContainer/Log_Ind/HBoxContainer.get_children():
		logic.show_anim(n)

func go_back():
	for n in $TabContainer.get_child($TabContainer.current_tab).get_children():
		if n.is_class("VBoxContainer"):
			for h in n.get_children():
				logic.hide_anim(h)
		else:
			logic.hide_anim(n)
	yield(get_tree().create_timer(0.7),"timeout")
	$TabContainer.current_tab -= 1
	for n in $TabContainer.get_child($TabContainer.current_tab).get_children():
		if n.is_class("VBoxContainer"):
			for h in n.get_children():
				logic.show_anim(h)
		else:
			logic.show_anim(n)
