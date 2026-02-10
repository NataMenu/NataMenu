 -- Aimbot API atualizada
loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V3/main/src/Aimbot.lua"))()

if getgenv().NataMenu then return end
getgenv().NataMenu = true

-- Serviços
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Configurações
local Config = {
    Aimbot = {
        Enabled = true,
        FOV = 100,
        Smoothness = 0.5,
        TargetPart = "Head",
        VisibleCheck = true,
        TeamCheck = true
    },
    Visuals = {
        Enabled = true,
        Boxes = true,
        Names = true,
        Health = true,
        Distance = true,
        Tracers = false,
        TeamCheck = true,
        MaxDistance = 1000
    },
    Misc = {
        NightMode = false,
        Fullbright = false,
        NoClip = false,
        WalkSpeed = 16,
        JumpPower = 50,
        FPSBoost = false,
        AutoClick = false,
        AntiAFK = true,
        Bypass = false
    }
}

-- Cores (Interface BRANCA com texto PRETO)
local WHITE_COLOR = Color3.fromRGB(255, 255, 255)       -- Branco principal
local LIGHT_GRAY = Color3.fromRGB(240, 240, 240)        -- Cinza claro
local MEDIUM_GRAY = Color3.fromRGB(220, 220, 220)       -- Cinza médio
local DARK_GRAY = Color3.fromRGB(200, 200, 200)         -- Cinza escuro
local BLACK_COLOR = Color3.new(0, 0, 0)                 -- Preto para texto
local BORDER_COLOR = Color3.fromRGB(180, 180, 180)      -- Cor da borda

-- Load Aimbot
local function LoadAimbot()
    local success, _ = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V2/main/Resources/Scripts/Raw%20Main.lua"))()
    end)
    
    if success and getgenv().Aimbot then
        local AB = getgenv().Aimbot
        AB.FOVSettings.Color = Color3.fromRGB(0, 120, 255) -- Azul para FOV
        AB.FOVSettings.Visible = true
        AB.Enabled = Config.Aimbot.Enabled
        AB.FOV = Config.Aimbot.FOV
        AB.Smoothness = Config.Aimbot.Smoothness
        AB.TargetPart = Config.Aimbot.TargetPart
    end
end
LoadAimbot()

-- Bypass System
local function SetupBypass()
    if Config.Misc.Bypass then
        pcall(function()
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                local args = {...}
                
                if method == "Kick" or method == "kick" then
                    return nil
                end
                
                return oldNamecall(self, unpack(args))
            end)
        end)
        
        pcall(function()
            game:GetService("ScriptContext").Error:Connect(function() end)
        end)
    end
end

-- ESP
local ESP = {Drawings = {}}
local DrawingLib = (drawing or Drawing)

function ESP:AddPlayer(player)
    if player == LocalPlayer then return end
    self.Drawings[player] = {
        Box = DrawingLib.new("Square"),
        Name = DrawingLib.new("Text"),
        Health = DrawingLib.new("Text"),
        Distance = DrawingLib.new("Text")
    }
end

