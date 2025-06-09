local replicatedStorage = game:GetService("ReplicatedStorage")
local collectionService = game:GetService("CollectionService")
local players = game:GetService("Players")
local runService = game:GetService("RunService")
 
local localPlayer = players.LocalPlayer
local currentCamera = workspace.CurrentCamera
 
local hatchFunction = getupvalue(getupvalue(getconnections(replicatedStorage.GameEvents.PetEggService.OnClientEvent)[1].Function, 1), 2)
local eggModels = getupvalue(hatchFunction, 1)
local eggPets = getupvalue(hatchFunction, 2)
 
local espCache = {}
local activeEggs = {}
 
local function getObjectFromId(objectId)
    for eggModel in eggModels do
        if eggModel:GetAttribute("OBJECT_UUID") ~= objectId then continue end
        return eggModel
    end
end
 
local function UpdateEsp(objectId, petName)
    local object = getObjectFromId(objectId)
    if not object or not espCache[objectId] then return end
 
    local eggName = object:GetAttribute("EggName")
    espCache[objectId].Text = `{eggName} | {petName}`
end
 
local function AddEsp(object)
    if object:GetAttribute("OWNER") ~= localPlayer.Name then return end
 
    local eggName = object:GetAttribute("EggName")
    local petName = eggPets[object:GetAttribute("OBJECT_UUID")]
 
    local objectId = object:GetAttribute("OBJECT_UUID")
    if not objectId then return end
 
    local label = Drawing.new("Text")
    label.Text = `{eggName} | {petName or "?"}`
    label.Size = 18
    label.Color = Color3.new(1, 1, 1)
    label.Outline = true
    label.OutlineColor = Color3.new(0, 0, 0)
    label.Center = true
    label.Visible = false
 
    espCache[objectId] = label
    activeEggs[objectId] = object
end
 
local function RemoveEsp(object)
    if object:GetAttribute("OWNER") ~= localPlayer.Name then return end
 
    local objectId = object:GetAttribute("OBJECT_UUID")
    if espCache[objectId] then
        espCache[objectId]:Remove()
        espCache[objectId] = nil
    end
 
    activeEggs[objectId] = nil
end
 
local function UpdateAllEsp()
    for objectId, object in activeEggs do
        if not object or not object:IsDescendantOf(workspace) then
            activeEggs[objectId] = nil
            if espCache[objectId] then
                espCache[objectId].Visible = false
            end
            continue
        end
 
        local label = espCache[objectId]
        if label then
            local pos, onScreen = currentCamera:WorldToViewportPoint(object:GetPivot().Position)
            if onScreen then
                label.Position = Vector2.new(pos.X, pos.Y)
                label.Visible = true
            else
                label.Visible = false
            end
        end
    end
end
 
for _, object in collectionService:GetTagged("PetEggServer") do
    task.spawn(AddEsp, object)
end
 
collectionService:GetInstanceAddedSignal("PetEggServer"):Connect(AddEsp)
collectionService:GetInstanceRemovedSignal("PetEggServer"):Connect(RemoveEsp)
 
local old; old = hookfunction(getconnections(replicatedStorage.GameEvents.EggReadyToHatch_RE.OnClientEvent)[1].Function, newcclosure(function(objectId, petName)
    UpdateEsp(objectId, petName)
    return old(objectId, petName)
end))
 
runService.PreRender:Connect(UpdateAllEsp)
