-- Advanced ESP Script - Rayfield GUI
-- ALL buttons are toggles/switches

if getgenv().ESP_SCRIPT_LOADED then return end
getgenv().ESP_SCRIPT_LOADED = true

-- ========== LOAD RAYFIELD ==========
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/lzhenwei76-beep/RayfieldCopy/refs/heads/main/source.lua'))()

-- ========== SERVICES ==========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- ========== ESP VARIABLES ==========
local espEnabled = false
local espMode = "All" -- "All", "Team", "Enemy", "Selected"
local selectedPlayer = nil
local selectedPlayerName = "None"

-- ESP Options (alle mit Toggle steuerbar)
local showBox = true
local showName = true
local showDistance = true
local showHealth = true
local showTracer = false
local teamColor = Color3.fromRGB(0, 255, 0)
local enemyColor = Color3.fromRGB(255, 0, 0)
local tracerColor = Color3.fromRGB(255, 255, 255)
local boxTransparency = 0.5
local maxDistance = 2000

-- ESP Objects Storage
local espObjects = {}

-- ========== PLAYER LIST ==========
local playerList = {}

local function updatePlayerList()
    playerList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
end

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()

-- ========== HELPER FUNCTIONS ==========
local function notify(title, content, duration)
    pcall(function()
        Rayfield:Notify({Title = title, Content = content, Duration = duration or 2})
    end)
end

local function isTeammate(player)
    return player.Team == LocalPlayer.Team and LocalPlayer.Team ~= nil
end

local function shouldShowESP(player)
    if player == LocalPlayer then return false end
    if not espEnabled then return false end
    
    if espMode == "All" then
        return true
    elseif espMode == "Team" then
        return isTeammate(player)
    elseif espMode == "Enemy" then
        return not isTeammate(player) and player.Team ~= nil
    elseif espMode == "Selected" then
        return selectedPlayer == player
    end
    return false
end

local function getESPColor(player)
    if isTeammate(player) then
        return teamColor
    else
        return enemyColor
    end
end

-- ========== CREATE ESP ==========
local function createESP(player)
    if espObjects[player] then return end
    
    local char = player.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local espFolder = Instance.new("Folder")
    espFolder.Name = player.Name .. "_ESP"
    espFolder.Parent = hrp
    
    -- Box
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "Box"
    box.Adornee = hrp
    box.Size = Vector3.new(4, 5, 2)
    box.Color3 = getESPColor(player)
    box.Transparency = boxTransparency
    box.AlwaysOnTop = true
    box.Visible = showBox
    box.Parent = espFolder
    
    -- Billboard
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "Billboard"
    billboard.Adornee = hrp
    billboard.Size = UDim2.new(0, 200, 0, 60)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = espFolder
    
    -- Name Label
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = getESPColor(player)
    nameLabel.TextStrokeTransparency = 0.3
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.Text = player.Name
    nameLabel.Visible = showName
    nameLabel.Parent = billboard
    
    -- Distance Label
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "DistanceLabel"
    distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distanceLabel.TextStrokeTransparency = 0.3
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.TextSize = 12
    distanceLabel.Text = ""
    distanceLabel.Visible = showDistance
    distanceLabel.Parent = billboard
    
    -- Health Bar Background
    local healthBg = Instance.new("Frame")
    healthBg.Name = "HealthBg"
    healthBg.Size = UDim2.new(1, 0, 0.15, 0)
    healthBg.Position = UDim2.new(0, 0, 1, 2)
    healthBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    healthBg.BorderSizePixel = 0
    healthBg.Visible = showHealth
    healthBg.Parent = billboard
    
    -- Health Bar Fill
    local healthFill = Instance.new("Frame")
    healthFill.Name = "HealthFill"
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthBg
    
    -- Tracer
    local tracer = Instance.new("Frame")
    tracer.Name = "Tracer"
    tracer.BackgroundColor3 = tracerColor
    tracer.BorderSizePixel = 0
    tracer.AnchorPoint = Vector2.new(0.5, 0.5)
    tracer.Visible = showTracer
    tracer.Parent = espFolder
    
    espObjects[player] = {
        Folder = espFolder,
        Box = box,
        Billboard = billboard,
        NameLabel = nameLabel,
        DistanceLabel = distanceLabel,
        HealthBg = healthBg,
        HealthFill = healthFill,
        Tracer = tracer,
        Humanoid = char:FindFirstChild("Humanoid")
    }
    
    -- Health update
    local humanoid = espObjects[player].Humanoid
    if humanoid then
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if espObjects[player] and espObjects[player].HealthFill and humanoid then
                local percent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                espObjects[player].HealthFill.Size = UDim2.new(percent, 0, 1, 0)
                if percent > 0.6 then
                    espObjects[player].HealthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                elseif percent > 0.3 then
                    espObjects[player].HealthFill.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                else
                    espObjects[player].HealthFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                end
            end
        end)
        
        local percent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
        espObjects[player].HealthFill.Size = UDim2.new(percent, 0, 1, 0)
    end
