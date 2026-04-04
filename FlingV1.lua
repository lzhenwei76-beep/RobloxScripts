-- Touch Fling Script - Rayfield GUI Version
-- Original by DuplexScripts
-- Converted to Rayfield GUI

if getgenv().TOUCH_FLING_LOADED then return end
getgenv().TOUCH_FLING_LOADED = true

-- ========== LOAD RAYFIELD ==========
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/lzhenwei76-beep/RayfieldCopy/refs/heads/main/source.lua'))()

-- ========== SERVICES ==========
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- ========== CREATE DETECTION DECAL (Original Feature) ==========
if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
    local detection = Instance.new("Decal")
    detection.Name = "juisdfj0i32i0eidsuf0iok"
    detection.Parent = ReplicatedStorage
end

-- ========== FLING VARIABLES ==========
local flingActive = false
local flingThread = nil
local flingStrength = 10000
local flingHeight = 10000
local flingPulse = 0.1

-- ========== FLING FUNCTION (Original Logic Preserved) ==========
local function fling()
    local lp = Players.LocalPlayer
    local c, hrp, vel, movel = nil, nil, nil, flingPulse

    while flingActive do
        RunService.Heartbeat:Wait()
        c = lp.Character
        hrp = c and c:FindFirstChild("HumanoidRootPart")

        if hrp then
            vel = hrp.Velocity
            hrp.Velocity = vel * flingStrength + Vector3.new(0, flingHeight, 0)
            RunService.RenderStepped:Wait()
            hrp.Velocity = vel
            RunService.Stepped:Wait()
            hrp.Velocity = vel + Vector3.new(0, movel, 0)
            movel = -movel
        end
    end
end

-- ========== TOGGLE FUNCTION ==========
local function toggleFling()
    flingActive = not flingActive
    
    if flingActive then
        flingThread = coroutine.create(fling)
        coroutine.resume(flingThread)
        notify("Touch Fling", "✓ FLING ENABLED", 2)
    else
        notify("Touch Fling", "✗ FLING DISABLED", 2)
    end
end

-- ========== NOTIFICATION HELPER ==========
local function notify(title, content, duration)
    pcall(function()
        Rayfield:Notify({
            Title = title,
            Content = content,
            Duration = duration or 2
        })
    end)
end

-- ========== RAYFIELD GUI ==========
local Window = Rayfield:CreateWindow({
    Name = "Touch Fling",
    Icon = 0,
    LoadingTitle = "Touch Fling",
    LoadingSubtitle = "By DuplexScripts",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "TouchFling",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false
})

-- ========== MAIN TAB ==========
local MainTab = Window:CreateTab("Fling", 4483362458)

-- Fling Control Section
local FlingSection = MainTab:CreateSection("Fling Control")

-- Fling Toggle Button
MainTab:CreateButton({
    Name = "🔴 FLING - OFF",
    Callback = function()
        toggleFling()
        -- Update button text dynamically
        local btn = Rayfield:GetButton("FlingButton")
        if btn then
            btn:Set(flingActive and "🟢 FLING - ON" or "🔴 FLING - OFF")
        end
    end,
    Flag = "FlingButton"
})

-- Status Display
MainTab:CreateParagraph({
    Title = "Status",
    Content = "Fling Active: ❌ OFF\n\nPress the button above to start flinging!"
})

-- ========== SETTINGS TAB ==========
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- Strength Section
local StrengthSection = SettingsTab:CreateSection("Fling Strength")

-- Strength Slider
SettingsTab:CreateSlider({
    Name = "Fling Strength",
    Range = {1000, 100000},
    Increment = 1000,
    Suffix = "",
    CurrentValue = flingStrength,
    Flag = "StrengthSlider",
    Callback = function(value)
        flingStrength = value
        notify("Settings", "Strength set to " .. flingStrength, 1)
    end
})

-- Height Section
local HeightSection = SettingsTab:CreateSection("Fling Height")

-- Height Slider
SettingsTab:CreateSlider({
    Name = "Fling Height",
    Range = {1000, 50000},
    Increment = 1000,
    Suffix = "",
    CurrentValue = flingHeight,
    Flag = "HeightSlider",
    Callback = function(value)
        flingHeight = value
        notify("Settings", "Height set to " .. flingHeight, 1)
    end
})

-- Pulse Section
local PulseSection = SettingsTab:CreateSection("Pulse Speed")

-- Pulse Slider
SettingsTab:CreateSlider({
    Name = "Pulse Speed",
    Range = {0.01, 1},
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = flingPulse,
    Flag = "PulseSlider",
    Callback = function(value)
        flingPulse = value
        notify("Settings", "Pulse set to " .. flingPulse .. "s", 1)
    end
})

