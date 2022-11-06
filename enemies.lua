local enemies = {}

	player = require("player")

	turrets = {}
	tanks = {}

	pngTurretBase = love.graphics.newImage("images/turretBase.png")
	pngTurretHead = love.graphics.newImage("images/turretHead.png")

	pngTankBody = love.graphics.newImage("images/enemyBody.png")
	pngTankHead = love.graphics.newImage("images/enemyHead.png")

	tankCollidePlayer = false
	turretCollidePlayer = false

	function enemies.SpawnTurret(x, y)
		local newTurret = {}
      newTurret.x = x
      newTurret.y = y
      newTurret.rHead = math.pi
      newTurret.r = math.pi
      newTurret.ox = pngTurretBase:getWidth() / 2
		newTurret.oy = pngTurretBase:getHeight() / 2
		-- Health
		newTurret.hp = 3
      newTurret.isAlive = true
      -- Export game object
      table.insert(turrets, newTurret)
      return newTurret
	end


	function enemies.SpawnTank(x, y)
		local newTank = {}
      newTank.x = x
      newTank.y = y
      newTank.rHead = - math.pi / 2
      newTank.r = - math.pi / 2
      newTank.ox = pngTankBody:getWidth() / 2
		newTank.oy = pngTankBody:getHeight() / 2
		-- Health
		newTank.hp = 5
      newTank.isAlive = true
		-- Export game object
      table.insert(tanks, newTank)
      return newTank
	end


function enemies.Update(dt)
	for i, t in ipairs(turrets) do
		if player.body.y > t.y then
			t.rHead = math.pi - math.acos((t.x - player.body.x) / player.Distance(t, player.body))
		else
			t.rHead = math.pi + math.acos((t.x - player.body.x) / player.Distance(t, player.body))
		end

		--health
		if t.hp <= 0 then
			t.isAlive = false
		end
	end


   for i, t in ipairs(tanks) do
		--head movement
		if player.body.y > t.y then
			t.rHead = math.pi - math.acos((t.x - player.body.x) / player.Distance(t, player.body))
		else
			t.rHead = math.pi + math.acos((t.x - player.body.x) / player.Distance(t, player.body))
		end

		--health
		if t.hp <= 0 then
			t.isAlive = false
		end
   end


   if love.keyboard.isDown("f2") then
   	tanks[1].hp = tanks[1].hp - 1
   end

   if love.keyboard.isDown("f3") then
   	turrets[1].hp = turrets[1].hp - 1
   end


   -- collision with player
	for i, t in ipairs(tanks) do
	      if player.Distance(t, player.nextPosition) < pngTankBody:getWidth() - 2 then
	          tankCollidePlayer = true
	          break
	      else
	      	tankCollidePlayer = false
	      end
  	end

	for i, t in ipairs(turrets) do
	      if player.Distance(t, player.nextPosition) < pngTurretBase:getWidth() - 2 then
	          turretCollidePlayer = true
	          break
	      else
	      	turretCollidePlayer = false
	      end	
   end

   if tankCollidePlayer == true or turretCollidePlayer == true then
   	player.isCollided = true
   else
   	player.isCollided = false
   end

end



function enemies.Draw()
	for i, t in ipairs(turrets) do
         love.graphics.draw(pngTurretBase, t.x, t.y, t.r, 1, 1, t.ox, t.oy)
         love.graphics.draw(pngTurretHead, t.x, t.y, t.rHead, 1, 1, pngTurretHead:getWidth() / 3, pngTurretHead:getHeight() / 2)
      end
	for i = #turrets, 1, -1 do
    	if turrets[i].isAlive == false then
    		love.graphics.setColor(0.5, 0, 0)
    	end 
      love.graphics.draw(pngTurretBase, turrets[i].x, turrets[i].y, turrets[i].r, 1, 1, turrets[i].ox, turrets[i].oy)
      love.graphics.draw(pngTurretHead, turrets[i].x, turrets[i].y, turrets[i].rHead, 1, 1, pngTurretHead:getWidth() / 4, pngTurretHead:getHeight() / 2)
      
      love.graphics.setColor(0.5, 0, 0)
      love.graphics.print(tostring(turrets[i].hp), 10, 40 + 10 * i)
      love.graphics.print(tostring(turrets[i].isAlive), 10, 50 + 10 * i)
      love.graphics.setColor(1, 1, 1)
   end

   for i = #tanks, 1, -1 do
    	if tanks[i].isAlive == false then
    		love.graphics.setColor(0.5, 0, 0)
    	end 
      love.graphics.draw(pngTankBody, tanks[i].x, tanks[i].y, tanks[i].r, 1, 1, tanks[i].ox, tanks[i].oy)
      love.graphics.draw(pngTankHead, tanks[i].x, tanks[i].y, tanks[i].rHead, 1, 1, pngTankHead:getWidth() / 4, pngTankHead:getHeight() / 2)
      
      love.graphics.setColor(0.5, 0, 0)
      love.graphics.print(tostring(tanks[i].hp), 10, 20 + 10 * i)
      love.graphics.print(tostring(tanks[i].isAlive), 10, 30 + 10 * i)
      love.graphics.setColor(1, 1, 1)
   end
end

return enemies