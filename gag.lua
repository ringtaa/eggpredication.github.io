local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local AnimalsModule = require(ReplicatedStorage.Datas.Animals)
local TraitsModule = require(ReplicatedStorage.Datas.Traits)
local MutationsModule = require(ReplicatedStorage.Datas.Mutations)
local PlotController = require(ReplicatedStorage.Controllers:WaitForChild("PlotController"))

local ALL_ANIMAL_NAMES = {
    ["Noobini Pizzanini"] = true,
    ["LirilÃ¬ LarilÃ "] = true,
    ["Tim Cheese"] = true,
    ["Fluriflura"] = true,
    ["Svinina Bombardino"] = true,
    ["Talpa Di Fero"] = true,
    ["Pipi Kiwi"] = true,
    ["Trippi Troppi"] = true,
    ["Tung Tung Tung Sahur"] = true,
    ["Gangster Footera"] = true,
    ["Boneca Ambalabu"] = true,
    ["Ta Ta Ta Ta Sahur"] = true,
    ["Tric Trac Baraboom"] = true,
    ["Bandito Bobritto"] = true,
    ["Cacto Hipopotamo"] = true,
    ["Cappuccino Assassino"] = true,
    ["Brr Brr Patapim"] = true,
    ["Trulimero Trulicina"] = true,
    ["Bananita Dolphinita"] = true,
    ["Brri Brri Bicus Dicus Bombicus"] = true,
    ["Bambini Crostini"] = true,
    ["Perochello Lemonchello"] = true,
    ["Burbaloni Loliloli"] = true,
    ["Chimpanzini Bananini"] = true,
    ["Ballerina Cappuccina"] = true,
    ["Chef Crabracadabra"] = true,
    ["Glorbo Fruttodrillo"] = true,
    ["Blueberrinni Octopusini"] = true,
    ["Lionel Cactuseli"] = true,
    ["Pandaccini Bananini"] = true,
    ["Frigo Camelo"] = true,
    ["Orangutini Ananassini"] = true,
    ["Bombardiro Crocodilo"] = true,
    ["Bombombini Gusini"] = true,
    ["Rhino Toasterino"] = true,
    ["Cavallo Virtuoso"] = true,
    ["Spioniro Golubiro"] = true,
    ["Zibra Zubra Zibralini"] = true,
    ["Tigrilini Watermelini"] = true,
    ["Cocofanto Elefanto"] = true,
    ["Tralalero Tralala"] = true,
    ["Odin Din Din Dun"] = true,
    ["Girafa Celestre"] = true,
    ["Gattatino Nyanino"] = true,
    ["Trenostruzzo Turbo 3000"] = true,
    ["Matteo"] = true,
    ["Tigroligre Frutonni"] = true,
    ["Orcalero Orcala"] = true,
    ["Statutino Libertino"] = true,
    ["Gattatino Neonino"] = true,
    ["La Vacca Saturno Saturnita"] = true,
    ["Los Tralaleritos"] = true,
    ["Graipuss Medussi"] = true,
    ["La Grande Combinasion"] = true,
    ["Chimpanzini Spiderini"] = true,
    ["Garama and Madundung"] = true,
    ["Torrtuginni Dragonfrutini"] = true,
    ["Las Tralaleritas"] = true,
    ["Pot Hotspot"] = true,
    ["Mythic Lucky Block"] = true,
    ["Brainrot God Lucky Block"] = true,
    ["Secret Lucky Block"] = true
}

local function getTraitMultiplier(model)
    local traitSource = model:FindFirstChild("Instance") or model
    local traitJson = traitSource:GetAttribute("Traits")
    if not traitJson then return 1 end
    local success, traitList = pcall(function()
        return HttpService:JSONDecode(traitJson)
    end)
    if not success or typeof(traitList) ~= "table" then return 1 end
    local mult = 1
    for _, traitName in ipairs(traitList) do
        local trait = TraitsModule[traitName]
        if trait and trait.MultiplierModifier then
            mult *= trait.MultiplierModifier
        end
    end
    return mult
end

local function getMutationInfo(model)
    local mutationName = model:GetAttribute("Mutation")
    if not mutationName then return nil, nil, 1 end
    local data = MutationsModule[mutationName]
    if data and data.Price then
        return mutationName, data, data.Price
    end
    return mutationName, data, 1
end

local function getFinalGeneration(model)
    local animalData = AnimalsModule[model.Name]
    if not animalData then return 0, nil end
    local baseGen = animalData.Generation or 0
    local traitMult = getTraitMultiplier(model)
    local mutationName, mutationData, mutationPrice = getMutationInfo(model)
    local mutationMult = (mutationData and mutationData.MultiplierModifier) or 1
    local total = baseGen * traitMult * mutationMult * (mutationPrice or 1)
    return math.round(total), mutationName