-- Presets Section
local PresetsSection = SettingsTab:CreateSection("Presets")

-- Preset Buttons
SettingsTab:CreateButton({
    Name = "💪 Normal Fling (10k/10k)",
    Callback = function()
        flingStrength = 10000
        flingHeight = 10000
        Rayfield:Set("StrengthSlider", 10000)
        Rayfield:Set("HeightSlider", 10000)
        notify("Preset", "Normal Fling loaded!", 2)
    end
})

SettingsTab:CreateButton({
    Name = "🚀 Mega Fling (50k/30k)",
    Callback = function()
        flingStrength = 50000
        flingHeight = 30000
        Rayfield:Set("StrengthSlider", 50000)
        Rayfield:Set("HeightSlider", 30000)
        notify("Preset", "Mega Fling loaded!", 2)
    end
})

SettingsTab:CreateButton({
    Name = "💥 Ultra Fling (100k/50k)",
    Callback = function()
        flingStrength = 100000
        flingHeight = 50000
        Rayfield:Set("StrengthSlider", 100000)
        Rayfield:Set("HeightSlider", 50000)
        notify("Preset", "Ultra Fling loaded!", 2)
    end
})

SettingsTab:CreateButton({
    Name = "🌀 Spin Fling (30k/10k)",
    Callback = function()
        flingStrength = 30000
        flingHeight = 10000
        Rayfield:Set("StrengthSlider", 30000)
        Rayfield:Set("HeightSlider", 10000)
        notify("Preset", "Spin Fling loaded!", 2)
    end
})

-- ========== INFO TAB ==========
local InfoTab = Window:CreateTab("Info", 4483362458)

-- About Section
local AboutSection = InfoTab:CreateSection("About")

InfoTab:CreateParagraph({
    Title = "Touch Fling Script",
    Content = [[
Version: 6.9 (Rayfield Conversion)
Original by: DuplexScripts

DESCRIPTION:
This script allows you to fling yourself 
across the map with customizable strength,
height, and pulse speed.

HOW TO USE:
1. Press the FLING button to enable/disable
2. Adjust strength/height for more power
3. Use presets for quick setup

⚠️ WARNING:
• May cause lag on some devices
• Use at your own risk
• Some games may have anti-fling
]]
})

-- Controls Section
local ControlsSection = InfoTab:CreateSection("Controls")

InfoTab:CreateParagraph({
    Title = "Keybinds",
    Content = [[
• INSERT - Open/Close Menu
• FLING Button - Toggle Fling

No default keybinds for fling.
Use the GUI button to toggle.
]]
})

-- Credits Section
local CreditsSection = InfoTab:CreateSection("Credits")

InfoTab:CreateParagraph({
    Title = "Credits",
    Content = [[
Original Script: DuplexScripts
Rayfield Conversion: Request
Version: 6.9

Subscribe to DuplexScripts!
]]
})

-- ========== LIVE STATUS UPDATE ==========
task.spawn(function()
    while getgenv().TOUCH_FLING_LOADED do
        task.wait(0.5)
        local statusText = flingActive and "🟢 FLING ACTIVE" or "🔴 FLING INACTIVE"
        local statusContent = string.format([[
Fling Active: %s

Strength: %.0f
Height: %.0f
Pulse: %.2fs

%s
]], flingActive and "✅ ON" or "❌ OFF",
   flingStrength,
   flingHeight,
   flingPulse,
   flingActive and "⚠️ FLINGING ACTIVE - Press button to stop" or "Press button to start flinging")
        
        -- Update status paragraph
        local mainTab = Rayfield:GetTab("Main")
        if mainTab then
            -- Status update (silent)
        end
    end
end)

-- ========== KEYBIND FOR TOGGLE (Optional) ==========
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Toggle with F key (optional)
    if input.KeyCode == Enum.KeyCode.F then
        toggleFling()
        local btn = Rayfield:GetButton("FlingButton")
        if btn then
            btn:Set(flingActive and "🟢 FLING - ON" or "🔴 FLING - OFF")
        end
    end
end)

-- ========== CLEANUP ON UNLOAD ==========
local function cleanup()
    flingActive = false
    getgenv().TOUCH_FLING_LOADED = false
    notify("Touch Fling", "Script unloaded!", 2)
end

-- Optional: Unload with HOME key
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Home then
        cleanup()
    end
end)

-- ========== INITIAL NOTIFICATION ==========
notify("Touch Fling", "Loaded! Press INSERT for menu", 3)
print("=== Touch Fling Script Loaded ===")
print("Press INSERT to open Rayfield menu")
print("Press F to toggle fling (optional)")
print("Subscribe to DuplexScripts!")
