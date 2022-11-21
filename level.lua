map = require("map")
enemies = require("enemies")
player = require("player")
projectiles = require("projectiles")
ui = require("ui")
items = require("items")
dialog = require("dialog")
snow = require("snow")
boss = require("boss")

local level = {}
level.currentLevel = 1
level.isPaused = false
level.wonTheGame = false

level.music = {}
level.music["main"] = love.audio.newSource("sounds/651871__davejf__synthwave.mp3", "stream")
level.music["main"]:setLooping(true)

--a temporary feature for changing levels one at a time
local canChangeLevel = true
local canChangeLevelTimer = 0

-- events manager
level.event = {}

---------------------------------------------------------------
function level.Load(index)
	print("loading level...")
	-- populate map
	local nCol = map.tileSheet:getWidth()/ui.tileWidth
	local nRow = map.tileSheet:getHeight()/ui.tileHeight
	local row, col
	local id = 1
	for row = 1, nRow do
		for col = 1, nCol do
		  map.tileTexture[id] = love.graphics.newQuad(
		  	(col - 1) * ui.tileWidth, 
		    (row - 1) * ui.tileHeight, 
		    ui.tileWidth, 
		    ui.tileHeight, 
		    map.tileSheet:getWidth(), 
		    map.tileSheet:getHeight()
		    )
		  id = id + 1
		end
	end
	print("...textures loaded")

  -- add enemies
	if index == 2 then
		enemies.SpawnTurret(17*32, 4*32, "idle", math.pi/2)
		enemies.SpawnTurret(17*32, 16*32, "idle", - math.pi/2)

  elseif index == 3 then
    enemies.SpawnTurret(13*32, 12*32, "idle", math.pi)
    enemies.SpawnTurret(13*32, 2*32, "idle", math.pi)
    enemies.SpawnTurret(26*32, 3*32, "idle", math.pi)
	
  elseif index == 4 then
    enemies.SpawnTurret(3*32,  3*32, "idle", math.pi/2)
    enemies.SpawnTurret(22*32, 2*32, "idle", math.pi)
    enemies.SpawnTurret(22*32, 16*32, "idle", math.pi)
    enemies.SpawnTurret(21*32, 10*32, "idle", math.pi)

  elseif index == 5 then
    enemies.SpawnTank(17*32, 5*32, "idle", math.pi)
    enemies.SpawnTank(21*32, 11*32, "idle", math.pi)
    enemies.SpawnTank(22*32, 15*32, "idle", math.pi)

  elseif index == 6 then
    enemies.SpawnTank(26*32, 1*32, "idle", math.pi)
    enemies.SpawnTank(20*32, 14*32, "idle", math.pi)
    enemies.SpawnTank(13*32, 17*32, "idle", math.pi)

  elseif index == 7 then
    enemies.SpawnTank(12*32, 15*32, "idle", math.pi)
    enemies.SpawnTank(23*32, 12*32, "idle", math.pi)
    enemies.SpawnTurret(12*32, 2*32, "idle", math.pi/2)
    enemies.SpawnTurret(20*32, 2*32, "idle", math.pi)

  elseif index == 8 then
    enemies.SpawnTank(16*32, 4*32, "idle", math.pi)
    enemies.SpawnTank(16*32, 16*32, "idle", math.pi)
    enemies.SpawnTurret(24*32, 10*32, "idle", math.pi)
    enemies.SpawnTurret(8*32, 1*32, "idle", math.pi/2)

  elseif index == 9 then
    level.event[1] = false

  elseif index == 10 then
    level.event[2] = false
    enemies.SpawnTank(24*32, 6*32, "idle", math.pi)
    enemies.SpawnTank(22*32, 14*32, "idle", math.pi)
    enemies.SpawnTank(9*32, 16*32, "warp", -math.pi/2)

  elseif index == 11 then
    level.event[3] = false
    level.event[4] = false

  elseif index == 12 then
    level.event[5] = false
    enemies.SpawnTank(21*32, 2*32, "idle", math.pi/2)
    enemies.SpawnTank(26*32, 14*32, "idle", math.pi)

  elseif index == 13 then
    level.event[6] = false
    level.event[7] = false
    enemies.SpawnTurret(15*32, 6*32, "idle", math.pi/2)
    enemies.SpawnTurret(15*32, 19*32, "idle", - math.pi/2)

  elseif index == 14 then
    enemies.SpawnMammoth(22*32, 2*32, "idle")
    enemies.SpawnMammoth(24*32, 3*32, "idle")
    enemies.SpawnMammoth(26*32, 2*32, "idle")
    enemies.SpawnMammoth(21*32, 6*32, "idle")
    enemies.SpawnMammoth(24*32, 8*32, "idle")
    enemies.SpawnMammoth(25*32, 6*32, "idle")

  elseif index == 15 then
    enemies.SpawnTurret(13*32, 8*32, "idle", math.pi)
    --grp 1
    enemies.SpawnMammoth(13*32, 14*32, "idle", math.pi/9)
    enemies.SpawnMammoth(12*32, 15*32, "idle", math.pi/13*15)
    enemies.SpawnMammoth(11*32, 16*32, "idle", math.pi/4*5)
    --grp 2
    enemies.SpawnMammoth(20*32, 3*32, "idle", -math.pi)
    enemies.SpawnMammoth(20*32, 6*32, "idle", -math.pi/9)
    enemies.SpawnMammoth(24*32, 8*32, "idle", -math.pi/13*15)

  elseif index == 16 then
    level.event[8] = false
    enemies.SpawnTurret(23*32, 6*32, "idle", math.pi)
    --grp 1
    enemies.SpawnMammoth(12*32, 5*32, "idle", math.pi/9)
    enemies.SpawnMammoth(12*32, 7*32, "idle", math.pi/9)
    enemies.SpawnMammoth(13*32, 9*32, "idle", math.pi/13*15)
    --grp 2
    enemies.SpawnMammoth(12*32, 15*32, "idle", -math.pi)
    enemies.SpawnMammoth(13*32, 14*32, "idle", -math.pi/9)
    enemies.SpawnMammoth(12*32, 17*32, "idle", -math.pi/13*15)

  elseif index == 17 then
    level.event[9] = false
    level.event[10] = false
    enemies.SpawnTurret(13*32, 9*32, "idle", math.pi)
    enemies.SpawnTurret(13*32, 11*32, "idle", math.pi)
    --enemies.SpawnTank(4*32, 3*32, "warp", math.pi/2)
    --enemies.SpawnTank(4*32, 15*32, "warp", -math.pi/2)
    --grp 1
    enemies.SpawnMammoth(22*32, 6*32, "idle", math.pi/9)
    enemies.SpawnMammoth(24*32, 7*32, "idle", math.pi/9)
    enemies.SpawnMammoth(22*32, 7*32, "idle", math.pi/13*15)
    --grp 2
    enemies.SpawnMammoth(23*32, 15*32, "idle", -math.pi)
    enemies.SpawnMammoth(20*32, 17*32, "idle", -math.pi/9)
    enemies.SpawnMammoth(21*32, 16*32, "idle", -math.pi/13*15)

  elseif index == 18 then
    boss.Load()
	end
	print("...the ennemies have spawned")

	-- add player
  if index == 1 then
    player.Load(ui.width / 8, ui.height / 2)
  elseif index == 4 then
    player.Load(ui.width / 8 - 50, ui.height / 2 + 50)
  else  
  	player.Load(ui.width / 8 - 50, ui.height / 2)
  end
  print("...player 1 has spawned")

  -- add medipacks
  if index == 3 then
    items.SpawnMedipack(22*32, 2*32)
  end
  if index == 6 then
    items.SpawnMedipack(28*32, 5*32)
  end
  if index == 9 then
    items.SpawnMedipack(15*32, 10*32)
  end
  if index == 12 then
    items.SpawnMedipack(26*32, 2*32)
  end
  if index == 15 then
    items.SpawnMedipack(13*32 + 16, 2*32)
  end
  if index == 18 then
    items.SpawnMedipack(26*32, 5*32)
    items.SpawnMedipack(3*32,  5*32)
    items.SpawnMedipack(26*32,  16*32)
    items.SpawnMedipack(3*32,  16*32)
  end
  print("...medipacks deployed")

  -- add snow
  if index == 1 then
    snow.Add(10)
    snow.wind:stop()
    snow.wind:play()
    snow.wind:setPitch(0.8)
  elseif index == 6 then
    snow.Remove(10)
    snow.Add(20)
    snow.wind:setPitch(1.2)
  elseif index == 10 then
    snow.Remove(20)
    snow.Add(30)
    snow.wind:setPitch(1.6)
  elseif index == 14 then
    snow.Remove(30)
    snow.Add(50)
    snow.wind:setPitch(2.0)
  elseif index == 18 then
    snow.Remove(25)
    snow.wind:setPitch(0.8)
  end

  print("...a snowstorm has arrived")

  -- launch dialog
  dialog.index = 1
  dialog.isDialog = true

  -- add music
  if index == 1 then
    level.music["main"]:stop()
    level.music["main"]:play()
    level.music["main"]:setVolume(0.9)
  elseif index == 18 then
    level.music["main"]:stop()
  end


