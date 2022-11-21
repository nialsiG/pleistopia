-- HUD elements
ui = require("ui")
mouse = {}

local player = {}

-- body
player.x = 0
player.y = 0
player.r = 0
player.img = {}
player.img[1] = love.graphics.newImage("images/playerBody.png")
player.currentImage = 1
player.scale = 1
player.ox = player.img[player.currentImage]:getWidth()/2
player.oy = player.img[player.currentImage]:getHeight()/2

-- head
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
player.shootAnim.currentImage = 1
player.shootAnim.ox = 0
player.shootAnim.oy = 0
player.shootAnim.isFiring = false
player.shootAnim.timer = 0
player.shootingRange = 250

-- origin of the projectiles
player.projOrigin = {}
player.projOrigin.x = 0
player.projOrigin.y = 0
player.projOrigin.r = 0
player.projOrigin.ox = 0
player.projOrigin.oy = 0

-- flickering animation
player.flickTimer = 0
player.isVisible = true

-- warping animation
player.timeWarping = true
player.color = {}
player.color.r = 1
player.color.b = 1
player.color.g = 0
player.color.alpha = 0

-- collision
player.isCollided = false
player.nextPosition = {}
player.nextPosition.x = 0
player.nextPosition.y = 0
player.objectToTile = false

-- bounding box
player.bBox = {}
for i = 1, 8 do 
	local newPoint = {x = 0, y = 0}
	table.insert(player.bBox, newPoint)
end

-- level transition
player.touchRightBorder = false
player.touchLeftBorder = false
player.touchTopBorder = false
player.touchBotBorder = false

-- Speed
player.isSliding = false
player.velocity = 1
player.speedType = {}
player.speedType["normal"] = 175
player.speedType["snow"] = 75
player.speed = player.speedType["normal"]
player.turnSpeed = 3

-- sound
player.sound = {}
player.sound[2] = love.audio.newSource("sounds/TankIdle.wav", "static")
player.sound[1] = love.audio.newSource("sounds/tank_medium_idle.wav", "static")
player.engineSound = player.sound[1]
player.engineSound:setLooping(true)
player.engineSound:setVolume(0.4)
player.sound[2]:setVolume(0.5)
player.soundWarp = love.audio.newSource("sounds/400126__harrietniamh__sci-fi-warp.wav", "static")
player.shootAnim.sound = {}
player.shootAnim.sound[1] = love.audio.newSource("sounds/tank-fire-mixed.mp3", "static")

function player.Distance(source, target)
	local x = target.x - source.x
	local y = target.y - source.y
	norme = math.sqrt((x * x) + (y * y))
	return(norme)
end

function player.TextureDetect(object, map, tileType, dt)
  	-- detect if object moves over a texture
    local col = math.floor((object.x + object.ox) / ui.tileWidth) + 1
    local row = math.floor(object.y / ui.tileHeight) + 1
   	local coord = map.top[row][col]

   	-- snow and ice tiles
  	if tileType[coord] == "snow" then
    	object.speed = object.speedType["snow"]
 	else
    	object.speed = object.speedType["normal"]
  	end
    if tileType[coord] == "ice" then
		object.isSliding = true
		else
  		object.isSliding = false
	end

	-- detect if object collides a texture
  	for i = 1, #object.bBox do
  		local nextCol = math.floor(object.bBox[i].x / ui.tileWidth) + 1
  		local nextRow = math.floor(object.bBox[i].y / ui.tileHeight) + 1
  		local nextCoord = map.top[nextRow][nextCol]
		if 	tileType[nextCoord] == "rock" or 
			tileType[nextCoord] == "cliff" or 
			tileType[nextCoord] == "tree" then
  			object.objectToTile = true
  			break
    	else
  			object.objectToTile = false
    	end
  	end


end

---------------------------------------------------------------
function player.Load(x, y)
	projectiles = require("projectiles")

	player.x = x
	player.y = y

	if player.timeWarping == true then
		player.color.g = 0
		player.color.alpha = 0
		player.soundWarp:stop()
		player.soundWarp:play()
	else
		player.color.g = 1
		player.color.alpha = 1
	end

	player.engineSound:play()
end

