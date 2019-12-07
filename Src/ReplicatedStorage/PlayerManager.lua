local PlayerManager = {}
PlayerManager.Player = nil

function PlayerManager:Init(server)
    self.server = server
end

function PlayerManager:Run(player)
    self.Player = player

    game.ReplicatedStorage.Events.EnableControls:FireClient(player, true)
    print('Enable Controls')
end

return PlayerManager