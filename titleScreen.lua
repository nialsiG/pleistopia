local titleScreen = {}
local ui = require("ui")

function titleScreen.Update()
end

function titleScreen.Draw()
	love.graphics.draw(ui.menu, 0, 0)
	ui.PrintCentered(ui.width / 2, ui.height / 2 - 40, ui.fontMain, "PLEISTOPIA")
	ui.PrintCentered(ui.width / 2, ui.height / 2, ui.fontTitle1, "A Time-Traveling Tank Fantasy")
	ui.PrintCentered(ui.width / 2, ui.height / 2 + 100, ui.fontTitle2, "Start? Y/N")
end

return titleScreen