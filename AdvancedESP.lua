-- Advanced ESP V4 - Beautiful Edition
-- Mit schönerem Design, Neon-Effekten, Gradienten

if getgenv().ESP_V4_LOADED then return end
getgenv().ESP_V4_LOADED = true

-- ========== LOAD RAYFIELD ==========
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/lzhenwei76-beep/RayfieldCopy/refs/heads/main/source.lua'))()

-- ========== SERVICES ==========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

-- ========== BEAUTIFUL ESP VARIABLES ==========
local espEnabled = false
local espMode = "All"
local selectedPlayer = nil
local selectedPlayerName = "None"

-- Beautiful ESP Options
local espStyle = "Modern" -- "Modern", "Glow", "Minimal", "Neon"
local showBox = true
local showName = true
local showDistance = true
local showHealth = true
local showTracer = false
local showGlow = true
local showCorners = true
local showStatus = true
local smoothAnimation = true

-- Beautiful Colors
local teamColor = Color3.fromRGB(0, 255, 255) -- Cyan für Team
local enemyColor = Color3.fromRGB(255, 50, 100) -- Pink/Red für Gegner
local tracerColor = Color3.fromRGB(100, 200, 255)
local healthColor = Color3.fromRGB(0, 255, 100)

-- Style Settings
local boxThickness = 2
local glowIntensity = 0.5
local cornerSize = 8
local borderRadius = 4
local updateRate = 0.1
local maxDistance = 2000

-- ESP Objects
local espObjects = {}
local lastUpdate = 0
local playerList = {}

-- ========== BEAUTY FUNCTIONS ==========
local function createGlowEffect(parent, color, intensity)
    local glow = Instance.new("BloomEffect")
    glow.Name = "GlowEffect"
    glow.Intensity = intensity or 0.3
    glow.Size = 16
    glow.Parent = parent
    
    local colorCorrection = Instance.new("ColorCorrectionEffect")
    colorCorrection.Name = "ColorCorrection"
    colorCorrection.Parent = parent
    
    return {glow, colorCorrection}
end

local function createNeonBorder(frame, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 2
    stroke.Transparency = 0.2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = frame
    
    local glow = Instance.new("UIGradient")
    glow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, color)
    })
    glow.Rotation = 45
    glow.Parent = stroke
    
    return stroke
end

local function createCornerFrame(parent, position, size, color)
    local corner = Instance.new("Frame")
    corner.Size = UDim2.new(0, size, 0, size)
    corner.Position = position
    corner.BackgroundColor3 = color
    corner.BackgroundTransparency = 0.2
    corner.BorderSizePixel = 0
    corner.Parent = parent
    
    local cornerStroke = Instance.new("UIStroke")
    cornerStroke.Color = color
    cornerStroke.Thickness = 2
    cornerStroke.Transparency = 0.5
    cornerStroke.Parent = corner
    
    return corner
end

local function createSmoothBar(parent, color, size, position)
    local bar = Instance.new("Frame")
    bar.Size = size
    bar.Position = position
    bar.BackgroundColor3 = color
    bar.BackgroundTransparency = 0.2
    bar.BorderSizePixel = 0
    bar.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = bar
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
    gradient.Rotation = 90
    gradient.Parent = bar
    
    return bar
end

