local ui = {}

-- aesthetics
ui.menu = love.graphics.newImage("images/menu.png")
ui.background = love.graphics.newImage("images/uiBackground.png")
ui.backgroundTop = love.graphics.newImage("images/uiBackgroundTop.png")
ui.arrow = love.graphics.newImage("images/arrow.png")
ui.arrowTransparency = 0

-- reference values
ui.mapWidth = 30
ui.mapHeight = 20
ui.tileWidth = 32
ui.tileHeight = 32
ui.width = ui.tileWidth * ui.mapWidth
ui.height = ui.tileHeight * ui.mapHeight
ui.pauseMenu = false

-- custom mouse cursor
pngCursor = love.graphics.newImage("images/target_30.png")
love.mouse.setVisible(false)
love.mouse.setGrabbed(true)

-- Fonts
ui.fontMain = love.graphics.newFont("fonts/Audiowide-Regular.ttf", 40)
ui.fontTitle1 = love.graphics.newFont("fonts/Audiowide-Regular.ttf", 30)
ui.fontTitle2 = love.graphics.newFont("fonts/Audiowide-Regular.ttf", 24)
ui.fontText1 = love.graphics.newFont("fonts/Iceland-Regular.ttf", 20)

-- sound
ui.alarm = love.audio.newSource("sounds/503855__tim-kahn__deep-space-alarm.wav", "static")
   	ui.alarm:setLooping(true)
    ui.alarm:setVolume(0.5)
    ui.alarm:setPitch(1.2)

-- health
ui.lifes = {}
ui.maxLife = 4
ui.lifeManager = {}
ui.lifeManager.currentLife = ui.maxLife
ui.lifeManager.isInvincible = false
ui.lifeManager.timer = 0 
for i = 1, ui.maxLife do
	ui.lifes[i] = {}
	ui.lifes[i].img = love.graphics.newImage("images/LED_green.png")
	ui.lifes[i].img2 = love.graphics.newImage("images/LED_red.png")
	ui.lifes[i].imgCurrent = ui.lifes[i].img
	ui.lifes[i].x = 760 + 40 * i
	ui.lifes[i].y = ui.mapHeight * ui.tileHeight + 25
	ui.lifes[i].ox = ui.lifes[i].img:getWidth()/2
	ui.lifes[i].oy = ui.lifes[i].img:getHeight()/2
	ui.lifes[i].scale = 1
end

-- enemy counter
	ui.currentMob = 0
	ui.maxMob = 0

function LoseLife(lifes, lifeManager, dt)
	local lifeMax = #lifes
	print("Max life =", lifeMax)
	if lifeManager.isInvincible == true then
		print("I'm invicible!")
	elseif lifeManager.currentLife > 0 then
		lifeManager.currentLife = lifeManager.currentLife - 1
		lifeManager.timer = 1.5
		lifeManager.isInvincible = true
		print("Current Life =", lifeManager.currentLife)
	else
		lifeManager.currentLife = 0
		print("Game Over!")
	end
	return(lifeManager.currentLife)
end

function Blink(scale, dt)
	if scale >= 0 and scale < 1 then
		scale = math.cos(math.acos(scale) + 2 * dt)
	elseif scale > - 0.9 and scale < 0 then
		scale = math.cos(math.acos(scale) + 5 * dt)
	else scale = 0.99
	end
	return(scale)
end

function ui.PrintCentered(x, y, font, text)
	local string = tostring(text)
	love.graphics.setFont(font)
	love.graphics.print(
		string, 
		x, y, 
		0, 1, 1,
		font:getWidth(string) / 2, 
		font:getHeight(string) / 2)
end

------------------------------------
function ui.Update(dt)
    if ui.lifeManager.currentLife == 1 then
        ui.lifes[1].imgCurrent = ui.lifes[1].img2
        ui.lifes[1].scale = Blink(ui.lifes[1].scale, dt)
        ui.alarm:play()
    else
        ui.alarm:stop()
        ui.lifes[1].imgCurrent = ui.lifes[1].img
        ui.lifes[1].scale = 1
    end

    if ui.currentMob == 0 then
    	ui.arrowTransparency = ui.arrowTransparency + dt
    	if ui.arrowTransparency <= 1 then
    		ui.arrowTransparency = ui.arrowTransparency + dt
    	elseif ui.arrowTransparency > 1 then
    		ui.arrowTransparency = 0
    	end
    end

end

------------------------------------
function ui.Draw()
	-- bg
	love.graphics.draw(ui.background, 0, ui.mapHeight * ui.tileHeight)
	love.graphics.draw(ui.backgroundTop, ui.tileWidth * ui.mapWidth / 2, 0,
		0, 1, 1, ui.backgroundTop:getWidth() / 2)
   	love.graphics.setColor(1, 1, 1, 1)
   	
   	-- health
	for i = 1, ui.lifeManager.currentLife do
	    love.graphics.draw(ui.lifes[i].imgCurrent, 
        ui.lifes[i].x, ui.lifes[i].y,
        0, ui.lifes[i].scale, ui.lifes[i].scale,
        ui.lifes[i].ox, ui.lifes[i].oy)
	end

	-- mob counter
	love.graphics.setColor(41/100, 66/100, 52/100, 1)
	love.graphics.setFont(ui.fontTitle2)
	love.graphics.print(
		tostring(ui.currentMob).."/"..tostring(ui.maxMob), 
		ui.width / 2, 5,
		0, 1, 1,
		ui.fontTitle2:getWidth(tostring(ui.currentMob).."/"..tostring(ui.maxMob))/2)

	-- draw arrow if enemies are all dead
	love.graphics.setColor(1, 1, 1, ui.arrowTransparency)
	if ui.currentMob == 0 then
    	love.graphics.draw(
        	ui.arrow,
			ui.mapWidth * ui.tileWidth - ui.arrow:getWidth(),
			(ui.mapHeight * ui.tileHeight) / 2)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

return ui