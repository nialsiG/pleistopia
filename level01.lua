local level = {}

level.map = {}
level.map.grid = {
  {247, 248, 247, 248, 247, 248, 247, 248, 247, 248, 247, 248, 247, 248, 247, 248, 247, 248, 247, 248, 24, 24, 247, 248, 247, 248, 247, 248, 247, 248, 247, 248},
  {267, 268, 267, 268, 267, 268, 267, 268, 267, 268, 267, 268, 267, 268, 267, 268, 267, 268, 267, 268, 24, 24, 267, 268, 267, 268, 267, 268, 267, 268, 267, 268},
  {56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 24, 24, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56},
  {56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 24, 24, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56},
  {56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 24, 24, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56},
  {56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 24, 24, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56},
  {56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 24, 24, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56},
  {56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 24, 24, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56},
  {56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 24, 24, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56},
  {56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 24, 24, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56},
  {24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24},
  {24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24},
  {24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24},
  {56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 24, 24, 24, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56},
  {56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 24, 24, 24, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56},
  {56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 24, 24, 24, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56},
  {56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 24, 24, 24, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56},
  {56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 24, 24, 24, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56},
  {56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 24, 24, 24, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56},
  {56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 24, 24, 24, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56},
  {56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 24, 24, 24, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56},
  {56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 24, 24, 24, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56},
  {56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56, 24, 24, 24, 56, 56, 56, 56, 56, 56, 56, 56, 56, 56},
  }

level.map.MAP_WIDTH = 32
level.map.MAP_HEIGHT = 23
level.map.TILE_WIDTH = 32
level.map.TILE_HEIGHT = 32

level.tileSheet = nil
level.tileTexture = {}
level.tileType = {}
level.tileType[10] = "Grass"
level.tileType[11] = "Grass"
level.tileType[13] = "Sand"
level.tileType[14] = "Sand"
level.tileType[15] = "Sand"
level.tileType[19] = "Water"
level.tileType[20] = "Water"
level.tileType[21] = "Water"
level.tileType[37] = "Lava"
level.tileType[56] = "Tree"
level.tileType[58] = "Tree"
level.tileType[61] = "Tree"
level.tileType[129] = "Rock"
level.tileType[142] = "Rock"
level.tileType[169] = "Rock"

function level.Load()
print("Level textures loading...")
  -- get tilesheet png
  level.tileSheet = love.graphics.newImage("images/tilesheet.png")
  -- get number of tilesheet columns/rows
  local nCol = level.tileSheet:getWidth()/level.map.TILE_WIDTH
  local nRow = level.tileSheet:getHeight()/level.map.TILE_HEIGHT

  level.tileTexture[0] = nil

  local row, col
  local id = 1

  for row = 1, nRow do
    for col = 1, nCol do
      level.tileTexture[id] = love.graphics.newQuad(
        (col - 1) * level.map.TILE_WIDTH, 
        (row - 1) * level.map.TILE_HEIGHT, 
        level.map.TILE_WIDTH, 
        level.map.TILE_HEIGHT, 
        level.tileSheet:getWidth(), 
        level.tileSheet:getHeight()
        )
      id = id + 1
    end
  end

  print("...textures loaded")


  -- add enemies
  enemies = require("enemies")
  enemies.Load()

  enemies.SpawnTank(450, 350)

  enemies.SpawnTurret(560, 300)
  enemies.SpawnTurret(560, 400)


end

function level.Update()
  enemies.Update()
end

function level.Draw()
  -- boucle de dessin de la map en fonction des textures
  local row, col
  for row = 1, level.map.MAP_HEIGHT do
    for col = 1, level.map.MAP_WIDTH do
      local id = level.map.grid[row][col]
      local quad = level.tileTexture[id]
      if quad ~= nil then
        love.graphics.draw(
          level.tileSheet,
          quad, 
          (col - 1) * level.map.TILE_WIDTH, 
          (row - 1) * level.map.TILE_HEIGHT
          )
      end
    end
  end

  -- draw enemies
  enemies.Draw()

end

return level