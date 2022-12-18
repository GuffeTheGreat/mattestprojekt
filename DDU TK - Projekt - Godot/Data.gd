extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")

var current_user_id = null
var current_user_type = null #0 = elev | 1 = lærer

var selected_class_id = null
var current_test_id = null

var test_data

var db : SQLite
var db_name = "res://DataBase/KlasseData.sqlite"

func _ready():
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	
	
	var f = File.new()
	f.open("res://JSON/test_data.json", File.READ)
	var json = f.get_as_text()
	test_data = parse_json(json)
