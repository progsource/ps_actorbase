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
extends Node2D
# Actor


const ActorComponent = preload("res://addons/ps_actorbase/ps_actorbase_actorcomponent.gd")


var velocity := Vector2.ZERO setget _set_velocity, _get_velocity
var speed := 95.0 setget _set_speed, _get_speed
var direction := Vector2.ZERO setget _set_direction, _get_direction


var _logic_components := [] # like input/AI/...
var _physics_components := [] # handling velocity, speed, direction
var _graphics_components := [] # like sprites, animations, ...


func _ready() -> void :
  for c in _logic_components:
    c.ready()
  for c in _physics_components:
    c.ready()
  for c in _graphics_components:
    c.ready()


func _input(event) -> void :
  for c in _logic_components:
    c.input(event)
  for c in _physics_components:
    c.input(event)
  for c in _graphics_components:
    c.input(event)

func _process(delta) -> void :
  for c in _logic_components:
    c.process(delta)
  for c in _physics_components:
    c.process(delta)
  for c in _graphics_components:
    c.process(delta)

func _physics_process(delta) -> void :
  for c in _logic_components:
    c.physics_process(delta)
  for c in _physics_components:
    c.physics_process(delta)
  for c in _graphics_components:
    c.physics_process(delta)


func add_logic_component(component : ActorComponent) -> void :
  _logic_components.push_back(component)
  _init_component(component)

func add_physics_component(component : ActorComponent) -> void :
  _physics_components.push_back(component)
  _init_component(component)

func add_graphics_component(component : ActorComponent) -> void :
  _graphics_components.push_back(component)
  _init_component(component)

func _set_velocity(value : Vector2) -> void :
  velocity = value

func _get_velocity() -> Vector2 :
  return velocity

func _set_speed(value : float) -> void :
  speed = value

func _get_speed() -> float :
  return speed

func _set_direction(value : Vector2) -> void :
  direction = value

func _get_direction() -> Vector2 :
  return direction


func _init_component(component : ActorComponent) -> void :
  component.actor = self
  component.init()