---------------------------------------------------------------
function player.Update(map, tileType, dt)
	-- déplacement futur
	player.nextPosition.x = player.x + math.cos(player.r) * player.velocity
	player.nextPosition.y = player.y + math.sin(player.r) * player.velocity

	-- déplacement
	if love.keyboard.isDown("up", "z") then
		-- déplacement sur glace
		if player.isSliding == true and player.velocity < (player.speed * 1.2 * dt) then
    		player.velocity = player.velocity + 1.5 * dt
    	elseif player.isSliding == true and player.velocity >= (player.speed * 1.2 * dt) then
    		player.velocity = player.speed * 1.2 * dt
    	elseif player.isSliding == false then
    		player.velocity = player.speed * dt
		end
		player.sound[2]:play()

	elseif love.keyboard.isDown("down", "s") then
		-- déplacement sur glace
		if player.isSliding == true and player.velocity > (- player.speed * 1.2 * dt) then
    		player.velocity = player.velocity - 1.5 * dt
    	elseif player.isSliding == true and player.velocity <= (- player.speed * 1.2 * dt) then
    		player.velocity = (- player.speed * 1.2 * dt)
    	elseif player.isSliding == false then
    		player.velocity = - player.speed * dt
		end
		if player.velocity < -player.speed then
			player.velocity = -player.speed
		end
		player.sound[2]:play()

	else
		if player.velocity > 0.1 and player.isSliding == true then
			player.velocity = player.velocity - dt 
		elseif player.velocity < - 0.1 and player.isSliding == true then
			player.velocity = player.velocity + dt
		else
			player.velocity = 0
		end
		player.sound[2]:stop()
	end
	
	-- tourner à gauche
	if love.keyboard.isDown("left", "q") then
		player.ox = 0
		player.oy = 0
		player.r = player.r - player.turnSpeed * dt
		player.ox = player.img[player.currentImage]:getWidth() / 2
		player.oy = player.img[player.currentImage]:getHeight() / 2
	end
	-- tourner à droite
	if love.keyboard.isDown("right", "d") then
		player.ox = player.img[player.currentImage]:getWidth()
		player.oy = player.img[player.currentImage]:getWidth()
		player.r = player.r + player.turnSpeed * dt
		player.ox = player.img[player.currentImage]:getWidth() / 2
		player.oy = player.img[player.currentImage]:getHeight() / 2
	end

	-- boundaries
	player.touchLeftBorder = false
	player.touchRightBorder = false
	player.touchTopBorder = false
	player.touchBotBorder = false
	if player.nextPosition.x <= 0 + player.ox then
		player.touchLeftBorder = true
		player.nextPosition.x = 0 + player.ox
	end
	if player.nextPosition.x >= ui.mapWidth * ui.tileWidth - player.ox then
		player.touchRightBorder = true
		player.nextPosition.x = ui.mapWidth * ui.tileWidth - player.ox
	end
	if player.nextPosition.y <= 0 + player.oy + 5 then
		player.touchTopBorder = true
		player.nextPosition.y = 0 + player.oy + 5
	end
	if player.nextPosition.y >= ui.mapHeight * ui.tileHeight - player.oy - 5 then
		player.touchBotBorder = true
		player.nextPosition.y = ui.mapHeight * ui.tileHeight - player.oy - 5
	end

	-- next bounding box coordinates
	player.bBox[1].x = player.nextPosition.x - math.cos(player.r) * (player.ox - 10)
	player.bBox[1].y = player.nextPosition.y - math.sin(player.r) * (player.oy - 10)
	player.bBox[2].x = player.nextPosition.x + math.sin(player.r) * (player.ox - 10)
	player.bBox[2].y = player.nextPosition.y - math.cos(player.r) * (player.oy - 10)
	player.bBox[3].x = player.nextPosition.x + math.cos(player.r) * (player.ox - 10)
	player.bBox[3].y = player.nextPosition.y + math.sin(player.r) * (player.oy - 10)
	player.bBox[4].x = player.nextPosition.x - math.sin(player.r) * (player.ox - 10)
	player.bBox[4].y = player.nextPosition.y + math.cos(player.r) * (player.oy - 10)

	player.bBox[5].x = player.nextPosition.x - math.cos(player.r) * (player.ox - 15) - math.sin(player.r) * (player.ox - 15)
	player.bBox[5].y = player.nextPosition.y - math.sin(player.r) * (player.oy - 15) + math.cos(player.r) * (player.oy - 15)
	player.bBox[6].x = player.nextPosition.x - math.cos(player.r) * (player.ox - 15) + math.sin(player.r) * (player.ox - 15)
	player.bBox[6].y = player.nextPosition.y - math.sin(player.r) * (player.oy - 15) - math.cos(player.r) * (player.oy - 15)
	player.bBox[7].x = player.nextPosition.x + math.sin(player.r) * (player.ox - 15) + math.cos(player.r) * (player.ox - 15)
	player.bBox[7].y = player.nextPosition.y - math.cos(player.r) * (player.oy - 15) + math.sin(player.r) * (player.oy - 15)
	player.bBox[8].x = player.nextPosition.x + math.cos(player.r) * (player.ox - 15) - math.sin(player.r) * (player.ox - 15)
	player.bBox[8].y = player.nextPosition.y + math.sin(player.r) * (player.oy - 15) + math.cos(player.r) * (player.oy - 15)

	-- détection des collisions
	player.TextureDetect(player, map, tileType, dt)
	--player.isCollided = false
	if enemies.tankCollidePlayer == true or enemies.turretCollidePlayer == true or player.objectToTile == true then
		player.isCollided = true
	elseif player.timeWarping == true then
		player.isCollided = true
	else
		player.isCollided = false
	end

    -- déplacement si aucune collision
    if player.isCollided == false then
    	player.x = player.nextPosition.x
    	player.y = player.nextPosition.y
	end

	-- position de la tête
	player.head.x = player.x
	player.head.y = player.y

	-- rotation de la tête
	mouse.x, mouse.y = love.mouse.getPosition()
	if mouse.y > player.y then
		player.head.r = math.pi - math.acos((player.x - mouse.x) / player.Distance(player, mouse))
	else
		player.head.r = math.pi + math.acos((player.x - mouse.x) / player.Distance(player, mouse))
	end
	
	-- shooting system
	player.shootAnim.x = player.x + (player.head.img[player.head.currentImage]:getWidth() * math.cos(player.head.r))
	player.shootAnim.y = player.y + (player.head.img[player.head.currentImage]:getWidth() * math.sin(player.head.r))
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

	-- origin of the projectiles
	player.projOrigin.x = player.x + (player.head.img[player.head.currentImage]:getWidth() * math.cos(player.head.r))
	player.projOrigin.y = player.y + (player.head.img[player.head.currentImage]:getWidth() * math.sin(player.head.r))
	player.projOrigin.r = player.head.r
	player.projOrigin.ox = player.head.ox
	player.projOrigin.oy = 0

    -- invincibility
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

    if ui.lifeManager.timer > 0 then
        ui.lifeManager.timer = ui.lifeManager.timer - dt
        ui.lifeManager.isInvincible = true
    else 
    	ui.lifeManager.isInvincible = false
        player.isVisible = true
    end

    -- time warp animation
 	if player.color.alpha < 1 then
    	player.color.alpha = player.color.alpha + dt / 2
    else
    	player.color.alpha = 1
    end
	if player.color.g < 1 then
    	player.color.g = player.color.g + dt / 2
    else
    	player.color.g = 1
    	player.timeWarping = false
    end
    -- disable player while time warping
    if player.timeWarping == true then
		player.isCollided = true
		player.shootAnim.timer = 0.1
	end

