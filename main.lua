io.stdout:setvbuf('no')
love.graphics.setDefaultFilter("nearest")
if arg[#arg] == "-debug" then require("mobdebug").start() end

local Tetros = {}

Tetros[1] = {}

Tetros[1].shape = { {
    {0,0,0,0},
    {1,1,1,1},
    {0,0,0,0},
    {0,0,0,0}
  },
  {
    {0,0,1,0},
    {0,0,1,0},
    {0,0,1,0},
    {0,0,1,0}
    } }

Tetros[1].color = {1,0,0}

Tetros[2] = {}

Tetros[2].shape = { {
    {0,0,0,0},
    {0,1,1,0},
    {0,1,1,0},
    {0,0,0,0}
    } }

Tetros[2].color = {0,71/255,222/255}

Tetros[3] = {}

Tetros[3].shape = { {
    {0,0,0},
    {1,1,1},
    {0,0,1},
  },
  {
    {0,1,0},
    {0,1,0},
    {1,1,0},
  },
  {
    {1,0,0},
    {1,1,1},
    {0,0,0},
  },
  {
    {0,1,1},
    {0,1,0},
    {0,1,0},
    } }

Tetros[3].color = {222/255,184/255,0}

Tetros[4] = {}

Tetros[4].shape = { {
    {0,0,0},
    {1,1,1},
    {1,0,0},
  },
  {
    {1,1,0},
    {0,1,0},
    {0,1,0},
  },
  {
    {0,0,1},
    {1,1,1},
    {0,0,0},
  },
  {
    {1,0,0},
    {1,0,0},
    {1,1,0},
  } }

Tetros[4].color = {222/255,0,222/255}

Tetros[5] = {}

Tetros[5].shape = { {
    {0,0,0},
    {0,1,1},
    {1,1,0},
  },
  {
    {0,1,0},
    {0,1,1},
    {0,0,1},
  },
  {
    {0,0,0},
    {0,1,1},
    {1,1,0},
  },
  {
    {0,1,0},
    {0,1,1},
    {0,0,1},
    } }

Tetros[5].color = {1,151/255,0}

Tetros[6] = {}

Tetros[6].shape = { {
    {0,0,0},
    {1,1,1},
    {0,1,0},
  },
  {
    {0,1,0},
    {1,1,0},
    {0,1,0},
  },
  {
    {0,1,0},
    {1,1,1},
    {0,0,0},
  },
  {
    {0,1,0},
    {0,1,1},
    {0,1,0},
  } }

Tetros[6].color = {71/255,184/255,0}

Tetros[7] = {}

Tetros[7].shape = { {
    {0,0,0},
    {1,1,0},
    {0,1,1},
  },
  {
    {0,1,0},
    {1,1,0},
    {1,0,0},
  },
  {
    {0,0,0},
    {1,1,0},
    {0,1,1},
  },
  {
    {0,1,0},
    {1,1,0},
    {1,0,0},
  } }

Tetros[7].color = {0,184/255,151/255}

  local currentTetros = {}
  currentTetros.shapeId = 1
  currentTetros.rotation = 1
  currentTetros.position = { x=0, y=0}
  

  local Grid = {}
  Grid.offsetX = 0
 
  
  Grid.Height = 20
  Grid.Width  = 10
  Grid.CellSize = 0
  Grid.Cells = {}
  
  local dropSpeed = 1
  local dropTimer = 0
  local forceDropPause = false
 
 local gamestate = ""
 local sndMusicGameOver
 local sndMusicPlay
 local sndMusicMenu
 
 local fontMenu
 local menuSin = 1
 
 local score = 0
 local level = 0
 local lines = 0
 
 local bag = {}
 
 function InitBag ()
   bag = {}
   for n=1,#Tetros do
     table.insert (bag,n)
     table.insert (bag,n)
    end
  end
 
function SpawnTetros ()
  
  local nBag = math.random (1,#bag)
  local new = bag[nBag]
  table.remove (bag,nBag)
  if #bag == 0 then
    InitBag()
  end
  currentTetros.shapeId = new
  currentTetros.rotation = 1
  
  local tetrosWidth = #Tetros [currentTetros.shapeId].shape[currentTetros.rotation][1]
  
  currentTetros.position.x = (math.floor ((Grid.Width - tetrosWidth)/2))+1
  currentTetros.position.y = 1
  
  dropTimer = dropSpeed
  forceDropPause = true
  
  if Collide () then
    StartGameOver ()
  end
 
 
end
function InitGrid ()
  local h = hauteur/Grid.Height
  Grid.CellSize = h
  
  Grid.offsetX = (largeur/2) - (( Grid.CellSize * Grid.Width)/2)
  
  Grid.Cells = {}
  for l=1,Grid.Height do
     Grid.Cells [l] = {}
    for c=1,Grid.Width do
      Grid.Cells [l][c] = 0
    end
  end
end
function RemoveLineGrid (pLine)
  
  for l = pLine,2,-1 do
    for c=1,Grid.Width do
        Grid.Cells [l][c] = Grid.Cells [l-1][c]
    end
  end
  
end
function Transfert ()
  local Shape = Tetros [currentTetros.shapeId].shape[currentTetros.rotation]
  
  for l=1,#Shape do
    for c=1, #Shape [l] do
      local cGrid = (c-1) + currentTetros.position.x
      local lGrid = (l-1) + currentTetros.position.y
          if Shape [l][c] ~= 0 then
            Grid.Cells[lGrid][cGrid] = currentTetros.shapeId
          end
      
    end
  end
  
end
function Collide ()
  local Shape = Tetros [currentTetros.shapeId].shape[currentTetros.rotation]
  
  for l=1,#Shape do
    for c=1, #Shape [l] do
      local cGrid = (c-1) + currentTetros.position.x
      local lGrid = (l-1) + currentTetros.position.y
      
      if Shape[l][c] == 1 then
        if cGrid <= 0 or cGrid > Grid.Width then
          return true
        end
        
        if lGrid > Grid.Height then
          return true
        end
        
        if Grid.Cells[lGrid][cGrid] ~= 0 then
          return  true
        end
        
      end
      
    end
  end
  
  return false
end
function ManageLevel()
  local newLevel = math.floor (lines/10) +1
  
  if newLevel < 20 then
    if newLevel ~= level then
      sndLevel: play()
      level = newLevel
      dropSpeed = dropSpeed -0.08
    end
  end
end
function StartGame ()
  InitBag ()
  sndMusicMenu:stop()
  SpawnTetros ()
  dropSpeed = 1
  gamestate = "play"
  sndMusicPlay:play()
  love.graphics.setFont(fontScore)
  
  score = 0
  level = 1
  lines = 0
end
function StartGameOver ()
  sndMusicPlay:stop()
  love.graphics.setFont(fontMenu)
  
  gamestate = "gameover"
  sndMusicGameOver:play()
end
function StartMenu ()
  sndMusicPlay:stop()
  sndMusicGameOver: stop()
  gamestate = "menu"
  sndMusicMenu:play()
  love.graphics.setFont(fontMenu)
  
end
function love.load()
  
  sndMusicMenu = love.audio.newSource ("tetris-gameboy-01.mp3","static")
  sndMusicMenu : setLooping(true)
  
  sndMusicPlay = love.audio.newSource ("tetris-gameboy-02.mp3","static")
  sndMusicPlay : setLooping(true)
  
  sndMusicGameOver = love.audio.newSource ("tetris-gameboy-04.mp3","static")
  sndMusicGameOver : setLooping(true)
  
  sndLevel = love.audio.newSource ("levelup.wav","static")
  sndLine = love.audio.newSource ("line.wav", "static")
  
  
  fontMenu = love.graphics.newFont ("blocked.ttf",50)
  fontScore = love.graphics.newFont ("blocked.ttf",30)
  
   
  love.keyboard.setKeyRepeat (true)
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  InitGrid ()
  StartMenu ()
end
function UpdateMenu(dt)
  menuSin = menuSin + 5 * 60 *dt
  
end

function UpdatePlay (dt)
  if love.keyboard.isDown ("down") == false then
    forceDropPause = false
  end
  
 dropTimer = dropTimer - dt
 
 if dropTimer <= 0 then
   
   currentTetros.position.y = currentTetros.position.y +1
   dropTimer = dropSpeed
end

  if Collide () then
    currentTetros.position.y = currentTetros.position.y - 1
    Transfert()
    SpawnTetros ()
    
  end
  local bLineComplete
  local nblines = 0
  for l =1,Grid.Height do
    bLineComplete = true
    for c=1,Grid.Width do
      if Grid.Cells [l][c] == 0 then
        bLineComplete = false
        break
      end
    end
    if bLineComplete == true then
      RemoveLineGrid (l)
      
      nblines = nblines +1
    end
  end
  if nblines > 0 then
    sndLine: play ()
  end
  lines = lines + nblines
  
  if nblines == 1 then
    score = score + (100*level)
  elseif nblines == 2 then
    score = score + (300*level)
  elseif nblines == 3 then
    score = score + (400*level)
  elseif nblines == 4 then
    score = score + (800*level)
  end
  
  ManageLevel()
end

function UpdateGameOver (dt)
end

function love.update(dt)
  
  if gamestate == "menu" then
    UpdateMenu(dt)
  elseif gamestate == "play" then
    UpdatePlay(dt)
  elseif gamestate =="gameover" then
    UpdateGameOver(dt)
  end
  
end
function drawGrid ()
local h = Grid.CellSize
local w = h
local x,y

 for l=1,Grid.Height do
    for c=1,Grid.Width do
      
     x = ((c-1)*w) + Grid.offsetX
     y = (l-1)*h
     local id = Grid.Cells [l][c]
     
      if id == 0 then
        love.graphics.setColor (0.75,0.75,0.75,0.25)
      else
        local color = Tetros[id].color
        love.graphics.setColor (color[1],color[2],color[3])
      end
      
    love.graphics.rectangle ("fill",x,y,w-1,h-1)
    end
  end

  
end
function drawShape(pShape, pColor, pColumn, pLine)
  love.graphics.setColor(pColor[1], pColor[2], pColor[3])
  for l=1,#pShape do
    for c=1,#pShape[l] do
      -- Calcule la position initiale de la case
      local x = (c-1) * Grid.CellSize
      local y = (l-1) * Grid.CellSize
      -- Ajoute la position de la pièce
      x = x + (pColumn-1) * Grid.CellSize
      y = y + (pLine-1) * Grid.CellSize
      -- Ajoute l'offset de la grille
      x = x + Grid.offsetX
      if pShape[l][c] == 1 then
        love.graphics.rectangle("fill", x, y, Grid.CellSize - 1, Grid.CellSize - 1)
      end
    end
  end
end

function drawMenu ()
  
  local Color
  local idColor = 1
  local sMessage = ("Tetris BR 4K GONE WRONG!!!")
  local w= fontMenu:getWidth(sMessage)
  local h= fontMenu:getHeight(sMessage)
  local x = (largeur-w)/2
  local y = 0
  
  for c=1,sMessage:len() do
    Color = Tetros[idColor].color
    love.graphics.setColor (Color[1],Color[2],Color[3])
    local char = string.sub (sMessage,c,c)
    y = math.sin ((x+menuSin)/50)*30
    love.graphics.print( char, x, y+(hauteur-h)/4)
    x = x + fontMenu:getWidth(char)
    idColor = idColor + 1
      if idColor > #Tetros then
        idColor = 1
      end
  end
  
end
function drawPlay ()
  local Shape = Tetros [currentTetros.shapeId].shape[currentTetros.rotation]
  local Color = Tetros[currentTetros.shapeId].color
    
  drawShape (Shape,Color , currentTetros.position.x ,currentTetros.position.y)
  
  love.graphics.setColor (1,1,1)
  y = 100
  h = fontScore:getHeight ("X")
  
  love.graphics.print ("Score : ",50,y)
  y=y+h
  love.graphics.print (tostring(score),50,y)
  y = y + 2*h
 
  love.graphics.print ("Level : ",50,y)
  y=y+h
  love.graphics.print (tostring(level),50,y)
  y = y + 2*h
  
  love.graphics.print ("Lines : ",50,y)
  y=y+h
  love.graphics.print (tostring(lines),50,y)
end

function drawGameOver ()
  
  local sMessage = ("Game Over !")
  local w= fontMenu:getWidth(sMessage)
  local h= fontMenu:getHeight(sMessage)
  
  love.graphics.print (sMessage, (largeur-w)/2,(hauteur-h)/2)
end


function love.draw()
  
   drawGrid ()
  if gamestate == "menu" then
    drawMenu()
  elseif gamestate == "play" then
    drawPlay()
  elseif gamestate =="gameover" then
    drawGameOver()
  end
end

function InputMenu (key)
  if key == "return" then
    StartGame ()
  end
  
end
function InputPlay (key)
  if key == "r" then 
    currentTetros.rotation = currentTetros.rotation +1
    if currentTetros.rotation > #Tetros[currentTetros.shapeId] then
      currentTetros.rotation = 1
    end
  end
  
  if key == "t" then 
    currentTetros.shapeId = currentTetros.shapeId +1
    currentTetros.rotation = 1
    if currentTetros.shapeId > #Tetros then
      currentTetros.shapeId = 1
    end
  end
  local oldX = currentTetros.position.x
  local oldY = currentTetros.position.y
  local oldR = currentTetros.rotation
  
   if key == "right" then
    currentTetros.position.x = currentTetros.position.x + 1
  end
  
  if key == "left" then
    currentTetros.position.x = currentTetros.position.x - 1
  end
  
  if key == "up" then
    currentTetros.rotation = currentTetros.rotation + 1
    if currentTetros.rotation > #Tetros[currentTetros.shapeId].shape then
      
      currentTetros.rotation = 1 
    end
  end
    if Collide() then
    
  currentTetros.position.x = oldX
  currentTetros.position.y = oldY
  currentTetros.rotation = oldR
    end
  
  if forceDropPause == false then
    if key == "down"  then
      currentTetros.position.y = currentTetros.position.y + 1
      dropTimer = dropSpeed
    end
    if Collide() then
       currentTetros.position.y = oldY
       Transfert()
       SpawnTetros ()
    end
  end
  
end
function InputGameOver (key)
  if key == "return" then
    StartMenu ()
  end
end

function love.keypressed(key)
  if gamestate == "menu" then
   InputMenu(key)
  elseif gamestate == "play" then
   InputPlay(key)
  elseif gamestate =="gameover" then
    InputGameOver(key)
  end
  
end