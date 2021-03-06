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
extends Node


const config_file = "res://.ps_actorbase_config.json"


# default values of config should be set to live environment values
var config = {"is_feet_collider_debug_draw_enabled" : false}


func set_is_feet_collider_debug_draw_enabled(value : bool) -> void :
  config.is_feet_collider_debug_draw_enabled = value
  save_file()


func save_file() -> void :
  var file = File.new()
  var json = to_json(config)

  file.open(config_file, File.WRITE)
  file.store_string(json)
  file.close()


func read_file() -> void :
  if not OS.is_debug_build():
    return

  var dict := {}

  var file = File.new()

  var does_file_exist = file.file_exists(config_file)
  if not does_file_exist:
    return

  file.open(config_file, File.READ)
  var text = file.get_as_text()
  dict = parse_json(text)
  file.close()

  config = dict


func remove_file() -> void :
  var file = File.new()

  var does_file_exist = file.file_exists(config_file)
  if not does_file_exist:
    return

  var dir = Directory.new()
  dir.remove(config_file)