-- ========== CREATE BEAUTIFUL ESP ==========
local function createBeautifulESP(player)
    if espObjects[player] then return end
    
    local char = player.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local espFolder = Instance.new("Folder")
    espFolder.Name = player.Name .. "_ESP"
    espFolder.Parent = hrp
    
    local mainColor = isTeammate(player) and teamColor or enemyColor
    
    -- Main Box Frame (für 2D ESP)
    local boxFrame = Instance.new("Frame")
    boxFrame.Name = "BoxFrame"
    boxFrame.BackgroundTransparency = 0.85
    boxFrame.BackgroundColor3 = mainColor
    boxFrame.BorderSizePixel = 0
    boxFrame.Visible = showBox
    boxFrame.Parent = espFolder
    
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, borderRadius)
    boxCorner.Parent = boxFrame
    
    -- Neon Border
    local borderStroke = Instance.new("UIStroke")
    borderStroke.Color = mainColor
    borderStroke.Thickness = boxThickness
    borderStroke.Transparency = 0.3
    borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    borderStroke.Parent = boxFrame
    
    -- Glow Effect (Bloom)
    if showGlow and espStyle == "Glow" then
        local bloom = Instance.new("BloomEffect")
        bloom.Intensity = glowIntensity
        bloom.Size = 24
        bloom.Parent = boxFrame
    end
    
    -- Corner Decorations
    local corners = {}
    if showCorners then
        corners.TL = createCornerFrame(espFolder, UDim2.new(0, -cornerSize/2, 0, -cornerSize/2), cornerSize, mainColor)
        corners.TR = createCornerFrame(espFolder, UDim2.new(1, -cornerSize/2, 0, -cornerSize/2), cornerSize, mainColor)
        corners.BL = createCornerFrame(espFolder, UDim2.new(0, -cornerSize/2, 1, -cornerSize/2), cornerSize, mainColor)
        corners.BR = createCornerFrame(espFolder, UDim2.new(1, -cornerSize/2, 1, -cornerSize/2), cornerSize, mainColor)
    end
    
    -- Billboard mit schönem Design
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "Billboard"
    billboard.Adornee = hrp
    billboard.Size = UDim2.new(0, 250, 0, 100)
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = espFolder
    
    -- Hintergrund für Text
    local textBg = Instance.new("Frame")
    textBg.Name = "TextBg"
    textBg.Size = UDim2.new(1, 0, 1, 0)
    textBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    textBg.BackgroundTransparency = 0.4
    textBg.BorderSizePixel = 0
    textBg.Parent = billboard
    
    local textBgCorner = Instance.new("UICorner")
    textBgCorner.CornerRadius = UDim.new(0, 8)
    textBgCorner.Parent = textBg
    
    -- Name Label mit Gradient
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = mainColor
    nameLabel.TextStrokeTransparency = 0.2
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 15
    nameLabel.Text = player.Name
    nameLabel.Visible = showName
    nameLabel.Parent = billboard
    
    -- Distance Label mit schöner Schrift
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Name = "DistanceLabel"
    distanceLabel.Size = UDim2.new(1, 0, 0.3, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.4, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.TextSize = 12
    distanceLabel.Text = ""
    distanceLabel.Visible = showDistance
    distanceLabel.Parent = billboard
    
    -- Health Bar (Smooth)
    local healthBg = Instance.new("Frame")
    healthBg.Name = "HealthBg"
    healthBg.Size = UDim2.new(0.9, 0, 0.12, 0)
    healthBg.Position = UDim2.new(0.05, 0, 0.75, 0)
    healthBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    healthBg.BackgroundTransparency = 0.3
    healthBg.BorderSizePixel = 0
    healthBg.Visible = showHealth
    healthBg.Parent = billboard
    
    local healthBgCorner = Instance.new("UICorner")
    healthBgCorner.CornerRadius = UDim.new(0, 4)
    healthBgCorner.Parent = healthBg
    
    local healthFill = Instance.new("Frame")
    healthFill.Name = "HealthFill"
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = healthColor
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthBg
    
    local healthFillCorner = Instance.new("UICorner")
    healthFillCorner.CornerRadius = UDim.new(0, 4)
    healthFillCorner.Parent = healthFill
    
    -- Health Gradient
    local healthGradient = Instance.new("UIGradient")
    healthGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 100)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 50))
    })
    healthGradient.Rotation = 90
    healthGradient.Parent = healthFill
    
    -- Status Icon (z.B. 💀 für tot, ⚔️ für Kampf)
    local statusIcon = Instance.new("TextLabel")
    statusIcon.Name = "StatusIcon"
    statusIcon.Size = UDim2.new(0, 20, 0, 20)
    statusIcon.Position = UDim2.new(0, 5, 0, 5)
    statusIcon.BackgroundTransparency = 1
    statusIcon.Font = Enum.Font.GothamBold
    statusIcon.TextSize = 16
    statusIcon.Text = ""
    statusIcon.Visible = showStatus
    statusIcon.Parent = billboard
    
    -- Tracer (schöne Linie)
    local tracer = Instance.new("Frame")
    tracer.Name = "Tracer"
    tracer.BackgroundColor3 = tracerColor
    tracer.BackgroundTransparency = 0.3
    tracer.BorderSizePixel = 0
    tracer.AnchorPoint = Vector2.new(0.5, 0.5)
    tracer.Visible = showTracer
    tracer.Parent = espFolder
    
    local tracerCorner = Instance.new("UICorner")
    tracerCorner.CornerRadius = UDim.new(1, 0)
    tracerCorner.Parent = tracer
    
    espObjects[player] = {
        Folder = espFolder,
        BoxFrame = boxFrame,
        BorderStroke = borderStroke,
        Corners = corners,
        Billboard = billboard,
        NameLabel = nameLabel,
        DistanceLabel = distanceLabel,
        HealthBg = healthBg,
        HealthFill = healthFill,
        StatusIcon = statusIcon,
        Tracer = tracer,
        Humanoid = char:FindFirstChild("Humanoid"),
        Head = char:FindFirstChild("Head"),
        MainColor = mainColor
    }
    
    -- Health Update
    local humanoid = espObjects[player].Humanoid
    if humanoid then
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if espObjects[player] and espObjects[player].HealthFill and humanoid then
                local percent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                espObjects[player].HealthFill.Size = UDim2.new(percent, 0, 1, 0)
                
                if humanoid.Health <= 0 then
                    espObjects[player].StatusIcon.Text = "💀"
                end
            end
        end)
        
        local percent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
        espObjects[player].HealthFill.Size = UDim2.new(percent, 0, 1, 0)
    end