function ESP:Update()
    for player, drawings in pairs(self.Drawings) do
        if not player.Parent or not player.Character or not Config.Visuals.Enabled then
            for _, d in pairs(drawings) do d.Visible = false end
            continue
        end
        
        local char = player.Character
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        
        if root and hum then
            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
            local dist = (Camera.CFrame.Position - root.Position).Magnitude
            
            if onScreen and dist <= Config.Visuals.MaxDistance then
                local isTeam = Config.Visuals.TeamCheck and player.Team == LocalPlayer.Team
                local color = isTeam and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(255, 50, 50)
                
                if Config.Visuals.Boxes then
                    local size = Vector2.new(2000/dist * 2, 2000/dist * 3)
                    drawings.Box.Visible = true
                    drawings.Box.Size = size
                    drawings.Box.Position = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)
                    drawings.Box.Color = color
                    drawings.Box.Thickness = 1
                else drawings.Box.Visible = false end
                
                if Config.Visuals.Names then
                    drawings.Name.Visible = true
                    drawings.Name.Text = player.Name
                    drawings.Name.Position = Vector2.new(pos.X, pos.Y - (2000/dist * 1.5) - 15)
                    drawings.Name.Center = true
                    drawings.Name.Outline = true
                    drawings.Name.Color = BLACK_COLOR  -- Texto preto
                    drawings.Name.Size = 14
                else drawings.Name.Visible = false end
                
                if Config.Visuals.Health then
                    drawings.Health.Visible = true
                    drawings.Health.Text = math.floor(hum.Health) .. " HP"
                    drawings.Health.Position = Vector2.new(pos.X, pos.Y + (2000/dist * 1.5) + 5)
                    drawings.Health.Center = true
                    drawings.Health.Outline = true
                    drawings.Health.Color = BLACK_COLOR  -- Texto preto
                    drawings.Health.Size = 14
                else drawings.Health.Visible = false end
                
                if Config.Visuals.Distance then
                    drawings.Distance.Visible = true
                    drawings.Distance.Text = math.floor(dist) .. " studs"
                    drawings.Distance.Position = Vector2.new(pos.X, pos.Y + (2000/dist * 1.5) + 25)
                    drawings.Distance.Center = true
                    drawings.Distance.Outline = true
                    drawings.Distance.Color = BLACK_COLOR  -- Texto preto
                    drawings.Distance.Size = 12
                else drawings.Distance.Visible = false end
            else
                for _, d in pairs(drawings) do d.Visible = false end
            end
        end
    end
end

RunService.RenderStepped:Connect(function() ESP:Update() end)
for _, p in ipairs(Players:GetPlayers()) do ESP:AddPlayer(p) end
Players.PlayerAdded:Connect(function(p) ESP:AddPlayer(p) end)

-- Funções Misc
local miscFunctions = {
    NightModeEnabled = false,
    FullbrightEnabled = false,
    NoClipEnabled = false,
    FPSBoostEnabled = false,
    AutoClickEnabled = false,
    AntiAFKEnabled = true
}

function miscFunctions:ToggleNightMode(state)
    if state then
        local colorCorrection = Instance.new("ColorCorrectionEffect")
        colorCorrection.Name = "NataMenu_NightMode"
        colorCorrection.Parent = Lighting
        colorCorrection.Brightness = -0.15
        colorCorrection.Contrast = 0.05
        colorCorrection.TintColor = Color3.fromRGB(50, 50, 100) -- Azul escuro
        colorCorrection.Saturation = -0.3
    else
        local cc = Lighting:FindFirstChild("NataMenu_NightMode")
        if cc then cc:Destroy() end
    end
end

function miscFunctions:ToggleFullbright(state)
    if state then
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.new(0.9,0.9,0.9)
        Lighting.Brightness = 1.5
        Lighting.ClockTime = 14
    else
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        Lighting.Brightness = 1
    end
end

function miscFunctions:ToggleNoClip(state)
    Config.Misc.NoClip = state
    if state then
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:ChangeState(11)
            end
        end
    end
end

function miscFunctions:SetWalkSpeed(speed)
    Config.Misc.WalkSpeed = speed
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speed
        end
    end
end

function miscFunctions:SetJumpPower(power)
    Config.Misc.JumpPower = power
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpPower = power
        end
    end
end

function miscFunctions:ToggleFPSBoost(state)
    if state then
        settings().Rendering.QualityLevel = 1
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
        game:GetService("Workspace").Terrain.WaterReflection = false
        game:GetService("Workspace").Terrain.WaterWaveSize = 0
        game:GetService("Workspace").Terrain.WaterWaveSpeed = 0
    else
        settings().Rendering.QualityLevel = 21
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
    end
end

function miscFunctions:ToggleAutoClick(state)
    Config.Misc.AutoClick = state
    if state then
        spawn(function()
            while Config.Misc.AutoClick do
                mouse1click()
                wait(0.1)
            end
        end)
    end
end

function miscFunctions:ToggleAntiAFK(state)
    Config.Misc.AntiAFK = state
    if state then
        local VirtualUser = game:GetService("VirtualUser")
        LocalPlayer.Idled:Connect(function()
            if Config.Misc.AntiAFK then
                VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
                wait(1)
                VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
            end
        end)
    end
