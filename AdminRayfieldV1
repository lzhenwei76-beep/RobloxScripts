-- Admin Script V3 - Fixed Version
-- WARNING: This script is outdated! Kick/Ban commands removed (patched by Roblox)

if getgenv().ADMIN_V3_LOADED then return end
getgenv().ADMIN_V3_LOADED = true

if not game:IsLoaded() then game.Loaded:Wait() end

-- ========== LOAD RAYFIELD ==========
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/lzhenwei76-beep/RayfieldCopy/refs/heads/main/source.lua'))()

-- ========== SERVICES ==========
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ========== PLAYER LIST FOR BUTTONS ==========
local PlayerList = {}

local function updatePlayerList()
    PlayerList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(PlayerList, player.Name)
        end
    end
end

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()

-- ========== WARNING POPUP ==========
local WarningGui = Instance.new("ScreenGui")
WarningGui.Name = "AdminV3_Warning"
WarningGui.ResetOnSpawn = false
WarningGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
WarningGui.DisplayOrder = 999

pcall(function() WarningGui.Parent = game:GetService("CoreGui") end)
if not WarningGui.Parent then
    WarningGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Warning Frame
local WarningFrame = Instance.new("Frame")
WarningFrame.Size = UDim2.new(0, 500, 0, 350)
WarningFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
WarningFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
WarningFrame.BackgroundTransparency = 0.05
WarningFrame.BorderSizePixel = 0
WarningFrame.ClipsDescendants = true
WarningFrame.Parent = WarningGui

local WarningStroke = Instance.new("UIStroke")
WarningStroke.Color = Color3.fromRGB(255, 50, 50)
WarningStroke.Thickness = 3
WarningStroke.Transparency = 0.3
WarningStroke.Parent = WarningFrame

local WarningCorner = Instance.new("UICorner")
WarningCorner.CornerRadius = UDim.new(0, 12)
WarningCorner.Parent = WarningFrame

-- Header
local WarningHeader = Instance.new("Frame")
WarningHeader.Size = UDim2.new(1, 0, 0, 50)
WarningHeader.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
WarningHeader.BackgroundTransparency = 0.15
WarningHeader.BorderSizePixel = 0
WarningHeader.Parent = WarningFrame

local WarningIcon = Instance.new("TextLabel")
WarningIcon.Size = UDim2.new(0, 50, 1, 0)
WarningIcon.Position = UDim2.new(0, 10, 0, 0)
WarningIcon.BackgroundTransparency = 1
WarningIcon.Font = Enum.Font.GothamBold
WarningIcon.TextSize = 28
WarningIcon.Text = "⚠️"
WarningIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
WarningIcon.Parent = WarningHeader

local WarningTitle = Instance.new("TextLabel")
WarningTitle.Size = UDim2.new(1, -70, 1, 0)
WarningTitle.Position = UDim2.new(0, 70, 0, 0)
WarningTitle.BackgroundTransparency = 1
WarningTitle.Font = Enum.Font.GothamBold
WarningTitle.TextSize = 18
WarningTitle.Text = "ADMIN SCRIPT V3 - OUTDATED"
WarningTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
WarningTitle.TextXAlignment = Enum.TextXAlignment.Left
WarningTitle.Parent = WarningHeader

-- Content
local WarningContent = Instance.new("Frame")
WarningContent.Size = UDim2.new(1, -20, 1, -70)
WarningContent.Position = UDim2.new(0, 10, 0, 60)
WarningContent.BackgroundTransparency = 1
WarningContent.Parent = WarningFrame

local RiskLabel = Instance.new("TextLabel")
RiskLabel.Size = UDim2.new(1, 0, 0, 40)
RiskLabel.BackgroundTransparency = 1
RiskLabel.Font = Enum.Font.GothamBold
RiskLabel.TextSize = 16
RiskLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
RiskLabel.Text = "🔴 HIGH RISK OF BAN!"
RiskLabel.TextXAlignment = Enum.TextXAlignment.Center
RiskLabel.Parent = WarningContent

