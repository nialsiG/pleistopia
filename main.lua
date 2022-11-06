-- Update la console pendant l'éxécution
io.stdout:setvbuf('no')
-- Si pixel art
love.graphics.setDefaultFilter("nearest")
---------------------------------------------------
-- Load
---------------------------------------------------
 function love.load()
   
   level01 = require("level01")
   enemies = require("enemies")
   player = require("player")
   screen = require("screen")
   playerProj = require("player_projectiles")
   ui = require("ui")


   love.window.setMode(
        --level01.map.TILE_WIDTH * 30, 
        --level01.map.TILE_HEIGHT * 24,
        screen.tileWidth * screen.mapWidth,
        screen.tileHeight * screen.mapHeight + ui.background:getHeight())
   
   --screenWidth = love.graphics.getWidth()
   --screenHeight = love.graphics.getHeight()



   level01.Load()
   player.Load(screen.width / 8, screen.height / 2)
   ui.Load()


 end

---------------------------------------------------
 -- Update
 ---------------------------------------------------
 function love.update(dt)
   level01.Update(dt)
   player.Update(dt)
   playerProj.Update(dt)
   --enemies.Update(dt)
   ui.Update(dt)
 end

 ---------------------------------------------------
 -- Draw
 ---------------------------------------------------
 function love.draw()
    --love.graphics.draw(img, x, y, rotation, scaleX, scaleY, ox, oy)
   level01.Draw()
   ui.Draw()

   if player.isVisible == true then
      player.Draw()
   end

   enemies.Draw()
   playerProj.Draw()
   




 end

---------------------------------------------------
-- Keys and clicks
---------------------------------------------------

 function love.keypressed(key)
    print(key)

 end

 function love.mousepressed(x, y, button, istouch, presses)
    print(button)
    player.Keypressed(button)
end
