math.randomseed(os.time())

local PlayerManager = require(game.ReplicatedStorage.Source.PlayerManager)
local RoadManager = require(game.ReplicatedStorage.Source.RoadManager)

RoadManager:GenRoad()
RoadManager:GenRoad()

game.ReplicatedStorage.Events.StartRunning.OnServerEvent:connect(
    function(player)
        print('On Start Running')
        wait(3)

        PlayerManager:Run(player)
    end)

game.ReplicatedStorage.Events.GenRoad.OnServerEvent:connect(
    function()
        RoadManager:GenRoad()
    end)