local PlayerManager = {}

function PlayerManager:Init(server)
    self.server = server
    self.playerScore = 0
    self.playerDistance = 0

    game.ReplicatedStorage.Events.ServerOnly.HitBall.Event:connect(function()
        self.playerScore = self.playerScore + 200
    end)

    game.ReplicatedStorage.Events.ServerOnly.HitPlayer.Event:connect(function()
        self.playerScore = math.max(0, self.playerScore - 3000)
    end)
end

function PlayerManager:Run(player)
    self.player = player
    self.playerStartPos = player.Character.HumanoidRootPart.Position

    game.ReplicatedStorage.Events.EnableControls:FireClient(player, true)
    print('Enable Controls')
end

function PlayerManager:Update(dt)
    if not self.player then return end

    self:_CalPlayerScore()
end

function PlayerManager:_CalPlayerScore()
    local currentPos = self.player.Character.HumanoidRootPart.Position
    self.playerDistance = math.abs(currentPos.Z - self.playerStartPos.Z)
    self.playerScore = self.playerScore + self.playerDistance * 10
    self.playerStartPos = currentPos

    game.ReplicatedStorage.Events.UpdateScore:FireClient(self.player, self.playerScore)
end

return PlayerManager