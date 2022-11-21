player = require("player")
ui = require("ui")

local projectiles = {}
projectiles.friendly = {}
projectiles.foe = {}

pngBullets = {}
pngBullets["tank"] = love.graphics.newImage("images/playerShellMedium.png")
pngBullets["tankRed"] = love.graphics.newImage("images/enemyShellMedium.png")
pngBullets["turret"] = love.graphics.newImage("images/LED_red.png")
pngBullets["explosion"] = love.graphics.newImage("images/shellExplosion.png")
pngBullets["explosionA"] = love.graphics.newImage("images/Explosion_A.png")
pngBullets["explosionB"] = love.graphics.newImage("images/Explosion_B.png")
pngBullets["explosionC"] = love.graphics.newImage("images/Explosion_C.png")
pngBullets["explosionD"] = love.graphics.newImage("images/Explosion_D.png")
pngBullets["explosionE"] = love.graphics.newImage("images/Explosion_E.png")
pngBullets["explosionF"] = love.graphics.newImage("images/Explosion_F.png")
pngBullets["explosionG"] = love.graphics.newImage("images/Explosion_G.png")
pngBullets["explosionH"] = love.graphics.newImage("images/Explosion_H.png")

function projectiles.Spawn(source, shellType, friendlyOrFoe, addAngle)
   local newProj = {}
   -- choose image
   newProj.png = pngBullets[shellType]

   -- projectile caracteristics
   newProj.source = source
   newProj.x = source.x
   newProj.y = source.y
   newProj.ox = newProj.png:getWidth() / 2
   newProj.oy = newProj.png:getHeight() / 2
   
   if friendlyOrFoe == "friendly" then
      newProj.r = source.r
   elseif friendlyOrFoe == "foe" then
      newProj.r = source.rHead
   end

   if addAngle ~= nil then
      newProj.r = newProj.r + addAngle
   end
   if shellType == "tank" or shellType == "tankRed"then
      newProj.vx = 240
   elseif shellType == "turret" then
      newProj.vx = 80
   end
   newProj.vy = newProj.vx

   -- collision
   newProj.isCollided = false
   newProj.timer = 0

   -- bounding box
   newProj.bBox = {}
   newProj.bBox[1] = {x = 0, y = 0} 
   
   -- add to relevant table
   if friendlyOrFoe == "friendly" then
      table.insert(projectiles.friendly, newProj)
   elseif friendlyOrFoe == "foe" then
      table.insert(projectiles.foe, newProj)
   end
end

function projectiles.TextureDetect(object, map, tileType, dt)
   -- detect if player projectiles collides with a texture
         local col = math.floor(object.x / ui.tileWidth) + 1
         local row = math.floor(object.y / ui.tileHeight) + 1
         local coord = map.top[row][col]

      if tileType[coord] == "rock" or 
         tileType[coord] == "tree" then
         object.isCollided = true
      end
end

