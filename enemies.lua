local enemies = {}

player = require("player")
projectiles = require("projectiles")
ui = require("ui")

enemies.detectRange = 300
enemies.shootingRange = 160
enemies.detectRangeMammoths = 300

enemies.turrets = {}
enemies.tanks = {}
enemies.mammoths = {}

enemies.pngTurretBase = love.graphics.newImage("images/turretBase.png")
enemies.pngTurretHead = love.graphics.newImage("images/turretHead.png")
enemies.pngTankBody = love.graphics.newImage("images/enemyBody.png")
enemies.pngTankHead = love.graphics.newImage("images/enemyHead.png")
enemies.pngMammoth1 = love.graphics.newImage("images/woollyMammoth1.png")
enemies.pngMammoth2 = love.graphics.newImage("images/woollyMammoth2.png")

enemies.soundWarp = love.audio.newSource("sounds/400126__harrietniamh__sci-fi-warp.wav", "static")
enemies.soundFire1 = love.audio.newSource("sounds/tank-fire-mixed.mp3", "static")
enemies.soundElephant1 = love.audio.newSource("sounds/139052__jasher70__elephant-scream.wav", "static")
enemies.soundElephant2 = love.audio.newSource("sounds/139875__y89312__44.wav", "static")

enemies.tankCollidePlayer = false
enemies.turretCollidePlayer = false
enemies.mammothCollidePlayer = false

function enemies.TargetPlayer(source)
	if player.y > source.y then
		source.rHead = math.pi - math.acos((source.x - player.x) / player.Distance(source, player))
	else
		source.rHead = math.pi + math.acos((source.x - player.x) / player.Distance(source, player))
	end
end

function enemies.SpawnTurret(x, y, state, angle)
	-- default
	if angle == nil then
		angle = 0
	end
	-- Update mob counter
	ui.currentMob = ui.currentMob + 1
	ui.maxMob = ui.maxMob + 1
	-- Create mob
	local newTurret = {}
   newTurret.x = x
   newTurret.y = y
   newTurret.r = angle
   newTurret.rHead = newTurret.r

   newTurret.ox = enemies.pngTurretBase:getWidth() / 2
	newTurret.oy = enemies.pngTurretBase:getHeight() / 2
	-- Health
	newTurret.hp = 3
   newTurret.isAlive = true
   newTurret.timer = 0
   -- Behavior
   newTurret.state = state
   -- Colors (for dead state)
   newTurret.color = {}
   newTurret.color.r = 1
   newTurret.color.g = 1
   newTurret.color.b = 1
   newTurret.color.alpha = 1
	-- shooting
   newTurret.shootAnim = {}
	newTurret.shootAnim.isFiring = false
	newTurret.shootAnim.timer = 0
   -- Export game object
   table.insert(enemies.turrets, newTurret)
end

function enemies.SpawnTank(x, y, state, angle)
	-- default
	if angle == nil then
		angle = 0
	end
	-- Update counter
	ui.currentMob = ui.currentMob + 1
	ui.maxMob = ui.maxMob + 1
	-- Create mob
	local newTank = {}
   newTank.x = x
   newTank.y = y
   newTank.r = angle
   newTank.rHead = newTank.r
   newTank.ox = enemies.pngTankBody:getWidth() / 2
	newTank.oy = enemies.pngTankBody:getHeight() / 2
	-- Health
	newTank.hp = 4
   newTank.isAlive = true
   newTank.timer = 0
   -- Behavior
   newTank.state = state
   -- Colors (for warp/dead states)
   newTank.color = {}
   newTank.color.r = 1
   newTank.color.b = 1
   if state == "warp" then
   	newTank.color.g = 0
   	newTank.color.alpha = 0
   else
   	newTank.color.g = 1
   	newTank.color.alpha = 1
   end
   -- shooting
   newTank.shootAnim = {}
	newTank.shootAnim.isFiring = false
	newTank.shootAnim.timer = 0
   -- bounding box
	newTank.bBox = {}
	for i = 1, 8 do 
		local newPoint = {x = 0, y = 0}
		table.insert(newTank.bBox, newPoint)
	end
	-- collisions
   newTank.isCollided = false
   newTank.nextPosition = {}
	newTank.nextPosition.x = newTank.x
	newTank.nextPosition.y = newTank.y
	newTank.objectToTile = false
	newTank.isSliding = false
	newTank.velocity = 1
	newTank.speedType = {}
	newTank.speedType["normal"] = 75
	newTank.speedType["snow"] = 50
	newTank.speed = newTank.speedType["normal"]
	
	-- Export game object
   table.insert(enemies.tanks, newTank)
