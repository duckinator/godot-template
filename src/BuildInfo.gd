extends Node

var defaults = {
	"build_id": null,
	"build_hash": null,
	"cirrus_task_id": null,
}

onready var metadata = load_metadata()
onready var build_id = metadata.result["build_id"]
onready var build_hash = metadata.result["build_hash"]
onready var cirrus_task_id = metadata.result["cirrus_task_id"]

var source_url = null
var cirrus_url = null

func _ready():
	normalize_metadata()
	
	if cirrus_task_id != null:
		cirrus_url = "https://cirrus-ci.com/task/" + cirrus_task_id
		Console.log("Build logs: " + cirrus_url)
	
	#if build_id == null:
	#	Console.log("Build ID not found. This is expected for unofficial builds.")
	#else:
	#	Console.log("Build ID: " + build_id)
	
	if build_hash == null:
		Console.log("No build information is available. This usually means it's run from the editor.")
	else:
		source_url = "https://github.com/duckinator/keress/tree/" + build_hash
		Console.log("Source for this build: " + source_url)

func normalize_metadata():
	if build_id == "":
		build_id = null
		
	if build_hash == "":
		build_hash = null
	
	if cirrus_task_id == "":
		cirrus_task_id = null

func load_metadata():
	var path = "res://build_info.json"
	var file = File.new()
	
	if not file.file_exists(path):
		return defaults
	
	file.open(path, File.READ)
	var content = file.get_as_text()
	file.close()
	return JSON.parse(content)