local RiskDesc = Instance.new("TextLabel")
RiskDesc.Size = UDim2.new(1, 0, 0, 50)
RiskDesc.Position = UDim2.new(0, 0, 0, 35)
RiskDesc.BackgroundTransparency = 1
RiskDesc.Font = Enum.Font.SourceSans
RiskDesc.TextSize = 13
RiskDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
RiskDesc.Text = "This script is outdated. Kick/Ban/Freeze commands have been PATCHED by Roblox.\nThey will NOT work anymore."
RiskDesc.TextWrapped = true
RiskDesc.TextXAlignment = Enum.TextXAlignment.Center
RiskDesc.Parent = WarningContent

local WorkingLabel = Instance.new("TextLabel")
WorkingLabel.Size = UDim2.new(1, 0, 0, 30)
WorkingLabel.Position = UDim2.new(0, 0, 0, 90)
WorkingLabel.BackgroundTransparency = 1
WorkingLabel.Font = Enum.Font.GothamBold
WorkingLabel.TextSize = 14
WorkingLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
WorkingLabel.Text = "✅ STILL WORKING:"
WorkingLabel.TextXAlignment = Enum.TextXAlignment.Center
WorkingLabel.Parent = WarningContent

local WorkingFeatures = Instance.new("TextLabel")
WorkingFeatures.Size = UDim2.new(1, 0, 0, 80)
WorkingFeatures.Position = UDim2.new(0, 0, 0, 120)
WorkingFeatures.BackgroundTransparency = 1
WorkingFeatures.Font = Enum.Font.SourceSans
WorkingFeatures.TextSize = 12
WorkingFeatures.TextColor3 = Color3.fromRGB(150, 200, 150)
WorkingFeatures.Text = "• Fly / Noclip\n• Speed / Jump Power\n• TP to Player / Mouse\n• Waypoints (Save/Load)\n• Keybinds\n• Chat Commands"
WorkingFeatures.TextXAlignment = Enum.TextXAlignment.Center
WorkingFeatures.Parent = WarningContent

local BrokenLabel = Instance.new("TextLabel")
BrokenLabel.Size = UDim2.new(1, 0, 0, 30)
BrokenLabel.Position = UDim2.new(0, 0, 0, 205)
BrokenLabel.BackgroundTransparency = 1
BrokenLabel.Font = Enum.Font.GothamBold
BrokenLabel.TextSize = 14
BrokenLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
BrokenLabel.Text = "❌ PATCHED / BROKEN:"
BrokenLabel.TextXAlignment = Enum.TextXAlignment.Center
BrokenLabel.Parent = WarningContent

local BrokenFeatures = Instance.new("TextLabel")
BrokenFeatures.Size = UDim2.new(1, 0, 0, 60)
BrokenFeatures.Position = UDim2.new(0, 0, 0, 235)
BrokenFeatures.BackgroundTransparency = 1
BrokenFeatures.Font = Enum.Font.SourceSans
BrokenFeatures.TextSize = 12
BrokenFeatures.TextColor3 = Color3.fromRGB(200, 100, 100)
BrokenFeatures.Text = "• Kick / Ban (Patched by Roblox)\n• Freeze / Jail (Patched)\n• ESP (Broken)\n• Loop / Spam (Detected)"
BrokenFeatures.TextXAlignment = Enum.TextXAlignment.Center
BrokenFeatures.Parent = WarningContent

-- Buttons
local ButtonFrame = Instance.new("Frame")
ButtonFrame.Size = UDim2.new(1, -20, 0, 40)
ButtonFrame.Position = UDim2.new(0, 10, 1, -50)
ButtonFrame.BackgroundTransparency = 1
ButtonFrame.Parent = WarningFrame

local ContinueButton = Instance.new("TextButton")
ContinueButton.Size = UDim2.new(0, 200, 1, 0)
ContinueButton.Position = UDim2.new(0.5, -210, 0, 0)
ContinueButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ContinueButton.BackgroundTransparency = 0.2
ContinueButton.BorderSizePixel = 0
ContinueButton.Font = Enum.Font.GothamBold
ContinueButton.TextSize = 14
ContinueButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ContinueButton.Text = "⚠️ CONTINUE ANYWAY"
ContinueButton.Parent = ButtonFrame

local ContinueCorner = Instance.new("UICorner")
ContinueCorner.CornerRadius = UDim.new(0, 6)
ContinueCorner.Parent = ContinueButton