end

function enemies.SpawnMammoth(x, y, state, angle)
		-- default
		if angle == nil then
			angle = 0
		end
		-- Update counter
		ui.currentMob = ui.currentMob + 1
		ui.maxMob = ui.maxMob + 1
		-- Create mob
		local newMammoth = {}
		newMammoth.x = x
      newMammoth.y = y
      newMammoth.rHead = angle
      newMammoth.ox = enemies.pngTankBody:getWidth() / 2
		newMammoth.oy = enemies.pngTankBody:getHeight() / 2
		-- Health
		newMammoth.hp = 3
      newMammoth.isAlive = true
      newMammoth.timer = 0
      -- Behavior
      newMammoth.state = state
      -- Colors (for dead states)
      newMammoth.color = {}
      newMammoth.color.r = 1
      newMammoth.color.g = 1
      newMammoth.color.b = 1
      newMammoth.color.alpha = 1
      -- sound
      newMammoth.sound = {}
      newMammoth.sound[1] = enemies.soundElephant1
      newMammoth.sound[2] = enemies.soundElephant2
      newMammoth.soundCurrent = 1
      newMammoth.soundTimer = 0
      -- animation
      newMammoth.img = {}
      newMammoth.img[1] = enemies.pngMammoth1
      newMammoth.img[2] = enemies.pngMammoth2
      newMammoth.imgCurrent = 1
      newMammoth.imgTimer = 0
      -- bounding box = only the head
		newMammoth.bBox = {}
		for i = 1, 8 do 
			local newPoint = {x = 0, y = 0}
			table.insert(newMammoth.bBox, newPoint)
		end
		-- collisions
      newMammoth.isCollided = false
      newMammoth.nextPosition = {}
		newMammoth.nextPosition.x = newMammoth.x
		newMammoth.nextPosition.y = newMammoth.y
		newMammoth.objectToTile = false
		--newMammoth.isSliding = false
		--newMammoth.velocity = 1
		newMammoth.speedType = {}
		newMammoth.speedType["normal"] = 65
		newMammoth.speedType["snow"] = 65
		newMammoth.speed = newMammoth.speedType["normal"]
		-- Export game object
      table.insert(enemies.mammoths, newMammoth)
end

