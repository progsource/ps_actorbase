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
# PhysicsMoveAndCollideComponent


var feet_collider = Rect2(0.0, 0.0, 0.0, 0.0)
var collision_layer := [] # list of layers the body shall be in (integers)
var collision_mask := [] # list of masks the body shall interact with (integers)


var _body : KinematicBody2D = null


func ready() -> void :
  _body = _build_kinematic_body()
  actor.add_child(_body)

func physics_process(_delta) -> void :
  _body.move_and_slide(actor.velocity)
  if _body.position != Vector2.ZERO:
    actor.position += _body.position
    _body.position = Vector2.ZERO


func _get_bits_combined(list : Array) -> int :
  var bits := 0

  for entry in list:
    bits += pow(2, entry)

  return bits

func _build_collision_shape() -> CollisionShape2D :
  var collision_shape = CollisionShape2D.new()
  var rect_shape = RectangleShape2D.new()
  rect_shape.extents = feet_collider.size * 0.5
  collision_shape.shape = rect_shape
  collision_shape.position = feet_collider.position
  return collision_shape

func _build_debug_color_rect() -> ColorRect :
  var color_rect_debug = ColorRect.new()
  color_rect_debug.rect_size = feet_collider.size
  color_rect_debug.rect_position = feet_collider.position
  color_rect_debug.color = Color.deeppink
  return color_rect_debug

func _build_kinematic_body() -> KinematicBody2D :
  var body = KinematicBody2D.new()

  var collision_shape = _build_collision_shape()

  if actor.debug_global != null && actor.debug_global.is_feet_collider_debug_draw_enabled:
    var color_rect_debug = _build_debug_color_rect()
    body.add_child(color_rect_debug)

  body.collision_layer = _get_bits_combined(collision_layer)
  body.collision_mask = _get_bits_combined(collision_mask)

  body.add_child(collision_shape)

  return body