end

-- ========== UPDATE BEAUTIFUL ESP ==========
local function updateBeautifulESP()
    local now = tick()
    if now - lastUpdate < updateRate then return end
    lastUpdate = now
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local shouldShow = shouldShowESP(player)
            
            if shouldShow then
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                    
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    local camera = workspace.CurrentCamera
                    
                    if hrp and camera then
                        local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
                        
                        if onScreen and screenPos.Z > 0 then
                            if not espObjects[player] then
                                createBeautifulESP(player)
                            end
                            
                            if espObjects[player] then
                                local esp = espObjects[player]
                                local mainColor = isTeammate(player) and teamColor or enemyColor
                                local dist = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and 
                                            (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude or 0
                                
                                -- Update Box Position und Größe
                                local boxHeight = 200 / screenPos.Z
                                local boxWidth = boxHeight * 0.8
                                local boxX = screenPos.X - boxWidth / 2
                                local boxY = screenPos.Y - boxHeight / 2
                                
                                if esp.BoxFrame then
                                    esp.BoxFrame.Position = UDim2.new(0, boxX, 0, boxY)
                                    esp.BoxFrame.Size = UDim2.new(0, boxWidth, 0, boxHeight)
                                    
                                    if smoothAnimation then
                                        TweenService:Create(esp.BoxFrame, TweenInfo.new(0.1), {
                                            Position = UDim2.new(0, boxX, 0, boxY),
                                            Size = UDim2.new(0, boxWidth, 0, boxHeight)
                                        }):Play()
                                    end
                                end
                                
                                -- Update Border Color
                                if esp.BorderStroke then
                                    esp.BorderStroke.Color = mainColor
                                end
                                
                                -- Update Corners
                                if esp.Corners then
                                    for _, corner in pairs(esp.Corners) do
                                        corner.BackgroundColor3 = mainColor
                                    end
                                end
                                
                                -- Update Name Color
                                if esp.NameLabel then
                                    esp.NameLabel.TextColor3 = mainColor
                                end
                                
                                -- Update Distance
                                if esp.DistanceLabel then
                                    esp.DistanceLabel.Text = dist <= maxDistance and string.format("%.0f m", dist) or ""
                                end
                                
                                -- Update Tracer
                                if showTracer and esp.Tracer then
                                    local center = camera.ViewportSize / 2
                                    local dx = screenPos.X - center.X
                                    local dy = screenPos.Y - center.Y
                                    local length = math.sqrt(dx * dx + dy * dy)
                                    if length > 0 and length < 500 then
                                        local angle = math.atan2(dy, dx) * (180 / math.pi)
                                        esp.Tracer.Size = UDim2.new(0, length, 0, 3)
                                        esp.Tracer.Position = UDim2.new(0, center.X, 0, center.Y)
                                        esp.Tracer.Rotation = angle
                                        esp.Tracer.Visible = true
                                    else
                                        esp.Tracer.Visible = false
                                    end
                                end
                            end
                        else
                            if espObjects[player] then
                                pcall(function() espObjects[player].Folder:Destroy() end)
                                espObjects[player] = nil
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

-- ========== HELPER FUNCTIONS ==========
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

local function notify(title, content, duration)
    pcall(function()
        Rayfield:Notify({Title = title, Content = content, Duration = duration or 2})
    end)
end

-- ========== UPDATE PLAYER LIST ==========
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

-- ========== REMOVE ALL ESP ==========
local function removeAllESP()
    for player, esp in pairs(espObjects) do
        pcall(function() esp.Folder:Destroy() end)
        espObjects[player] = nil
    end
end

-- ========== RAYFIELD GUI ==========
local Window = Rayfield:CreateWindow({
    Name = "ESP V4 | Beautiful",
    Icon = 0,
    LoadingTitle = "Beautiful ESP",
    LoadingSubtitle = "Premium Design",
    Theme = "Default",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BeautifulESP",
        FileName = "Config"
    },
    KeySystem = false
})

