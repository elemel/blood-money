local mathUtils = require("mathUtils")
local tableUtils = require("tableUtils")

local clampLength = mathUtils.clampLength
local round = mathUtils.round

local physics = {}

function physics.applyFriction(
  entity, accelerationX, accelerationY, targetVelocityX, targetVelocityY, dt)

  physics.applyFrictionX(entity, accelerationX, targetVelocityX, dt)
  physics.applyFrictionY(entity, accelerationY, targetVelocityY, dt)
end

function physics.applyFrictionX(entity, acceleration, targetVelocity, dt)
  local velocity = (entity.x - entity.oldX) / dt

  local deltaVelocity = clampLength(
    targetVelocity - velocity, acceleration * dt)

  velocity = velocity + deltaVelocity
  entity.x = entity.oldX + velocity * dt
end

function physics.applyFrictionY(entity, acceleration, targetVelocity, dt)
  local velocity = (entity.y - entity.oldY) / dt

  local deltaVelocity = clampLength(
    targetVelocity - velocity, acceleration * dt)

  velocity = velocity + deltaVelocity
  entity.y = entity.oldY + velocity * dt
end

function physics.applyBoostX(entity, acceleration, targetVelocity, dt)
  local velocity = (entity.x - entity.oldX) / dt

  local deltaVelocity = clampLength(
    targetVelocity - velocity, acceleration * dt)

  if deltaVelocity * targetVelocity > 0 then
    velocity = velocity + deltaVelocity
    entity.x = entity.oldX + velocity * dt
  end
end

function physics.updatePosition(entity)
  local dx = entity.x - entity.oldX
  local dy = entity.y - entity.oldY

  entity.oldX = entity.x
  entity.oldY = entity.y

  entity.x = entity.x + dx
  entity.y = entity.y + dy
end

function physics.resolveTerrainCollision(entity, blocks)
  local x1 = entity.x - 0.5 * entity.width
  local y1 = entity.y - 0.5 * entity.height
  local x2 = entity.x + 0.5 * entity.width
  local y2 = entity.y + 0.5 * entity.height

  local collisionDistance = 0
  local collisionNormalX = 0
  local collisionNormalY = 0

  for x = round(x1), round(x2) do
    for y = round(y1), round(y2) do
      local type_ = tableUtils.get2(blocks, x, y)

      if type_ then
        distance, normalX, normalY =
          mathUtils.boxDistance(
            x1, y1, x2, y2, x - 0.5, y - 0.5, x + 0.5, y + 0.5)

        if distance < collisionDistance then
          collisionDistance = distance
          collisionNormalX = normalX
          collisionNormalY = normalY
        end
      end
    end
  end

  entity.x = entity.x + collisionDistance * collisionNormalX
  entity.y = entity.y + collisionDistance * collisionNormalY

  return collisionDistance, collisionNormalX, collisionNormalY
end

return physics
