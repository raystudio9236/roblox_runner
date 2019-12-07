local Object = require(game.ReplicatedStorage.Source.Base.classic)

local Glass = Object:extend()
local players = game:GetService("Players")

local function BeHit(glass, delayTime)
    glass.Anchored = false
    glass.Parent.Anchored = false

    glass.Color = Color3.new(166, 66, 92)

    delay(delayTime, function()
        glass.Parent.Parent:Destroy()
    end)
end

function Glass:new()
    self.touched = false
end

function Glass:Init(script)
    self.script = script

    local glass = script.Parent
    glass.Touched:connect(function(other)
        if self.touched then return end

        if other.Name == 'IronBall' then
            self.touched = true
            print('Hit Ball')
            BeHit(glass, 1)
        else
            for i, player in pairs(players:GetPlayers()) do
                if other.Parent.Name == player.Name then
                    self.touched = true
                    print('Hit Player')
                    BeHit(glass, 0.1)
                end
            end
        end
    end)
end

return Glass