ui = {}

screen = require("screen")
player = require("player")
ui.background = love.graphics.newImage("images/uiBackground.png")

ui.lifes = {}
ui.maxLife = 8

ui.lifeManager = {}
    ui.lifeManager.currentLife = ui.maxLife
    ui.lifeManager.isInvincible = false
    ui.lifeManager.timer = 0 

ui.alarm = love.audio.newSource("sounds/503855__tim-kahn__deep-space-alarm.wav", "static")
   	ui.alarm:setLooping(true)
    ui.alarm:setVolume(0.5)
    ui.alarm:setPitch(1.2)

function ui.Load()
	for i = 1, ui.maxLife do
		ui.lifes[i] = {}
		ui.lifes[i].img = love.graphics.newImage("images/LED_green.png")
		ui.lifes[i].img2 = love.graphics.newImage("images/LED_red.png")
		ui.lifes[i].x = 780 + 20 * i
		ui.lifes[i].y = screen.mapHeight * screen.tileHeight + 25
		ui.lifes[i].ox = ui.lifes[i].img:getWidth()/2
		ui.lifes[i].oy = ui.lifes[i].img:getHeight()/2
		ui.lifes[i].scale = 1
	end

	function LoseLife(lifes, lifeManager, dt)
		local lifeMax = #lifes
		print("Max life =", lifeMax)
		if lifeManager.isInvincible == true then
			print("Current Life =", ui.lifeManager.currentLife)
			print("I'm invicible!")
		elseif lifeManager.currentLife > 0 then
			lifeManager.currentLife = lifeManager.currentLife - 1
			lifeManager.timer = 1
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

end


function ui.Update(dt)
if love.keyboard.isDown("space") then
       ui.lifeManager.currentLife = LoseLife(ui.lifes, ui.lifeManager, dt)
    end
    
    if ui.lifeManager.timer > 0 then
        ui.lifeManager.timer = ui.lifeManager.timer - dt
        ui.lifeManager.isInvincible = true
    else ui.lifeManager.isInvincible = false
        player.isVisible = true
    end

    if ui.lifeManager.currentLife == 1 then
        ui.lifes[1].img = ui.lifes[1].img2
        ui.lifes[1].scale = Blink(ui.lifes[1].scale, dt)
        ui.alarm:play()
    else
        ui.alarm:stop()
    end

    if ui.lifeManager.isInvincible == true then
        player.flickTimer = player.flickTimer + dt
        if player.flickTimer >= 0.15 then
            if player.isVisible == true then
                player.isVisible = false
            elseif player.isVisible == false then
                player.isVisible = true
            end
        	player.flickTimer = 0
    	end
    end
end


function ui.Draw()
	love.graphics.draw(ui.background, 0, screen.mapHeight * screen.tileHeight)
	
   	love.graphics.setColor(0, 0, 0)
   	-- debug square
	love.graphics.rectangle("fill", 0, 0, 50, 100)
   	-- terminal placeholders
	love.graphics.rectangle("fill", 20, screen.tileHeight * screen.mapHeight + 10, 90, 80)
	love.graphics.rectangle("fill", 140, screen.tileHeight * screen.mapHeight + 10, 760 - 140, 80)

   	love.graphics.setColor(1, 1, 1)

	for i = 1, ui.lifeManager.currentLife do
	    love.graphics.draw(ui.lifes[i].img, 
        ui.lifes[i].x, ui.lifes[i].y,
        0, ui.lifes[i].scale, ui.lifes[i].scale,
        ui.lifes[i].ox, ui.lifes[i].oy)
	end
end

return ui