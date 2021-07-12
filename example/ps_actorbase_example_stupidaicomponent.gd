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
# StupidAIComponent


var screen_size := Vector2.ZERO
var ai_size := Vector2.ZERO
var speed := 20.0


var _min_pos := Vector2.ZERO
var _max_pos := Vector2.ZERO
var _current_direction := Vector2.ZERO
var _rng : RandomNumberGenerator = null


func ready() -> void :
  assert(ai_size != Vector2.ZERO)

  _min_pos = ai_size
  _max_pos = screen_size - ai_size

  _rng = RandomNumberGenerator.new()
  _find_new_direction([-1.0, 0.0, 1.0], [-1.0, 0.0, 1.0])


func process(delta) -> void :
  actor.velocity = _current_direction * speed
  actor.direction = _current_direction

  var is_too_much_left = _current_direction.x + actor.position.x < _min_pos.x
  var is_too_much_right = _current_direction.x + actor.position.x > _max_pos.x

  var is_too_much_up = _current_direction.y + actor.position.y < _min_pos.y
  var is_too_much_down = _current_direction.y + actor.position.y > _max_pos.y

  if (is_too_much_left or is_too_much_right or is_too_much_down or is_too_much_up):
    var possible_x = [0.0]
    if not is_too_much_right:
      possible_x.append(1.0)
    if not is_too_much_left:
      possible_x.append(-1.0)

    var possible_y = [0.0]
    if not is_too_much_up:
      possible_y.append(-1.0)
    if not is_too_much_down:
      possible_y.append(1.0)

    _current_direction = Vector2.ZERO
    while(_current_direction == Vector2.ZERO):
      _find_new_direction(possible_x, possible_y)
    _current_direction = _normalize_diagonal_direction(_current_direction)


func _find_new_direction(possible_x : Array, possible_y : Array) -> void :
  var dir_x = _rng.randi_range(0, possible_x.size() - 1)
  var dir_y = _rng.randi_range(0, possible_y.size() - 1)
  _current_direction = Vector2(possible_x[dir_x], possible_y[dir_y])

func _normalize_diagonal_direction(direction : Vector2) -> Vector2 :
  if abs(direction.x) == 1 and abs(direction.y) == 1:
    direction = direction.normalized()
  return direction