local CancelButton = Instance.new("TextButton")
CancelButton.Size = UDim2.new(0, 200, 1, 0)
CancelButton.Position = UDim2.new(0.5, 10, 0, 0)
CancelButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
CancelButton.BackgroundTransparency = 0.2
CancelButton.BorderSizePixel = 0
CancelButton.Font = Enum.Font.GothamBold
CancelButton.TextSize = 14
CancelButton.TextColor3 = Color3.fromRGB(200, 200, 200)
CancelButton.Text = "✗ UNLOAD"
CancelButton.Parent = ButtonFrame

local CancelCorner = Instance.new("UICorner")
CancelCorner.CornerRadius = UDim.new(0, 6)
CancelCorner.Parent = CancelButton

-- Animation
WarningFrame.BackgroundTransparency = 1
WarningFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.3, true)
task.wait(0.2)
WarningFrame:TweenSize(UDim2.new(0, 500, 0, 350), Enum.EasingDirection.Out, Enum.EasingStyle.Elastic, 0.5, true)
WarningFrame.BackgroundTransparency = 0.05

-- ========== ADMIN SCRIPT CORE ==========
local Admin = {
    Prefix = ";",
    Commands = {},
    Keybinds = {},
    Aliases = {},
    Waypoints = {},
    Toggles = {
        Flying = false,
        Noclip = false,
        God = false,
        InfiniteJump = false,
        Speed = 16,
        JumpPower = 50,
        FlySpeed = 50
    },
    FlyConnection = nil,
    FlyBV = nil,
    JumpConnection = nil
}

-- Helper Functions
local function findPlayer(input)
    if input == "me" then return LocalPlayer end
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower():sub(1, #input) == input:lower() then
            return player
        end
    end
    return nil
end

local function notify(title, content, duration)
    pcall(function()
        Rayfield:Notify({Title = title, Content = content, Duration = duration or 3})
    end)
end

local function warnUser(message)
    print("[WARNING] " .. message)
    pcall(function()
        Rayfield:Notify({Title = "⚠️ WARNING", Content = message, Duration = 4})
    end)
end

-- ========== COMMANDS ==========

-- Fly
function Admin.Commands.fly()
    Admin.Toggles.Flying = not Admin.Toggles.Flying
    
    if Admin.Toggles.Flying then
        local char = LocalPlayer.Character
        if not char then warnUser("Character not found"); return end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not hrp or not humanoid then warnUser("Character not ready"); return end
        
        Admin.FlyBV = Instance.new("BodyVelocity")
        Admin.FlyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        Admin.FlyBV.Velocity = Vector3.new(0, 0, 0)
        Admin.FlyBV.Parent = hrp
        
        humanoid.PlatformStand = true
        humanoid.AutoRotate = false
        
        Admin.FlyConnection = RunService.RenderStepped:Connect(function()
            if not Admin.Toggles.Flying or not hrp or not hrp.Parent then return end
            local cam = workspace.CurrentCamera
            local move = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end
            Admin.FlyBV.Velocity = move.Magnitude > 0 and move.Unit * Admin.Toggles.FlySpeed or Vector3.new(0, 0, 0)
        end)
        
        notify("Fly", "✓ Enabled (Speed: " .. Admin.Toggles.FlySpeed .. ")", 2)
    else
        if Admin.FlyConnection then Admin.FlyConnection:Disconnect() end
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local humanoid = char:FindFirstChild("Humanoid")
            if hrp and Admin.FlyBV then Admin.FlyBV:Destroy() end
            if humanoid then
                humanoid.PlatformStand = false
                humanoid.AutoRotate = true
            end
        end
        notify("Fly", "✗ Disabled", 2)
    end
end

-- Noclip
function Admin.Commands.noclip()
    Admin.Toggles.Noclip = not Admin.Toggles.Noclip
    
    local function setCollision(state)
        local char = LocalPlayer.Character
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = state
            end
        end
    end
    
    if Admin.Toggles.Noclip then
        setCollision(false)
        LocalPlayer.CharacterAdded:Connect(function()
            if Admin.Toggles.Noclip then setCollision(false) end
        end)
        notify("Noclip", "✓ Enabled", 2)
        warnUser("Noclip may be detected")
    else
        setCollision(true)
        notify("Noclip", "✗ Disabled", 2)
    end
end

-- God Mode
function Admin.Commands.god()
    Admin.Toggles.God = not Admin.Toggles.God
    
    if Admin.Toggles.God then
        local function setupGod(char)
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                    if Admin.Toggles.God and humanoid and humanoid.Health > 0 then
                        humanoid.Health = humanoid.MaxHealth
                    end
                end)
            end
        end
        setupGod(LocalPlayer.Character)
        LocalPlayer.CharacterAdded:Connect(setupGod)
        notify("God Mode", "✓ Enabled", 2)
    else
        notify("God Mode", "✗ Disabled", 2)
    end
