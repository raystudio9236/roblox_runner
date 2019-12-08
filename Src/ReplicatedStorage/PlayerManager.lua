local PlayerManager = {}

local cdBillBoard = game.ReplicatedStorage.Objects.CD
local lifeBillBoard = game.ReplicatedStorage.Objects.Life

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

    game.ReplicatedStorage.Events.ServerOnly.FireCdUpdate.Event:connect(function(timer)
        if timer <= 0 then
            self.cdTxt.Text = 'Ready Fire'
        else
            self.cdTxt.Text = string.format( "Fire CD: %0.2f", timer)
        end
    end)
end

function PlayerManager:Run(player)
    self.player = player
    self.playerStartPos = player.Character.HumanoidRootPart.Position

    local cd = cdBillBoard:Clone()
    local life = lifeBillBoard:Clone()

    self.cdTxt = cd.CDTxt
    self.lifeTxt = life.LifeTxt

    self.lifeTxt.Text = string.format("Life: %d", self.server.PlayerConfig.DefaultLife)
    self.cdTxt.Text = 'Ready Fire'

    cd.Parent = game.workspace[player.Name].Head
    life.Parent = game.workspace[player.Name].Head

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