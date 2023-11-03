extends Node


func _create_outline_mesh():
	# get arguments
	var args: PackedStringArray = OS.get_cmdline_user_args()
	
	# pop first, that should be the offset amount param
	var offset = float(args[0])
	args = args.slice(1)
	
	# var args: Array[String] = ["E:/github/OpenAT/Model/FromScratch/tank_sample/Turret1.glb"]

	for _path in args:
		# extract name & path
		var delim = "/" if "/" in _path else "\\"
		var _name = _path.split(delim)[-1]
		var _parent = _path.replace(_name, "")
		
		# if _name.ends_with(".import"):
		# 	continue
		
		print("Creating outline mesh for " + _path)
		
		# prep gltf loader
		var gltf_state: GLTFState = GLTFState.new()
		var gltf_doc: GLTFDocument = GLTFDocument.new()
		
		# load resource and create outline mesh
		gltf_doc.append_from_file(_path, gltf_state)
		
		var mesh: Mesh = gltf_doc.generate_scene(gltf_state).get_child(0).mesh
		
		var root: MeshInstance3D = MeshInstance3D.new()
		root.name = _name.split(".")[0]
		root.mesh = mesh.create_outline(offset)
		
		var scene: PackedScene = PackedScene.new()
		scene.pack(root)
		
		gltf_state = GLTFState.new()
		gltf_doc = GLTFDocument.new()
		
		gltf_doc.append_from_scene(root, gltf_state)
		gltf_doc.write_to_filesystem(gltf_state, _parent + "_outline_" + _name)
		
		get_tree().quit()


func _ready():
	_create_outline_mesh()
