local playerProj = {}

pngBullets = {}
pngBullets["playerMedium"] = love.graphics.newImage("images/playerShellMedium.png")
--pngBullets["ennemyMedium"] = love.graphics.newImage("images/enemyShellMedium.png")

screen = require("screen")

function playerProj.Spawn(source)
   local newProj = {}
   newProj.x = source.x + pngBullets["playerMedium"]:getWidth()
   newProj.y = source.y + pngBullets["playerMedium"]:getHeight()
   newProj.r = source.r
   newProj.vx = 300
   newProj.vy = 300
   table.insert(playerProj, newProj)
end


function playerProj.Update(dt)
   

   for i = #playerProj, 1, -1 do
      -- Move projectiles
         playerProj[i].x = playerProj[i].x + math.cos(playerProj[i].r) * playerProj[i].vx * dt
         playerProj[i].y = playerProj[i].y + math.sin(playerProj[i].r) * playerProj[i].vy * dt

      -- Remove projectiles
      if playerProj[i].x < 0 
         or playerProj[i].x > screen.mapWidth * screen.tileWidth 
         or playerProj[i].y < 0 
         or playerProj[i].y > screen.mapHeight * screen.tileHeight then
         table.remove(playerProj, i)
      end

   end
   
end


function playerProj.Draw()
   -- Draw projectiles
   for i, s in ipairs(playerProj) do
      love.graphics.draw(pngBullets["playerMedium"], s.x, s.y, s.r)
   end

   -- debug number of projectiles
   love.graphics.print(#playerProj, 10, 10)
end


return playerProj