end

-- Infinite Jump
function Admin.Commands.infJump()
    Admin.Toggles.InfiniteJump = not Admin.Toggles.InfiniteJump
    
    if Admin.Toggles.InfiniteJump then
        if Admin.JumpConnection then Admin.JumpConnection:Disconnect() end
        Admin.JumpConnection = UserInputService.JumpRequest:Connect(function()
            if Admin.Toggles.InfiniteJump and LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
        notify("Infinite Jump", "✓ Enabled", 2)
    else
        if Admin.JumpConnection then Admin.JumpConnection:Disconnect() end
        notify("Infinite Jump", "✗ Disabled", 2)
    end
end

-- Speed
function Admin.Commands.speed(args)
    local speed = tonumber(args[1])
    if not speed then notify("Speed", "Usage: ;speed <number>", 3); return end
    Admin.Toggles.Speed = math.clamp(speed, 16, 500)
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then humanoid.WalkSpeed = Admin.Toggles.Speed end
    end
    notify("Speed", "Set to " .. Admin.Toggles.Speed, 2)
    if Admin.Toggles.Speed > 100 then warnUser("High speed may trigger anti-cheat") end
end

-- Jump Power
function Admin.Commands.jumppower(args)
    local power = tonumber(args[1])
    if not power then notify("Jump Power", "Usage: ;jumppower <number>", 3); return end
    Admin.Toggles.JumpPower = math.clamp(power, 50, 500)
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then humanoid.JumpPower = Admin.Toggles.JumpPower end
    end
    notify("Jump Power", "Set to " .. Admin.Toggles.JumpPower, 2)
end

-- Fly Speed
function Admin.Commands.flyspeed(args)
    local speed = tonumber(args[1])
    if not speed then notify("Fly Speed", "Usage: ;flyspeed <number>", 3); return end
    Admin.Toggles.FlySpeed = math.clamp(speed, 10, 500)
    notify("Fly Speed", "Set to " .. Admin.Toggles.FlySpeed, 2)
end

-- TP to Player
function Admin.Commands.tp(args)
    if not args[1] then notify("TP", "Usage: ;tp <player>", 3); return end
    local target = findPlayer(args[1])
    if not target then notify("TP", "Player not found", 2); return end
    
    local targetChar = target.Character
    local localChar = LocalPlayer.Character
    if not targetChar or not localChar then notify("TP", "Character not found", 2); return end
    
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    local localRoot = localChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot or not localRoot then notify("TP", "Character not ready", 2); return end
    
    localRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 5)
    notify("TP", "Teleported to " .. target.Name, 2)
end

-- Bring Player
function Admin.Commands.bring(args)
    if not args[1] then notify("Bring", "Usage: ;bring <player>", 3); return end
    local target = findPlayer(args[1])
    if not target then notify("Bring", "Player not found", 2); return end
    
    local targetChar = target.Character
    local localChar = LocalPlayer.Character
    if not targetChar or not localChar then notify("Bring", "Character not found", 2); return end
    
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    local localRoot = localChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot or not localRoot then notify("Bring", "Character not ready", 2); return end
    
    targetRoot.CFrame = localRoot.CFrame * CFrame.new(0, 0, 5)
    notify("Bring", "Brought " .. target.Name, 2)
end

-- Goto Player
function Admin.Commands.goto(args)
    if not args[1] then notify("Goto", "Usage: ;goto <player>", 3); return end
    local target = findPlayer(args[1])
    if not target then notify("Goto", "Player not found", 2); return end
    
    local targetChar = target.Character
    local localChar = LocalPlayer.Character
    if not targetChar or not localChar then notify("Goto", "Character not found", 2); return end
    
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    local localRoot = localChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot or not localRoot then notify("Goto", "Character not ready", 2); return end
    
    localRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 5)
    notify("Goto", "Went to " .. target.Name, 2)
end

