-- src/entities/switch.lua
local event_bus = require("event_bus")

local Switch = {}
Switch.__index = Switch

local IMG_ON, IMG_OFF

function Switch.new(x, y)
  local self = setmetatable({}, Switch)
  self.x, self.y = x, y
  self.w, self.h = 16, 16
  self.state = "off"
  if not IMG_ON then
    IMG_ON  = love.graphics.newImage("assets/sprites/switch_on.png")
    IMG_OFF = love.graphics.newImage("assets/sprites/switch_off.png")
    IMG_ON:setFilter("nearest", "nearest")
    IMG_OFF:setFilter("nearest", "nearest")
  end
  return self
end

function Switch:tryInteract(player)
  local pad = 2
  local near = (player.x < self.x + self.w + pad) and (self.x - pad < player.x + player.w)
            and (player.y < self.y + self.h + pad) and (self.y - pad < player.y + player.h)
  if near then
    self.state = (self.state == "off") and "on" or "off"
    event_bus.emit("switch:toggled", { state = self.state })
  end
end

function Switch:update(dt, player) end

function Switch:draw()
  love.graphics.setColor(1,1,1,1)
  if self.state == "on" then
    love.graphics.draw(IMG_ON, self.x, self.y)
  else
    love.graphics.draw(IMG_OFF, self.x, self.y)
  end
end

return Switch
