local FireManager = {}
FireManager.Bullet = game.ReplicatedStorage.Objects.IronBall

local function createBullet(target)
    local bullet = FireManager.Bullet:Clone()
    bullet.Parent = workspace

    local pos = FireManager.server.PlayerManager.Player.Character.Head.Position
    pos = Vector3.new(pos.x, pos.y, pos.z - 3.5)
    bullet.Position = pos
    bullet.Transparency = 1

    local direction = (target - pos).unit
    bullet.Velocity = direction * 500

    wait(0.2)

    bullet.Transparency = 0
end

function FireManager:Init(server)
    self.server = server
end

function FireManager:Fire(pos)
    createBullet(pos)
end

return FireManager