end

function miscFunctions:ToggleBypass(state)
    Config.Misc.Bypass = state
    if state then
        SetupBypass()
    end
end

function miscFunctions:ShowCredits()
    local creditsGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    creditsGui.Name = "NataMenuCredits"
    
    local Main = Instance.new("Frame", creditsGui)
    Main.Size = UDim2.new(0, 300, 0, 200)
    Main.Position = UDim2.new(0.5, -150, 0.5, -100)
    Main.BackgroundColor3 = WHITE_COLOR
    Main.BorderSizePixel = 1
    Main.BorderColor3 = BORDER_COLOR
    
    local Title = Instance.new("TextLabel", Main)
    Title.Text = "NATA.MENU CREDITS"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 10)
    Title.TextColor3 = BLACK_COLOR  -- Texto preto
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 18
    Title.BackgroundTransparency = 1
    
    local Designer = Instance.new("TextLabel", Main)
    Designer.Text = "Designer: Farpa"
    Designer.Size = UDim2.new(1, 0, 0, 30)
    Designer.Position = UDim2.new(0, 0, 0, 60)
    Designer.TextColor3 = BLACK_COLOR  -- Texto preto
    Designer.Font = Enum.Font.SourceSans
    Designer.TextSize = 16
    Designer.BackgroundTransparency = 1
    
    local Programmer = Instance.new("TextLabel", Main)
    Programmer.Text = "Programmer: Toque"
    Programmer.Size = UDim2.new(1, 0, 0, 30)
    Programmer.Position = UDim2.new(0, 0, 0, 90)
    Programmer.TextColor3 = BLACK_COLOR  -- Texto preto
    Programmer.Font = Enum.Font.SourceSans
    Programmer.TextSize = 16
    Programmer.BackgroundTransparency = 1
    
    local Version = Instance.new("TextLabel", Main)
    Version.Text = "Version: 1.0"
    Version.Size = UDim2.new(1, 0, 0, 30)
    Version.Position = UDim2.new(0, 0, 0, 120)
    Version.TextColor3 = BLACK_COLOR  -- Texto preto
    Version.Font = Enum.Font.SourceSans
    Version.TextSize = 14
    Version.BackgroundTransparency = 1
    
    local CloseBtn = Instance.new("TextButton", Main)
    CloseBtn.Text = "Close"
    CloseBtn.Size = UDim2.new(0, 80, 0, 30)
    CloseBtn.Position = UDim2.new(0.5, -40, 1, -40)
    CloseBtn.BackgroundColor3 = LIGHT_GRAY
    CloseBtn.TextColor3 = BLACK_COLOR  -- Texto preto
    CloseBtn.Font = Enum.Font.SourceSans
    CloseBtn.TextSize = 14
    CloseBtn.BorderSizePixel = 1
    CloseBtn.BorderColor3 = BORDER_COLOR
    
    CloseBtn.MouseButton1Click:Connect(function()
        creditsGui:Destroy()
    end)
end

-- Conectores
Players.PlayerAdded:Connect(function(player)
    if player == LocalPlayer then
        player.CharacterAdded:Connect(function(character)
            wait(1)
            miscFunctions:SetWalkSpeed(Config.Misc.WalkSpeed)
            miscFunctions:SetJumpPower(Config.Misc.JumpPower)
        end)
    end
end)

-- Menu UI
local Menu = {Tabs = {}}

