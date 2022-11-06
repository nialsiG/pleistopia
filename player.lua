local player = {}
player.body = {}
player.body.x = 0
player.body.y = 0
player.body.r = 0
player.body.img = {}
player.body.img[1] = love.graphics.newImage("images/playerBody.png")
player.body.currentImage = 1
player.body.scale = 1
player.body.ox = player.body.img[player.body.currentImage]:getWidth()/2
player.body.oy = player.body.img[player.body.currentImage]:getHeight()/2
player.body.speed = 175
player.body.turnSpeed = 3

-- sound
player.sound = {}
player.sound[2] = love.audio.newSource("sounds/TankIdle.wav", "static")
player.sound[1] = love.audio.newSource("sounds/tank_medium_idle.wav", "static")
player.engineSound = player.sound[1]
player.engineSound:setLooping(true)
player.engineSound:setVolume(0.5)

player.head = {}
player.head.r = 0
player.head.img = {}
player.head.img[1] = love.graphics.newImage("images/playerHead.png")
player.head.currentImage = 1
player.head.scale = 1
player.head.ox = player.head.img[player.head.currentImage]:getWidth()/4
player.head.oy = player.head.img[player.head.currentImage]:getHeight()/2
player.head.width = player.head.img[player.head.currentImage]:getWidth()

-- shooting animation
player.shootAnim = {}
player.shootAnim.x = 0
player.shootAnim.y = 0
player.shootAnim.r = 0
player.shootAnim.scale = 1

player.shootAnim.img = {}
player.shootAnim.img[1] = love.graphics.newImage("images/Flash_A_01.png")
player.shootAnim.img[2] = love.graphics.newImage("images/Flash_A_02.png")
player.shootAnim.img[3] = love.graphics.newImage("images/Flash_A_03.png")
player.shootAnim.currentImage = 1

player.shootAnim.ox = 0
player.shootAnim.oy = 0

player.shootAnim.mode = {}
player.shootAnim.mode[1] = "single"
player.shootAnim.mode[2] = "auto"
player.shootAnim.currentMode = 1

player.shootAnim.isFiring = false
player.shootAnim.timer = 0

player.shootAnim.sound = {}
player.shootAnim.sound[1] = love.audio.newSource("sounds/tank-fire-mixed.mp3", "static")

player.projOrigin = {}
player.projOrigin.x = 0
player.projOrigin.y = 0
player.projOrigin.r = 0
player.projOrigin.ox = 0
player.projOrigin.oy = 0
player.projOrigin.isLeftCanonFiring = true


player.flickTimer = 0
player.isVisible = true
player.isCollided = false
player.nextPosition = {}
player.nextPosition.x = 0
player.nextPosition.y = 0

-- inertie on ice
player.body.isSliding = false
player.body.velocity = 1

-- HUD elements
screen = require("screen")
mouse = {}

function player.Distance(source, target)
	local x = target.x - source.x
	local y = target.y - source.y
	norme = math.sqrt((x * x) + (y * y))
	return(norme)
end

function player.TextureDetect(map, tileType, dt)
  	-- detect if player collides with a texture
      	local col = math.floor(player.body.x / screen.tileWidth) + 1
      	local row = math.floor(player.body.y / screen.tileHeight) + 1
    	local coord = map.grid[row][col]

      	local futureCol = math.floor(player.nextPosition.x / screen.tileWidth) + 1
      	local futureRow = math.floor(player.nextPosition.y / screen.tileHeight) + 1
      	local futureCoord = map.grid[futureRow][futureCol]

      	if tileType[coord] == "snow" then
        	player.body.speed = 50
     	else
        	player.body.speed = 175
      	end

	    if tileType[coord] == "ice" then
    		player.body.isSliding = true
   		else
      		player.body.isSliding = false
    	end


    	if tileType[futureCoord] == "rock" then
  			player.isCollided = true
    	else
  			player.isCollided = false
    	end

end

---------------------------------------------------------------
-- Load
---------------------------------------------------------------
function player.Load(x, y)
	player.body.x = x
	player.body.y = y

	-- shooting system
	playerProj = require("player_projectiles")

	-- sound
	player.engineSound:play()

end

