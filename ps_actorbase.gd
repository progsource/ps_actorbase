#Copyright © 2021 Petra Baranski (progsource)
#
#Permission is hereby granted, free of charge, to any person obtaining a copy of
#this software and associated documentation files (the “Software”), to deal in
#the Software without restriction, including without limitation the rights to
#use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
#of the Software, and to permit persons to whom the Software is furnished to do
#so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.
tool
extends EditorPlugin


const ps_ActorBaseDebugGlobal = preload("res://addons/ps_actorbase/editor/ps_actorbase_debug_global.gd")
const ps_ActorBaseDebugGlobal_name = "ps_ActorBaseDebugGlobal"


var _dock = null


func _enter_tree() -> void:
  _dock = preload("res://addons/ps_actorbase/editor/ps_actorbase_config.tscn").instance()
  add_control_to_bottom_panel(_dock, "ps ActorBase Config")

  var singleton = ps_ActorBaseDebugGlobal.new()
  singleton.name = ps_ActorBaseDebugGlobal_name

  get_tree().root.add_child(singleton)

  singleton.save_file()


func _exit_tree() -> void:
  if _dock != null:
    remove_control_from_bottom_panel(_dock)
    _dock.queue_free()

  if get_tree().root.has_node(ps_ActorBaseDebugGlobal_name):
    var singleton = get_tree().root.get_node(ps_ActorBaseDebugGlobal_name)
    if singleton:
      singleton.remove_file()
      singleton.queue_free()