end

---------------------------------------------------------------
function player.Draw()
	love.graphics.setColor(player.color.r, player.color.g, player.color.b, player.color.alpha)
	love.graphics.draw(
		player.img[player.currentImage],
		player.x, player.y, 
		player.r, 
		player.scale, player.scale,
		player.ox, player.oy
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

   	--[[for i = 1, #player.bBox do
   		if i <= 4 then 
   			love.graphics.setColor(0.2 * i, 0, 0, 1)
   		else
   			love.graphics.setColor(1, 0, 0.2 * (i - 4), 1)
   		end
	   	love.graphics.circle("fill", player.bBox[i].x, player.bBox[i].y, 2)
	end
	love.graphics.setColor(1,1,1,1)]]

end

---------------------------------------------------------------
function player.Keypressed(button)
	if button == 1 and 
	mouse.y < ui.mapHeight * ui.tileHeight and
	player.shootAnim.timer <= 0 then
		--player.shootAnim.isFiring = false
		print("I'm Firing My Canon!")
		player.shootAnim.isFiring = true
		player.shootAnim.timer = 0.3
		local shootingSound = player.shootAnim.sound[1]
		shootingSound:stop()
		shootingSound:play()
		projectiles.Spawn(player.projOrigin, "tank", "friendly")
	end
end

return player