---------------------------------------------------------------
-- Update
---------------------------------------------------------------
function player.Update(dt)


	-- déplacement normal
		-- marche avant
		if love.keyboard.isDown("up", "z") then
			-- déplacement sur glace
			if player.body.isSliding == true then
	    		player.body.velocity = 2
	    	else
	    		player.body.velocity = 1
			end
			-- déplacement futur
			player.nextPosition.x = player.body.x + (math.cos(player.body.r) * player.body.speed * player.body.velocity * dt)
			player.nextPosition.y = player.body.y + (math.sin(player.body.r) * player.body.speed * player.body.velocity * dt)

            -- déplacement si aucune collision
            if player.isCollided == false then
            	player.body.x = player.nextPosition.x
            	player.body.y = player.nextPosition.y
            else
            	-- bump en arrière si collision
            	player.nextPosition.x = player.body.x - (math.cos(player.body.r) * player.body.speed * player.body.velocity * dt)
				player.nextPosition.y = player.body.y - (math.sin(player.body.r) * player.body.speed * player.body.velocity * dt)
            	player.body.x = player.nextPosition.x
            	player.body.y = player.nextPosition.y
        	end
        end

		-- marche arrière
		if love.keyboard.isDown("down", "s") then
			-- déplacement sur glace
			if player.body.isSliding == true then
	    		player.body.velocity = 2
	    	else
	    		player.body.velocity = 1
			end

			-- déplacement futur
			player.nextPosition.x = player.body.x - (math.cos(player.body.r) * player.body.speed * player.body.velocity * dt)
			player.nextPosition.y = player.body.y - (math.sin(player.body.r) * player.body.speed * player.body.velocity * dt)

            -- déplacement si aucune collision
            if player.isCollided == false then
            	player.body.x = player.nextPosition.x
            	player.body.y = player.nextPosition.y
            else
        	-- bump en arrière si collision
            	player.nextPosition.x = player.body.x + (math.cos(player.body.r) * player.body.speed * player.body.velocity * dt)
				player.nextPosition.y = player.body.y + (math.sin(player.body.r) * player.body.speed * player.body.velocity * dt)
            	player.body.x = player.nextPosition.x
            	player.body.y = player.nextPosition.y
        	end

		end
		-- tourner à gauche
		if love.keyboard.isDown("left", "q") then
			player.body.ox = 0
			player.body.oy = 0
			player.body.r = player.body.r - player.body.turnSpeed * dt
			player.body.ox = player.body.img[player.body.currentImage]:getWidth() / 2
			player.body.oy = player.body.img[player.body.currentImage]:getHeight() / 2
		end
		-- tourner à droite
		if love.keyboard.isDown("right", "d") then
			player.body.ox = player.body.img[player.body.currentImage]:getWidth()
			player.body.oy = player.body.img[player.body.currentImage]:getWidth()
			player.body.r = player.body.r + player.body.turnSpeed * dt
			player.body.ox = player.body.img[player.body.currentImage]:getWidth() / 2
			player.body.oy = player.body.img[player.body.currentImage]:getHeight() / 2
		end





	-- boundaries
	if player.body.x <= 0 + player.body.ox then
		player.body.x = 0 + player.body.ox
	end

	if player.body.x >= screen.mapWidth * screen.tileWidth - player.body.ox then
		player.body.x = screen.mapWidth * screen.tileWidth - player.body.ox
	end

	if player.body.y <= 0 + player.body.oy then
		player.body.y = 0 + player.body.oy
	end

	if player.body.y >= screen.mapHeight * screen.tileHeight - player.body.oy then
		player.body.y = screen.mapHeight * screen.tileHeight - player.body.oy
	end

	-- Movement sounds
	if love.keyboard.isDown("up", "z", "down", "s", "left", "q", "right", "d") then
		player.sound[2]:play()
	else
		player.sound[2]:stop()
	end

	-- position de la tête
	player.head.x = player.body.x
	player.head.y = player.body.y


	-- rotation de la tête
	mouse.x, mouse.y = love.mouse.getPosition()
	if mouse.y > player.body.y then
		player.head.r = math.pi - math.acos((player.body.x - mouse.x) / player.Distance(player.body, mouse))
	else
		player.head.r = math.pi + math.acos((player.body.x - mouse.x) / player.Distance(player.body, mouse))
	end

	
	-- shooting system
	player.shootAnim.x = player.body.x + (player.head.img[player.head.currentImage]:getWidth() * math.cos(player.head.r))
	player.shootAnim.y = player.body.y + (player.head.img[player.head.currentImage]:getWidth() * math.sin(player.head.r))
	player.shootAnim.r = player.head.r
	player.shootAnim.ox = player.head.ox
	player.shootAnim.oy = player.shootAnim.img[player.shootAnim.currentImage]:getHeight() / 2

	-- shootAnim timer
	if player.shootAnim.timer > 0 then
		player.shootAnim.timer = player.shootAnim.timer - dt
		if player.shootAnim.timer <= 0 then
			player.shootAnim.isFiring = false
			player.shootAnim.timer = 0 -- inutile mais c'est plus propre
		end
	end

	-- origin of the projectile alternates between the canons
	player.projOrigin.x = player.body.x + (player.head.img[player.head.currentImage]:getWidth() * math.cos(player.head.r))
	player.projOrigin.y = player.body.y + (player.head.img[player.head.currentImage]:getWidth() * math.sin(player.head.r))
	player.projOrigin.r = player.head.r
	player.projOrigin.ox = player.head.ox
	player.projOrigin.oy = -5



end

---------------------------------------------------------------
-- Draw
---------------------------------------------------------------
function player.Draw()
	love.graphics.draw(
		player.body.img[player.body.currentImage],
		player.body.x, player.body.y, 
		player.body.r, 
		player.body.scale, player.body.scale,
		player.body.ox, player.body.oy
		)

	love.graphics.draw(
		player.head.img[player.head.currentImage],
		player.head.x, player.head.y, 
		player.head.r, 
		player.head.scale, player.head.scale,
		player.head.ox, player.head.oy
		)

	if player.shootAnim.isFiring == true then
      love.graphics.draw(
        player.shootAnim.img[player.shootAnim.currentImage], 
        player.shootAnim.x, player.shootAnim.y, 
        player.shootAnim.r, 
        player.shootAnim.scale, player.shootAnim.scale, 
        player.shootAnim.ox, player.shootAnim.oy
        )
   end

   love.graphics.print(tostring(player.body.isSliding), 10, 20)

end

---------------------------------------------------------------
--Keypressed
---------------------------------------------------------------
function player.Keypressed(button)
	if player.shootAnim.mode[player.shootAnim.currentMode] == "single" then
		if button == 1 and 
			mouse.y < screen.mapHeight * screen.tileHeight and
			player.shootAnim.timer <= 0 then
				player.shootAnim.isFiring = false
				print("I'm Firing My Canon!")
				player.shootAnim.isFiring = true
				player.shootAnim.timer = 0.3
				local shootingSound = player.shootAnim.sound[1]
				shootingSound:stop()
				shootingSound:play()
				playerProj.Spawn(player.projOrigin)
		end
	end
end

return player