-- TP to Mouse
function Admin.Commands.tpm()
    local localChar = LocalPlayer.Character
    if not localChar then notify("TPM", "Character not found", 2); return end
    local localRoot = localChar:FindFirstChild("HumanoidRootPart")
    if not localRoot then notify("TPM", "Character not ready", 2); return end
    localRoot.CFrame = CFrame.new(Mouse.Hit.p)
    notify("TPM", "Teleported to mouse", 2)
end

-- Waypoints
function Admin.Commands.setwaypoint(args)
    if not args[1] then notify("Waypoint", "Usage: ;swp <name>", 3); return end
    local localChar = LocalPlayer.Character
    if not localChar then notify("Waypoint", "Character not found", 2); return end
    local localRoot = localChar:FindFirstChild("HumanoidRootPart")
    if not localRoot then notify("Waypoint", "Character not ready", 2); return end
    Admin.Waypoints[args[1]] = localRoot.Position
    notify("Waypoint", "Saved '" .. args[1] .. "'", 2)
end

function Admin.Commands.waypoint(args)
    if not args[1] then notify("Waypoint", "Usage: ;wp <name>", 3); return end
    local pos = Admin.Waypoints[args[1]]
    if not pos then notify("Waypoint", "Waypoint not found", 2); return end
    local localChar = LocalPlayer.Character
    if not localChar then notify("Waypoint", "Character not found", 2); return end
    local localRoot = localChar:FindFirstChild("HumanoidRootPart")
    if not localRoot then notify("Waypoint", "Character not ready", 2); return end
    localRoot.CFrame = CFrame.new(pos)
    notify("Waypoint", "Teleported to '" .. args[1] .. "'", 2)
end

function Admin.Commands.delwaypoint(args)
    if not args[1] then notify("Waypoint", "Usage: ;delwp <name>", 3); return end
    if not Admin.Waypoints[args[1]] then notify("Waypoint", "Waypoint not found", 2); return end
    Admin.Waypoints[args[1]] = nil
    notify("Waypoint", "Deleted '" .. args[1] .. "'", 2)
end

function Admin.Commands.waypoints()
    local list = "=== Waypoints ===\n"
    for name, pos in pairs(Admin.Waypoints) do
        list = list .. string.format("• %s → (%.0f, %.0f, %.0f)\n", name, pos.X, pos.Y, pos.Z)
    end
    if list == "=== Waypoints ===\n" then list = "No waypoints saved" end
    print(list)
    notify("Waypoints", "Check console (F9)", 2)
end

-- Keybinds
function Admin.Commands.bind(args)
    if not args[1] or not args[2] then notify("Bind", "Usage: ;bind <key> <command>", 3); return end
    local key = args[1]:upper()
    local command = table.concat(args, " ", 2)
    Admin.Keybinds[key] = command
    notify("Bind", key .. " → " .. command, 2)
end

function Admin.Commands.unbind(args)
    if not args[1] then notify("Unbind", "Usage: ;unbind <key>", 3); return end
    local key = args[1]:upper()
    if Admin.Keybinds[key] then
        Admin.Keybinds[key] = nil
        notify("Unbind", "Unbound " .. key, 2)
    else
        notify("Unbind", "No bind found for " .. key, 2)
    end
end

function Admin.Commands.keybinds()
    local list = "=== Keybinds ===\n"
    for key, cmd in pairs(Admin.Keybinds) do
        list = list .. "• " .. key .. " → " .. cmd .. "\n"
    end
    if list == "=== Keybinds ===\n" then list = "No keybinds set" end
    print(list)
    notify("Keybinds", "Check console (F9)", 2)
end

-- Aliases
function Admin.Commands.addalias(args)
    if not args[1] or not args[2] then notify("Alias", "Usage: ;addalias <alias> <command>", 3); return end
    Admin.Aliases[args[1]:lower()] = args[2]:lower()
    notify("Alias", args[1] .. " → " .. args[2], 2)
end

function Admin.Commands.aliases()
    local list = "=== Aliases ===\n"
    for alias, cmd in pairs(Admin.Aliases) do
        list = list .. "• " .. alias .. " → " .. cmd .. "\n"
    end
    if list == "=== Aliases ===\n" then list = "No aliases set" end
    print(list)
    notify("Aliases", "Check console (F9)", 2)
end

