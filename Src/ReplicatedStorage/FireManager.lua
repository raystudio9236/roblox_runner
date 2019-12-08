local FireManager = {}
local PhysicsService = game:GetService("PhysicsService")
FireManager.Bullet = game.ReplicatedStorage.Objects.IronBall

local function createBullet(target)
    local bullet = FireManager.Bullet:Clone()
    bullet.Parent = workspace
    PhysicsService:SetPartCollisionGroup(bullet, 'Ball')

    local pos = FireManager.server.PlayerManager.player.Character.Head.Position
    pos = Vector3.new(pos.x, pos.y, pos.z - 1.5)
    bullet.Position = pos
    bullet.Transparency = 1

    local direction = (target - pos).unit
    direction = Vector3.new(direction.x, direction.y * 2, direction.z)
    bullet.Velocity = direction * 300

    wait(0.15)

    bullet.Transparency = 0
end

function FireManager:Init(server)
    self.server = server
    self.fireCd = server.PlayerConfig.FireCd
    self.fireTimer = 0
    self.canFire = true
end

function FireManager:Update(dt)
    if self.fireTimer > 0 then
        self.fireTimer = self.fireTimer - dt

        game.ReplicatedStorage.Events.ServerOnly.FireCdUpdate:Fire(self.fireTimer)

        if self.fireTimer <= 0 then
            self.canFire = true
        end
    end
end

function FireManager:Clear()
    self.canFire = true
    self.fireTimer = 0
end

function FireManager:Fire(pos)
    if not self.server.gameRunning then return end

    if self.canFire then
        self.canFire = false
        createBullet(pos)

        self.fireTimer = self.fireCd
        print('cd ' .. self.fireTimer)
    end
end

return FireManager