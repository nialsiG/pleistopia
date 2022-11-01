local enemies = {}

function enemies.Load()
	player = require("player")

	turrets = {}
	tanks = {}

	pngTurretBase = love.graphics.newImage("images/turretBase.png")
	pngTurretHead = love.graphics.newImage("images/turretHead.png")

	pngTankBody = love.graphics.newImage("images/enemyBody.png")
	pngTankHead = love.graphics.newImage("images/enemyHead.png")

	function enemies.SpawnTurret(x, y)
		local newTurret = {}
        newTurret.x = x
        newTurret.y = y
        newTurret.rHead = math.pi
        newTurret.r = math.pi
        newTurret.ox = pngTurretBase:getWidth() / 2
		newTurret.oy = pngTurretBase:getHeight() / 2

        newTurret.isAlive = true

        table.insert(turrets, newTurret)
	end


	function enemies.SpawnTank(x, y)
		local newTank = {}
        newTank.x = x
        newTank.y = y
        newTank.rHead = - math.pi / 2
        newTank.r = - math.pi / 2
        newTank.ox = pngTankBody:getWidth() / 2
		  newTank.oy = pngTankBody:getHeight() / 2

        newTank.isAlive = true

        table.insert(tanks, newTank)
	end


end


function enemies.Update(dt)
	for i, t in ipairs(turrets) do
		if player.body.y > t.y then
			t.rHead = math.pi - math.acos((t.x - player.body.x) / Distance(t, player.body))
		else
			t.rHead = math.pi + math.acos((t.x - player.body.x) / Distance(t, player.body))
		end
	end

   for i, t in ipairs(tanks) do
		if player.body.y > t.y then
			t.rHead = math.pi - math.acos((t.x - player.body.x) / Distance(t, player.body))
		else
			t.rHead = math.pi + math.acos((t.x - player.body.x) / Distance(t, player.body))
		end
   end

end


function enemies.Draw()
	for i, t in ipairs(turrets) do
         love.graphics.draw(pngTurretBase, t.x, t.y, t.r, 1, 1, t.ox, t.oy)
         love.graphics.draw(pngTurretHead, t.x, t.y, t.rHead, 1, 1, pngTurretHead:getWidth() / 3, pngTurretHead:getHeight() / 2)
      end

    for i, t in ipairs(tanks) do
       love.graphics.draw(pngTankBody, t.x, t.y, t.r, 1, 1, t.ox, t.oy)
       love.graphics.draw(pngTankHead, t.x, t.y, t.rHead, 1, 1, pngTankHead:getWidth() / 4, pngTankHead:getHeight() / 2)
    end
end

return enemies