end
---------------------------------------------------------------
function level.Update(dt)
  -- change level
  if player.touchRightBorder == true then
    if ui.currentMob == 0 and canChangeLevel == true then
      -- update counters
      local nextLevel = level.currentLevel + 1
      level.currentLevel = nextLevel
      ui.maxMob = 0 
      -- remove items
      for i = #items.medipacks, 1, -1 do
         table.remove(items.medipacks, i)
      end
      -- remove bullets
      for i = #projectiles.friendly, 1, -1 do
         table.remove(projectiles.friendly, i)
      end
      for i = #projectiles.foe, 1, -1 do
         table.remove(projectiles.foe, i)
      end
      -- load level
      level.Load(level.currentLevel)      
    end
  end

  if level.isPaused == false then
    enemies.Update(map.tileMaps[level.currentLevel], map.tileType, dt)
    if level.currentLevel == 18 then
      boss.Update(dt)
    end
    player.Update(map.tileMaps[level.currentLevel], map.tileType, dt)
    projectiles.Update(map.tileMaps[level.currentLevel], map.tileType, dt)
    items.Update(dt)
    ui.Update(dt)
    snow.Update(level.currentLevel, dt)
  end

  if dialog.isDialog == true and level.isPaused == false and ui.pauseMenu == false and boss.state == "hidden" then
    dialog.Update(level.currentLevel, dt)
  elseif boss.anger == 2 and boss.isAlive == true then
    dialog.isDialog = true
    dialog.Update(19, dt)
  elseif boss.isAlive == false and boss.state == "dead" then
    dialog.isDialog = true
    dialog.Update(20, dt)
  end

   -- collision of projectiles with...
   -- ...enemy tanks
   for i = 1, #projectiles.friendly do
       for j = 1, #enemies.tanks do
         local distance = player.Distance(projectiles.friendly[i], enemies.tanks[j])
         if distance <= 30 then
           projectiles.friendly[i].isCollided = true
           if projectiles.friendly[i].vx ~= 0 and projectiles.friendly[i].vy ~= 0 then
             enemies.tanks[j].hp = enemies.tanks[j].hp - 1
           end
         end
       end
     end
   -- ...enemy turrets
  for i = 1, #projectiles.friendly do
    for j = 1, #enemies.turrets do
      local distance = player.Distance(projectiles.friendly[i], enemies.turrets[j])
      if distance <= 30 then
        projectiles.friendly[i].isCollided = true
        if projectiles.friendly[i].vx ~= 0 and projectiles.friendly[i].vy ~= 0 then
          enemies.turrets[j].hp = enemies.turrets[j].hp - 1
        end
      end
    end
  end
  -- ...enemy mammoths
   for i = 1, #projectiles.friendly do
       for j = 1, #enemies.mammoths do
         local distance = player.Distance(projectiles.friendly[i], enemies.mammoths[j])
         if distance <= 30 then
           projectiles.friendly[i].isCollided = true
           if projectiles.friendly[i].vx ~= 0 and projectiles.friendly[i].vy ~= 0 then
             enemies.mammoths[j].hp = enemies.mammoths[j].hp - 1
           end
         end
       end
     end
  -- ...boss
  if boss.isAlive == true then
    for i = 1, #projectiles.friendly do
      local distance = player.Distance(projectiles.friendly[i], boss)
      if distance <= 64 then
        projectiles.friendly[i].isCollided = true
        if projectiles.friendly[i].vx ~= 0 and projectiles.friendly[i].vy ~= 0 then
          boss.hp = boss.hp - 1
        end
      end   
    end
  end

  -- ...player
  for i = 1, #projectiles.foe do
      local distance = player.Distance(projectiles.foe[i], player)
      if distance <= 40 then
         projectiles.foe[i].isCollided = true
         if projectiles.foe[i].vx ~= 0 and projectiles.foe[i].vy ~= 0 then
            ui.lifeManager.currentLife = LoseLife(ui.lifes, ui.lifeManager, dt)
         end
      end
  end
  --collision of mammoths with player
  for i = 1, #enemies.mammoths do
    local distance = player.Distance(enemies.mammoths[i].bBox[1], player)
    if distance <= enemies.pngMammoth1:getWidth() / 2 + player.ox + 5 then
      ui.lifeManager.currentLife = LoseLife(ui.lifes, ui.lifeManager, dt)
    end
  end

  -- events
  if level.currentLevel == 9 and player.x > 10*32 and level.event[1] == false then
    enemies.SpawnTank(8*32,  7*32, "warp", math.pi/4)
    enemies.SpawnTank(9*32,  14*32, "warp", -math.pi/4)
    enemies.SpawnTank(17*32, 3*32, "warp", math.pi/4*5)
    enemies.SpawnTank(23*32, 8*32, "warp", -math.pi/4*5)
    level.event[1] = true

  elseif level.currentLevel == 10 and player.x > 12*32 and level.event[2] == false then
    enemies.SpawnTank(9*32, 6*32, "warp")
    level.event[2] = true

  elseif level.currentLevel == 11 and player.x > 10*32 and level.event[3] == false then
    enemies.SpawnTank(6*32, 17*32, "warp", math.pi)
    enemies.SpawnTank(18*32, 6*32, "warp", math.pi)
    level.event[3] = true

  elseif level.currentLevel == 11 and player.x > 21*32 and level.event[4] == false then
    enemies.SpawnTank(18*32, 3*32, "warp")
    enemies.SpawnTank(25*32, 8*32, "warp", math.pi)
    enemies.SpawnTank(25*32, 14*32, "warp", math.pi)
    level.event[4] = true

  elseif level.currentLevel == 12 and player.x > 17*32 and level.event[5] == false then
    enemies.SpawnTank(12*32, 6*32, "warp")
    enemies.SpawnTank(12*32, 11*32, "warp")
    enemies.SpawnTank(12*32, 15*32, "warp")
    level.event[5] = true

  elseif level.currentLevel == 13 and player.x > 13*32 and level.event[6] == false then
    enemies.SpawnTank(17*32, 13*32, "warp")
    level.event[6] = true

  elseif level.currentLevel == 13 and player.x > 23*32 and level.event[7] == false then
    enemies.SpawnTank(17*32, 12*32, "warp")
    enemies.SpawnTank(28*32, 5*32, "warp", math.pi)
    enemies.SpawnTank(28*32, 12*32, "warp", math.pi)
    level.event[7] = true

  elseif level.currentLevel == 16 and player.x > 17*32 and level.event[8] == false then
    enemies.SpawnTank(12*32, 11*32, "warp")
    enemies.SpawnTank(26*32, 11*32, "warp", math.pi)
    level.event[8] = true

  elseif level.currentLevel == 17 and player.x > 17*32 and level.event[9] == false then
    enemies.SpawnTank(13*32, 1*32, "warp")
    enemies.SpawnTank(13*32, 16*32, "warp")
    level.event[9] = true

  elseif level.currentLevel == 17 and player.x > 24 and level.event[10] == false then
    enemies.SpawnTank(28*32, 9*32, "warp", math.pi)
    enemies.SpawnTank(28*32, 10*32, "warp", math.pi)
    level.event[10] = true
  end

  --Victory!
  if boss.isAlive == false and boss.state == "dead" and dialog.isDialog == false then
    level.wonTheGame = true
    ui.alarm:stop()
  end

