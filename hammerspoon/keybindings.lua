local application = require "hs.application"
local eventtap = require "hs.eventtap"
local keycodes = require "hs.keycodes"
local hotkey = require "hs.hotkey"
local log = hs.logger.new("init", "debug")

local keyDown = eventtap.event.types.keyDown
local keyUp = eventtap.event.types.keyUp
local flagsChanged = eventtap.event.types.flagsChanged

local emacsBlacklist = {
   'Emacs',
   'iTerm2'
}

local emacsBindings = {
   w = {mods = {'ctrl'}, map = {{'alt'}, 'delete'}},
   a = {mods = {'ctrl'}, map = {{'cmd'}, 'left'}},
   e = {mods = {'ctrl'}, map = {{'cmd'}, 'right'}},
   f = {mods = {'alt'}, map = {{'alt'}, 'right'}},
   b = {mods = {'alt'}, map = {{'alt'}, 'left'}}
}

local function keyCode(key, modifiers)
  modifiers = modifiers or {}
  return function() hs.eventtap.keyStroke(modifiers, key) end
end

hotkey.bind({'ctrl'}, ',', keyCode('-'), nil, keyCode('-'))
hotkey.bind({'ctrl'}, '.', keyCode('-', {'shift'}), nil, keyCode('-', {'shift'}))

local function emacsModeEnabled()
   local app = application.frontmostApplication():title()
   log.d(app)
   for i, appName in ipairs(emacsBlacklist) do
      if appName == app then
         return false
      end
   end
   return true
end

local function checkFlagsWithModArray(flags, mods)
   local flagCount = 0
   for _ in pairs(flags) do flagCount = flagCount + 1 end
   if flagCount ~= #mods then
      return false
   end
   for i, mod in ipairs(mods) do
      if flags[mod] ~= true then
         return false
      end
   end
   return true
end

eventtap.new({keyDown}, function(event)
  local key = keycodes.map[event:getKeyCode()]
  local flags = event:getFlags()
  local binding = emacsBindings[key]
  if binding == nil then
     return false
  end
  if not checkFlagsWithModArray(flags, binding.mods) then
     return false
  end
  if not emacsModeEnabled() then
     return false
  end
  local down = eventtap.event.newKeyEvent(binding.map[1], binding.map[2], true)
  local up = eventtap.event.newKeyEvent(binding.map[1], binding.map[2], false)
  return true, {down, up}
end):start()

local leftShift = 56
local rightShift = 60
local ctrl = 59

local function eventHasMod(event, mod)
   return (event:getFlags()[mod] == true)
end

local keyToMod = {}
keyToMod[56] = 'shift'
keyToMod[60] = 'shift'
keyToMod[59] = 'ctrl'

local function oneTapMetaBinding(oldKeyCode, newKeyMod, newKeyCode)
   local pressed = false
   eventtap.new({keyDown, flagsChanged}, function(event)
      local keyCode = event:getKeyCode()
      local eventType = eventtap.event.types[event:getType()]
      if keyCode ~= oldKeyCode and pressed then
         pressed = false
      end
      return false
   end):start()
   eventtap.new({flagsChanged}, function(event)
      local keyCode = event:getKeyCode()
      if keyCode ~= oldKeyCode then
         return false
      end
      if eventHasMod(event, keyToMod[oldKeyCode]) then
         pressed = true
         return false
      end
      if not pressed then
         return false
      end
      -- If we reach here, the modifier key has been pressed and released without
      -- any other keys being pressed
      local down = eventtap.event.newKeyEvent(newKeyMod, newKeyCode, true)
      local up = eventtap.event.newKeyEvent(newKeyMod, newKeyCode, false)
      return true, {down, up}
   end):start()
end

oneTapMetaBinding(leftShift, {'shift'}, '9')
oneTapMetaBinding(rightShift, {'shift'}, '0')
oneTapMetaBinding(ctrl, {}, 'escape')
