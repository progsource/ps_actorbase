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
extends "res://addons/ps_actorbase/ps_actorbase_actorcomponent.gd"
# Spritesheet2DComponent
# This component expects a texture with equaled sized frames


# This order of blend positions has to be the same order that you use in
# animation_nodes.
const BLEND_POSITIONS := [
  Vector2(0.0, 1.0), # down
  Vector2(-1.0, 0.0), # left
  Vector2(1.0, 0.0), # right
  Vector2(0.0, -1.0), # up
  ]


var texture : String = ""
var frame_size := Vector2.ZERO # number of frames, not size of a frame
var frame_time_distance := 0.0
var region_rect := Rect2(Vector2.ZERO, Vector2.ZERO)
var animations := {} # {"animatione_name":[1,0,1,2]} - numbers are the frame indices

# {"node_name":["anim_name_down", "anim_name_left", "anim_name_right", "anim_name_up"]}
# first node is start node
var animation_nodes := {}
var animation_transitions := {} # {"start_node_name" : ["target_node_name1", "target_node_name2"]}


var _sprite : Sprite = null
var _animation_player : AnimationPlayer = null
var _animation_tree : AnimationTree = null
var _state_machine : AnimationNodeStateMachinePlayback = null


func ready() -> void :
  _init_sprite()
  _init_animation_player()
  _init_animation_tree()

  # warning-ignore:return_value_discarded
  actor.connect("component_message_send", self, "_on_actor_component_message_send")


func process(_delta) -> void:
  var current_animation_node = _state_machine.get_current_node()
  _animation_tree.set("parameters/" + current_animation_node + "/blend_position", actor.direction)


func _on_actor_component_message_send(message_type, info) -> void :
  if message_type == "animation_state":
    var current_animation_node = _state_machine.get_current_node()

    if current_animation_node != info:
      _state_machine.travel(info)


func _init_sprite() -> void :
  assert(!texture.empty())
  assert(frame_size.x > 0)
  assert(frame_size.y > 0)
  assert(region_rect.size.x > 0)
  assert(region_rect.size.y > 0)

  _sprite = Sprite.new()
  _sprite.texture = load(texture)
  _sprite.region_enabled = true
  _sprite.region_rect = region_rect
  _sprite.hframes = frame_size.x
  _sprite.vframes = frame_size.y
#  _sprite.modulate.a = 0.5 # debug

  actor.add_child(_sprite)

func _init_animation_player() -> void :
  assert(_sprite)
  assert(frame_time_distance > 0)

  _animation_player = AnimationPlayer.new()

  for a in animations:
    var anim = _build_animation(a, animations[a])
    _animation_player.add_animation(a, anim)

  actor.add_child(_animation_player)

func _init_animation_tree() -> void :
  assert(_animation_player)

  _animation_tree = AnimationTree.new()
  _animation_tree.anim_player = _animation_player.get_path()

  var state_machine = _build_animation_state_machine()

  _animation_tree.tree_root = state_machine
  _animation_tree.active = true

  actor.add_child(_animation_tree)

  _state_machine = _animation_tree.get("parameters/playback")


func _build_animation(name : String, frames : Array) -> Animation :
  var anim := Animation.new()
  var track_index := anim.add_track(Animation.TYPE_VALUE)

  var sprite_node_path = str(_sprite.get_path()) + ":frame"

  anim.track_set_path(track_index, NodePath(sprite_node_path))
  anim.value_track_set_update_mode(track_index, Animation.UPDATE_TRIGGER)
  anim.loop = true
  anim.length = frames.size() * frame_time_distance

  var time = 0.0
  for frame in frames:
    anim.track_insert_key(track_index, time, frame)
    time += frame_time_distance

  return anim

func _build_animation_state_machine() -> AnimationNodeStateMachine :
  var state_machine = AnimationNodeStateMachine.new()

  for n in animation_nodes:
    var blend_node = _build_animation_node(n, animation_nodes[n])
    state_machine.add_node(n, blend_node)

    if state_machine.get_start_node().empty():
      state_machine.set_start_node(n)

  for from in animation_transitions:
    for to in animation_transitions[from]:
      var transition = AnimationNodeStateMachineTransition.new()
      state_machine.add_transition(from, to, transition)

  return state_machine

func _build_animation_node(name : String, blend_nodes : Array) -> AnimationNodeBlendSpace2D :
    assert(blend_nodes.size() == BLEND_POSITIONS.size())

    var node = AnimationNodeBlendSpace2D.new()
    node.blend_mode = AnimationNodeBlendSpace2D.BLEND_MODE_DISCRETE

    for i in range(blend_nodes.size()):
      var anim = AnimationNodeAnimation.new()
      anim.set_animation(blend_nodes[i])

      node.add_blend_point(anim, BLEND_POSITIONS[i])

    return node
