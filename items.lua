local player = require("player")
local ui = require("ui")
local items = {}

items.transparency = 0
items.medipacks = {}

function items.SpawnMedipack(x, y)
	local mp = {}
	mp.x = x
	mp.y = y
	mp.png = love.graphics.newImage("images/medipack.png")
	mp.isCollected = false

	table.insert(items.medipacks, mp)
end

function items.Update(dt)
	for i = 1, #items.medipacks do
		if player.Distance(player, items.medipacks[i]) <= 50 then
			if ui.lifeManager.currentLife == ui.maxLife then
				break
			else
				items.medipacks[i].isCollected = true
				ui.lifeManager.currentLife = ui.lifeManager.currentLife + 1
			end
		end
	end

    if items.transparency <= 1 then
    	items.transparency = items.transparency + dt
    elseif items.transparency > 1 then
    	items.transparency = 0
    end

	for i = #items.medipacks, 1, -1 do
		if items.medipacks[i].isCollected == true then
			table.remove(items.medipacks, i)
		end
	end
end

function items.Draw()
	
	for i = 1, #items.medipacks do
		love.graphics.setColor(1, 1, 1, items.transparency)
		love.graphics.draw(items.medipacks[i].png, items.medipacks[i].x, items.medipacks[i].y)
	end
	love.graphics.setColor(1, 1, 1, 1)

end

return items