-----------------------------------
function enemies.Update(tileType, map, dt)
	
   --update tanks
   for i = 1, #enemies.tanks do
   	-- states: "idle", "warp", "chase", "shoot", "dead"
   	if enemies.tanks[i].state == "idle" and player.Distance(enemies.tanks[i], player) <= enemies.detectRange then
   		enemies.tanks[i].state = "chase"
		
		elseif enemies.tanks[i].state == "warp" then
			if enemies.tanks[i].color.alpha == 0 then
				print("play warp sound")
				enemies.soundWarp:stop()
				enemies.soundWarp:play()
			end
			if enemies.tanks[i].color.alpha < 1 then
				enemies.tanks[i].color.alpha = enemies.tanks[i].color.alpha + dt / 2
			else
				enemies.tanks[i].color.alpha = 1
			end
			if enemies.tanks[i].color.g < 1 then
				enemies.tanks[i].color.g = enemies.tanks[i].color.g + dt / 2
			else
				enemies.tanks[i].color.g = 1
			end			
			if enemies.tanks[i].color.alpha == 1 and enemies.tanks[i].color.g == 1 then
				enemies.tanks[i].state = "idle"
			end
		
		elseif enemies.tanks[i].state == "chase" then
   		enemies.TargetPlayer(enemies.tanks[i])
   		-- move
   		enemies.tanks[i].r = enemies.tanks[i].rHead
			-- déplacement futur
			enemies.tanks[i].nextPosition.x = enemies.tanks[i].x + (math.cos(enemies.tanks[i].r) * enemies.tanks[i].speed * dt)
   		enemies.tanks[i].nextPosition.y = enemies.tanks[i].y + (math.sin(enemies.tanks[i].r) * enemies.tanks[i].speed * dt)
			-- next bounding box coordinates
			enemies.tanks[i].bBox[1].x = enemies.tanks[i].nextPosition.x - math.cos(enemies.tanks[i].r) * (enemies.tanks[i].ox - 10)
			enemies.tanks[i].bBox[1].y = enemies.tanks[i].nextPosition.y - math.sin(enemies.tanks[i].r) * (enemies.tanks[i].oy - 10)
			enemies.tanks[i].bBox[2].x = enemies.tanks[i].nextPosition.x + math.sin(enemies.tanks[i].r) * (enemies.tanks[i].ox - 10)
			enemies.tanks[i].bBox[2].y = enemies.tanks[i].nextPosition.y - math.cos(enemies.tanks[i].r) * (enemies.tanks[i].oy - 10)
			enemies.tanks[i].bBox[3].x = enemies.tanks[i].nextPosition.x + math.cos(enemies.tanks[i].r) * (enemies.tanks[i].ox - 10)
			enemies.tanks[i].bBox[3].y = enemies.tanks[i].nextPosition.y + math.sin(enemies.tanks[i].r) * (enemies.tanks[i].oy - 10)
			enemies.tanks[i].bBox[4].x = enemies.tanks[i].nextPosition.x - math.sin(enemies.tanks[i].r) * (enemies.tanks[i].ox - 10)
			enemies.tanks[i].bBox[4].y = enemies.tanks[i].nextPosition.y + math.cos(enemies.tanks[i].r) * (enemies.tanks[i].oy - 10)
			enemies.tanks[i].bBox[5].x = enemies.tanks[i].nextPosition.x - math.cos(enemies.tanks[i].r) * (enemies.tanks[i].ox - 15) - math.sin(enemies.tanks[i].r) * (enemies.tanks[i].ox - 15)
			enemies.tanks[i].bBox[5].y = enemies.tanks[i].nextPosition.y - math.sin(enemies.tanks[i].r) * (enemies.tanks[i].oy - 15) + math.cos(enemies.tanks[i].r) * (enemies.tanks[i].oy - 15)
			enemies.tanks[i].bBox[6].x = enemies.tanks[i].nextPosition.x - math.cos(enemies.tanks[i].r) * (enemies.tanks[i].ox - 15) + math.sin(enemies.tanks[i].r) * (enemies.tanks[i].ox - 15)
			enemies.tanks[i].bBox[6].y = enemies.tanks[i].nextPosition.y - math.sin(enemies.tanks[i].r) * (enemies.tanks[i].oy - 15) - math.cos(enemies.tanks[i].r) * (enemies.tanks[i].oy - 15)
			enemies.tanks[i].bBox[7].x = enemies.tanks[i].nextPosition.x + math.sin(enemies.tanks[i].r) * (enemies.tanks[i].ox - 15) + math.cos(enemies.tanks[i].r) * (enemies.tanks[i].ox - 15)
			enemies.tanks[i].bBox[7].y = enemies.tanks[i].nextPosition.y - math.cos(enemies.tanks[i].r) * (enemies.tanks[i].oy - 15) + math.sin(enemies.tanks[i].r) * (enemies.tanks[i].oy - 15)
			enemies.tanks[i].bBox[8].x = enemies.tanks[i].nextPosition.x + math.cos(enemies.tanks[i].r) * (enemies.tanks[i].ox - 15) - math.sin(enemies.tanks[i].r) * (enemies.tanks[i].ox - 15)
			enemies.tanks[i].bBox[8].y = enemies.tanks[i].nextPosition.y + math.sin(enemies.tanks[i].r) * (enemies.tanks[i].oy - 15) + math.cos(enemies.tanks[i].r) * (enemies.tanks[i].oy - 15)
         -- collision
			player.TextureDetect(enemies.tanks[i], tileType, map, dt)
	   	if enemies.tanks[i].objectToTile == true then
	      	enemies.tanks[i].isCollided = true
	   	else
	  			enemies.tanks[i].isCollided = false
	    	end
         -- déplacement si aucune collision
         if enemies.tanks[i].isCollided == false then
         	enemies.tanks[i].x = enemies.tanks[i].nextPosition.x
         	enemies.tanks[i].y = enemies.tanks[i].nextPosition.y         	
       	end
       	-- change state
			if player.Distance(enemies.tanks[i], player) <= enemies.shootingRange then
				enemies.tanks[i].state = "shoot"
			end

		elseif enemies.tanks[i].state == "shoot" then
			enemies.tanks[i].color.alpha = 1
   		enemies.tanks[i].color.g = 1
   		enemies.TargetPlayer(enemies.tanks[i])
   		-- shoot
   		if enemies.tanks[i].shootAnim.isFiring == false then
				print("Tank ", i, " fired!")
				enemies.tanks[i].shootAnim.isFiring = true
				local shootingSound = enemies.soundFire1
				shootingSound:stop()
				shootingSound:play()
				projectiles.Spawn(enemies.tanks[i], "tankRed", "foe")
			end
   		-- change state
			if player.Distance(enemies.tanks[i], player) > enemies.shootingRange then
				enemies.tanks[i].state = "chase"
			end

		elseif enemies.tanks[i].state == "dead" then 
			enemies.tanks[i].color.alpha = enemies.tanks[i].color.alpha - dt
   		enemies.tanks[i].color.r = 0.5
   		enemies.tanks[i].color.g = 0
   		enemies.tanks[i].color.b = 0
		end

		-- shoot timer
		if enemies.tanks[i].shootAnim.isFiring == true then
			enemies.tanks[i].shootAnim.timer = enemies.tanks[i].shootAnim.timer + dt
			if enemies.tanks[i].shootAnim.timer > 1 then
				enemies.tanks[i].shootAnim.isFiring = false
				enemies.tanks[i].shootAnim.timer = 0
			end
		end
   end

   -- update turrets
   for i = 1, #enemies.turrets do
	-- states: "idle", "shoot", "dead"
   	if enemies.turrets[i].state == "idle" then
   		if player.Distance(enemies.turrets[i], player) <= enemies.detectRange then
   			enemies.turrets[i].state = "shoot"
   		end

		elseif enemies.turrets[i].state == "shoot" then
			enemies.TargetPlayer(enemies.turrets[i])
			--shoot
			if enemies.turrets[i].shootAnim.isFiring == false then
				print("Turret ", i, " fired!")
				enemies.turrets[i].shootAnim.isFiring = true
				local shootingSound = enemies.soundFire1
				shootingSound:stop()
				shootingSound:play()
				projectiles.Spawn(enemies.turrets[i], "turret", "foe")
				projectiles.Spawn(enemies.turrets[i], "turret", "foe", math.pi / 16)
				projectiles.Spawn(enemies.turrets[i], "turret", "foe", - math.pi / 16)
			end
			if player.Distance(enemies.turrets[i], player) > enemies.detectRange then
				enemies.turrets[i].state = "idle"
			end

		elseif enemies.turrets[i].state == "dead" then
			enemies.turrets[i].color.alpha = enemies.turrets[i].color.alpha - dt
   		enemies.turrets[i].color.r = 0.5
   		enemies.turrets[i].color.g = 0
   		enemies.turrets[i].color.b = 0
		end

		-- shoot timer
		if enemies.turrets[i].shootAnim.isFiring == true then
			enemies.turrets[i].shootAnim.timer = enemies.turrets[i].shootAnim.timer + dt
			if enemies.turrets[i].shootAnim.timer > 0.5 then
				enemies.turrets[i].shootAnim.isFiring = false
				enemies.turrets[i].shootAnim.timer = 0
			end
		end
   end

   -- update mammoths
   for i = 1, #enemies.mammoths do
   	-- states: "idle", "chase", "dead"
   	if enemies.mammoths[i].state == "idle" then
   		if player.Distance(enemies.mammoths[i], player) <= enemies.detectRangeMammoths then
   			enemies.mammoths[i].state = "chase"
   		end

		elseif enemies.mammoths[i].state == "chase" then
			if player.Distance(enemies.mammoths[i].bBox[1], player) <= enemies.pngMammoth1:getWidth() / 2 + player.ox + 5 then
				enemies.mammoths[i].state = "attack"
			else
				enemies.TargetPlayer(enemies.mammoths[i])
	   		-- move
	   		enemies.mammoths[i].nextPosition.x = enemies.mammoths[i].x + (math.cos(enemies.mammoths[i].rHead) * enemies.mammoths[i].speed * dt)
	   		enemies.mammoths[i].nextPosition.y = enemies.mammoths[i].y + (math.sin(enemies.mammoths[i].rHead) * enemies.mammoths[i].speed * dt)
				enemies.mammoths[i].bBox[1].x = enemies.mammoths[i].nextPosition.x - math.cos(enemies.mammoths[i].rHead) * (enemies.mammoths[i].ox - 10)
				enemies.mammoths[i].bBox[1].y = enemies.mammoths[i].nextPosition.y - math.sin(enemies.mammoths[i].rHead) * (enemies.mammoths[i].oy - 10)
				enemies.mammoths[i].bBox[2].x = enemies.mammoths[i].nextPosition.x + math.sin(enemies.mammoths[i].rHead) * (enemies.mammoths[i].ox - 10)
				enemies.mammoths[i].bBox[2].y = enemies.mammoths[i].nextPosition.y - math.cos(enemies.mammoths[i].rHead) * (enemies.mammoths[i].oy - 10)
				enemies.mammoths[i].bBox[3].x = enemies.mammoths[i].nextPosition.x + math.cos(enemies.mammoths[i].rHead) * (enemies.mammoths[i].ox - 10)
				enemies.mammoths[i].bBox[3].y = enemies.mammoths[i].nextPosition.y + math.sin(enemies.mammoths[i].rHead) * (enemies.mammoths[i].oy - 10)
				enemies.mammoths[i].bBox[4].x = enemies.mammoths[i].nextPosition.x - math.sin(enemies.mammoths[i].rHead) * (enemies.mammoths[i].ox - 10)
				enemies.mammoths[i].bBox[4].y = enemies.mammoths[i].nextPosition.y + math.cos(enemies.mammoths[i].rHead) * (enemies.mammoths[i].oy - 10)
				enemies.mammoths[i].bBox[5].x = enemies.mammoths[i].nextPosition.x - math.cos(enemies.mammoths[i].rHead) * (enemies.mammoths[i].ox - 15) - math.sin(enemies.mammoths[i].rHead) * (enemies.mammoths[i].ox - 15)
				enemies.mammoths[i].bBox[5].y = enemies.mammoths[i].nextPosition.y - math.sin(enemies.mammoths[i].rHead) * (enemies.mammoths[i].oy - 15) + math.cos(enemies.mammoths[i].rHead) * (enemies.mammoths[i].oy - 15)
				enemies.mammoths[i].bBox[6].x = enemies.mammoths[i].nextPosition.x - math.cos(enemies.mammoths[i].rHead) * (enemies.mammoths[i].ox - 15) + math.sin(enemies.mammoths[i].rHead) * (enemies.mammoths[i].ox - 15)
				enemies.mammoths[i].bBox[6].y = enemies.mammoths[i].nextPosition.y - math.sin(enemies.mammoths[i].rHead) * (enemies.mammoths[i].oy - 15) - math.cos(enemies.mammoths[i].rHead) * (enemies.mammoths[i].oy - 15)
				enemies.mammoths[i].bBox[7].x = enemies.mammoths[i].nextPosition.x + math.sin(enemies.mammoths[i].rHead) * (enemies.mammoths[i].ox - 15) + math.cos(enemies.mammoths[i].rHead) * (enemies.mammoths[i].ox - 15)
				enemies.mammoths[i].bBox[7].y = enemies.mammoths[i].nextPosition.y - math.cos(enemies.mammoths[i].rHead) * (enemies.mammoths[i].oy - 15) + math.sin(enemies.mammoths[i].rHead) * (enemies.mammoths[i].oy - 15)
				enemies.mammoths[i].bBox[8].x = enemies.mammoths[i].nextPosition.x + math.cos(enemies.mammoths[i].rHead) * (enemies.mammoths[i].ox - 15) - math.sin(enemies.mammoths[i].rHead) * (enemies.mammoths[i].ox - 15)
				enemies.mammoths[i].bBox[8].y = enemies.mammoths[i].nextPosition.y + math.sin(enemies.mammoths[i].rHead) * (enemies.mammoths[i].oy - 15) + math.cos(enemies.mammoths[i].rHead) * (enemies.mammoths[i].oy - 15)
				-- collision
				player.TextureDetect(enemies.mammoths[i], tileType, map, dt)
		   	if enemies.mammoths[i].objectToTile == true then
		      	enemies.mammoths[i].isCollided = true
		   	else
		  			enemies.mammoths[i].isCollided = false
		    	end
	         -- déplacement si aucune collision
	         if enemies.mammoths[i].isCollided == false then
	         	enemies.mammoths[i].x = enemies.mammoths[i].nextPosition.x
	         	enemies.mammoths[i].y = enemies.mammoths[i].nextPosition.y         	
	       	end
	       	--animation
	       	enemies.mammoths[i].imgTimer = enemies.mammoths[i].imgTimer + dt
	       	if enemies.mammoths[i].imgTimer > 0.8 then
	       		enemies.mammoths[i].imgTimer = 0
	       		if enemies.mammoths[i].imgCurrent == 1 then
	       			enemies.mammoths[i].imgCurrent = 2
	       		else 
	       			enemies.mammoths[i].imgCurrent = 1
	       		end
	       	end

       	end

      elseif enemies.mammoths[i].state == "attack" then
			enemies.mammoths[i].soundCurrent = love.math.random(1, 2)
			if enemies.mammoths[i].soundTimer == 0 then 
				enemies.mammoths[i].sound[enemies.mammoths[i].soundCurrent]:stop()
				enemies.mammoths[i].sound[enemies.mammoths[i].soundCurrent]:play()
			end
			enemies.mammoths[i].soundTimer = enemies.mammoths[i].soundTimer + dt
			if enemies.mammoths[i].soundTimer > 1.5 then
				enemies.mammoths[i].soundTimer = 0
			end

			if player.Distance(enemies.mammoths[i].bBox[1], player) > enemies.pngMammoth1:getWidth() / 2 + player.ox then
				enemies.mammoths[i].state = "chase"
			end

		elseif enemies.mammoths[i].state == "dead" then
				enemies.mammoths[i].color.alpha = enemies.mammoths[i].color.alpha - dt
	   		enemies.mammoths[i].color.r = 0.5
	   		enemies.mammoths[i].color.g = 0
	   		enemies.mammoths[i].color.b = 0
		end			

   end

   -- collision with player
	for i, t in ipairs(enemies.tanks) do
	      if player.Distance(t, player.nextPosition) < enemies.pngTankBody:getWidth() then
	          enemies.tankCollidePlayer = true
	          break
	      else
	      	enemies.tankCollidePlayer = false
	      end
  	end

	for i, t in ipairs(enemies.turrets) do
	      if player.Distance(t, player.nextPosition) < enemies.pngTurretBase:getWidth() then
	          enemies.turretCollidePlayer = true
	          break
	      else
	      	enemies.turretCollidePlayer = false
	      end
   end

   for i, m in ipairs(enemies.mammoths) do
	      if player.Distance(m, player.nextPosition) < enemies.pngMammoth1:getWidth() / 2 + player.ox then
	         enemies.mammothCollidePlayer = true
	         break
	      else
	      	enemies.mammothCollidePlayer = false
	      end
  	end

   -- remove enemies
	for i = #enemies.tanks, 1, -1 do
		if enemies.tanks[i].hp <= 0 then
			enemies.tanks[i].isAlive = false
			enemies.tanks[i].state = "dead"
			enemies.tanks[i].timer = enemies.tanks[i].timer + dt
			if enemies.tanks[i].timer > 0.5 then
				table.remove(enemies.tanks, i)
				ui.currentMob = ui.currentMob - 1
			end
		end
	end
		
	for i = #enemies.turrets, 1, -1 do
		if enemies.turrets[i].hp <= 0 then
			enemies.turrets[i].isAlive = false
			enemies.turrets[i].state = "dead"
			enemies.turrets[i].timer = enemies.turrets[i].timer + dt
			if enemies.turrets[i].timer > 0.5 then
				table.remove(enemies.turrets, i)
				ui.currentMob = ui.currentMob - 1
			end
		end
	end

	for i = #enemies.mammoths, 1, -1 do
		if enemies.mammoths[i].hp <= 0 then
			enemies.mammoths[i].isAlive = false
			enemies.mammoths[i].state = "dead"
			enemies.mammoths[i].timer = enemies.mammoths[i].timer + dt
			if enemies.mammoths[i].timer > 0.5 then
				table.remove(enemies.mammoths, i)
				ui.currentMob = ui.currentMob - 1
			end
		end
	end