-- ========== MAIN TAB ==========
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateSection("ESP Control")

MainTab:CreateToggle({
    Name = "🎨 Beautiful ESP",
    CurrentValue = false,
    Flag = "ESPMaster",
    Callback = function(value)
        espEnabled = value
        if not espEnabled then removeAllESP() end
        notify("Beautiful ESP", value and "✨ ENABLED" or "DISABLED", 2)
    end
})

MainTab:CreateSection("ESP Style")

MainTab:CreateButton({Name = "✨ Modern Style", Callback = function() espStyle = "Modern"; notify("Style", "Modern", 1) end})
MainTab:CreateButton({Name = "🌟 Glow Style", Callback = function() espStyle = "Glow"; notify("Style", "Glow", 1) end})
MainTab:CreateButton({Name = "⬜ Minimal Style", Callback = function() espStyle = "Minimal"; notify("Style", "Minimal", 1) end})
MainTab:CreateButton({Name = "💜 Neon Style", Callback = function() espStyle = "Neon"; notify("Style", "Neon", 1) end})

MainTab:CreateSection("Filter Mode")

MainTab:CreateButton({Name = "👥 ALL PLAYERS", Callback = function() espMode = "All"; if espEnabled then removeAllESP() end; notify("Mode", "All Players", 1) end})
MainTab:CreateButton({Name = "💚 TEAMMATES ONLY", Callback = function() espMode = "Team"; if espEnabled then removeAllESP() end; notify("Mode", "Teammates Only", 1) end})
MainTab:CreateButton({Name = "❤️ ENEMIES ONLY", Callback = function() espMode = "Enemy"; if espEnabled then removeAllESP() end; notify("Mode", "Enemies Only", 1) end})
MainTab:CreateButton({Name = "🎯 SPECIFIC PLAYER", Callback = function() espMode = "Selected"; if espEnabled then removeAllESP() end; notify("Mode", "Selected Player", 1) end})

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
    end
})

-- ========== VISUAL TAB ==========
local VisualTab = Window:CreateTab("Visual", 4483362458)

VisualTab:CreateSection("Display Elements")

VisualTab:CreateToggle({Name = "📦 Show Box", CurrentValue = showBox, Flag = "ShowBox", Callback = function(v) showBox = v; notify("Box", v and "ON" or "OFF", 1) end})
VisualTab:CreateToggle({Name = "🏷️ Show Name", CurrentValue = showName, Flag = "ShowName", Callback = function(v) showName = v; notify("Name", v and "ON" or "OFF", 1) end})
VisualTab:CreateToggle({Name = "📏 Show Distance", CurrentValue = showDistance, Flag = "ShowDistance", Callback = function(v) showDistance = v; notify("Distance", v and "ON" or "OFF", 1) end})
VisualTab:CreateToggle({Name = "💚 Show Health", CurrentValue = showHealth, Flag = "ShowHealth", Callback = function(v) showHealth = v; notify("Health", v and "ON" or "OFF", 1) end})
VisualTab:CreateToggle({Name = "📈 Show Tracer", CurrentValue = showTracer, Flag = "ShowTracer", Callback = function(v) showTracer = v; notify("Tracer", v and "ON" or "OFF", 1) end})
VisualTab:CreateToggle({Name = "✨ Show Glow", CurrentValue = showGlow, Flag = "ShowGlow", Callback = function(v) showGlow = v; notify("Glow", v and "ON" or "OFF", 1) end})
VisualTab:CreateToggle({Name = "🔲 Show Corners", CurrentValue = showCorners, Flag = "ShowCorners", Callback = function(v) showCorners = v; notify("Corners", v and "ON" or "OFF", 1) end})
VisualTab:CreateToggle({Name = "🎭 Show Status", CurrentValue = showStatus, Flag = "ShowStatus", Callback = function(v) showStatus = v; notify("Status Icons", v and "ON" or "OFF", 1) end})
VisualTab:CreateToggle({Name = "🔄 Smooth Animation", CurrentValue = smoothAnimation, Flag = "SmoothAnim", Callback = function(v) smoothAnimation = v; notify("Smooth Animation", v and "ON" or "OFF", 1) end})

