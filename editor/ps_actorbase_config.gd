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
extends Control
# psActorBaseConfig


func _ready() -> void:
  # warning-ignore:return_value_discarded
  $VBoxContainer/FeetColliderDebugDraw.connect("toggled", self, "_on_feet_collider_debug_draw_toggled")


func _on_feet_collider_debug_draw_toggled(value : bool) -> void:
  var debug_config_node_path = "ps_ActorBaseDebugGlobal"
  if get_tree().root.has_node(debug_config_node_path):
    var debug_config = get_tree().root.get_node(debug_config_node_path)
    debug_config.set_is_feet_collider_debug_draw_enabled(value)