end

-----------------------------------
function enemies.Draw()
	for i = #enemies.turrets, 1, -1 do
    	if enemies.turrets[i].isAlive == false then
    		love.graphics.setColor(0.5, 0, 0)
    	end 
    	love.graphics.setColor(enemies.turrets[i].color.r, enemies.turrets[i].color.g, enemies.turrets[i].color.b, enemies.turrets[i].color.alpha)
      love.graphics.draw(enemies.pngTurretBase, enemies.turrets[i].x, enemies.turrets[i].y, enemies.turrets[i].r, 1, 1, enemies.turrets[i].ox, enemies.turrets[i].oy)
      love.graphics.draw(enemies.pngTurretHead, enemies.turrets[i].x, enemies.turrets[i].y, enemies.turrets[i].rHead, 1, 1, enemies.pngTurretHead:getWidth() / 4, enemies.pngTurretHead:getHeight() / 2)
      
      --[[debug
      love.graphics.setColor(0.5, 0, 0)
      love.graphics.setColor(0.3, 0, 0, 0.2)
		love.graphics.circle("fill", enemies.turrets[i].x, enemies.turrets[i].y, enemies.detectRange)
		love.graphics.setColor(0.3, 0, 0, 0.5)
		love.graphics.circle("line", enemies.turrets[i].x, enemies.turrets[i].y, enemies.shootingRange)]]
      love.graphics.setColor(1, 1, 1, 1)
   end

   for i = #enemies.tanks, 1, -1 do
    	if enemies.tanks[i].isAlive == false then
    		love.graphics.setColor(0.5, 0, 0)
    	end
    	love.graphics.setColor(enemies.tanks[i].color.r, enemies.tanks[i].color.g, enemies.tanks[i].color.b, enemies.tanks[i].color.alpha)
      love.graphics.draw(enemies.pngTankBody, enemies.tanks[i].x, enemies.tanks[i].y, enemies.tanks[i].r, 1, 1, enemies.tanks[i].ox, enemies.tanks[i].oy)
      love.graphics.draw(enemies.pngTankHead, enemies.tanks[i].x, enemies.tanks[i].y, enemies.tanks[i].rHead, 1, 1, enemies.pngTankHead:getWidth() / 4, enemies.pngTankHead:getHeight() / 2)
      --[[debug
      for j = 1, #enemies.tanks[i].bBox do
	   	love.graphics.circle("fill", enemies.tanks[i].bBox[j].x, enemies.tanks[i].bBox[j].y, 2)
		end]]

		--[[debug
      love.graphics.setColor(0.3, 0.3, 0, 0.2)
		love.graphics.circle("fill", enemies.tanks[i].x, enemies.tanks[i].y, enemies.detectRange)
		love.graphics.setColor(0.3, 0, 0, 0.5)
		love.graphics.circle("line", enemies.tanks[i].x, enemies.tanks[i].y, enemies.shootingRange)]]
      love.graphics.setColor(1, 1, 1, 1)
   end

   for i = #enemies.mammoths, 1, -1 do
    	if enemies.mammoths[i].isAlive == false then
    		love.graphics.setColor(0.5, 0, 0)
    	end
    	love.graphics.setColor(enemies.mammoths[i].color.r, enemies.mammoths[i].color.g, enemies.mammoths[i].color.b, enemies.mammoths[i].color.alpha)
      love.graphics.draw(enemies.mammoths[i].img[enemies.mammoths[i].imgCurrent], enemies.mammoths[i].x, enemies.mammoths[i].y, enemies.mammoths[i].rHead, 1, 1, enemies.mammoths[i].ox, enemies.mammoths[i].oy)
      --[[debug
      for j = 1, #enemies.mammoths[i].bBox do
	   	love.graphics.circle("fill", enemies.mammoths[i].bBox[j].x, enemies.mammoths[i].bBox[j].y, 2)
		end

		--debug
      love.graphics.setColor(0.3, 0.3, 0, 0.2)
		love.graphics.circle("fill", enemies.mammoths[i].x, enemies.mammoths[i].y, enemies.detectRangeMammoths)]]
      love.graphics.setColor(1, 1, 1, 1)

   end


end

return enemies