-- Update la console pendant l'éxécution
io.stdout:setvbuf('no')
-- Si pixel art
love.graphics.setDefaultFilter("nearest")
---------------------------------------------------
function love.load()
   level = require("level")
   map = require("map")
   enemies = require("enemies")
   player = require("player")
   projectiles = require("projectiles")
   ui = require("ui")
   title = require("titleScreen")
   sceneManager = require("sceneManager")

   -- window size
   love.window.setMode(
      ui.tileWidth * ui.mapWidth, 
      ui.tileHeight * ui.mapHeight + ui.background:getHeight()
      )
end

---------------------------------------------------
function love.update(dt)
   sceneManager.Update(dt)
end

---------------------------------------------------
function love.draw()
   sceneManager.Draw()
   -- draw new mouse cursor
   love.graphics.draw(
      pngCursor, 
      love.mouse.getX(), 
      love.mouse.getY(),
      0, 1, 1,
      pngCursor:getWidth()/2,
      pngCursor:getHeight()/2
      )
end

---------------------------------------------------
 function love.keypressed(key)
   print(key)
   sceneManager.Keypressed(key)

 end

---------------------------------------------------
 function love.mousepressed(x, y, button, istouch, presses)
   if sceneManager.sceneCourante == level then
      level.Keypressed(button)
   end
end
