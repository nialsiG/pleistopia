local ui = require("ui")

local snow = {}

snow.img = love.graphics.newImage("images/snowFlake.png")
snow.wind = love.audio.newSource("sounds/wind.wav", "stream")
snow.wind:setLooping(true)
snow.wind:setVolume(0.5)

snow.speed = {}
snow.speed[1] = 50
snow.speed[2] = 150
snow.speed[3] = 350
snow.currentSpeed = 1

snow.slope = {}
snow.slope[1] = 1
snow.slope[2] = 0.7
snow.slope[3] = 0.4
snow.currentSlope = 1

snow.particles = {}

function snow.Add(number)
	for i = 1, number do
		local snw = {}
		snw.x = love.math.random(0, ui.width)
		snw.y = love.math.random(0, ui.height)
		snw.speed = snow.speed[snow.currentSpeed]
		snw.slope = snow.slope[snow.currentSlope]
		snw.r = 0
		snw.scale = love.math.random(5, 15) / 10
		table.insert(snow.particles, snw)
	end
end

function snow.Remove(number)
	for i = #snow.particles, #snow.particles - number, - 1 do
		table.remove(snow.particles, i)
	end
end

-----------------------------------
function snow.Update(level, dt)
	if level < 6 or level == 18 then
		snow.currentSpeed = 1
		snow.currentSlope = 1
	elseif level < 10 then
		snow.currentSpeed = 2
		snow.currentSlope = 2
	elseif level < 14 then
		snow.currentSpeed = 3
		snow.currentSlope = 3
	end

	for i, s in ipairs(snow.particles) do
		s.speed = snow.speed[snow.currentSpeed] / s.scale
		s.slope = snow.slope[snow.currentSlope]
		s.r = s.r + dt / s.scale

		s.x = s.x - s.speed * dt
		s.y = s.y + s.speed * s.slope * dt

		if s.x <= 0 then
			s.x = ui.width
			s.y = ui.height - s.y
		elseif s.y >= ui.height then
			s.x = ui.width - s.x
			s.y = 0
		end
	end

end

-----------------------------------
function snow.Draw()
	for i, s in ipairs(snow.particles) do
		love.graphics.draw(snow.img, s.x, s.y, s.r, s.scale, s.scale)
	end
end

return snow