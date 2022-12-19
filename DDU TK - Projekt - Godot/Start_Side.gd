extends Control

onready var logic = Button_Logic.new()

var login_side = 0

var current_question = 0
var current_test_array : Array = []

var selected_elev = null

func _ready():
	add_child(logic) 

func _process(_delta):
	$CanvasLayer2/TextureRect.rect_position = get_global_mouse_position()/100 - Vector2(60,60)
	
	if get_global_mouse_position().x <= 52 and $Side_bar.rect_position.x < 0 and $AnimationPlayer.current_animation != "Show":
		$AnimationPlayer.play("Show")
	elif get_global_mouse_position().x > 52 and $Side_bar.rect_position.x > -55 and $AnimationPlayer.current_animation != "Hide":
		$AnimationPlayer.play("Hide")


func go_to_tab(tab_value):
	
	
	for n in $TabContainer.get_child($TabContainer.current_tab).get_children():
		if n.is_class("VBoxContainer"):
			for h in n.get_children():
				if !h.is_class("AnimationPlayer"):
					logic.hide_anim(h)
		else:
			if !n.is_class("AnimationPlayer"):
				logic.hide_anim(n)
	yield(get_tree().create_timer(0.7),"timeout")

	
	match tab_value:
		2:
			for n in $TabContainer/Elev_Side/Panel2/ScrollContainer/VBoxContainer.get_children():
				#print(n)
				n.queue_free()

			var elev_tests = check_om_eleven_har_taget_testen(Data.current_user_id)
			
			Data.db.query("select * from elever")
			var elev_data = Data.db.query_result.duplicate()
			
			Data.db.query("select * from tildelt_test")
			var test_data = Data.db.query_result.duplicate()
			

			for n in test_data.size():

				
				if test_data[n]["klasseID"] == elev_data[Data.current_user_id]["klasseID"] and not elev_tests.has(n):
					var new_button = $TabContainer/Elev_Side/Button3.duplicate()
					new_button.modulate.a = 1
					$TabContainer/Elev_Side/Panel2/ScrollContainer/VBoxContainer.add_child(new_button)
					
					Data.db.query("select * from tests")
					var text
					for a in Data.db.query_result.size():
						text = (Data.db.query_result[a]["navn"])
					new_button.text = text
					new_button.connect("pressed",self,"start_test",[test_data[n]["testID"]])
		3:
			set_question()
		
		7:
			for n in $TabContainer/Rediger_Klasse_Valg/ScrollContainer/VBoxContainer.get_children():
				#print(n)
				n.queue_free()
				
			Data.db.query("select * from klasser")
			for n in Data.db.query_result.size():
				
				var new_button = $TabContainer/Rediger_Klasse_Valg/Button3.duplicate()
				new_button.modulate.a = 1
				$TabContainer/Rediger_Klasse_Valg/ScrollContainer/VBoxContainer.add_child(new_button)
				new_button.text = Data.db.query_result[n]["navn"]
				
				new_button.connect("pressed",self,"klasse_valg",[new_button.get_index() + 1])
		8:
			generate_elever()
		9:
			for n in $TabContainer/Fjern_Klasse/ScrollContainer/VBoxContainer.get_children():
				#print(n)
				n.queue_free()
				
			Data.db.query("select * from klasser")
			for n in Data.db.query_result.size():
				
				var new_button = $TabContainer/Fjern_Klasse/Button3.duplicate()
				new_button.modulate.a = 1
				$TabContainer/Fjern_Klasse/ScrollContainer/VBoxContainer.add_child(new_button)
				new_button.text = Data.db.query_result[n]["navn"]
				
				new_button.connect("pressed",self,"slet_klasse",[new_button.get_index() + 1])
		10:
			for n in $TabContainer/Tildel_test_klasse_valg/ScrollContainer/VBoxContainer.get_children():
				#print(n)
				n.queue_free()
				
			Data.db.query("select * from klasser")
			for n in Data.db.query_result.size():
				
				var new_button = $TabContainer/Tildel_test_klasse_valg/Button3.duplicate()
				new_button.modulate.a = 1
				$TabContainer/Tildel_test_klasse_valg/ScrollContainer/VBoxContainer.add_child(new_button)
				new_button.text = Data.db.query_result[n]["navn"]
				
				new_button.connect("pressed",self,"klasse_valg_test",[new_button.get_index() + 1])
		12:
			for n in $TabContainer/Tildel_test_valg/ScrollContainer/VBoxContainer.get_children():
				#print(n)
				n.queue_free()
				
			Data.db.query("select * from tests")
			for n in Data.db.query_result.size():
				
				var new_button = $TabContainer/Tildel_test_valg/Button3.duplicate()
				new_button.modulate.a = 1
				new_button.self_modulate.a = 1
				$TabContainer/Tildel_test_valg/ScrollContainer/VBoxContainer.add_child(new_button)
				new_button.text = Data.db.query_result[n]["navn"]
				#print(new_button)
				new_button.connect("pressed",self,"give_test",[new_button.get_index() + 1])
				
		14:
			var test_array = check_hvilke_tests_eleven_har_taget(Data.current_user_id).duplicate()
			
			print(test_array)
			
			for n in $TabContainer/Se_resultater/ScrollContainer/VBoxContainer.get_children():
				#print(n)
				n.queue_free()
				

			
			for n in test_array:
				
				
				
				var new_button = $TabContainer/Se_resultater/Button3.duplicate()

				$TabContainer/Se_resultater/ScrollContainer/VBoxContainer.add_child(new_button)

				#print(n)
				Data.db.query("select * from tests")
				var tests_data = Data.db.query_result.duplicate()
				
				Data.db.query("select * from TESTRESULTAT_" + str(n+1))
				
				
				#print(Data.db.query_result)
				#Data.db.query_result[Data.current_user_id]
				var data_1
				var data_2
				
				for a in Data.db.query_result.size():
					if Data.db.query_result[a]["elevID"] == Data.current_user_id:
						data_1 = Data.db.query_result[a]["resultat"]
						data_2 = Data.db.query_result[a]["karakter"]
				
				new_button.text = str(tests_data[n]["navn"]) + " | " + str(data_1) + " | " + str(data_2)
				#print(new_button.text)
		15:
			for n in $TabContainer/Se_resultater_elev_valg/ScrollContainer/VBoxContainer.get_children():
				#print(n)
				n.queue_free()
				
			Data.db.query("select * from Elever")
			for n in Data.db.query_result.size():
				
				var new_button = $TabContainer/Se_resultater_elev_valg/Button3.duplicate()
				new_button.modulate.a = 1
				new_button.self_modulate.a = 1
				$TabContainer/Se_resultater_elev_valg/ScrollContainer/VBoxContainer.add_child(new_button)
				new_button.text = Data.db.query_result[n]["navn"]
				#print(new_button)
				new_button.connect("pressed",self,"select_elev",[new_button.get_index()])
			
		16:
			var test_array = check_hvilke_tests_eleven_har_taget(selected_elev).duplicate()
			
			for n in $"TabContainer/Se_resultater_lære_elev/ScrollContainer/VBoxContainer".get_children():
				#print(n)
				n.queue_free()
				

			
			for n in test_array:
				
				
				
				var new_button = $"TabContainer/Se_resultater_lære_elev/Button3".duplicate()

				$"TabContainer/Se_resultater_lære_elev/ScrollContainer/VBoxContainer".add_child(new_button)

				#print(n)
				Data.db.query("select * from tests")
				var tests_data = Data.db.query_result.duplicate()
				
				Data.db.query("select * from TESTRESULTAT_" + str(n+1))
				
				
				#print(Data.db.query_result)
				#Data.db.query_result[Data.current_user_id]
				new_button.text = str(tests_data[n]["navn"]) + " | " + str(Data.db.query_result[selected_elev]["resultat"]) + " | " + str(Data.db.query_result[selected_elev]["karakter"])
				#print(new_button.text)


	$TabContainer.current_tab = tab_value
	for n in $TabContainer.get_child($TabContainer.current_tab).get_children():
		if !n.is_class("AnimationPlayer"):
			if n.is_class("VBoxContainer"):
				for h in n.get_children():

					if !h.is_class("AnimationPlayer"):
						logic.show_anim(h)
			else:
				if !n.is_class("AnimationPlayer"):
					logic.show_anim(n)
					
	#Extra Logic

