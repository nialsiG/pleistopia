local shooter = {}
shooter.x = 0
shooter.y = 0
shooter.r = 0
shooter.scale = 1

shooter.img = {}
shooter.img[1] = love.graphics.newImage("images/Flash_A_01.png")
shooter.img[2] = love.graphics.newImage("images/Flash_A_02.png")
shooter.img[3] = love.graphics.newImage("images/Flash_A_03.png")
shooter.currentImage = 1

shooter.ox = 0
shooter.oy = 0

shooter.mode = {}
shooter.mode[1] = "single"
shooter.mode[2] = "auto"
shooter.currentMode = 1

shooter.isFiring = false
shooter.timer = 0

shooter.sound = {}
shooter.sound[1] = love.audio.newSource("sounds/tank-fire-mixed.mp3", "static")

function shooter.Load()

end

function shooter.Update(dt)
	-- display on click
	if shooter.mode[shooter.currentMode] == "auto" then
		if love.mouse.isDown(1) then
			--if shooter.isFiring == false then
				shooter.isFiring = false
				print("I'm Firing My Machinegun!")
				shooter.isFiring = true
				local shootingSound = shooter.sound[1]
				shootingSound:stop()
				shootingSound:play()
			--end
		else
			--shooter.currentImage = 1
			shooter.isFiring = false
		end
	end

	-- shooter mode: update apparence and state
	if shooter.isFiring == true and shooter.mode[shooter.currentMode] == "single" then
		shooter.timer = shooter.timer + dt
		shooter.currentImage = 2
		if shooter.timer > 0.2 then
			shooter.isFiring = false
			shooter.timer = 0
		end
	end

end


function shooter.Draw()
	if shooter.isFiring == true then
		love.graphics.draw(
			shooter.img[shooter.currentImage], 
			shooter.x, shooter.y, 
			shooter.r, 
			shooter.scale, shooter.scale, 
			shooter.ox, shooter.oy
			)

	end
end

function shooter.Keypressed(button)
	if shooter.mode[shooter.currentMode] == "single" then
		if button == 1 then
			shooter.isFiring = false
			print("I'm Firing My Canon!")
			shooter.isFiring = true
			local shootingSound = shooter.sound[1]
			shootingSound:stop()
			shootingSound:play()
		end
	end

	if button == 2 then
		shooter.currentMode = shooter.currentMode + 1
		if shooter.currentMode > #shooter.mode then
			shooter.currentMode = 1
		end
	end
end

return shooter