VisualTab:CreateSection("Colors")

VisualTab:CreateButton({Name = "💙 Team: Cyan", Callback = function() teamColor = Color3.fromRGB(0, 255, 255); notify("Team Color", "Cyan", 1) end})
VisualTab:CreateButton({Name = "💚 Team: Mint", Callback = function() teamColor = Color3.fromRGB(100, 255, 150); notify("Team Color", "Mint", 1) end})
VisualTab:CreateButton({Name = "💜 Team: Purple", Callback = function() teamColor = Color3.fromRGB(180, 100, 255); notify("Team Color", "Purple", 1) end})

VisualTab:CreateButton({Name = "❤️ Enemy: Red", Callback = function() enemyColor = Color3.fromRGB(255, 50, 50); notify("Enemy Color", "Red", 1) end})
VisualTab:CreateButton({Name = "🧡 Enemy: Orange", Callback = function() enemyColor = Color3.fromRGB(255, 100, 50); notify("Enemy Color", "Orange", 1) end})
VisualTab:CreateButton({Name = "💖 Enemy: Pink", Callback = function() enemyColor = Color3.fromRGB(255, 50, 150); notify("Enemy Color", "Pink", 1) end})

VisualTab:CreateSection("Style Settings")

VisualTab:CreateSlider({Name = "Box Thickness", Range = {1, 5}, Increment = 1, CurrentValue = boxThickness, Flag = "BoxThickness", Callback = function(v) boxThickness = v; notify("Thickness", tostring(v), 1) end})
VisualTab:CreateSlider({Name = "Glow Intensity", Range = {0, 1}, Increment = 0.1, CurrentValue = glowIntensity, Flag = "GlowIntensity", Callback = function(v) glowIntensity = v; notify("Glow", tostring(v), 1) end})
VisualTab:CreateSlider({Name = "Corner Size", Range = {4, 16}, Increment = 1, CurrentValue = cornerSize, Flag = "CornerSize", Callback = function(v) cornerSize = v; notify("Corner Size", tostring(v), 1) end})

-- ========== SETTINGS TAB ==========
local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateSection("Distance")

SettingsTab:CreateSlider({Name = "Max ESP Distance", Range = {100, 5000}, Increment = 100, Suffix = "m", CurrentValue = maxDistance, Flag = "MaxDistance", Callback = function(v) maxDistance = v; notify("Max Distance", v .. "m", 1) end})

SettingsTab:CreateSection("Performance")

SettingsTab:CreateSlider({Name = "Update Rate", Range = {0.05, 0.3}, Increment = 0.05, Suffix = "s", CurrentValue = updateRate, Flag = "UpdateRate", Callback = function(v) updateRate = v; notify("Update Rate", v .. "s", 1) end})

-- ========== INFO TAB ==========
local InfoTab = Window:CreateTab("Info", 4483362458)

InfoTab:CreateSection("About")

InfoTab:CreateParagraph({
    Title = "Beautiful ESP V4",
    Content = [[
✨ Premium Design ESP ✨

FEATURES:
• Modern/Glow/Neon Styles
• Smooth Animations
• Gradient Health Bars
• Corner Decorations
• Status Icons
• Bloom Effects
• Beautiful Colors

STYLES:
• Modern - Clean & Sleek
• Glow - Bloom Effect
• Minimal - Simple
• Neon - Vibrant

CONTROLS:
• INSERT - Menu
• F - Toggle ESP
• HOME - Unload
]]
})

-- ========== UPDATE LOOP ==========
RunService.RenderStepped:Connect(function()
    if espEnabled then
        updateBeautifulESP()
    end
end)

-- ========== HOTKEYS ==========
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then
        espEnabled = not espEnabled
        if not espEnabled then removeAllESP() end
        notify("Beautiful ESP", espEnabled and "✨ ENABLED" or "DISABLED", 2)
        local masterToggle = Rayfield:Get("ESPMaster")
        if masterToggle then masterToggle:Set(espEnabled) end
    end
    
    if input.KeyCode == Enum.KeyCode.Home then
        espEnabled = false
        removeAllESP()
        getgenv().ESP_V4_LOADED = false
        notify("ESP V4", "Unloaded", 2)
    end
end)

-- ========== INIT ==========
notify("Beautiful ESP V4", "✨ Loaded! F = Toggle | INSERT = Menu", 4)
print("=== Beautiful ESP V4 Loaded ===")
print("✨ Premium Design ESP mit Glow, Neon, Gradienten")
print("Press F to toggle | INSERT for menu")
