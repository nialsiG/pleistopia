local sceneManager = {}

local title = require("titleScreen")
local level = require("level")
local gameOver = require("gameOver")
local victory = require("victory")
local ui = require("ui")

sceneManager.sceneCourante = title
sceneManager.index = 1

-----------------------------------
function sceneManager.Update(dt)
	if ui.lifeManager.currentLife == 0 then
		sceneManager.sceneCourante = gameOver
		sceneManager.index = 3
	end
	
	if level.wonTheGame == true then
		sceneManager.sceneCourante = victory
		sceneManager.index = 4
		victory.music:play()
		love.mouse.setGrabbed(false)
	end

	sceneManager.sceneCourante.Update(dt)
end

-----------------------------------
function sceneManager.Draw()
	sceneManager.sceneCourante.Draw()
end

function sceneManager.Keypressed(key)
	-- navigate menus
	if key == "y" and 
		sceneManager.index == 1 then
		sceneManager.sceneCourante = level
		sceneManager.index = 2
		level.Load(1)
	elseif key == "y" and 
		sceneManager.index == 3 then
		sceneManager.sceneCourante = level
		sceneManager.index = 2
		level.Load(level.currentLevel)
	elseif key == "y" and
		sceneManager.index == 2 and
		level.isPaused == true and 
		ui.pauseMenu == true then
		level.isPaused = false
		ui.pauseMenu = false
	end

	-- quit game
	if key == "n" and 
		sceneManager.index == 1 then
		love.event.quit()
	elseif key == "n" and 
		sceneManager.index == 3 then
		love.event.quit()
	elseif key == "n" and
		sceneManager.index == 2 and
		level.isPaused == true and 
		ui.pauseMenu == true then
		love.event.quit()
	end

	-- pause
	if key == "escape" and 
		sceneManager.index == 2 then
		if level.isPaused == true then
			level.isPaused = false
			ui.pauseMenu = false
		else
			level.isPaused = true
			ui.pauseMenu = true
		end
	end
end

return(sceneManager)