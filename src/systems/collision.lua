local C = {}

local function aabb(ax,ay,aw,ah,bx,by,bw,bh)
  return ax < bx + bw and bx < ax + aw and ay < by + bh and by < ay + ah
end

function C.aabb(a, b)
  return aabb(a.x,a.y,a.w,a.h, b.x,b.y,b.w,b.h)
end

function C.moveAndCollide(ent, dx, dy, colliders)
  ent.x = ent.x + dx
  for _,c in ipairs(colliders) do
    if aabb(ent.x, ent.y, ent.w, ent.h, c.x, c.y, c.w, c.h) then
      if dx > 0 then ent.x = c.x - ent.w else ent.x = c.x + c.w end
    end
  end
  ent.y = ent.y + dy
  for _,c in ipairs(colliders) do
    if aabb(ent.x, ent.y, ent.w, ent.h, c.x, c.y, c.w, c.h) then
      if dy > 0 then ent.y = c.y - ent.h else ent.y = c.y + c.h end
    end
  end
end

return C