function Menu:Init()
    local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    ScreenGui.Name = "NataMenu"
    
    -- Frame principal RETANGULAR (Branco)
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 520, 0, 350)
    Main.Position = UDim2.new(0.5, -260, 0.5, -175)
    Main.BackgroundColor3 = WHITE_COLOR
    Main.BorderSizePixel = 1
    Main.BorderColor3 = BORDER_COLOR
    
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 140, 1, 0)
    Sidebar.BackgroundColor3 = LIGHT_GRAY
    Sidebar.BorderSizePixel = 0

    -- LOGO GRANDE (Nova ID)
    local LogoFrame = Instance.new("Frame", Sidebar)
    LogoFrame.Size = UDim2.new(1, 0, 0, 100)
    LogoFrame.BackgroundTransparency = 1
    LogoFrame.BorderSizePixel = 0
    
    local Logo = Instance.new("ImageLabel", LogoFrame)
    Logo.Size = UDim2.new(1, -20, 1, -10)
    Logo.Position = UDim2.new(0, 10, 0, 5)
    Logo.Image = "rbxassetid://107352185324985"  -- NOVO LOGO
    Logo.BackgroundTransparency = 1
    Logo.ScaleType = Enum.ScaleType.Fit
    
    -- Efeito de brilho no logo (branco)
    local LogoGlow = Instance.new("UIGradient", Logo)
    LogoGlow.Rotation = 90
    LogoGlow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
    })
    LogoGlow.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 0.3)
    })

    local TabContainer = Instance.new("Frame", Sidebar)
    TabContainer.Position = UDim2.new(0, 0, 0, 110)
    TabContainer.Size = UDim2.new(1, 0, 1, -110)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    Instance.new("UIListLayout", TabContainer)

    local ContentArea = Instance.new("Frame", Main)
    ContentArea.Position = UDim2.new(0, 150, 0, 10)
    ContentArea.Size = UDim2.new(1, -160, 1, -20)
    ContentArea.BackgroundTransparency = 1
    ContentArea.BorderSizePixel = 0

    local function SyncAimbot()
        if getgenv().Aimbot then
            local AB = getgenv().Aimbot
            AB.Enabled = Config.Aimbot.Enabled
            AB.FOV = Config.Aimbot.FOV
            AB.Smoothness = Config.Aimbot.Smoothness
            AB.TargetPart = Config.Aimbot.TargetPart
        end
    end

    function Menu:CreateTab(name, icon)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.BackgroundColor3 = LIGHT_GRAY
        TabBtn.Text = icon .. " " .. name
        TabBtn.TextColor3 = BLACK_COLOR  -- Texto preto
        TabBtn.Font = Enum.Font.SourceSans
        TabBtn.TextSize = 13
        TabBtn.BorderSizePixel = 0
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left

        local Page = Instance.new("ScrollingFrame", ContentArea)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = DARK_GRAY  -- Scrollbar cinza
        Page.BorderSizePixel = 0
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Menu.Tabs) do
                v.Page.Visible = false
                v.Btn.TextColor3 = BLACK_COLOR
                v.Btn.BackgroundColor3 = LIGHT_GRAY
            end
            Page.Visible = true
            TabBtn.TextColor3 = BLACK_COLOR
            TabBtn.BackgroundColor3 = MEDIUM_GRAY  -- Cinza mais escuro quando selecionado
        end)

        Menu.Tabs[name] = {Page = Page, Btn = TabBtn}
        return Page
    end

    local function AddToggle(parent, text, default, callback)
        local Container = Instance.new("Frame", parent)
        Container.Size = UDim2.new(1, -10, 0, 35)
        Container.BackgroundTransparency = 1
        Container.BorderSizePixel = 0
        
        local Btn = Instance.new("TextButton", Container)
        Btn.Size = UDim2.new(1, 0, 1, 0)
        Btn.BackgroundColor3 = LIGHT_GRAY
        Btn.Text = (default and "✓ " or "✗ ") .. text
        Btn.TextColor3 = default and BLACK_COLOR or Color3.fromRGB(100, 100, 100)  -- Texto preto quando ligado
        Btn.Font = Enum.Font.SourceSans
        Btn.TextSize = 13
        Btn.TextXAlignment = Enum.TextXAlignment.Left
        Btn.BorderSizePixel = 0

        Btn.MouseButton1Click:Connect(function()
            default = not default
            Btn.Text = (default and "✓ " or "✗ ") .. text
            Btn.TextColor3 = default and BLACK_COLOR or Color3.fromRGB(100, 100, 100)
            callback(default)
        end)
    end

    local function AddSlider(parent, text, min, max, default, callback)
        local Container = Instance.new("Frame", parent)
        Container.Size = UDim2.new(1, -10, 0, 50)
        Container.BackgroundTransparency = 1
        Container.BorderSizePixel = 0

        local Label = Instance.new("TextLabel", Container)
        Label.Text = "📏 " .. text .. ": " .. default
        Label.Size = UDim2.new(1, 0, 0, 20)
        Label.TextColor3 = BLACK_COLOR  -- Texto preto
        Label.BackgroundTransparency = 1
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Font = Enum.Font.SourceSans
        Label.TextSize = 13
        Label.BorderSizePixel = 0

        local Bar = Instance.new("TextButton", Container)
        Bar.Position = UDim2.new(0, 0, 0, 25)
        Bar.Size = UDim2.new(1, 0, 0, 6)
        Bar.BackgroundColor3 = Color3.fromRGB(210, 210, 210)  -- Cinza claro
        Bar.Text = ""
        Bar.BorderSizePixel = 0

        local Fill = Instance.new("Frame", Bar)
        Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
        Fill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)  -- Azul para slider
        Fill.BorderSizePixel = 0

        Bar.MouseButton1Down:Connect(function()
            local conn
            conn = RunService.RenderStepped:Connect(function()
                local mp = UserInputService:GetMouseLocation().X
                local per = math.clamp((mp - Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X, 0, 1)
                local val = min + (max-min)*per
                if max <= 5 then val = tonumber(string.format("%.1f", val)) else val = math.floor(val) end
                Fill.Size = UDim2.new(per, 0, 1, 0)
                Label.Text = "📏 " .. text .. ": " .. val
                callback(val)
            end)
            local endedConn = UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    conn:Disconnect()
                    endedConn:Disconnect()
                end
            end)
        end)
    end

    local function AddDropdown(parent, text, options, callback)
        local Container = Instance.new("Frame", parent)
        Container.Size = UDim2.new(1, -10, 0, 35)
        Container.BackgroundTransparency = 1
        Container.BorderSizePixel = 0

        local Btn = Instance.new("TextButton", Container)
        Btn.Size = UDim2.new(1, 0, 1, 0)
        Btn.BackgroundColor3 = LIGHT_GRAY
        Btn.Text = "▼ " .. text .. ": " .. options[1]
        Btn.TextColor3 = BLACK_COLOR  -- Texto preto
        Btn.Font = Enum.Font.SourceSans
        Btn.TextSize = 13
        Btn.TextXAlignment = Enum.TextXAlignment.Left
        Btn.BorderSizePixel = 0

        local idx = 1
        Btn.MouseButton1Click:Connect(function()
            idx = idx + 1
            if idx > #options then idx = 1 end
            Btn.Text = "▼ " .. text .. ": " .. options[idx]
            callback(options[idx])
        end)
    end

    local function AddButton(parent, text, icon, callback)
        local Btn = Instance.new("TextButton", parent)
        Btn.Size = UDim2.new(1, -10, 0, 35)
        Btn.BackgroundColor3 = LIGHT_GRAY
        Btn.Text = icon .. " " .. text
        Btn.TextColor3 = BLACK_COLOR  -- Texto preto
        Btn.Font = Enum.Font.SourceSans
        Btn.TextSize = 13
        Btn.BorderSizePixel = 0

        Btn.MouseButton1Click:Connect(callback)
    end

    -- Abas
    local LegitPage = Menu:CreateTab("LegitBot", "🎯")
    AddToggle(LegitPage, "Aimbot", Config.Aimbot.Enabled, function(v) Config.Aimbot.Enabled = v SyncAimbot() end)
    AddSlider(LegitPage, "Field of View", 10, 600, Config.Aimbot.FOV, function(v) Config.Aimbot.FOV = v SyncAimbot() end)
    AddSlider(LegitPage, "Smoothness", 0, 5, Config.Aimbot.Smoothness, function(v) Config.Aimbot.Smoothness = v SyncAimbot() end)
    AddDropdown(LegitPage, "Target Part", {"Head", "HumanoidRootPart", "Torso"}, function(v) Config.Aimbot.TargetPart = v SyncAimbot() end)
    AddToggle(LegitPage, "Team Check", Config.Aimbot.TeamCheck, function(v) Config.Aimbot.TeamCheck = v SyncAimbot() end)

    local VisualPage = Menu:CreateTab("Visuals", "👁")
    AddToggle(VisualPage, "Enable ESP", Config.Visuals.Enabled, function(v) Config.Visuals.Enabled = v end)
    AddToggle(VisualPage, "Boxes", Config.Visuals.Boxes, function(v) Config.Visuals.Boxes = v end)
    AddToggle(VisualPage, "Names", Config.Visuals.Names, function(v) Config.Visuals.Names = v end)
    AddToggle(VisualPage, "Health", Config.Visuals.Health, function(v) Config.Visuals.Health = v end)
    AddToggle(VisualPage, "Team Check", Config.Visuals.TeamCheck, function(v) Config.Visuals.TeamCheck = v end)
    AddSlider(VisualPage, "Max Distance", 100, 5000, Config.Visuals.MaxDistance, function(v) Config.Visuals.MaxDistance = v end)

    -- Aba Misc
    local MiscPage = Menu:CreateTab("Misc", "⚙")

    local skyColors = {"Default", "Blue", "White", "Gray", "Bright", "Clean"}
    local colorMap = {
        Default = nil,
        Blue = Color3.fromRGB(100, 150, 255),
        White = Color3.fromRGB(255, 255, 255),
        Gray = Color3.fromRGB(200, 200, 200),
        Bright = Color3.fromRGB(255, 255, 230),
        Clean = Color3.fromRGB(220, 240, 255)
    }

    AddDropdown(MiscPage, "Sky Color", skyColors, function(selected)
        local sky = Lighting:FindFirstChild("NataMenu_Sky")
        local cc = Lighting:FindFirstChild("NataMenu_SkyTint")
        
        if sky then sky:Destroy() end
        if cc then cc:Destroy() end

        if selected == "Default" then return end

        local targetColor = colorMap[selected]

        local newSky = Instance.new("Sky")
        newSky.Name = "NataMenu_Sky"
        newSky.Parent = Lighting
        newSky.CelestialBodiesShown = false

        local newCC = Instance.new("ColorCorrectionEffect")
        newCC.Name = "NataMenu_SkyTint"
        newCC.Parent = Lighting
        newCC.Enabled = true
        newCC.TintColor = targetColor
        newCC.Brightness = -0.05
    end)

    -- Funções Misc
    AddToggle(MiscPage, "Night Mode", Config.Misc.NightMode, function(v)
        Config.Misc.NightMode = v
        miscFunctions:ToggleNightMode(v)
    end)

    AddToggle(MiscPage, "Fullbright", Config.Misc.Fullbright, function(v)
        Config.Misc.Fullbright = v
        miscFunctions:ToggleFullbright(v)
    end)

    AddToggle(MiscPage, "Noclip", Config.Misc.NoClip, function(v)
        Config.Misc.NoClip = v
        miscFunctions:ToggleNoClip(v)
    end)

    AddSlider(MiscPage, "Walk Speed", 16, 100, Config.Misc.WalkSpeed, function(v)
        Config.Misc.WalkSpeed = v
        miscFunctions:SetWalkSpeed(v)
    end)

    AddSlider(MiscPage, "Jump Power", 50, 200, Config.Misc.JumpPower, function(v)
        Config.Misc.JumpPower = v
        miscFunctions:SetJumpPower(v)
    end)

    AddToggle(MiscPage, "FPS Boost", Config.Misc.FPSBoost, function(v)
        Config.Misc.FPSBoost = v
        miscFunctions:ToggleFPSBoost(v)
    end)

    AddToggle(MiscPage, "Auto Click", Config.Misc.AutoClick, function(v)
        Config.Misc.AutoClick = v
        miscFunctions:ToggleAutoClick(v)
    end)

    AddToggle(MiscPage, "Anti-AFK", Config.Misc.AntiAFK, function(v)
        Config.Misc.AntiAFK = v
        miscFunctions:ToggleAntiAFK(v)
    end)

    AddToggle(MiscPage, "Bypass", Config.Misc.Bypass, function(v)
        Config.Misc.Bypass = v
        miscFunctions:ToggleBypass(v)
    end)

    -- Botões
    AddButton(MiscPage, "Refresh ESP", "🔄", function()
        for _, drawing in pairs(ESP.Drawings) do
            for _, d in pairs(drawing) do
                d:Remove()
            end
        end
        ESP.Drawings = {}
        for _, p in ipairs(Players:GetPlayers()) do ESP:AddPlayer(p) end
    end)

    AddButton(MiscPage, "Copy Discord", "📋", function()
        setclipboard("discord.gg/natamenu")
    end)

    AddButton(MiscPage, "Hide Menu (F5)", "👁", function()
        ScreenGui.Enabled = not ScreenGui.Enabled
    end)

    AddButton(MiscPage, "Credits", "⭐", function()
        miscFunctions:ShowCredits()
    end)

    -- Abrir LegitBot por padrão
    Menu.Tabs["LegitBot"].Btn.TextColor3 = BLACK_COLOR
    Menu.Tabs["LegitBot"].Btn.BackgroundColor3 = MEDIUM_GRAY
    Menu.Tabs["LegitBot"].Page.Visible = true

    -- Draggable
    local dragging, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Toggle F5
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.F5 then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    -- Watermark (Branco com texto preto)
    local Watermark = Instance.new("ScreenGui", game:GetService("CoreGui"))
    Watermark.Name = "NataMenuWatermark"
    Watermark.Enabled = true
    
    local WatermarkFrame = Instance.new("Frame", Watermark)
    WatermarkFrame.Size = UDim2.new(0, 150, 0, 25)
    WatermarkFrame.Position = UDim2.new(1, -160, 0, 10)
    WatermarkFrame.BackgroundColor3 = WHITE_COLOR
    WatermarkFrame.BorderSizePixel = 1
    WatermarkFrame.BorderColor3 = BORDER_COLOR
    
    local WatermarkLabel = Instance.new("TextLabel", WatermarkFrame)
    WatermarkLabel.Size = UDim2.new(1, 0, 1, 0)
    WatermarkLabel.Text = "NATA.MENU v1.0"
    WatermarkLabel.TextColor3 = BLACK_COLOR  -- Texto preto
    WatermarkLabel.Font = Enum.Font.SourceSans
    WatermarkLabel.TextSize = 12
    WatermarkLabel.BackgroundTransparency = 1

    -- Créditos
    local Credits = Instance.new("TextLabel", ScreenGui)
    Credits.Text = "Designer: Farpa | Programmer: Toque"
    Credits.Size = UDim2.new(0, 250, 0, 20)
    Credits.Position = UDim2.new(1, -260, 0, 40)
    Credits.BackgroundTransparency = 1
    Credits.TextColor3 = BLACK_COLOR  -- Texto preto
    Credits.Font = Enum.Font.SourceSans
    Credits.TextSize = 11
    Credits.BorderSizePixel = 0

    -- Iniciar funções
    miscFunctions:ToggleAntiAFK(true)
end

Menu:Init()

-- Conector NoClip
RunService.Stepped:Connect(function()
    if Config.Misc.NoClip and LocalPlayer.Character then
        local char = LocalPlayer.Character
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Atualizar WalkSpeed/JumpPower
LocalPlayer.CharacterAdded:Connect(function(character)
    wait(1)
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Config.Misc.WalkSpeed
            humanoid.JumpPower = Config.Misc.JumpPower
        end
    end
end)

-- Mensagem inicial (branco/preto)
print("╔════════════════════════════════╗")
print("║        NATA.MENU v1.0          ║")
print("║   🎯 LegitBot   👁 Visuals     ║")
print("║   ⚙ Misc        🚀 Loaded!     ║")
print("║   🖼 NEW LOGO                  ║")
print("║   ⚪ WHITE UI                  ║")
print("║   ⚫ BLACK TEXT                ║")
print("╚════════════════════════════════╝")
print("F5 - Toggle Menu")
print("Designer: Farpa | Programmer: Toque")
