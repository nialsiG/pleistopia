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

mouse = {}

function Distance(source, target)
	local x = target.x - source.x
	local y = target.y - source.y
	norme = math.sqrt((x * x) + (y * y))
	return(norme)
end


function player.Load(x, y)
	player.body.x = x
	player.body.y = y

	-- shooting system
	player.shooter = require("shooter")

	-- sound
	player.engineSound:play()

end

function player.Update(dt)
	-- marche avant
	if love.keyboard.isDown("up", "z") then
		player.body.x = player.body.x + (math.cos(player.body.r) * player.body.speed * dt)
		player.body.y = player.body.y + (math.sin(player.body.r) * player.body.speed * dt)
	end
	-- marche arrière
	if love.keyboard.isDown("down", "s") then
		player.body.x = player.body.x - (math.cos(player.body.r) * player.body.speed * dt)
		player.body.y = player.body.y - (math.sin(player.body.r) * player.body.speed * dt)
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
		player.head.r = math.pi - math.acos((player.body.x - mouse.x) / Distance(player.body, mouse))
	else
		player.head.r = math.pi + math.acos((player.body.x - mouse.x) / Distance(player.body, mouse))
	end

	-- boundaries
	if player.body.x <= 0 + player.body.ox then
		player.body.x = 0 + player.body.ox
	end

	if player.body.x >= love.graphics.getWidth() - player.body.ox then
		player.body.x = love.graphics.getWidth() - player.body.ox
	end

	if player.body.y <= 0 + player.body.oy then
		player.body.y = 0 + player.body.oy
	end

	if player.body.y >= love.graphics.getHeight() - player.body.oy then
		player.body.y = love.graphics.getHeight() - player.body.oy
	end

	-- shooting system
	player.shooter.x = player.body.x + (player.head.img[player.head.currentImage]:getWidth() * math.cos(player.head.r))
	player.shooter.y = player.body.y + (player.head.img[player.head.currentImage]:getWidth() * math.sin(player.head.r))
	player.shooter.r = player.head.r
	player.shooter.ox = player.head.ox -- - (player.shooter.img[player.shooter.currentImage]:getWidth() / 2)
	player.shooter.oy = (player.shooter.img[player.shooter.currentImage]:getHeight() / 2)
	player.shooter.Update(dt)

end

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

	player.shooter.Draw()

end

return player