func create_klasse():
	#Check om klassen eksistere
	Data.db.query("select * from klasser")
	var index = 0

	while index < Data.db.query_result.size():
		if Data.db.query_result[index]["navn"] == $TabContainer/Opret_Klasse_Side_1/CenterContainer/VBoxContainer/LineEdit.text:
			print("denne klasse findes allerede")
			return
			
		index += 1
	
	var klasse_dictionary : Dictionary = Dictionary()
	klasse_dictionary["navn"] = $TabContainer/Opret_Klasse_Side_1/CenterContainer/VBoxContainer/LineEdit.text
	Data.db.insert_row("klasser",klasse_dictionary)
	go_to_tab(5)

func go_to_login(value):
	login_side = value
	go_to_tab(1)

func generate_elever():
	for n in $TabContainer/Rediger_Klasser2/Panel3/Panel4/ScrollContainer/VBoxContainer.get_children():
		n.queue_free()
	for n in $TabContainer/Rediger_Klasser2/Panel/Panel5/ScrollContainer/VBoxContainer.get_children():
		n.queue_free()
	Data.db.query("select * from Elever")
	

	
	for n in Data.db.query_result.size():
		var new_button = $TabContainer/Rediger_Klasser2/Button3.duplicate()
		new_button.modulate.a = 1
		new_button.text = Data.db.query_result[n]["navn"]
		if Data.db.query_result[n]["klasseID"] == Data.selected_class_id:
			$TabContainer/Rediger_Klasser2/Panel3/Panel4/ScrollContainer/VBoxContainer.add_child(new_button)
			new_button.connect("pressed",self,"remove_elev",[n])
		else:
			$TabContainer/Rediger_Klasser2/Panel/Panel5/ScrollContainer/VBoxContainer.add_child(new_button)
			new_button.connect("pressed",self,"add_elev",[n])

