local boss = {}
local dialog = require("dialog")
local enemies = require("enemies")
projectiles = require("projectiles")

boss.imgHead = love.graphics.newImage("images/bossHead.png")
boss.imgBody = love.graphics.newImage("images/bossBody.png")
boss.imgTurret = love.graphics.newImage("images/bossTurret.png")
boss.soundWarp = love.audio.newSource("sounds/400126__harrietniamh__sci-fi-warp.wav", "static")
boss.soundWarp:setPitch(0.7)
boss.music = love.audio.newSource("sounds/563729__hutyl__multi-chord-remix-davejf.mp3", "stream")
boss.music:setLooping(true)
boss.shootingSound = love.audio.newSource("sounds/tank-fire-mixed.mp3", "static")

-- Health
boss.hpMax = 30
boss.isAlive = false
boss.anger = 1
boss.state = "hidden"

function boss.Load()
	boss.x = 15*32
	boss.y = 3*32
	boss.ox = boss.imgBody:getWidth() / 2
	boss.oy = boss.imgBody:getHeight() / 2

	boss.color = {}
	boss.color.r = 1
	boss.color.b = 1
	boss.color.g = 0
	boss.color.alpha = 0

	boss.head = {}
	boss.head.x = boss.x
	boss.head.y = boss.y
	boss.head.rHead = math.pi/2
	boss.head.ox = boss.imgHead:getWidth() / 3
	boss.head.oy = boss.imgHead:getHeight() / 2
	boss.head.isFiring = false
	boss.head.timer = 0

	boss.turrets = {}
	for i = 1, 2 do
		boss.turrets[i] = {}
		for j = 1, 2 do
			boss.turrets[i][j] = {}
			boss.turrets[i][j].x = boss.x - 35 + (70 * (i - 1))
			boss.turrets[i][j].y = boss.y - 35 + (75 * (j - 1))
			boss.turrets[i][j].rHead = math.pi/2
			boss.turrets[i][j].ox = boss.imgTurret:getWidth() / 3
			boss.turrets[i][j].oy = boss.imgTurret:getHeight() / 2
			boss.turrets[i][j].isFiring = false
			boss.turrets[i][j].timer = 0
		end
	end

	-- Health
	boss.hp = boss.hpMax
	boss.isAlive = true
	boss.hpTimer = 0
	boss.phaseTimer = 0
	boss.anger = 1
	boss.state = "hidden"

	ui.currentMob = 1
    ui.maxMob = 1
end

-----------------------------------
function boss.Update(dt)
	-- anger
	if boss.hp < boss.hpMax / 2 then
		boss.anger = 2
	end

	-- states
	if boss.state == "hidden" then
		if dialog.isDialog == false then
			boss.state = "warping"
		end

	elseif boss.state == "warping" then
		if boss.color.alpha == 0 then
			print("play boss warp sound")
			boss.soundWarp:stop()
			boss.soundWarp:play()
		end
		if boss.color.alpha < 1 then
			boss.color.alpha = boss.color.alpha + dt / 2
		else
			boss.color.alpha = 1
		end
		if boss.color.g < 1 then
			boss.color.g = boss.color.g + dt / 2
		else
			boss.color.g = 1
		end
		if boss.color.alpha == 1 and boss.color.g == 1 then
			boss.state = 1
			boss.music:play()
		end

	elseif boss.state == 1 then
		-- update shoot timer
		for i = 1, 2 do
			for j = 1, 2 do
				if boss.turrets[i][j].isFiring == true then
					boss.turrets[i][j].timer = boss.turrets[i][j].timer + dt
					if boss.turrets[i][j].timer > 0.5 / boss.anger then
						boss.turrets[i][j].isFiring = false
						boss.turrets[i][j].timer = 0
					end
				end
			end
		end
		-- update phase timer
		boss.phaseTimer = boss.phaseTimer + dt
		if boss.phaseTimer > 8 and boss.phaseTimer <= 10 then
			for i = 1, 2 do
				for j = 1, 2 do
					boss.turrets[i][j].isFiring = true
				end
			end
		elseif boss.phaseTimer > 10 then
			boss.state = 2
			boss.phaseTimer = 0
		end

		for i = 1, 2 do
			for j = 1, 2 do
				enemies.TargetPlayer(boss.turrets[i][j])
				--shoot
				if boss.turrets[i][j].isFiring == false then
					boss.turrets[i][j].isFiring = true
					boss.shootingSound:stop()
					boss.shootingSound:setPitch(1.8)
					boss.shootingSound:play()
					projectiles.Spawn(boss.turrets[i][j], "turret", "foe")
				end
			end
		end

	elseif boss.state == 2 then
		-- update shoot timer
		if boss.head.isFiring == true then
			boss.head.timer = boss.head.timer + dt
			if boss.head.timer > 1 / boss.anger then
				boss.head.isFiring = false
				boss.head.timer = 0
			end
		end
		-- update phase timer
		boss.phaseTimer = boss.phaseTimer + dt
		if boss.phaseTimer > 8 and boss.phaseTimer <= 10 then
			boss.head.isFiring = true
		elseif boss.phaseTimer > 10 then
			boss.state = 1
			boss.phaseTimer = 0
		end

		enemies.TargetPlayer(boss.head)
		--shoot
		if boss.head.isFiring == false then
			boss.head.isFiring = true
			boss.shootingSound:stop()
			boss.shootingSound:setPitch(0.8)
			boss.shootingSound:play()
			projectiles.Spawn(boss.head, "tankRed", "foe")
		end

	elseif boss.state == "dead" then
		boss.color.alpha = boss.color.alpha - dt
   		boss.color.r = 0.5
   		boss.color.g = 0
   		boss.color.b = 0
	end

	-- victory
	if boss.hp <= 0 then
		boss.isAlive = false
		boss.state = "dead"
		boss.music:stop()
	end

end

-----------------------------------
function boss.Draw()
	love.graphics.setColor(boss.color.r, boss.color.g, boss.color.b, boss.color.alpha)
	love.graphics.draw(boss.imgBody, boss.x, boss.y, 0, 1, 1, boss.ox, boss.oy)
	for i = 1, 2 do
		for j = 1, 2 do
			love.graphics.draw(
				boss.imgTurret, 
				boss.turrets[i][j].x,
				boss.turrets[i][j].y,
				boss.turrets[i][j].rHead,
				1, 1,
				boss.turrets[i][j].ox,
				boss.turrets[i][j].oy)
		end
	end
	love.graphics.draw(boss.imgHead, boss.head.x, boss.head.y, boss.head.rHead, 1, 1, boss.head.ox, boss.head.oy)
	love.graphics.setColor(1,1,1,1)

end


return boss