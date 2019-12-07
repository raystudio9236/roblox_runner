math.randomseed(os.time())

local Server = {
    PlayerManager = require(game.ReplicatedStorage.Source.PlayerManager),
    RoadManager = require(game.ReplicatedStorage.Source.RoadManager),
    FireManager = require(game.ReplicatedStorage.Source.FireManager)
}

Server.PlayerManager:Init(Server)
Server.RoadManager:Init(Server)
Server.FireManager:Init(Server)

Server.RoadManager:GenRoad()
Server.RoadManager:GenRoad()

game.ReplicatedStorage.Events.StartRunning.OnServerEvent:connect(
    function(player)
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