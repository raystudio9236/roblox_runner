local PlayerManager = {}

function PlayerManager:Run(player)
    _player = player

    game.ReplicatedStorage.Events.EnableControls:FireClient(player, true)
    print('Enable Controls')
end

return PlayerManager