-- Chat
function Admin.Commands.chat(args)
    if not args[1] then notify("Chat", "Usage: ;chat <message>", 3); return end
    local message = table.concat(args, " ")
    local chatBar = LocalPlayer.PlayerGui:FindFirstChild("Chat")
    if chatBar then
        local frame = chatBar:FindFirstChild("Frame")
        if frame then
            local barFrame = frame:FindFirstChild("ChatBarParentFrame")
            if barFrame then
                local bar = barFrame:FindFirstChild("ChatBar")
                if bar then
                    bar.Text = message
                    bar:CaptureFocus()
                    local event = bar:FindFirstChild("FocusLost")
                    if event then event:Fire(true) end
                    notify("Chat", "Sent: " .. message, 2)
                    return
                end
            end
        end
    end
    notify("Chat", "Chat not found", 2)
end

-- Reset Character
function Admin.Commands.reset()
    local char = LocalPlayer.Character
    if char then char:BreakJoints() end
    notify("Reset", "Character reset", 2)
end

-- Help
function Admin.Commands.help()
    local helpText = [[
=== ADMIN SCRIPT V3 ===
Prefix: ; 

[MOVEMENT]
;fly - Toggle fly
;noclip - Toggle noclip  
;god - Toggle god mode
;inf jump - Toggle infinite jump
;speed <num> - Set walkspeed
;jumppower <num> - Set jump power
;flyspeed <num> - Set fly speed

[TELEPORT]
;tp <player> - Teleport to player
;bring <player> - Bring player to you
;goto <player> - Go to player
;tpm - Teleport to mouse

[WAYPOINTS]
;swp <name> - Save waypoint
;wp <name> - Go to waypoint
;delwp <name> - Delete waypoint
;waypoints - List waypoints

[KEYBINDS]
;bind <key> <cmd> - Bind key
;unbind <key> - Remove bind
;keybinds - List binds

[ALIASES]
;addalias <alias> <cmd> - Add alias
;aliases - List aliases

[UTILITY]
;chat <msg> - Send chat
;reset - Reset character
;help - Show this help

❌ PATCHED (REMOVED): kick, ban, freeze, esp
]]
    print(helpText)
    notify("Help", "Commands printed to console (F9)", 3)
end

-- Status
function Admin.Commands.status()
    local status = string.format([[
=== ADMIN SCRIPT V3 STATUS ===
Fly: %s
Noclip: %s
God Mode: %s
Infinite Jump: %s
Walk Speed: %d
Jump Power: %d
Fly Speed: %d
Prefix: %s
Waypoints: %d
Keybinds: %d
Aliases: %d
]], Admin.Toggles.Flying and "✓" or "✗",
   Admin.Toggles.Noclip and "✓" or "✗",
   Admin.Toggles.God and "✓" or "✗",
   Admin.Toggles.InfiniteJump and "✓" or "✗",
   Admin.Toggles.Speed,
   Admin.Toggles.JumpPower,
   Admin.Toggles.FlySpeed,
   Admin.Prefix,
   table.count(Admin.Waypoints),
   table.count(Admin.Keybinds),
   table.count(Admin.Aliases))
    print(status)
    notify("Status", "Check console (F9)", 2)
end

-- Command Dispatcher
local function executeCommand(cmd, args)
    if Admin.Aliases[cmd] then
        cmd = Admin.Aliases[cmd]
    end
    
    local func = Admin.Commands[cmd]
    if func then
        pcall(func, args)
    else
        notify("Error", "Unknown: " .. cmd .. "\nType ;help", 3)
    end
end

-- Keybind Handler
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    local key = input.KeyCode.Name
    if key ~= "Unknown" and Admin.Keybinds[key] then
        task.spawn(function()
            executeCommand(Admin.Keybinds[key], {})
        end)
    end
end)

-- Character Handler
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = Admin.Toggles.Speed
        humanoid.JumpPower = Admin.Toggles.JumpPower
    end
    if Admin.Toggles.Flying then
        task.wait(1)
        Admin.Commands.fly()
    end
    if Admin.Toggles.Noclip then
        task.wait(1)
        Admin.Commands.noclip()
    end
end)

-- ========== RAYFIELD GUI (WITH BUTTONS INSTEAD OF INPUTS) ==========
local Window = Rayfield:CreateWindow({
    Name = "Admin Script V3",
    Icon = 0,
    LoadingTitle = "Admin Script V3",
    LoadingSubtitle = "⚠️ USE AT OWN RISK ⚠️",
    Theme = "Default",
    ConfigurationSaving = {Enabled = true, FolderName = "AdminScriptV3", FileName = "Config"},
    KeySystem = false
})