func add_elev(id):
	Data.db.query("select * from Elever")
	Data.db.update_rows("Elever", "id = " + str(id), 
	{
		"id":id,
		"navn":Data.db.query_result[id]["navn"],
		"adgangskode":Data.db.query_result[id]["adgangskode"],
		"klasseID":Data.selected_class_id
	})
	generate_elever()
	
func remove_elev(id):
	Data.db.query("select * from Elever")
	Data.db.update_rows("Elever", "id = " + str(id), 
	{
		"id":id,
		"navn":Data.db.query_result[id]["navn"],
		"adgangskode":Data.db.query_result[id]["adgangskode"],
		"klasseID":null
	})
	generate_elever()

func go_back():
	go_to_tab(0)

func log_in_warning(text : String):

	match $TabContainer.current_tab:
		1:
			
			$TabContainer/Log_Ind/HBoxContainer/AnimationPlayer.stop(true)
			$TabContainer/Log_Ind/HBoxContainer/Label.text = text
			$TabContainer/Log_Ind/HBoxContainer/AnimationPlayer.play("warning")

func klasse_valg(value):
	Data.selected_class_id = value
	go_to_tab(8)
	
func klasse_valg_test(value):
	Data.selected_class_id = value
	$TabContainer/Laerer_Test_Muligheder/ColorRect/Label.text = "Opret/Fjern test for " + str(Data.db.query_result[value - 1]["navn"])
	go_to_tab(11)

func slet_klasse(value):
	Data.db.delete_rows("klasser", "ID = " + str(value))
	go_to_tab(9)

func give_test(value):
	Data.db.query("select * from tests")
	
	var dict : Dictionary = Dictionary()
	dict["testID"] = value
	dict["klasseID"] = Data.selected_class_id
	
	Data.db.insert_row("tildelt_test",dict)

func start_test(value):
	Data.current_test_id = value -1
	go_to_tab(3)

func set_question():
	$TabContainer/Elev_Test/Panel/Label.text = "Opgave " + str(current_question + 1)
	$TabContainer/Elev_Test/Label2.text = Data.test_data[Data.current_test_id]["Spørgsmål"][current_question]["Question"]
	$TabContainer/Elev_Test/Button3.disabled = false
	$TabContainer/Elev_Test/Button4.disabled = true
	$TabContainer/Elev_Test/Label.self_modulate.a = 0
	$TabContainer/Elev_Test/Button.text = ""

func next_question():
	if current_question + 1 < Data.test_data[Data.current_test_id]["Spørgsmål"].size():
		current_question += 1
		go_to_tab(3)
	else:
		show_result()

