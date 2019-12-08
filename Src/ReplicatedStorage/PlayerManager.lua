local PlayerManager = {}

local cdBillBoard = game.ReplicatedStorage.Objects.CD
local lifeBillBoard = game.ReplicatedStorage.Objects.Life

function PlayerManager:Init(server)
    self.server = server
    self.playerScore = 0
    self.playerDistance = 0
    self.playerSpeed = 0
    self.playerSpeedTimer = 0

    game.ReplicatedStorage.Events.ServerOnly.HitBall.Event:connect(function()
        self.playerScore = self.playerScore + 200
    end)

    game.ReplicatedStorage.Events.ServerOnly.HitPlayer.Event:connect(function()
        self.playerScore = math.max(0, self.playerScore - 3000)

        self.life = self.life - 1
        self.lifeTxt.Text = string.format("Life: %d", self.life)

        if self.life <= 0 then
            game.ReplicatedStorage.Events.ServerOnly.GameOver:Fire()
            print('Game Over')
        end
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

    self.characterAdded = player.CharacterAdded:connect(function(character)
        self.playerStartPos = character.HumanoidRootPart.Position

        self.playerSpeed = player.Character.Humanoid.WalkSpeed

        local cd = cdBillBoard:Clone()
        local life = lifeBillBoard:Clone()

        self.cdTxt = cd.CDTxt
        self.lifeTxt = life.LifeTxt

        self.life = self.server.PlayerConfig.DefaultLife
        self.lifeTxt.Text = string.format("Life: %d", self.life)
        self.cdTxt.Text = 'Ready Fire'

        cd.Parent = character.Head
        life.Parent = character.Head

        game.ReplicatedStorage.Events.EnableControls:FireClient(player, true)
        print('Enable Controls')
    end)
end

function PlayerManager:Update(dt)
    if not self.player then return end

    self:_CalPlayerScore()
    self:_updatePlayerSpeed(dt)
end

function PlayerManager:Clear()
    self.playerScore = 0
    self.playerDistance = 0
    self.playerStartPos = nil
    self.playerSpeedTimer = 0
    self.playerSpeed = 0

    self.characterAdded:disconnect()
end

function PlayerManager:_CalPlayerScore()
    local currentPos = self.player.Character.HumanoidRootPart.Position
    self.playerDistance = math.abs(currentPos.Z - self.playerStartPos.Z)
    self.playerScore = self.playerScore + self.playerDistance * 10
    self.playerStartPos = currentPos

    game.ReplicatedStorage.Events.UpdateScore:FireClient(self.player, self.playerScore)
end

function PlayerManager:_updatePlayerSpeed(dt)
    self.playerSpeedTimer = self.playerSpeedTimer + dt
    if self.playerSpeedTimer >= 1 then
        self.playerSpeedTimer = 0
        self.playerSpeed = self.playerSpeed + self.server.PlayerConfig.PlayerSpeedChanged
        self.player.Character.Humanoid.WalkSpeed = self.playerSpeed
    end
end

return PlayerManager