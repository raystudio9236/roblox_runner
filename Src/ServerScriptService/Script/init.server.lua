math.randomseed(os.time())
local RunService = game:GetService("RunService")
local gameOverUI = game.ReplicatedStorage.Objects.GameOverGui

game.Players.CharacterAutoLoads = false

local Server = {
    PlayerManager = require(game.ReplicatedStorage.Source.PlayerManager),
    RoadManager = require(game.ReplicatedStorage.Source.RoadManager),
    FireManager = require(game.ReplicatedStorage.Source.FireManager),
    PlayerConfig = require(game.ReplicatedStorage.Source.PlayerConfig),
}

Server.gameRunning = false

Server.PlayerManager:Init(Server)
Server.RoadManager:Init(Server)
Server.FireManager:Init(Server)

local function MainLoop(dt)
    if not Server.gameRunning then return end

    Server.PlayerManager:Update(dt)
    Server.FireManager:Update(dt)
end

local function StartGame(player)
    Server.RoadManager:GenRoad()
    Server.RoadManager:GenRoad()

    Server.PlayerManager:Run(player)

    local c1
    c1 = player.CharacterAdded:connect(function()
        Server.gameRunning = true
        print('On Start Running')
    end)

    player:LoadCharacter()

    c1:disconnect()
end

game.ReplicatedStorage.Events.StartRunning.OnServerEvent:connect(
    function(player)
        StartGame(player)
    end)

game.ReplicatedStorage.Events.GenRoad.OnServerEvent:connect(
    function(player)
        Server.RoadManager:GenRoad()
    end)

game.ReplicatedStorage.Events.Fire.OnServerEvent:connect(
    function(player, position)
        Server.FireManager:Fire(position)
    end)

game.ReplicatedStorage.Events.ServerOnly.GameOver.Event:connect(function()
    Server.gameRunning = false
    Server.RoadManager:Clear()
    Server.FireManager:Clear()

    wait(2)

    local player = Server.PlayerManager.player
    player.Character:Destroy()
    
    -- show game over ui
    local gou = gameOverUI:Clone()
    gou.Parent = player:WaitForChild('PlayerGui')

    gou.Frame.BestScoreTxt.Text = string.format("-- Best Score: %d --", Server.PlayerManager.playerScore)
    local c1
    c1 = gou.Frame.TextButton.MouseButton1Click:connect(function()
        c1:disconnect()
        gou:Destroy()

        StartGame(player)
    end)

    Server.PlayerManager:Clear()
end)

RunService.Heartbeat:Connect(MainLoop)