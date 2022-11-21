local ui = require("ui")

local dialog = {}

dialog.rightClickIcon = love.graphics.newImage("images/rightClick.png")
dialog.rightClickAlpha = 0

dialog.table = {}

dialog.table[1] = {}
dialog.table[1][1] = [[???: I just landed, Captain. Do you copy ?]]
dialog.table[1][2] = [[CAPTAIN: Roger. Let the mission begin.]]
dialog.table[1][3] = [[???: What's the objective, sir?]]
dialog.table[1][4] = [[CAPTAIN: You must eliminate Professeur Shirô, a dangerous 
criminal, and counter his plan to eradicate the human kind.]]
dialog.table[1][5] = [[???: Is that all? No wonder I can't get that raise.]]
dialog.table[1][6] = [[CAPTAIN: This is serious. He used the same technology as us
to travel back in the Ice Age and kill the first humans.]]
dialog.table[1][7] = [[???: The Ice Age?! No wonder it's cold out there.]]
dialog.table[1][8] = [[CAPTAIN: For this operation, your codename will be BOBCAT.
Target is located eastward. Good luck.]]

dialog.table[2] = {}
dialog.table[2][1] = [[BOBCAT: Captain, I can spot two antitank turrets.]]
dialog.table[2][2] = [[CAPTAIN: You must destroy them. We cannot afford to let such 
advanced weaponry into the hands of Pleistocene people.]]
dialog.table[2][3] = [[BOBCAT: Play-store-scene...what ?]]
dialog.table[2][4] = [[CAPTAIN: The Pleistocene epoch. Started 2.58 million years ago,
ended with the last Ice Age, about 11,700 years ago.]]
dialog.table[2][5] = [[BOBCAT: If you say so...]]

dialog.table[3] = {}
dialog.table[3][1] = [[CAPTAIN: Do you see this crate with a red box?]]
dialog.table[3][2] = [[CAPTAIN: I believe it is a repair kit. Use it to fix your T3.]]
dialog.table[3][3] = [[BOBCAT: Roger that.]]

dialog.table[4] = {}
dialog.table[4][1] = [[BOBCAT: Captain, I'm under enemy fire!]]
dialog.table[4][2] = [[CAPTAIN: Don't panic. Use the rocks and the trees to take cover.]]

dialog.table[5] = {}
dialog.table[5][1] = [[BOBCAT: Three enemy armoured vehicles coming in, sir. 
Wait... are those... T3s?]]
dialog.table[5][2] = [[CAPTAIN: No wonder. Your target, Bobcat, is but the very 
inventor of the 'Time-Travelling-Tank' - or T3.]]
dialog.table[5][3] = [[BOBCAT: !!!]]
dialog.table[5][4] = [[CAPTAIN: Be warry, Bobcat. These tanks are as mobile and 
solid as yours.]]

dialog.table[6] = {}
dialog.table[6][1] = [[CAPTAIN: The ice should be thick enough to support your weight. 
Beware of not losing the control of your T3 though.]]
dialog.table[6][2] = [[BOBCAT: Too bad I skipped the ice-skating lessons...]]

dialog.table[7] = {}
dialog.table[7][1] = [[BOBCAT: More turrets, more T3s...]]

dialog.table[8] = {}
dialog.table[8][1] = [[BOBCAT: It's just like a real skating rink! Only, with tanks.]]

dialog.table[9] = {}
dialog.table[9][1] = [[BOBCAT: Ah, repair kit... Just what I needed.]]

dialog.table[10] = {}
dialog.table[10][1] = [[BOBCAT: So their T3s can ambush, too?]]
dialog.table[10][2] = [[CAPTAIN: I told you that they were as mobile as you, didn't I?]]
dialog.table[10][3] = [[CAPTAIN: On the other hand, they will equally be slowed down 
by these thick layers of fresh snow... just like you.]]
dialog.table[10][4] = [[BOBCAT: No fair!]]

dialog.table[11] = {}
dialog.table[11][1] = [[BOBCAT: More snow... I miss the ice-skating part.]]

dialog.table[12] = {}
dialog.table[12][1] = [[BOBCAT: Repair kit! Lemme guess... another trap, a'ight?]]

dialog.table[13] = {}
dialog.table[13][1] = [[CAPTAIN: You are getting close to the target, Bobcat.
Stay focused.]]
dialog.table[13][2] = [[BOBCAT: Gottcha, sir.]]

dialog.table[14] = {}
dialog.table[14][1] = [[BOBCAT: !!!
Are those dinosaurs?!]]
dialog.table[14][2] = [[CAPTAIN: Not quite. Those are woolly mammoths of the genus
Mammuthus, if I am not mistaken.]]
dialog.table[14][3] = [[BOBCAT: Oh, hairy elephants then.]]
dialog.table[14][4] = [[CAPTAIN: Do not underestimate their power. They're very
aggressive, and could damage your tank beyond repair.]]

dialog.table[15] = {}
dialog.table[15][1] = [[BOBCAT: How come they're not attacking THEM?]]
dialog.table[15][2] = [[CAPTAIN: I wonder. Could it mean that woolly mammoths
have been domesticated by early humans?]]
dialog.table[15][3] = [[BOBCAT: See? Big hairy elephants.]]


dialog.table[16] = {}
dialog.table[16][1] = [[BOBCAT: More elephants? Come on!]]

dialog.table[17] = {}
dialog.table[17][1] = [[BOBCAT: !!!]]

dialog.table[18] = {}
dialog.table[18][1] = [[???: So you did come to stop me, after all.]]
dialog.table[18][2] = [[BOBCAT: Shirô? Is that you, bastard?]]
dialog.table[18][3] = [[SHIRO: It is me, indeed. But I wonder, why would you want
to put a stop to my great masterplan?]]
dialog.table[18][4] = [[SHIRO: You come from the same time as me. You know the Earth
is dying. The forests, the oceans... even the ice is melting.]]
dialog.table[18][5] = [[SHIRO: Mankind is a cancer for all life, but I know the cure.
All I have to do is exterminate the early humans...]]
dialog.table[18][6] = [[BOBCAT: Cut the crap, Shirô. I defeated a whole army.
I will stop you right here, right now.]]
dialog.table[18][7] = [[SHIRO: As you wish. Please, make it entertaining!]]

dialog.table[19] = {}
dialog.table[19][1] = [[SHIRO: NOOO!!! STOP WRECKING MY CREATION!!!]]

dialog.table[20] = {}
dialog.table[20][1] = [[SHIRO: NOOOOOOOOOOOOOO!!!]]
dialog.table[20][2] = [[CAPTAIN: Well done, Bobcat. You just saved the world.
At last, you can time-travel back home.]]

dialog.isDialog = false
dialog.currentDialog = [[...]]
dialog.index = 1

-----------------------------------
function dialog.Update(level, dt)
	if dialog.index > #dialog.table[level] then
	  dialog.isDialog = false
	  dialog.index = 1
	end

	if dialog.isDialog == true then
		dialog.currentDialog = dialog.table[level][dialog.index]
	end

	--right click alpha
	dialog.rightClickAlpha = dialog.rightClickAlpha + dt
	if dialog.rightClickAlpha > 1 then
		dialog.rightClickAlpha = 0
	end
end

-----------------------------------
function dialog.Draw()
	if dialog.isDialog == true then
		--love.graphics.setFont(ui.fontText1)
		love.graphics.setColor(41/100, 66/100, 52/100, 1)
		ui.PrintCentered(420, 680, ui.fontText1, dialog.currentDialog)

		--right click icon
		love.graphics.setColor(1, 1, 1, dialog.rightClickAlpha)
		love.graphics.draw(dialog.rightClickIcon, ui.width * 0.7, 660)
		
		love.graphics.setColor(1, 1, 1, 1)
	end
end

-----------------------------------
function dialog.Keypressed(button)
	if button == 2 or button == 3 then
		dialog.index = dialog.index + 1
	end
end

return dialog