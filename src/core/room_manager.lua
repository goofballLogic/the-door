-- src/core/room_manager.lua
local current       = nil
local current_name  = nil

local M = {}

local function safe_call(method, ...)
  if current and current[method] then
    return current[method](...)
  end
end

function M.set(name, ...)
  -- tear down the old room (if any)
  if current and current.teardown then
    current.teardown()
  end

  -- force fresh load of the room module for dev hot-reload
  package.loaded[name] = nil

  -- protect the require with pcall so we see a readable error
  local ok, room_or_err = pcall(require, name)
  if not ok then
    error(("Failed to require room '%s': %s"):format(name, room_or_err))
  end

  if type(room_or_err) ~= "table" then
    error(("Room '%s' did not return a table. Did you forget `return RoomName`?"):format(name))
  end

  current      = room_or_err
  current_name = name

  if current.load then
    current.load(...)
  end
end

function M.reload()
  if current_name then
    M.set(current_name)
  end
end

function M.update(dt)       safe_call("update", dt)      end
function M.draw()            safe_call("draw")            end
function M.keypressed(key)   safe_call("keypressed", key) end
function M.keyreleased(key)  safe_call("keyreleased", key)end

return M