end

local function getMyPlot()
    local ok, result = pcall(function() return PlotController:GetMyPlot() end)
    if not ok or not result then return nil end
    local plotModel = result and result.PlotModel
    return typeof(plotModel) == "Instance" and plotModel or nil
end

local function isInEnemyPlot(model)
    local myPlot = getMyPlot()
    if not myPlot then return true end
    return not myPlot:IsAncestorOf(model)
end

local function isBasePet(m)
    return m:IsA("Model") and ALL_ANIMAL_NAMES[m.Name]
end

local function startRainbow(obj, prop)
    local cycleTime = 4
    task.spawn(function()
        while obj and obj.Parent do
            local h = (tick() % cycleTime) / cycleTime
            obj[prop] = Color3.fromHSV(h, 1, 1)
            RunService.Heartbeat:Wait()
        end
    end)
end

local function formatNumber(n)
    return tostring(n):reverse():gsub('%d%d%d', '%1,'):reverse():gsub('^,', '')
end

local function attachPetESP(m, g, mutationName)
    local root = m:FindFirstChild("RootPart") or m:FindFirstChildWhichIsA("BasePart")
    if not root then return end
    local hl = Instance.new('Highlight')
    hl.Name = "PetESP"
    hl.Adornee = m
    hl.OutlineColor = Color3.new(0, 0, 0)
    hl.FillTransparency = 0.25
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = m
    startRainbow(hl, "FillColor")
    startRainbow(hl, "OutlineColor")

    local gui = Instance.new('BillboardGui')
    gui.Name = "PetESP_Label"
    gui.Adornee = root
    gui.AlwaysOnTop = true
    gui.Size = UDim2.new(0, 400, 0, 100)
    gui.StudsOffset = Vector3.new(0, 6.5, 0)
    gui.Parent = m

    local n = Instance.new('TextLabel')
    n.Size = UDim2.new(1, 0, 0.4, 0)
    n.Position = UDim2.new(0.5, 0, 0.28, 0)
    n.AnchorPoint = Vector2.new(0.5, 0.5)
    n.BackgroundTransparency = 1
    n.Font = Enum.Font.GothamBlack
    n.TextSize = 22
    n.Text = m.Name:upper()
    n.TextXAlignment = Enum.TextXAlignment.Center
    n.Parent = gui

    local gL = Instance.new('TextLabel')
    gL.Size = UDim2.new(1, 0, 0.4, 0)
    gL.Position = UDim2.new(0.5, 0, 0.55, 0)
    gL.AnchorPoint = Vector2.new(0.5, 0.5)
    gL.BackgroundTransparency = 1
    gL.Font = Enum.Font.GothamBlack
    gL.TextSize = 28
    gL.Text = '$' .. formatNumber(g) .. '/s'
    gL.TextXAlignment = Enum.TextXAlignment.Center
    gL.Parent = gui

    if mutationName then
        local mutL = Instance.new('TextLabel')
        mutL.Size = UDim2.new(1, 0, 0.2, 0)
        mutL.Position = UDim2.new(0.5, 0, 0.82, 0)
        mutL.AnchorPoint = Vector2.new(0.5, 0.5)
        mutL.BackgroundTransparency = 1
        mutL.Font = Enum.Font.GothamBlack
        mutL.TextSize = 20
        mutL.Text = "Mutation: " .. tostring(mutationName)
        mutL.TextXAlignment = Enum.TextXAlignment.Center
        mutL.Parent = gui
        startRainbow(mutL, 'TextColor3')
    end

    startRainbow(n, 'TextColor3')
    startRainbow(gL, 'TextColor3')
end

local function clearPetESP()
    for _, m in ipairs(workspace:GetChildren()) do
        if m:FindFirstChild("PetESP") then m.PetESP:Destroy() end
        if m:FindFirstChild("PetESP_Label") then m.PetESP_Label:Destroy() end
    end
end

local INTERVAL = 0.25
local running = true

task.spawn(function()
    while running do
        local highest, bestGen, mutationName = nil, -1, nil
        for _, m in ipairs(workspace:GetChildren()) do
            if isBasePet(m) and isInEnemyPlot(m) then
                local g, mutName = getFinalGeneration(m)
                if g > bestGen then
                    bestGen = g
                    highest = m
                    mutationName = mutName
                end
            end
        end
        clearPetESP()
        if highest then
            attachPetESP(highest, bestGen, mutationName)
        end
        task.wait(INTERVAL)
    end
end)