-----------------------------------
function projectiles.Update(map, tileType, dt)

  -- Update projectile position
   for i = #projectiles.friendly, 1, -1 do
      -- Move projectiles
         projectiles.friendly[i].x = projectiles.friendly[i].x + math.cos(projectiles.friendly[i].r) * projectiles.friendly[i].vx * dt
         projectiles.friendly[i].y = projectiles.friendly[i].y + math.sin(projectiles.friendly[i].r) * projectiles.friendly[i].vy * dt
         projectiles.friendly[i].bBox[1].x = projectiles.friendly[i].x + math.cos(projectiles.friendly[i].r) * projectiles.friendly[i].png:getWidth() / 2
         projectiles.friendly[i].bBox[1].y = projectiles.friendly[i].y + math.sin(projectiles.friendly[i].r) * projectiles.friendly[i].png:getHeight()
      -- Remove projectiles out of ui
      if projectiles.friendly[i].x < 0 
         or projectiles.friendly[i].x > ui.mapWidth * ui.tileWidth 
         or projectiles.friendly[i].y < 0 
         or projectiles.friendly[i].y > ui.mapHeight * ui.tileHeight
         or player.Distance(projectiles.friendly[i], player.head) > player.shootingRange then
         table.remove(projectiles.friendly, i)
      end
   end

   for i = #projectiles.foe, 1, -1 do
      -- Move projectiles
         projectiles.foe[i].x = projectiles.foe[i].x + math.cos(projectiles.foe[i].r) * projectiles.foe[i].vx * dt
         projectiles.foe[i].y = projectiles.foe[i].y + math.sin(projectiles.foe[i].r) * projectiles.foe[i].vy * dt
         projectiles.foe[i].bBox[1].x = projectiles.foe[i].x + math.cos(projectiles.foe[i].r) * projectiles.foe[i].png:getWidth() / 2
         projectiles.foe[i].bBox[1].y = projectiles.foe[i].y + math.sin(projectiles.foe[i].r) * projectiles.foe[i].png:getHeight()
      -- Remove projectiles out of ui
      if projectiles.foe[i].x < 0 
         or projectiles.foe[i].x > ui.mapWidth * ui.tileWidth 
         or projectiles.foe[i].y < 0 
         or projectiles.foe[i].y > ui.mapHeight * ui.tileHeight then
         table.remove(projectiles.foe, i)
      end
   end

   -- Collision animation
   for i = #projectiles.friendly, 1, -1 do
      projectiles.TextureDetect(projectiles.friendly[i], map, tileType, dt)
      if projectiles.friendly[i].isCollided == true then
         projectiles.friendly[i].vx = 0
         projectiles.friendly[i].vy = 0
         projectiles.friendly[i].timer = projectiles.friendly[i].timer + dt
         if projectiles.friendly[i].timer > 0.1 and projectiles.friendly[i].timer <= 0.15 then
            projectiles.friendly[i].png = pngBullets["explosionA"]
         end
         if projectiles.friendly[i].timer > 0.15 and projectiles.friendly[i].timer <= 0.2 then
            projectiles.friendly[i].png = pngBullets["explosionB"]
         end
         if projectiles.friendly[i].timer > 0.2 and projectiles.friendly[i].timer <= 0.25 then
            projectiles.friendly[i].png = pngBullets["explosionC"]
         end
         if projectiles.friendly[i].timer > 0.25 and projectiles.friendly[i].timer <= 0.3 then
            projectiles.friendly[i].png = pngBullets["explosionD"]
         end
         if projectiles.friendly[i].timer > 0.3 and projectiles.friendly[i].timer <= 0.35 then
            projectiles.friendly[i].png = pngBullets["explosionE"]
         end
         if projectiles.friendly[i].timer > 0.35 and projectiles.friendly[i].timer <= 0.4 then
            projectiles.friendly[i].png = pngBullets["explosionF"]
         end
         if projectiles.friendly[i].timer > 0.4 and projectiles.friendly[i].timer <= 0.45 then
            projectiles.friendly[i].png = pngBullets["explosionG"]
         end
         if projectiles.friendly[i].timer > 0.45 and projectiles.friendly[i].timer <= 0.5 then
            projectiles.friendly[i].png = pngBullets["explosionH"]
         end

         if projectiles.friendly[i].timer > 0.5 then
            table.remove(projectiles.friendly, i)
         end
      end
   end

      for i = #projectiles.foe, 1, -1 do
      projectiles.TextureDetect(projectiles.foe[i], map, tileType, dt)
      if projectiles.foe[i].isCollided == true then
         projectiles.foe[i].vx = 0
         projectiles.foe[i].vy = 0
         projectiles.foe[i].timer = projectiles.foe[i].timer + dt
         if projectiles.foe[i].timer > 0.1 and projectiles.foe[i].timer <= 0.15 then
            projectiles.foe[i].png = pngBullets["explosionA"]
         end
         if projectiles.foe[i].timer > 0.15 and projectiles.foe[i].timer <= 0.2 then
            projectiles.foe[i].png = pngBullets["explosionB"]
         end
         if projectiles.foe[i].timer > 0.2 and projectiles.foe[i].timer <= 0.25 then
            projectiles.foe[i].png = pngBullets["explosionC"]
         end
         if projectiles.foe[i].timer > 0.25 and projectiles.foe[i].timer <= 0.3 then
            projectiles.foe[i].png = pngBullets["explosionD"]
         end
         if projectiles.foe[i].timer > 0.3 and projectiles.foe[i].timer <= 0.35 then
            projectiles.foe[i].png = pngBullets["explosionE"]
         end
         if projectiles.foe[i].timer > 0.35 and projectiles.foe[i].timer <= 0.4 then
            projectiles.foe[i].png = pngBullets["explosionF"]
         end
         if projectiles.foe[i].timer > 0.4 and projectiles.foe[i].timer <= 0.45 then
            projectiles.foe[i].png = pngBullets["explosionG"]
         end
         if projectiles.foe[i].timer > 0.45 and projectiles.foe[i].timer <= 0.5 then
            projectiles.foe[i].png = pngBullets["explosionH"]
         end

         if projectiles.foe[i].timer > 0.5 then
            table.remove(projectiles.foe, i)
         end
      end
   end
   
end

-----------------------------------
function projectiles.Draw()
   -- Draw projectiles
   for i, s in ipairs(projectiles.friendly) do
      love.graphics.draw(s.png, s.x, s.y, s.r, 1, 1, s.ox, s.oy)
      --love.graphics.circle("fill", s.bBox[1].x, s.bBox[1].y, 2)
   end

   for i, s in ipairs(projectiles.foe) do
      love.graphics.draw(s.png, s.x, s.y, s.r, 1, 1, s.ox, s.oy)
      --love.graphics.circle("fill", s.bBox[1].x, s.bBox[1].y, 2)
   end

end

return projectiles