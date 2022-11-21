local gameOver = {}
local ui = require("ui")

enemies = require("enemies")
projectiles = require("projectiles")
player = require("player")
boss = require("boss")
items = require("items")

function gameOver.Update()
   -- reset
   ui.alarm:stop()
	ui.lifeManager.currentLife = ui.maxLife
   enemies.tankCollidePlayer = false 
   enemies.turretCollidePlayer = false 
   enemies.mammothCollidePlayer = false
   player.objectToTile = false
   player.shootAnim.isFiring = false
   player.timeWarping = true	
   -- remove bullets
   for i = #projectiles.friendly, 1, -1 do
      table.remove(projectiles.friendly, i)
   end
   for i = #projectiles.foe, 1, -1 do
      table.remove(projectiles.foe, i)
   end
   -- remove enemies
   for i = #enemies.tanks, 1, -1 do
      table.remove(enemies.tanks, i)
   end
   for i = #enemies.turrets, 1, -1 do
      table.remove(enemies.turrets, i)
   end
   for i = #enemies.mammoths, 1, -1 do
      table.remove(enemies.mammoths, i)
   end
   --remove medipacks
   for i = #items.medipacks, 1, -1 do
      table.remove(items.medipacks, i)
   end

   ui.currentMob = 0
   ui.maxMob = 0
end


function gameOver.Draw()
   love.graphics.setColor(1, 0.1, 0.1, 1)
   love.graphics.draw(ui.menu, 0, 0)
   ui.PrintCentered(ui.width / 2, ui.height / 2, ui.fontMain, "GAME OVER")
   ui.PrintCentered(ui.width / 2, ui.height / 2 + 100, ui.fontTitle2, "Continue? Y/N")
   love.graphics.setColor(1, 1, 1, 1)
end


return gameOver