end

---------------------------------------------------------------
function level.Draw()
  -- boucle de dessin de la map en fonction des textures
  love.graphics.setColor(0.8, 0.8, 1, 1)
  local row, col
  for row = 1, ui.mapHeight do
    for col = 1, ui.mapWidth do
      local ground = map.tileMaps[level.currentLevel].ground[row][col]
      local quadGround = map.tileTexture[ground]
      if quadGround ~= nil then
        love.graphics.draw(
          map.tileSheet,
          quadGround, 
          (col - 1) * ui.tileWidth, 
          (row - 1) * ui.tileHeight
          )
      end
    end
  end
  love.graphics.setColor(1, 1, 1, 1)
  for row = 1, ui.mapHeight do
    for col = 1, ui.mapWidth do
      local grid = map.tileMaps[level.currentLevel].top[row][col]
      local quadGrid = map.tileTexture[grid]
      if quadGrid ~= nil then
        love.graphics.draw(
          map.tileSheet,
          quadGrid, 
          (col - 1) * ui.tileWidth, 
          (row - 1) * ui.tileHeight
          )
      end
    end
  end

  items.Draw()
  if player.isVisible == true then
    player.Draw()
  end
  enemies.Draw()
  if level.currentLevel == 18 then
    boss.Draw()
  end
  projectiles.Draw()
  snow.Draw()
  ui.Draw()
  dialog.Draw()

  -- pause menu
  if  level.isPaused == true and ui.pauseMenu == true then
      --draw pause menu
      love.graphics.setColor(1, 1, 1, 0.7)
      love.graphics.rectangle(
        "fill", 
        ui.width / 2 - ui.fontTitle2:getWidth("Continuer ? Y/N") / 2 - 20, ui.height / 2 - 20, 
        ui.fontTitle2:getWidth("Continuer ? Y/N") + 20 + 20, ui.fontTitle2:getHeight("Continuer ? Y/N") + 40 + 20 + 20)
      love.graphics.setColor(0.5, 0, 0, 1)
      love.graphics.setFont(ui.fontTitle1)
      love.graphics.print("- PAUSE- ", ui.width / 2, ui.height / 2, 0, 1, 1, ui.fontTitle1:getWidth("- PAUSE -")/2)
      love.graphics.setFont(ui.fontTitle2)
      love.graphics.print("Continuer ? Y/N", ui.width / 2, ui.height / 2 + 40, 0, 1, 1, ui.fontTitle2:getWidth("Continuer ? Y/N")/2)
      love.graphics.setColor(1, 1, 1, 1)
  end

end

---------------------------------------------------------------
function level.Keypressed(button)
  if level.isPaused == false then
    player.Keypressed(button)
  end

  if ui.pauseMenu == false and dialog.isDialog == true then
    dialog.Keypressed(button)
  end
end

return level