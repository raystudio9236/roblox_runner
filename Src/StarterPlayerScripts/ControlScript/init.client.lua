local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

repeat
    wait()
until player.Character

local controlsEnabled = false
local needJump = false
local needLeft = false
local needRight = false

local moveDir = Vector3.new(0, 0, -1)
local leftDir = Vector3.new(-1, 0, -1)
local rightDir = Vector3.new(1, 0, -1)

game.ReplicatedStorage.Events.EnableControls.OnClientEvent:connect(function(enabled)
	controlsEnabled = enabled
end)

game:GetService('RunService'):BindToRenderStep(
    'Controls',
    Enum.RenderPriority.Character.Value,
    function()
        if controlsEnabled then
            if player.Character and player.Character:FindFirstChild('Humanoid') then
                if needLeft then
                    player.Character.Humanoid:Move(leftDir, false)
                elseif needRight then
                    player.Character.Humanoid:Move(rightDir, false)
                else
                    player.Character.Humanoid:Move(moveDir, false)
                end

                if needJump then
                    player.Character.Humanoid.Jump = true
                    needJump = false
                end
            end
        end
    end)

local ContextActionService = game:GetService("ContextActionService")
-- Jump Key
ContextActionService:BindAction('Jump',
    function(actionName, inputState, inputObject)
        if not controlsEnabled then return end

        needJump = true;
    end, false, 'w', Enum.KeyCode.Space)

-- Left Key
ContextActionService:BindAction('Left',
    function(actionName, inputState, inputObject)
        if not controlsEnabled then return end

        if inputState == Enum.UserInputState.End then
            needLeft = false
        else
            needLeft = true
            needRight = false
        end
    end, false, 'a')

-- right Key
ContextActionService:BindAction('Right',
    function(actionName, inputState, inputObject)
        if not controlsEnabled then return end

        if inputState == Enum.UserInputState.End then
            needRight = false
        else
            needRight = true
            needLeft = false
        end
    end, false, 'd')

-- fire Key
mouse.Button1Down:Connect(function()
        if not controlsEnabled then return end

        game.ReplicatedStorage.Events.Fire:FireServer(mouse.Hit.p)
    end)