-- Main Tab
local MainTab = Window:CreateTab("Main", 4483362458)
MainTab:CreateSection("⚠️ WARNING")
MainTab:CreateParagraph({
    Title = "OUTDATED SCRIPT!",
    Content = "Kick/Ban/Freeze commands have been PATCHED by Roblox.\nThey will NOT work anymore.\n\nUse at your own risk!"
})

MainTab:CreateSection("Quick Commands")
MainTab:CreateButton({Name = "Fly", Callback = function() executeCommand("fly", {}) end})
MainTab:CreateButton({Name = "Noclip", Callback = function() executeCommand("noclip", {}) end})
MainTab:CreateButton({Name = "God Mode", Callback = function() executeCommand("god", {}) end})
MainTab:CreateButton({Name = "Infinite Jump", Callback = function() executeCommand("inf jump", {}) end})
MainTab:CreateButton({Name = "TP to Mouse", Callback = function() executeCommand("tpm", {}) end})
MainTab:CreateButton({Name = "Reset Character", Callback = function() executeCommand("reset", {}) end})

-- Player List for Teleport
MainTab:CreateSection("Player Teleport")
for _, playerName in ipairs(PlayerList) do
    MainTab:CreateButton({
        Name = "TP to " .. playerName,
        Callback = function() executeCommand("tp", {playerName}) end
    })
end

-- Movement Tab
local MovementTab = Window:CreateTab("Movement", 4483362458)
MovementTab:CreateSection("Toggles")
MovementTab:CreateButton({Name = "Fly", Callback = function() executeCommand("fly", {}) end})
MovementTab:CreateButton({Name = "Noclip", Callback = function() executeCommand("noclip", {}) end})
MovementTab:CreateButton({Name = "God Mode", Callback = function() executeCommand("god", {}) end})
MovementTab:CreateButton({Name = "Infinite Jump", Callback = function() executeCommand("inf jump", {}) end})

MovementTab:CreateSection("Speed Settings")
MovementTab:CreateButton({Name = "Speed 16 (Normal)", Callback = function() executeCommand("speed", {"16"}) end})
MovementTab:CreateButton({Name = "Speed 50", Callback = function() executeCommand("speed", {"50"}) end})
MovementTab:CreateButton({Name = "Speed 100", Callback = function() executeCommand("speed", {"100"}) end})
MovementTab:CreateButton({Name = "Speed 250", Callback = function() executeCommand("speed", {"250"}) end})
MovementTab:CreateButton({Name = "Speed 500", Callback = function() executeCommand("speed", {"500"}) end})

MovementTab:CreateSection("Jump Settings")
MovementTab:CreateButton({Name = "Jump 50 (Normal)", Callback = function() executeCommand("jumppower", {"50"}) end})
MovementTab:CreateButton({Name = "Jump 100", Callback = function() executeCommand("jumppower", {"100"}) end})
MovementTab:CreateButton({Name = "Jump 200", Callback = function() executeCommand("jumppower", {"200"}) end})
MovementTab:CreateButton({Name = "Jump 500", Callback = function() executeCommand("jumppower", {"500"}) end})

MovementTab:CreateSection("Fly Speed")
MovementTab:CreateButton({Name = "Fly Speed 25", Callback = function() executeCommand("flyspeed", {"25"}) end})
MovementTab:CreateButton({Name = "Fly Speed 50", Callback = function() executeCommand("flyspeed", {"50"}) end})
MovementTab:CreateButton({Name = "Fly Speed 100", Callback = function() executeCommand("flyspeed", {"100"}) end})
MovementTab:CreateButton({Name = "Fly Speed 250", Callback = function() executeCommand("flyspeed", {"250"}) end})

-- Teleport Tab
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
TeleportTab:CreateSection("Mouse Teleport")
TeleportTab:CreateButton({Name = "Teleport to Mouse", Callback = function() executeCommand("tpm", {}) end})

TeleportTab:CreateSection("Player Teleport")
for _, playerName in ipairs(PlayerList) do
    TeleportTab:CreateButton({
        Name = "TP to " .. playerName,
        Callback = function() executeCommand("tp", {playerName}) end
    })
    TeleportTab:CreateButton({
        Name = "Bring " .. playerName,
        Callback = function() executeCommand("bring", {playerName}) end
    })