func show_result():
	var max_result = current_test_array.size()
	var amount_of_correct_questions = 0
	
	for n in current_test_array:
		if n == true:
			amount_of_correct_questions += 1
			
	$TabContainer/Test_resultat/VBoxContainer/Label.text = "Du svarede " + str(amount_of_correct_questions) + "/" + str(max_result) + " spørgsmål rigtigt"
	
	var procent_af_rigtige_svar = amount_of_correct_questions/max_result if amount_of_correct_questions != 0 else 0
	
	var karakter = get_grade(procent_af_rigtige_svar)
	
	$TabContainer/Test_resultat/VBoxContainer/Label2.text = "Din karakter er: " + str(karakter)
	
	var dict :Dictionary = Dictionary()
	
	dict["elevID"] = Data.current_user_id
	dict["resultat"] = str(amount_of_correct_questions) + "/" + str(max_result)
	dict["karakter"] = karakter
	
	Data.db.insert_row("TESTRESULTAT_" + str(Data.current_test_id + 1),dict)
	
	
	go_to_tab(13)

func get_grade(value):
	if value <= 25:
		return -3
	if value <= 50:
		return 0
	if value <= 60:
		return 02
	if value <= 70:
		return 4
	if value <= 80:
		return 7
	if value <= 90:
		return 10
	if value <= 100:
		return 12
	if value > 100:
		return 12
		

func answear_notif(text : String, correct : bool):
	$TabContainer/Elev_Test/Label.text = text
	if correct:
		$TabContainer/Elev_Test/AnimationPlayer.play("correct")
	else:
		$TabContainer/Elev_Test/AnimationPlayer.play("wrong")

func check_svar():
	if $TabContainer/Elev_Test/Button.text == "":
		answear_notif("Du skal skrive noget i tekstboksen",false)
		return
	
	
	if $TabContainer/Elev_Test/Button.text == Data.test_data[Data.current_test_id]["Spørgsmål"][current_question]["Svar"]:
		answear_notif("Korrekt", true)
		current_test_array.append(true)
	else:
		answear_notif("Forkert, svaret var: " + str(Data.test_data[Data.current_test_id]["Spørgsmål"][current_question]["Svar"]),false)
		current_test_array.append(false)
	
	$TabContainer/Elev_Test/Button3.disabled = true
	$TabContainer/Elev_Test/Button4.disabled = false

func check_om_eleven_har_taget_testen(id):
	Data.db.query("select * from sqlite_master where type = 'table' and name like 'TESTRESULTAT_%'")
	
	var result_1 = Data.db.query_result.duplicate()
	var return_array = []
	
	
	for n in result_1.size():
		Data.db.query("select * from TESTRESULTAT_" + str(n+1))
		for i in Data.db.query_result.size():
			if Data.db.query_result[i]["elevID"] == id:
				return_array.append(i)
		
	return return_array

func select_elev(id):
	selected_elev = id
	go_to_tab(16)

func check_hvilke_tests_eleven_har_taget(id : int):
	Data.db.query("select * from sqlite_master where type = 'table' and name like 'TESTRESULTAT_%'")
	
	var result_1 = Data.db.query_result.duplicate()
	var return_array = []

	
	for n in result_1.size():
		Data.db.query("select * from TESTRESULTAT_" + str(n+1))
		print(Data.db.query_result[0]["elevID"])
		print(id)
		if Data.db.query_result[0]["elevID"] == id:
			return_array.append(n)
		
	return return_array
		

func check_log_ind():
	if login_side == 0:
		Data.db.query("select * from Elever;")
	else:
		Data.db.query("select * from laerere;")
	
	#Check efter brugernavn
	var name_match = ""
	var index = 0
	while index < Data.db.query_result.size():
		if Data.db.query_result[index]["navn"] == $TabContainer/Log_Ind/HBoxContainer/Button.text:
			name_match = Data.db.query_result[index]["navn"]
			break
		index += 1
	if name_match == "":
		log_in_warning("Fejl: Brugernavnet findes ikke")
		return null
	#Check efter adgangskode

	if $TabContainer/Log_Ind/HBoxContainer/Button2.text != Data.db.query_result[index]["adgangskode"]:
		log_in_warning("Fejl: Adgangskoden er forkert")
	else:
		Data.current_user_id = index
		Data.current_user_type = login_side
		if login_side == 0:
			
			go_to_tab(2)
			$TabContainer/Elev_Side/ColorRect/Label.text = "Hej " + Data.db.query_result[index]["navn"]
			check_om_eleven_har_taget_testen(Data.current_user_id)
		else:
			go_to_tab(4)
			$TabContainer/Laerer_Side/ColorRect/Label.text = "Hej " + Data.db.query_result[index]["navn"]
