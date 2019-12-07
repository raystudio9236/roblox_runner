local PlayerManager = require(game.ReplicatedStorage.Source.PlayerManager)

game.ReplicatedStorage.Events.StartRunning.OnServerEvent:connect(function(player)
    print('On Start Running')
    PlayerManager:Run(player)
end)
