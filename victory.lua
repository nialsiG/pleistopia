local victory = {}

victory.music = love.audio.newSource("sounds/568994__hutyl__homecoming-remix-davejf.mp3", "stream")
victory.music:setLooping(true)

function victory.Update()

end

function victory.Draw()

   ui.PrintCentered(ui.width / 2, ui.height / 8, ui.fontMain, "PLEISTOPIA")
   ui.PrintCentered(ui.width / 2, ui.height / 8 + 40, ui.fontTitle1, "A Time-Traveling Tank Fantasy")
	ui.PrintCentered(ui.width / 2, ui.height / 8 + 100, ui.fontTitle2, " - Credits - ")

   ui.PrintCentered(ui.width / 2, ui.height / 3 + 30, ui.fontTitle2, "Game Development")
   ui.PrintCentered(ui.width / 2, ui.height / 3 + 60, ui.fontText1, "Ghislain Thiery")

   ui.PrintCentered(ui.width / 2, ui.height / 3 + 110, ui.fontTitle2, "Music")
   ui.PrintCentered(ui.width / 2, ui.height / 3 + 140, ui.fontText1, "DaveJf, hutyl")

   ui.PrintCentered(ui.width / 2, ui.height / 3 + 190, ui.fontTitle2, "Sound")
   ui.PrintCentered(ui.width / 2, ui.height / 3 + 220, ui.fontText1, "magnuswaker, y89312, tim-kahn, Jasher70, harrietniamh and Bosk1 from freesound.org")

   ui.PrintCentered(ui.width / 2, ui.height / 3 + 270, ui.fontTitle2, "2D-Art")
   ui.PrintCentered(ui.width / 2, ui.height / 3 + 300, ui.fontText1, "Ghislain Thiery, Daniel Cook, yd, Jetrel, Zabin, Matriax and Richy Mackro from opengameart.org")
   ui.PrintCentered(ui.width / 2, ui.height / 3 + 330, ui.fontText1, "Ragewortt from gamedevmarket.net")
   ui.PrintCentered(ui.width / 2, ui.height / 3 + 360, ui.fontText1, "...as well as assets from gamecodeur.fr")


end

return victory