end

-- ========== UPDATE ESP ==========
local function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local shouldShow = shouldShowESP(player)
            
            if shouldShow then
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                    
                    if not espObjects[player] then
                        createESP(player)
                    else
                        local esp = espObjects[player]
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp and esp.Folder.Parent ~= hrp then
                            esp.Folder.Parent = hrp
                        end
                        
                        local color = getESPColor(player)
                        if esp.Box then 
                            esp.Box.Color3 = color
                            esp.Box.Transparency = boxTransparency
                        end
                        if esp.NameLabel then esp.NameLabel.TextColor3 = color end
                        if esp.Box then esp.Box.Visible = showBox end
                        if esp.NameLabel then esp.NameLabel.Visible = showName end
                        if esp.DistanceLabel then esp.DistanceLabel.Visible = showDistance end
                        if esp.HealthBg then esp.HealthBg.Visible = showHealth end
                        if esp.Tracer then esp.Tracer.Visible = showTracer end
                        
                        if showDistance and esp.DistanceLabel and LocalPlayer.Character then
                            local localHrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if localHrp and hrp then
                                local dist = (hrp.Position - localHrp.Position).Magnitude
                                esp.DistanceLabel.Text = dist <= maxDistance and math.floor(dist) .. "m" or ""
                            end
                        end
                        
                        if showTracer and esp.Tracer and LocalPlayer.Character then
                            local camera = workspace.CurrentCamera
                            if camera then
                                local hrpPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
                                if onScreen and hrpPos.Z > 0 then
                                    local center = camera.ViewportSize / 2
                                    local dx = hrpPos.X - center.X
                                    local dy = hrpPos.Y - center.Y
                                    local length = math.sqrt(dx * dx + dy * dy)
                                    if length > 0 then
                                        local angle = math.atan2(dy, dx) * (180 / math.pi)
                                        esp.Tracer.Size = UDim2.new(0, length, 0, 2)
                                        esp.Tracer.Position = UDim2.new(0, center.X, 0, center.Y)
                                        esp.Tracer.Rotation = angle
                                        esp.Tracer.Visible = true
                                    else
                                        esp.Tracer.Visible = false
                                    end
                                else
                                    esp.Tracer.Visible = false
                                end
                            end
                        end
                    end
                else
                    if espObjects[player] then
                        pcall(function() espObjects[player].Folder:Destroy() end)
                        espObjects[player] = nil
                    end
                end
            else
                if espObjects[player] then
                    pcall(function() espObjects[player].Folder:Destroy() end)
                    espObjects[player] = nil
                end
            end
        end
    end
end

local function removeAllESP()
    for player, esp in pairs(espObjects) do
        pcall(function() esp.Folder:Destroy() end)
        espObjects[player] = nil
    end
end

-- ========== UPDATE SETTINGS ==========
local function updateSettings()
    for player, esp in pairs(espObjects) do
        if esp.Box then 
            esp.Box.Visible = showBox
            esp.Box.Transparency = boxTransparency
        end
        if esp.NameLabel then esp.NameLabel.Visible = showName end
        if esp.DistanceLabel then esp.DistanceLabel.Visible = showDistance end
        if esp.HealthBg then esp.HealthBg.Visible = showHealth end
        if esp.Tracer then 
            esp.Tracer.Visible = showTracer
            esp.Tracer.BackgroundColor3 = tracerColor
        end
    end
end

-- ========== RAYFIELD GUI ==========
local Window = Rayfield:CreateWindow({
    Name = "Advanced ESP",
    Icon = 0,
    LoadingTitle = "Advanced ESP",
    LoadingSubtitle = "Rayfield Edition",
    Theme = "Default",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AdvancedESP",
        FileName = "Config"
    },
    KeySystem = false
})

-- ========== MAIN TAB ==========
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateSection("ESP Control")

