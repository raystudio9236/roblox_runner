local PlayerManager = require(game.ReplicatedStorage.Source.PlayerManager)

game.ReplicatedStorage.Events.StartRunning.OnServerEvent:connect(function(player)
    print('On Start Running')
    wait(3)

    PlayerManager:Run(player)
end)
