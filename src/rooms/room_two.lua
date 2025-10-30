-- src/rooms/room_two.lua
local RoomBase   = require("room_base")
local Player     = require("player")
local Switch     = require("switch")
local Door       = require("door")
local event_bus  = require("event_bus")
local collision  = require("collision")
local room_mgr   = require("room_manager")

print("loading src/rooms/room_two.lua")

local RoomTwo = setmetatable({}, { __index = RoomBase })

local player, door, switches
local walls = {}
local sub_id

-- Require both switches ON to open door
local required_ids = { "A", "B" }
local sw_state = {}
local on_count = 0

local function build_walls()
  walls = {
    { x = 32,  y = 64,  w = 416, h = 16 },
    { x = 32,  y = 240, w = 416, h = 16 },
    { x = 32,  y = 64,  w = 16,  h = 192 },
    { x = 432, y = 64,  w = 16,  h = 192 },

    -- two platforms for the two switches
    { x = 96,  y = 176, w = 88,  h = 16 },
    { x = 264, y = 144, w = 88,  h = 16 },
  }
end

local function all_required_on()
  return on_count == #required_ids
end

local function set_switch_state(id, new_state)
  local old = sw_state[id]
  if old == new_state then return end
  if old == "on" then on_count = on_count - 1 end
  if new_state == "on" then on_count = on_count + 1 end
  sw_state[id] = new_state
end

function RoomTwo.load()
  build_walls()
  player = Player.new(72, 128)

  -- Two switches with IDs; place them on their platforms
  switches = {
    Switch.new("A", 128, 160),  
    Switch.new("B", 296, 128), 
  }

  on_count = 0
  for _, id in ipairs(required_ids) do sw_state[id] = "off" end

  door = Door.new(360, 96, 16, 128)

  -- Listen for switch toggles
  sub_id = event_bus.on("switch:toggled", function(payload)
    -- only track required IDs
    for _, id in ipairs(required_ids) do
      if payload.id == id then
        set_switch_state(payload.id, payload.state)
        if all_required_on() then door:setState("open") else door:setState("locked") end
        break
      end
    end
  end)
end

function RoomTwo.update(dt)
  local colliders = {}
  for i=1,#walls do colliders[i] = walls[i] end
  if door.state == "locked" then table.insert(colliders, door) end

  player:update(dt, colliders)
  for _, sw in ipairs(switches) do sw:update(dt, player) end
  door:update(dt)

  -- If door is open and player touches it, go to room one for test purposes
  if door.state == "open" and collision.aabb(player, door) then
    room_mgr.set("room_one")
  end
end

function RoomTwo.draw()
  love.graphics.clear(0.09,0.1,0.12)
  love.graphics.setColor(0.2,0.22,0.26)
  for _,w in ipairs(walls) do love.graphics.rectangle("fill", w.x, w.y, w.w, w.h) end

  for _, sw in ipairs(switches) do sw:draw() end
  door:draw()
  player:draw()

  love.graphics.setColor(1,1,1,0.85)
  love.graphics.print(("Room 2  |  Switches ON: %d/%d"):format(on_count, #required_ids), 10, 28)
  love.graphics.print(("Door: %s  (walk into door to return)"):format(door.state), 10, 44)
end

function RoomTwo.keypressed(key)
  if key == "e" then
    for _, sw in ipairs(switches) do sw:tryInteract(player) end
  end
end

function RoomTwo.teardown()
  if sub_id then event_bus.off(sub_id); sub_id = nil end
end

return RoomTwo