tool
extends Node

const images_path: String = "res://Images/"
const objects_path: String = "res://Objects/"

func load_files(path: String, ext: Array) -> Array:
	var rev_val: = []
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and \
			file_name.get_extension().to_lower() in ext:
				rev_val.append(file_name)
			file_name = dir.get_next()
	return rev_val

func find_object_by_texture_name(_name: String) -> String:
	var path: String = objects_path
	var names = load_files(objects_path, [])
	var dir = Directory.new()
	var dir_name: String
	var rev_val: = []
	var rev_names: = []
	if dir.open(path) == OK:
		dir.list_dir_begin()
		dir_name = dir.get_next()
		while dir_name != "":
			if dir.current_is_dir() and \
			dir_name.find(".") == -1 and \
			dir_name.get_extension().to_lower()  == "":
				var d = dir_name 
				d.erase(dir_name.length()-1, 1)
				if _name.find(d.to_lower()) != -1:
					break
			dir_name = dir.get_next()
		if dir.open(path+dir_name) == OK:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				if not dir.current_is_dir() and \
				file_name.get_extension().to_lower() == "tscn":
					rev_val.append(path+dir_name+"/"+file_name)
					file_name.erase(file_name.length()-5, 5)
					rev_names.append(file_name)
				file_name = dir.get_next()
	for i in rev_names.size():
		if rev_names[i].to_lower() == _name:
			return rev_val[i]
	print("Object not found")
	return ""

#func find(names: PoolStringArray, _name: String) -> int:
#	_name = _name.split(".")[0]
#	var sa = _name.split("_")
#	var name_without__: = ""
#	for s in sa:
#		name_without__ += s
#
#	for i in names.size():
#		var n = names[i].split(".")[0].to_lower()
#		var s = name_without__.split(n)
#
#	for i in names.size():
#		var n = names[i].split(".")[0].to_lower()
#		var s = name_without__.split(n)
#		var count: int = 0
#		for c in s.size():
#			if s[c] == "":
#				count += 1
#			else:
#				count = 0
#				continue
#			if count == s.size():
#				return i
#				break
#	return -1



