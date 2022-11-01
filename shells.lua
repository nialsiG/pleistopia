local shells = {}

shell.speed = 300
pngBullets = {}
pngBullets["playerMedium"] = love.graphics.newImage("images/playerShellMedium.png")
pngBullets["ennemyMedium"] = love.graphics.newImage("images/enemyShellMedium.png")

function shells.Spawn(shells, source)
   local newShell = {}
   newShell.x = source.x + source.width + pngBullets["playerMedium"]:getWidth()
   newShell.y = source.x + source.width + pngBullets["playerMedium"]:getHeight()
   newShell.r = source.r
   newShell.vx = 5
   newShell.vy = 5
   love.table.insert(shells, newShell)
end



function shells.Update(dt)
   -- Move projectiles



   -- Remove projectiles

   
end


function shells.Draw()

end


return shells