log('Enter Module => ' .. ...)

local specs = require('layout.specs')

local bling = require('module.bling')
local rubato = require('module.rubato') -- Totally optional, only required if you are using animations.

local screenWidth = screen.primary.geometry.width
local screenHeight = screen.primary.geometry.height

local height = screenHeight / 2
local width = screenWidth * 0.8
local posX = (screenWidth - width) / 2
local posY = specs.topPanel.height

-- These are example rubato tables. You can use one for just y, just x, or both.
-- The duration and easing is up to you. Please check out the rubato docs to learn more.
local anim_y = rubato.timed {
  pos = -height,
  rate = 60,
  easing = rubato.quadratic,
  intro = 0.1,
  duration = 0.3,
  awestore_compat = true -- This option must be set to true.
}

local anim_x = rubato.timed {
  pos = posX,
  rate = 60,
  easing = rubato.quadratic,
  intro = 0.1,
  duration = 0.3,
  awestore_compat = true -- This option must be set to true.
}

local term_scratch = bling.module.scratchpad {
  command                 = 'kitty --class spad', -- How to spawn the scratchpad
  rule                    = { instance = 'spad' }, -- The rule that the scratchpad will be searched by
  sticky                  = true, -- Whether the scratchpad should be sticky
  autoclose               = true, -- Whether it should hide itself when losing focus
  floating                = true, -- Whether it should be floating (MUST BE TRUE FOR ANIMATIONS)
  geometry                = { x = posX, y = posY, height = height, width = width }, -- The geometry in a floating state
  reapply                 = true, -- Whether all those properties should be reapplied on every new opening of the scratchpad (MUST BE TRUE FOR ANIMATIONS)
  dont_focus_before_close = true, -- When set to true, the scratchpad will be closed by the toggle function regardless of whether its focused or not. When set to false, the toggle function will first bring the scratchpad into focus and only close it on a second call
  rubato                  = { x = anim_x, y = anim_y } -- Optional. This is how you can pass in the rubato tables for animations. If you don't want animations, you can ignore this option.
}

return {
  quake = term_scratch
}
