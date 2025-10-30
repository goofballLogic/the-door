-- Tiny pub/sub bus: on(event, fn) -> id; emit(event, payload); off(id)
local bus = {
  _nextId = 1,
  _subs = {} -- event -> array of {id, fn}
}

function bus.on(event, fn)
  local id = bus._nextId
  bus._nextId = id + 1
  if not bus._subs[event] then bus._subs[event] = {} end
  table.insert(bus._subs[event], { id = id, fn = fn })
  return id
end

function bus.off(id)
  for evt, list in pairs(bus._subs) do
    for i=#list,1,-1 do
      if list[i].id == id then table.remove(list, i) end
    end
  end
end

function bus.emit(event, payload)
  local list = bus._subs[event]
  if not list then return end
  -- copy to avoid mutation during iteration
  local copy = {}
  for i=1,#list do copy[i] = list[i] end
  for _,sub in ipairs(copy) do
    sub.fn(payload)
  end
end

return bus
