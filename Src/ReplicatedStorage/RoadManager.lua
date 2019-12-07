local RoadManager = {}

RoadManager.objects = {
    Road1 = game.ReplicatedStorage.Objects.Road1,
    Road2 = game.ReplicatedStorage.Objects.Road2,

    TopGlass = game.ReplicatedStorage.Objects.TopGlass,
    BottomGlass = game.ReplicatedStorage.Objects.BottomGlass,
    LeftGlass = game.ReplicatedStorage.Objects.LeftGlass,
    RightGlass = game.ReplicatedStorage.Objects.RightGlass,
}

RoadManager.roadIdx = 0
RoadManager.roads = {}

local ROAD_OFFSET = -512
local OB_INTERVAL = -50

function RoadManager:Init(server)
    self.server = server
end


function RoadManager:GenRoad()
    print('GenRoad')

    local obj
    if self.roadIdx == 0 then
        obj = self.objects.Road1
    else
        obj = self.objects.Road2
    end

    local newRoad = obj:Clone()
    newRoad.Parent = workspace
    newRoad.Model:SetPrimaryPartCFrame(CFrame.new(0, 0, self.roadIdx * ROAD_OFFSET))
    local r = math.random(0, 255)
    local g = math.random(0, 255)
    local b = math.random(0, 255)
    print(r, g, b)
    newRoad.Model.Root.Color = Color3.new(r, g, b)
    table.insert(self.roads, newRoad)

    local startPos = self.roadIdx * ROAD_OFFSET - ROAD_OFFSET / 2

    local glasses = {}

    for i=0, math.ceil(ROAD_OFFSET / OB_INTERVAL), 1 do
        if not (self.roadIdx == 0 and i <= 3) then
            local type = math.ceil(math.random(1, 4))
            local obj
            if type == 1 then
                obj = self.objects.TopGlass
            elseif type == 2 then
                obj = self.objects.BottomGlass
            elseif type == 3 then
                obj = self.objects.LeftGlass
            elseif type == 4 then
                obj = self.objects.RightGlass
            end

            local glass = obj:Clone()
            glass.Parent = workspace
            glass:SetPrimaryPartCFrame(CFrame.new(0, 10.5, startPos + i * OB_INTERVAL))

            table.insert(glasses, glass)
        end
    end

    self.roadIdx = self.roadIdx + 1

    if #self.roads > 4 then
        local oldRoad = self.roads[1]
        table.remove(self.roads, 1)
        oldRoad:Destroy()
        print('Clear Old Road')
    end

    wait(1)

    for _, glass in ipairs(glasses) do
        -- glass.Part.Anchored = false
        glass.Part.Glass.Anchored = false
        local g2 = glass.Part:FindFirstChild('Glass2')
        if g2 then
            g2.Anchored = false
        end
        local g3 = glass.Part:FindFirstChild('Glass3')
        if g3 then
            g3.Anchored = false
        end
    end

    glasses = nil
end

return RoadManager