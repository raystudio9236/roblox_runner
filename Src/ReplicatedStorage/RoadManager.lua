local RoadManager = {}

RoadManager.objects = {
    Road1 = game.ReplicatedStorage.Objects.Road1,
    Road2 = game.ReplicatedStorage.Objects.Road2
}

RoadManager.roadIdx = 0
RoadManager.roads = {}

local ROAD_OFFSET = -512

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
    local r = math.random(0, 256)
    local g = math.random(0, 256)
    local b = math.random(0, 256)
    print(r, g, b)
    newRoad.Model.Root.Color = Color3.new(r, g, b)
    table.insert(self.roads, newRoad)

    self.roadIdx = self.roadIdx + 1
end

return RoadManager