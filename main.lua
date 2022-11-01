-- Update la console pendant l'éxécution
io.stdout:setvbuf('no')
-- Si pixel art
love.graphics.setDefaultFilter("nearest")
---------------------------------------------------
-- Load
---------------------------------------------------
 function love.load()
   
   level01 = require("level01")
   player = require("player")
   shooter = require("shooter")



   love.window.setMode(
        level01.map.TILE_WIDTH * level01.map.MAP_WIDTH, 
        level01.map.TILE_HEIGHT * level01.map.MAP_HEIGHT, 
        {resizable = true, vsync = 0, minwidth = 400, minheight = 300})
   screenWidth = love.graphics.getWidth()
   screenHeight = love.graphics.getHeight()



   level01.Load()
   player.Load(screenWidth / 8, screenHeight / 2)


 end

---------------------------------------------------
 -- Update
 ---------------------------------------------------
 function love.update(dt)
   level01.Update(dt)
   player.Update(dt)

 end

 ---------------------------------------------------
 -- Draw
 ---------------------------------------------------
 function love.draw()
    --love.graphics.draw(img, x, y, rotation, scaleX, scaleY, ox, oy)
   level01.Draw()
   player.Draw()
 end

---------------------------------------------------
-- Keys and clicks
---------------------------------------------------

 function love.keypressed(key)
    print(key)

 end

 function love.mousepressed(x, y, button, istouch, presses)
    print(button)
    shooter.Keypressed(button)
end