-- ESP Master Toggle (Hauptschalter)
MainTab:CreateToggle({
    Name = "ESP Master Switch",
    CurrentValue = false,
    Flag = "ESPMaster",
    Callback = function(value)
        espEnabled = value
        if not espEnabled then
            removeAllESP()
        end
        notify("ESP", value and "ENABLED" or "DISABLED", 2)
    end
})

-- Mode Selection mit Toggle-ähnlichen Buttons
MainTab:CreateSection("ESP Mode")

MainTab:CreateButton({
    Name = "👥 ALL PLAYERS",
    Callback = function()
        espMode = "All"
        if espEnabled then removeAllESP() end
        notify("Mode", "Showing ALL players", 2)
    end
})

MainTab:CreateButton({
    Name = "👥 TEAMMATES ONLY",
    Callback = function()
        espMode = "Team"
        if espEnabled then removeAllESP() end
        notify("Mode", "Showing TEAMMATES only", 2)
    end
})

MainTab:CreateButton({
    Name = "⚔️ ENEMIES ONLY",
    Callback = function()
        espMode = "Enemy"
        if espEnabled then removeAllESP() end
        notify("Mode", "Showing ENEMIES only", 2)
    end
})

MainTab:CreateButton({
    Name = "🎯 SPECIFIC PLAYER",
    Callback = function()
        espMode = "Selected"
        if espEnabled then removeAllESP() end
        notify("Mode", "Showing SELECTED player only", 2)
    end
})

-- Player Selection Dropdown
MainTab:CreateDropdown({
    Name = "Select Player",
    Options = {"None", unpack(playerList)},
    CurrentOption = "None",
    Flag = "PlayerSelect",
    Callback = function(option)
        if option == "None" then
            selectedPlayer = nil
            selectedPlayerName = "None"
        else
            selectedPlayer = Players:FindFirstChild(option)
            selectedPlayerName = option
        end
        if espEnabled and espMode == "Selected" then
            removeAllESP()
        end
        notify("Selected Player", selectedPlayerName, 1)
    end
})

-- ========== VISUAL TAB (ALLE TOGGLES) ==========
local VisualTab = Window:CreateTab("Visual", 4483362458)

VisualTab:CreateSection("Display Toggles")

-- Box Toggle
VisualTab:CreateToggle({
    Name = "Show Box ESP",
    CurrentValue = showBox,
    Flag = "ShowBox",
    Callback = function(value)
        showBox = value
        updateSettings()
        notify("Box ESP", value and "ON" or "OFF", 1)
    end
})

-- Name Toggle
VisualTab:CreateToggle({
    Name = "Show Name",
    CurrentValue = showName,
    Flag = "ShowName",
    Callback = function(value)
        showName = value
        updateSettings()
        notify("Name Display", value and "ON" or "OFF", 1)
    end
})

-- Distance Toggle
VisualTab:CreateToggle({
    Name = "Show Distance",
    CurrentValue = showDistance,
    Flag = "ShowDistance",
    Callback = function(value)
        showDistance = value
        updateSettings()
        notify("Distance Display", value and "ON" or "OFF", 1)
    end
})

-- Health Bar Toggle
VisualTab:CreateToggle({
    Name = "Show Health Bar",
    CurrentValue = showHealth,
    Flag = "ShowHealth",
    Callback = function(value)
        showHealth = value
        updateSettings()
        notify("Health Bar", value and "ON" or "OFF", 1)
    end
})

-- Tracer Toggle
VisualTab:CreateToggle({
    Name = "Show Tracer Line",
    CurrentValue = showTracer,
    Flag = "ShowTracer",
    Callback = function(value)
        showTracer = value
        updateSettings()
        notify("Tracer Line", value and "ON" or "OFF", 1)
    end
})

-- Colors Section
VisualTab:CreateSection("Team Color")

VisualTab:CreateButton({
    Name = "🟢 Green",
    Callback = function()
        teamColor = Color3.fromRGB(0, 255, 0)
        updateSettings()
        notify("Team Color", "Green", 1)
    end
})

VisualTab:CreateButton({
    Name = "🔵 Blue",
    Callback = function()
        teamColor = Color3.fromRGB(0, 100, 255)
        updateSettings()
        notify("Team Color", "Blue", 1)
    end
})

VisualTab:CreateButton({
    Name = "🟣 Purple",
    Callback = function()
        teamColor = Color3.fromRGB(255, 0, 255)
        updateSettings()
        notify("Team Color", "Purple", 1)
    end
})

VisualTab:CreateSection("Enemy Color")

VisualTab:CreateButton({
    Name = "🔴 Red",
    Callback = function()
        enemyColor = Color3.fromRGB(255, 0, 0)
        updateSettings()
        notify("Enemy Color", "Red", 1)
    end
})

