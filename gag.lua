local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local mouse = Players.LocalPlayer:GetMouse()
local ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/Singularity5490/rbimgui-2/main/rbimgui-2.lua"))()
local window = ui.new({text="booga booga :flushed:", size=Vector2.new(400, 300)})
local mainTab = window.new({text="main"})
local combatTab = window.new({text="combat"})
local autofarmTab = window.new({text="autofarm"})
local killauraToggle = combatTab.new("Switch", {text="kill aura"})
local autohealToggle = combatTab.new("Switch", {text="auto heal"})
local autohealSlider = combatTab.new("Slider", {text="auto heal health", min=1, max=99, value=30})
local breakauraToggle = mainTab.new("Switch", {text="mine aura"})
local pickupToggle = mainTab.new("Switch", {text="auto pickup"})
local autofarmToggle = autofarmTab.new("Switch", {text="everything autofarm"})
mainTab.new("Label", {text="fly will freeze you when you run it"})
local flyToggle = mainTab.new("Switch", {text="fly"})
local autoPlant = autofarmTab.new("Switch", {text="auto plant fruit"})
local autoharvest = autofarmTab.new("Switch", {text="auto harvest fruit"})
local chosenFruit = "Bloodfruit"
local fruits = {
    "Bloodfruit",
    "Sunfruit",
    "Bluefruit",
    "Berry"
}
local autoplantDropdown = autofarmTab.new("Dropdown", {text="fruits"})
local plantButton = autofarmTab.new("Button", {text=" plant 5 boxes "})
plantButton.event:Connect(function()
    for i = 1, 5 do
        local ohString1 = "Plant Box"
        local ohCFrame2 = CFrame.new(Players.LocalPlayer.Character.HumanoidRootPart.Position.X,Players.LocalPlayer.Character.HumanoidRootPart.Position.Y-3,Players.LocalPlayer.Character.HumanoidRootPart.Position.Z+i, 1, 0, 0, 0, 1, 0, 0, 0, 1)
        local ohNumber3 = 0
        game:GetService("ReplicatedStorage").Events.PlaceStructure:FireServer(ohString1, ohCFrame2, ohNumber3)
    end
end)
for i,v in pairs(fruits) do
    autoplantDropdown.new(v)
end
autoplantDropdown.event:Connect(function(v)
    chosenFruit = v
end)




FLYING = false
iyflyspeed = 0.25
vehicleflyspeed = 0.25


-- i love stealing features from infinite yield and adding them to my script :sunglasses:
function sFLY(vfly)
    repeat wait() until Players.LocalPlayer and Players.LocalPlayer.Character and Players.LocalPlayer.Character.HumanoidRootPart and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    repeat wait() until mouse
    if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end

    local T = Players.LocalPlayer.Character.HumanoidRootPart
    local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local SPEED = 0

    local function FLY()
        FLYING = true
        local BG = Instance.new('BodyGyro')
        local BV = Instance.new('BodyVelocity')
        BG.P = 9e4
        BG.Parent = T
        BV.Parent = T
        BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        BG.cframe = T.CFrame
        BV.velocity = Vector3.new(0, 0, 0)
        BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
        task.spawn(function()
            repeat wait()
                if not vfly and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
                    Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
                end
                if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
                    SPEED = 50
                elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
                    SPEED = 0
                end
                if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
                    BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
                    lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
                elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
                    BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
                else
                    BV.velocity = Vector3.new(0, 0, 0)
                end
                BG.cframe = workspace.CurrentCamera.CoordinateFrame
            until not FLYING
            CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
            lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
            SPEED = 0
            BG:Destroy()
            BV:Destroy()
            if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
                Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
            end
        end)
    end
    flyKeyDown = mouse.KeyDown:Connect(function(KEY)
        if KEY:lower() == 'w' then
            CONTROL.F = (vfly and vehicleflyspeed or iyflyspeed)
        elseif KEY:lower() == 's' then
            CONTROL.B = - (vfly and vehicleflyspeed or iyflyspeed)
        elseif KEY:lower() == 'a' then
            CONTROL.L = - (vfly and vehicleflyspeed or iyflyspeed)
        elseif KEY:lower() == 'd' then 
            CONTROL.R = (vfly and vehicleflyspeed or iyflyspeed)
        elseif QEfly and KEY:lower() == 'e' then
            CONTROL.Q = (vfly and vehicleflyspeed or iyflyspeed)*2
        elseif QEfly and KEY:lower() == 'q' then
            CONTROL.E = -(vfly and vehicleflyspeed or iyflyspeed)*2
        end
        pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
    end)
    flyKeyUp = mouse.KeyUp:Connect(function(KEY)
        if KEY:lower() == 'w' then
            CONTROL.F = 0
        elseif KEY:lower() == 's' then
            CONTROL.B = 0
        elseif KEY:lower() == 'a' then
            CONTROL.L = 0
        elseif KEY:lower() == 'd' then
            CONTROL.R = 0
        elseif KEY:lower() == 'e' then
            CONTROL.Q = 0
        elseif KEY:lower() == 'q' then
            CONTROL.E = 0
        end
    end)
    FLY()
end

function NOFLY()
    FLYING = false
    if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end
    if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
        Players.LocalPlayer.Character.Humanoid.PlatformStand = false
    end
    pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end

