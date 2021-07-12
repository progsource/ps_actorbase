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
# InputMoveComponent


func physics_process(_delta) -> void :
  var direction := _get_direction()
  direction = _normalize_diagonal_direction(direction)
  _apply_movement(direction)


func _get_direction() -> Vector2 :
  var direction: Vector2
  direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
  direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
  return direction

func _normalize_diagonal_direction(direction : Vector2) -> Vector2 :
  if abs(direction.x) == 1 and abs(direction.y) == 1:
    direction = direction.normalized()
  return direction

func _apply_movement(direction : Vector2) -> void :
  actor.velocity = actor.speed * direction

  if actor.velocity != Vector2.ZERO:
    actor.direction = direction