VisualTab:CreateButton({
    Name = "🟠 Orange",
    Callback = function()
        enemyColor = Color3.fromRGB(255, 100, 0)
        updateSettings()
        notify("Enemy Color", "Orange", 1)
    end
})

VisualTab:CreateButton({
    Name = "⚪ White",
    Callback = function()
        enemyColor = Color3.fromRGB(255, 255, 255)
        updateSettings()
        notify("Enemy Color", "White", 1)
    end
})

VisualTab:CreateSection("Tracer Color")

VisualTab:CreateButton({
    Name = "⚪ White",
    Callback = function()
        tracerColor = Color3.fromRGB(255, 255, 255)
        updateSettings()
        notify("Tracer Color", "White", 1)
    end
})

VisualTab:CreateButton({
    Name = "🔴 Red",
    Callback = function()
        tracerColor = Color3.fromRGB(255, 0, 0)
        updateSettings()
        notify("Tracer Color", "Red", 1)
    end
})

VisualTab:CreateButton({
    Name = "🟡 Yellow",
    Callback = function()
        tracerColor = Color3.fromRGB(255, 255, 0)
        updateSettings()
        notify("Tracer Color", "Yellow", 1)
    end
})

-- Transparency Slider
VisualTab:CreateSection("Box Transparency")

VisualTab:CreateSlider({
    Name = "Transparency",
    Range = {0, 1},
    Increment = 0.05,
    CurrentValue = boxTransparency,
    Flag = "BoxTransparency",
    Callback = function(value)
        boxTransparency = value
        updateSettings()
    end
})

-- ========== SETTINGS TAB ==========
local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateSection("Distance")

SettingsTab:CreateSlider({
    Name = "Max ESP Distance",
    Range = {100, 5000},
    Increment = 100,
    Suffix = "m",
    CurrentValue = maxDistance,
    Flag = "MaxDistance",
    Callback = function(value)
        maxDistance = value
        notify("Max Distance", value .. "m", 1)
    end
})

SettingsTab:CreateSection("Performance")

SettingsTab:CreateParagraph({
    Title = "Info",
    Content = [[
Toggle switches control what you see.
Higher distance = more performance impact.
Disable features you don't need.
]]
})

-- ========== INFO TAB ==========
local InfoTab = Window:CreateTab("Info", 4483362458)

InfoTab:CreateSection("About")

InfoTab:CreateParagraph({
    Title = "Advanced ESP Script",
    Content = [[
Version: 2.0
ALL features are toggles!

FEATURES:
✓ ESP Master Switch
✓ Box ESP (Toggle)
✓ Name Display (Toggle)
✓ Distance Display (Toggle)
✓ Health Bar (Toggle)
✓ Tracer Line (Toggle)
✓ Team/Enemy Colors
✓ Player Selection

MODES:
• All Players
• Teammates Only
• Enemies Only
• Selected Player

CONTROLS:
• INSERT - Open/Close Menu
• HOME - Unload Script
]]
})

-- ========== UPDATE LOOP ==========
RunService.RenderStepped:Connect(function()
    if espEnabled then
        updateESP()
    end
end)

-- ========== CHARACTER RESPAWN ==========
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if espEnabled then
        removeAllESP()
    end
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            if espEnabled and espObjects[player] then
                pcall(function() espObjects[player].Folder:Destroy() end)
                espObjects[player] = nil
            end
        end)
    end
end

-- ========== PLAYER LIST UPDATE ==========
Players.PlayerAdded:Connect(function()
    updatePlayerList()
    local dropdown = Rayfield:Get("PlayerSelect")
    if dropdown then
        dropdown:SetOptions({"None", unpack(playerList)})
    end
end)

Players.PlayerRemoving:Connect(function()
    updatePlayerList()
    local dropdown = Rayfield:Get("PlayerSelect")
    if dropdown then
        dropdown:SetOptions({"None", unpack(playerList)})
    end
end)

-- ========== CLEANUP ==========
local function cleanup()
    espEnabled = false
    removeAllESP()
    getgenv().ESP_SCRIPT_LOADED = false
    notify("ESP", "Script unloaded!", 2)
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Home then
        cleanup()
    end
end)

-- ========== INIT ==========
notify("Advanced ESP", "Loaded! Press INSERT for menu", 3)
print("=== Advanced ESP Script Loaded ===")
print("ALL features are toggles/switches!")
print("Press INSERT for Rayfield menu")