end

-- Waypoints Tab
local WaypointsTab = Window:CreateTab("Waypoints", 4483362458)
WaypointsTab:CreateSection("Waypoint Commands")
WaypointsTab:CreateButton({Name = "Save Current Position (test)", Callback = function() executeCommand("swp", {"test"}) end})
WaypointsTab:CreateButton({Name = "Go to 'test'", Callback = function() executeCommand("wp", {"test"}) end})
WaypointsTab:CreateButton({Name = "Delete 'test'", Callback = function() executeCommand("delwp", {"test"}) end})
WaypointsTab:CreateButton({Name = "List All Waypoints", Callback = function() executeCommand("waypoints", {}) end})

-- Keybinds Tab
local KeybindsTab = Window:CreateTab("Keybinds", 4483362458)
KeybindsTab:CreateSection("Preset Keybinds")
KeybindsTab:CreateButton({Name = "Bind G to Fly", Callback = function() executeCommand("bind", {"G", "fly"}) end})
KeybindsTab:CreateButton({Name = "Bind V to Noclip", Callback = function() executeCommand("bind", {"V", "noclip"}) end})
KeybindsTab:CreateButton({Name = "Bind F to God", Callback = function() executeCommand("bind", {"F", "god"}) end})
KeybindsTab:CreateButton({Name = "Unbind G", Callback = function() executeCommand("unbind", {"G"}) end})
KeybindsTab:CreateButton({Name = "Unbind V", Callback = function() executeCommand("unbind", {"V"}) end})
KeybindsTab:CreateButton({Name = "Unbind F", Callback = function() executeCommand("unbind", {"F"}) end})
KeybindsTab:CreateButton({Name = "List All Keybinds", Callback = function() executeCommand("keybinds", {}) end})

-- Settings Tab
local SettingsTab = Window:CreateTab("Settings", 4483362458)
SettingsTab:CreateSection("General")
SettingsTab:CreateButton({Name = "Reset Character", Callback = function() executeCommand("reset", {}) end})
SettingsTab:CreateButton({Name = "Show Help", Callback = function() executeCommand("help", {}) end})
SettingsTab:CreateButton({Name = "Show Status", Callback = function() executeCommand("status", {}) end})

-- Info Tab
local InfoTab = Window:CreateTab("Info", 4483362458)
InfoTab:CreateSection("About")
InfoTab:CreateParagraph({
    Title = "Admin Script V3",
    Content = [[
Version: 3.0 (Fixed)
Status: ⚠️ OUTDATED

WORKING COMMANDS:
✓ Fly / Noclip / God
✓ Speed / Jump Power
✓ TP to Player / Mouse
✓ Waypoints (Save/Load)
✓ Keybinds
✓ Chat Commands

PATCHED (REMOVED):
✗ Kick / Ban
✗ Freeze / Jail
✗ ESP
✗ Loop / Spam

USE AT YOUR OWN RISK!
]]
})

-- Update player list periodically
task.spawn(function()
    while true do
        task.wait(5)
        updatePlayerList()
    end
end)

-- ========== BUTTON HANDLERS ==========
ContinueButton.MouseButton1Click:Connect(function()
    WarningFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Back, 0.3, true)
    task.wait(0.3)
    WarningGui:Destroy()
    notify("Admin Script V3", "Loaded! Type ;help", 5)
    warnUser("Kick/Ban/Freeze are PATCHED and removed!")
    print("=== Admin Script V3 Loaded ===")
    print("⚠️ Kick/Ban/Freeze have been REMOVED (patched by Roblox)")
    print("Type ';help' for working commands")
    print("Press INSERT for Rayfield menu")
end)

CancelButton.MouseButton1Click:Connect(function()
    WarningFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Back, 0.3, true)
    task.wait(0.3)
    WarningGui:Destroy()
    getgenv().ADMIN_V3_LOADED = false
end)

-- Animation
WarningFrame.BackgroundTransparency = 1
WarningFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.3, true)
task.wait(0.2)
WarningFrame:TweenSize(UDim2.new(0, 500, 0, 350), Enum.EasingDirection.Out, Enum.EasingStyle.Elastic, 0.5, true)
WarningFrame.BackgroundTransparency = 0.05
