math.randomseed(os.time())
local RunService = game:GetService("RunService")

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

Server.RoadManager:GenRoad()
Server.RoadManager:GenRoad()


local frame = 0

local function MainLoop(dt)
    if not Server.gameRunning then return end

    Server.PlayerManager:Update(dt)
    Server.FireManager:Update(dt)
end

game.ReplicatedStorage.Events.StartRunning.OnServerEvent:connect(
    function(player)
        Server.gameRunning = true

        print('On Start Running')
        wait(3)

        Server.PlayerManager:Run(player)
    end)

game.ReplicatedStorage.Events.GenRoad.OnServerEvent:connect(
    function(player)
        Server.RoadManager:GenRoad()
    end)

game.ReplicatedStorage.Events.Fire.OnServerEvent:connect(
    function(player, position)
        Server.FireManager:Fire(position)
    end)

RunService.Heartbeat:Connect(MainLoop)