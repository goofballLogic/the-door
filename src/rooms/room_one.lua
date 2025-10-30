local RoomBase = require("room_base")
local Player = require("player")
local Switch = require("switch")
local Door = require("door")
local event_bus = require("event_bus")
local collision = require("collision")

local RoomOne = setmetatable({}, { __index = RoomBase })

local player, door, switch
local walls = {}

local sub_id = nil

local function build_walls()
  walls = {
    { x = 32,  y = 64,  w = 416, h = 16 },
    { x = 32,  y = 240, w = 416, h = 16 },
    { x = 32,  y = 64,  w = 16,  h = 192 },
    { x = 432, y = 64,  w = 16,  h = 192 },
    -- platform for switch
    { x = 120, y = 176, w = 96,  h = 16 },
  }
end

function RoomOne.load()
  build_walls()
  player = Player.new(72, 128)
  switch = Switch.new(160, 160)
  door   = Door.new(360, 96, 16, 128)

  -- Listen for switch toggles
  sub_id = event_bus.on("switch:toggled", function(payload)
    if payload.state == "on" then
      door:setState("open")
    else
      door:setState("locked")
    end
  end)
end

function RoomOne.update(dt)
  -- Build colliders (door blocks only when locked)
  local colliders = {}
  for i=1,#walls do colliders[i] = walls[i] end
  if door.state == "locked" then table.insert(colliders, door) end

  player:update(dt, colliders)
  switch:update(dt, player)
  door:update(dt)
end

function RoomOne.draw()
  love.graphics.clear(0.09,0.1,0.12)

  -- walls
  love.graphics.setColor(0.2,0.22,0.26)
  for _,w in ipairs(walls) do love.graphics.rectangle("fill", w.x, w.y, w.w, w.h) end

  switch:draw()
  door:draw()
  player:draw()

  -- HUD
  love.graphics.setColor(1,1,1,0.85)
  love.graphics.print("Switch: "..switch.state.."   Door: "..door.state, 10, 28)
end

function RoomOne.keypressed(key)
  if key == "e" then
    switch:tryInteract(player)
  end
end

function RoomOne.teardown()
  if sub_id then event_bus.off(sub_id); sub_id = nil end
end

return RoomOne
