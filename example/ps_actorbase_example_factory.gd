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
extends Reference


const Actor = preload("res://addons/ps_actorbase/ps_actorbase_actor.gd")
const InputMoveComponent = preload("res://addons/ps_actorbase/components/ps_actorbase_inputmovecomponent.gd")
const PhysicsMoveAndCollideComponent = preload("res://addons/ps_actorbase/components/ps_actorbase_physicsmoveandcollidecomponent.gd")
const Spritesheet2DComponent = preload("res://addons/ps_actorbase/components/ps_actorbase_spritesheet2dcomponent.gd")

const UpdateSpritesheetComponent = preload("res://addons/ps_actorbase/example/ps_actorbase_example_updatespritesheetcomponent.gd")
const StupidAIComponent = preload("res://addons/ps_actorbase/example/ps_actorbase_example_stupidaicomponent.gd")

static func createPlayerExample32x64(pos : Vector2) -> Actor :
  var actor = Actor.new()

  actor.add_logic_component(InputMoveComponent.new())

  var physics_component = PhysicsMoveAndCollideComponent.new()
  physics_component.feet_collider = Rect2(-16, 22, 32, 10)
  physics_component.collision_layer = [1]
  physics_component.collision_mask = [1]

  actor.add_physics_component(physics_component)

  actor.add_graphics_component(UpdateSpritesheetComponent.new())

  var spritesheet_component = Spritesheet2DComponent.new()
  spritesheet_component.texture = "res://addons/ps_actorbase/example/char_32x64_template.png"
  spritesheet_component.frame_size = Vector2(6, 4)
  spritesheet_component.frame_time_distance = 0.2
  spritesheet_component.region_rect = Rect2(Vector2.ZERO, Vector2(192, 256))
  spritesheet_component.animations = {
    "idle_down": [1, 0, 1, 2],
    "idle_left" : [7, 6, 7, 8],
    "idle_right": [13, 12, 13, 14],
    "idle_up": [19, 18, 19, 20],
    "run_down": [4, 3, 4, 5],
    "run_left": [10, 9, 10, 11],
    "run_right": [16, 15, 16, 17],
    "run_up": [22, 21, 22, 23],
    }
  spritesheet_component.animation_nodes = {
    "idle": ["idle_down", "idle_left", "idle_right", "idle_up"],
    "run": ["run_down", "run_left", "run_right", "run_up"],
    }
  spritesheet_component.animation_transitions = {"idle": ["run"], "run": ["idle"]}

  actor.add_graphics_component(spritesheet_component)

  actor.position = pos
  actor.add_to_group("player")

  return actor


static func createAIExample32x32(pos : Vector2, screen_size : Vector2) -> Actor :
  var actor = Actor.new()

  var stupid_ai = StupidAIComponent.new()
  stupid_ai.screen_size = screen_size
  stupid_ai.ai_size = Vector2(32, 32)
  actor.add_logic_component(stupid_ai)

  var physics_component = PhysicsMoveAndCollideComponent.new()
  physics_component.feet_collider = Rect2(-16, 6, 32, 10)
  physics_component.collision_layer = [1]
  physics_component.collision_mask = [1]

  actor.add_physics_component(physics_component)

  var spritesheet_component = Spritesheet2DComponent.new()
  spritesheet_component.texture = "res://addons/ps_actorbase/example/char_32x32_template.png"
  spritesheet_component.frame_size = Vector2(3, 4)
  spritesheet_component.frame_time_distance = 0.2
  spritesheet_component.region_rect = Rect2(Vector2.ZERO, Vector2(96, 128))
  spritesheet_component.animations = {
    "idle_down": [1, 0, 1, 2],
    "idle_left" : [4, 3, 4, 5],
    "idle_right": [7, 6, 7, 8],
    "idle_up": [10, 9, 10, 11]
    }
  spritesheet_component.animation_nodes = {
    "idle": ["idle_down", "idle_left", "idle_right", "idle_up"]
    }
  spritesheet_component.animation_transitions = {}

  actor.add_graphics_component(spritesheet_component)

  actor.position = pos
  actor.add_to_group("ai")

  return actor