flyToggle.event:Connect(function(v)
    if v then
        Players.LocalPlayer.Character:SetPrimaryPartCFrame(Players.LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,0,32))
        task.wait(0.01)
        Players.LocalPlayer.Character:SetPrimaryPartCFrame(Players.LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,0,32))
        wait(0.5)
        sFLY(true)
    else
        NOFLY()
    end
end)

-- took this from devforums
local function getClosest()
    local hrp = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position
    local closest_distance = math.huge
    local closestperson

    for i,v in pairs(game.Players:GetPlayers()) do
        if v.Character ~= nil and v ~= Players.LocalPlayer and v.Character:FindFirstChild("HumanoidRootPart") ~= nil and v.Character:FindFirstChild("Humanoid").Health > 0 then
            local plr_pos = v.Character.HumanoidRootPart.Position
            local plr_distance = (hrp - plr_pos).Magnitude
    
            if plr_distance < closest_distance then
                closest_distance = plr_distance
                closestperson = v
            end
        end
    end

    return closestperson
end

local function getClosestObject(folder)
    local distance, part = math.huge, nil
    local Character = Players.LocalPlayer.Character
    if Character:FindFirstChild("HumanoidRootPart") then
        for i,v in pairs(folder:GetChildren()) do
            if v and not v:FindFirstChild("Humanoid") and v:FindFirstChild("Health") then
                local HRPPosition = Character:FindFirstChild("HumanoidRootPart").Position
                for i2,v2 in pairs(v:GetChildren()) do
                    if v2:IsA("BasePart") then
                        local realDistance = math.abs((HRPPosition - v2.Position).Magnitude)
        
                        if realDistance < distance then
                            distance = realDistance
                            part = v2
                        end
                    end
                end
            end
        end
    end
    return part
end

local function getClosestPickups(folder)
    local Character = Players.LocalPlayer.Character
    local pickups = {}
    for i,v in pairs(folder:GetChildren()) do
        if v:FindFirstChild("Pickup") and v:IsA("BasePart") and table.find(pickups,v) == nil and Character:FindFirstChild("HumanoidRootPart") then
            if (Character.HumanoidRootPart.Position - v.Position).Magnitude <= 30 then
                table.insert(pickups, v)
            end
        end
    end
    return pickups
end

while wait(0.2) do
    local Character = Players.LocalPlayer.Character
    if killauraToggle.on then
        if Character:FindFirstChild("HumanoidRootPart") then
            local closest = getClosest()
            local hrp = Character.HumanoidRootPart.Position

            -- guessing the distance tbh
            if (hrp - closest.Character.HumanoidRootPart.Position).Magnitude <= 10 then
                ReplicatedStorage.Events.SwingTool:FireServer(ReplicatedStorage.RelativeTime.Value, {
                    [1] = closest.Character.HumanoidRootPart
                })
            end
        end
    end

    if autohealToggle.on then
        if Character:FindFirstChild("Humanoid") then
            if Character.Humanoid.Health <= autohealSlider.value then
                game:GetService("ReplicatedStorage").Events.UseBagltem:FireServer("Bloodfruit")
            end
        end
    end

    if breakauraToggle.on then
        local closestPart = getClosestObject(workspace)
        local hrp = Character.HumanoidRootPart.Position
        
        if (hrp - closestPart.Position).Magnitude <= 40 then
            ReplicatedStorage.Events.SwingTool:FireServer(ReplicatedStorage.RelativeTime.Value, {
                [1] = closestPart
            })
        end
    end

    if pickupToggle.on then
        for i,v in pairs(getClosestPickups(workspace)) do
            game:GetService("ReplicatedStorage").Events.Pickup:FireServer(v)
        end
    end
    if autofarmToggle.on then
        local part = getClosestObject(workspace)
        local HRPPosition = Players.LocalPlayer.Character.HumanoidRootPart.Position
        local realDistance = math.round(math.abs((HRPPosition - part.Position).Magnitude))
    
        ReplicatedStorage.Events.SwingTool:FireServer(ReplicatedStorage.RelativeTime.Value, {
            [1] = part
        })
        for i,v in pairs(getClosestPickups(workspace)) do
            game:GetService("ReplicatedStorage").Events.Pickup:FireServer(v)
        end
        wait(0.1)
        if part.Position.Y <= 30 then
            TweenService:Create(Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(realDistance/10, Enum.EasingStyle.Linear), {CFrame=part.CFrame+Vector3.new(0,part.Size.Y,0)}):Play()
            task.wait(realDistance/10)
        end
    end

    if autoPlant.on then
        local hrp = Character.HumanoidRootPart.Position
        for i,v in pairs(workspace.Deployables:GetChildren()) do
            if v.Name == "Plant Box" then
                local part = v:FindFirstChildOfClass("Part")
                if (hrp - part.Position).Magnitude <= 10 then
                    game:GetService("ReplicatedStorage").Events.lnteractStructure:FireServer(v, chosenFruit)
                end
            end
        end
    end

    if autoharvest.on then
        local hrp = Character.HumanoidRootPart.Position
        for i,v in pairs(workspace:GetChildren()) do
            if v.Name == chosenFruit.." Bush" and (hrp - v:FindFirstChildOfClass("Part").Position).Magnitude <= 30 then
                game:GetService("ReplicatedStorage").Events.Pickup:FireServer(v)
            end
        end
        end
end
