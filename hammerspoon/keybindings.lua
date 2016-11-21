local application = require "hs.application"
local eventtap = require "hs.eventtap"
local keycodes = require "hs.keycodes"
local hotkey = require "hs.hotkey"
local log = hs.logger.new("init", "debug")

local keyDown = eventtap.event.types.keyDown
local keyUp = eventtap.event.types.keyUp
local flagsChanged = eventtap.event.types.flagsChanged

hyper = hs.hotkey.modal.new({}, "F18")

local function pressedHyper()
   hyper.triggered = false
   hyper:enter()
   log.d("enter hyper mode")
end

local function releasedHyper()
   hyper:exit()
   log.d("leave hyper mode")
end

-- I have F19 bound to left ctrl key using Karabiner
hs.hotkey.bind({}, 'F19', pressedHyper, releasedHyper)

local emacsBlacklist = {
   'Emacs',
   'iTerm2'
}

local bindings = {
   w = {mods = {'ctrl'}, map = {{'alt'}, 'delete'}, emacsMode = true},
   a = {mods = {'ctrl'}, map = {{'cmd'}, 'left'}, emacsMode = true},
   e = {mods = {'ctrl'}, map = {{'cmd'}, 'right'}, emacsMode = true},
   f = {mods = {'alt'}, map = {{'alt'}, 'right'}, emacsMode = true},
   b = {mods = {'alt'}, map = {{'alt'}, 'left'}, emacsMode = true}
}
bindings[","] = {mods = {'ctrl'}, map = {{}, "-"}, emacsMode = false}
bindings["."] = {mods = {'ctrl'}, map = {{"shift"}, "-"}, emacsMode = false}

local function keyCode(key, modifiers)
  modifiers = modifiers or {}
  return function() hs.eventtap.keyStroke(modifiers, key) end
end

local function emacsModeEnabled()
   local app = application.frontmostApplication():title()
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
  local binding = bindings[key]
  if binding == nil then
     return false
  end
  if not checkFlagsWithModArray(flags, binding.mods) then
     return false
  end
  if binding.emacsMode and not emacsModeEnabled() then
     return false
  end
  local down = eventtap.event.newKeyEvent(binding.map[1], binding.map[2], true)
  return true, {down}
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
      if keyCode ~= oldKeyCode then
         pressed = false
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

local function oneTapKeyModifier(oldKeyName, newKeyMod)
   local oldKeyCode = keycodes.map[oldKeyName]
   local pressed = false
   local fired = false
   eventtap.new({keyDown, keyUp}, function(event)
      local keyCode = event:getKeyCode()
      local eventType = eventtap.event.types[event:getType()]
      if eventType == 'keyUp' then
         if keyCode ~= oldKeyCode then
            if pressed then
               return true, {}
            end
            return false
         end
         pressed = false
         if not fired then
            local down = eventtap.event.newKeyEvent({}, oldKeyName, true)
            local up = eventtap.event.newKeyEvent({}, oldKeyName, false)
            return true, {down, up}
         end
         return true, {}
      end
      if eventType == 'keyDown' then
         if keyCode == oldKeyCode then
            pressed = true
            fired = false
            return true, {}
         end
         if not pressed then
            return false
         end
         fired = true
         local down = eventtap.event.newKeyEvent(newKeyMod, keycodes.map[keyCode], true)
         return true, {down}
      end
      return false
   end):start()
end

oneTapKeyModifier("return", {'alt'})

return {
   hyper = hyper
}
