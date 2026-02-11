 -- NATA.MENU - Obfuscated Version (Fixed)
-- All functionality preserved

local _0x1a2b3c = string.char
local _0x4d5e6f = string.byte
local _0x7g8h9i = string.sub
local _0xjklmno = getfenv
local _0xpqrstu = setmetatable
local _0xvwxyz1 = table.concat
local _0x234567 = table.insert
local _0x89abcd = math.floor
local _0xefghij = tonumber

local function _0xDecode(_0xStr)
    local _0xResult = {}
    for _0xi = 1, #_0xStr, 2 do
        local _0xByte = _0xefghij(_0x7g8h9i(_0xStr, _0xi, _0xi + 1), 16)
        _0x234567(_0xResult, _0x1a2b3c(_0xByte))
    end
    return _0xvwxyz1(_0xResult)
end

if getgenv().NataMenu then
    warn("NATA.MENU is already loaded!")
    return
end

getgenv().NataMenu = true

local _0xServices = {
    game:GetService("RunService"),
    game:GetService("UserInputService"),
    game:GetService("Players"),
    game:GetService("Workspace"),
    game:GetService("Lighting"),
    game:GetService("HttpService")
}

local _0xPlayer = _0xServices[3].LocalPlayer
local _0xCamera = _0xServices[4].CurrentCamera
local _0xMenuID = _0xServices[6]:GenerateGUID(false):sub(1, 8)

local _0xConfig = {
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

local _0xColors = {
    Color3.fromRGB(255, 255, 255),
    Color3.fromRGB(245, 245, 245),
    Color3.fromRGB(225, 225, 225),
    Color3.fromRGB(200, 200, 200),
    Color3.new(0, 0, 0),
    Color3.fromRGB(180, 180, 180),
    Color3.fromRGB(0, 120, 255)
}

local function _0xLoadAimbot()
    local _0xSuccess, _0xError = pcall(function()
        local _0xScript = game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V3/main/src/Aimbot.lua")
        loadstring(_0xScript)()
        wait(0.5)
        
        if getgenv().Aimbot then
            local _0xAB = getgenv().Aimbot
            _0xAB.FOVSettings.Color = _0xColors[1]
            _0xAB.FOVSettings.Visible = true
            _0xAB.Enabled = _0xConfig.Aimbot.Enabled
            _0xAB.FOV = _0xConfig.Aimbot.FOV
            _0xAB.Smoothness = _0xConfig.Aimbot.Smoothness
            _0xAB.TargetPart = _0xConfig.Aimbot.TargetPart
            _0xAB.TeamCheck = _0xConfig.Aimbot.TeamCheck
            _0xAB.VisibleCheck = _0xConfig.Aimbot.VisibleCheck
            print("[AIMBOT] Successfully loaded and configured!")
        else
            warn("[AIMBOT] V3 not found, trying V2...")
            local _0xV2 = game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V2/main/Resources/Scripts/Raw%20Main.lua")
            loadstring(_0xV2)()
            wait(0.3)
            
            if getgenv().Aimbot then
                local _0xAB = getgenv().Aimbot
                _0xAB.FOVSettings.Color = _0xColors[1]
                _0xAB.FOVSettings.Visible = true
                _0xAB.Enabled = _0xConfig.Aimbot.Enabled
                _0xAB.FOV = _0xConfig.Aimbot.FOV
                _0xAB.Smoothness = _0xConfig.Aimbot.Smoothness
                _0xAB.TargetPart = _0xConfig.Aimbot.TargetPart
                _0xAB.TeamCheck = _0xConfig.Aimbot.TeamCheck
                print("[AIMBOT] V2 loaded successfully!")
            end
        end
    end)
    
    if not _0xSuccess then
        warn("[AIMBOT] Loading error: " .. tostring(_0xError))
    end
end

_0xLoadAimbot()

local function _0xSyncAimbot()
    if getgenv().Aimbot then
        local _0xAB = getgenv().Aimbot
        _0xAB.Enabled = _0xConfig.Aimbot.Enabled
        _0xAB.FOV = _0xConfig.Aimbot.FOV
        _0xAB.Smoothness = _0xConfig.Aimbot.Smoothness
        _0xAB.TargetPart = _0xConfig.Aimbot.TargetPart
        _0xAB.TeamCheck = _0xConfig.Aimbot.TeamCheck
        _0xAB.VisibleCheck = _0xConfig.Aimbot.VisibleCheck
    end
end

local function _0xSetupBypass()
    if not _0xConfig.Misc.Bypass then return end
    
    pcall(function()
        local _0xOld
        _0xOld = hookmetamethod(game, "__namecall", function(self, ...)
            local _0xMethod = getnamecallmethod()
            local _0xArgs = {...}
            
            if _0xMethod == "Kick" or _0xMethod == "kick" then
                return nil
            end
            
            return _0xOld(self, unpack(_0xArgs))
        end)
    end)
end

local _0xESP = {Drawings = {}}
local _0xDrawLib = (drawing or Drawing)

function _0xESP:AddPlayer(_0xP)
    if _0xP == _0xPlayer or not _0xDrawLib then return end
    self.Drawings[_0xP] = {
        Box = _0xDrawLib.new("Square"),
        Name = _0xDrawLib.new("Text"),
        Health = _0xDrawLib.new("Text"),
        Distance = _0xDrawLib.new("Text")
    }
end

function _0xESP:Update()
    if not _0xDrawLib then return end
    
    for _0xP, _0xD in pairs(self.Drawings) do
        if not _0xP.Parent or not _0xP.Character or not _0xConfig.Visuals.Enabled then
            for _, d in pairs(_0xD) do 
                if d then d.Visible = false end 
            end
            continue
        end
        
        local _0xChar = _0xP.Character
        local _0xRoot = _0xChar:FindFirstChild("HumanoidRootPart")
        local _0xHum = _0xChar:FindFirstChild("Humanoid")
        
        if _0xRoot and _0xHum then
            local _0xPos, _0xOnScreen = _0xCamera:WorldToViewportPoint(_0xRoot.Position)
            local _0xDist = (_0xCamera.CFrame.Position - _0xRoot.Position).Magnitude
            
            if _0xOnScreen and _0xDist <= _0xConfig.Visuals.MaxDistance then
                local _0xIsTeam = _0xConfig.Visuals.TeamCheck and _0xP.Team == _0xPlayer.Team
                local _0xColor = _0xIsTeam and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(255, 50, 50)
                
                if _0xConfig.Visuals.Boxes then
                    local _0xSize = Vector2.new(2000/_0xDist * 2, 2000/_0xDist * 3)
                    _0xD.Box.Visible = true
                    _0xD.Box.Size = _0xSize
                    _0xD.Box.Position = Vector2.new(_0xPos.X - _0xSize.X/2, _0xPos.Y - _0xSize.Y/2)
                    _0xD.Box.Color = _0xColor
                    _0xD.Box.Thickness = 1
                    _0xD.Box.Filled = false
                else 
                    _0xD.Box.Visible = false 
                end
                
                if _0xConfig.Visuals.Names then
                    _0xD.Name.Visible = true
                    _0xD.Name.Text = _0xP.Name
                    _0xD.Name.Position = Vector2.new(_0xPos.X, _0xPos.Y - (2000/_0xDist * 1.5) - 15)
                    _0xD.Name.Center = true
                    _0xD.Name.Outline = true
                    _0xD.Name.Color = _0xColors[5]
                    _0xD.Name.Size = 14
                else 
                    _0xD.Name.Visible = false 
                end
                
                if _0xConfig.Visuals.Health then
                    _0xD.Health.Visible = true
                    _0xD.Health.Text = _0x89abcd(_0xHum.Health) .. " HP"
                    _0xD.Health.Position = Vector2.new(_0xPos.X, _0xPos.Y + (2000/_0xDist * 1.5) + 5)
                    _0xD.Health.Center = true
                    _0xD.Health.Outline = true
                    _0xD.Health.Color = _0xColors[5]
                    _0xD.Health.Size = 14
                else 
                    _0xD.Health.Visible = false 
                end
                
                if _0xConfig.Visuals.Distance then
                    _0xD.Distance.Visible = true
                    _0xD.Distance.Text = _0x89abcd(_0xDist) .. " studs"
                    _0xD.Distance.Position = Vector2.new(_0xPos.X, _0xPos.Y + (2000/_0xDist * 1.5) + 25)
                    _0xD.Distance.Center = true
                    _0xD.Distance.Outline = true
                    _0xD.Distance.Color = _0xColors[5]
                    _0xD.Distance.Size = 12
                else 
                    _0xD.Distance.Visible = false 
                end
            else
                for _, d in pairs(_0xD) do 
                    if d then d.Visible = false end 
                end
            end
        end
    end
end

_0xServices[1].RenderStepped:Connect(function()
    pcall(function()
        _0xESP:Update()
    end)
end)

for _, _0xP in ipairs(_0xServices[3]:GetPlayers()) do 
    _0xESP:AddPlayer(_0xP) 
end

_0xServices[3].PlayerAdded:Connect(function(_0xP) 
    _0xESP:AddPlayer(_0xP) 
end)

local _0xMisc = {}

function _0xMisc:ToggleNightMode(_0xState)
    if _0xState then
        local _0xCC = Instance.new("ColorCorrectionEffect")
        _0xCC.Name = "NataMenu_NightMode"
        _0xCC.Parent = _0xServices[5]
        _0xCC.Brightness = -0.15
        _0xCC.Contrast = 0.05
        _0xCC.TintColor = Color3.fromRGB(50, 50, 100)
        _0xCC.Saturation = -0.3
    else
        local _0xCC = _0xServices[5]:FindFirstChild("NataMenu_NightMode")
        if _0xCC then _0xCC:Destroy() end
    end
end

function _0xMisc:ToggleFullbright(_0xState)
    if _0xState then
        _0xServices[5].GlobalShadows = false
        _0xServices[5].OutdoorAmbient = Color3.new(0.9,0.9,0.9)
        _0xServices[5].Brightness = 1.5
        _0xServices[5].ClockTime = 14
    else
        _0xServices[5].GlobalShadows = true
        _0xServices[5].OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        _0xServices[5].Brightness = 1
    end
end

function _0xMisc:ToggleNoClip(_0xState)
    _0xConfig.Misc.NoClip = _0xState
    if _0xState and _0xPlayer.Character then
        local _0xHum = _0xPlayer.Character:FindFirstChild("Humanoid")
        if _0xHum then
            _0xHum:ChangeState(11)
        end
    end
end

function _0xMisc:SetWalkSpeed(_0xSpeed)
    _0xConfig.Misc.WalkSpeed = _0xSpeed
    local _0xChar = _0xPlayer.Character
    if _0xChar then
        local _0xHum = _0xChar:FindFirstChild("Humanoid")
        if _0xHum then
            _0xHum.WalkSpeed = _0xSpeed
        end
    end
end

function _0xMisc:SetJumpPower(_0xPower)
    _0xConfig.Misc.JumpPower = _0xPower
    local _0xChar = _0xPlayer.Character
    if _0xChar then
        local _0xHum = _0xChar:FindFirstChild("Humanoid")
        if _0xHum then
            _0xHum.JumpPower = _0xPower
        end
    end
end

function _0xMisc:ToggleFPSBoost(_0xState)
    if _0xState then
        pcall(function()
            settings().Rendering.QualityLevel = 1
            settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
            _0xServices[4].Terrain.WaterReflection = false
            _0xServices[4].Terrain.WaterWaveSize = 0
            _0xServices[4].Terrain.WaterWaveSpeed = 0
        end)
    else
        pcall(function()
            settings().Rendering.QualityLevel = 21
            settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
        end)
    end
end

function _0xMisc:ToggleAutoClick(_0xState)
    _0xConfig.Misc.AutoClick = _0xState
    if _0xState then
        spawn(function()
            while _0xConfig.Misc.AutoClick do
                pcall(function()
                    mouse1click()
                end)
                wait(0.1)
            end
        end)
    end
end

function _0xMisc:ToggleAntiAFK(_0xState)
    _0xConfig.Misc.AntiAFK = _0xState
    if _0xState then
        local _0xVU = game:GetService("VirtualUser")
        _0xPlayer.Idled:Connect(function()
            if _0xConfig.Misc.AntiAFK then
                _0xVU:Button2Down(Vector2.new(0,0), _0xCamera.CFrame)
                wait(1)
                _0xVU:Button2Up(Vector2.new(0,0), _0xCamera.CFrame)
            end
        end)
    end
end

function _0xMisc:ToggleBypass(_0xState)
    _0xConfig.Misc.Bypass = _0xState
    if _0xState then
        _0xSetupBypass()
    end
end

function _0xMisc:ShowCredits()
    local _0xCG = game:GetService("CoreGui")
    local _0xExist = _0xCG:FindFirstChild("NataMenuCredits")
    if _0xExist then _0xExist:Destroy() end
    
    local _0xGui = Instance.new("ScreenGui", _0xCG)
    _0xGui.Name = "NataMenuCredits"
    _0xGui.ResetOnSpawn = false
    
    local _0xMain = Instance.new("Frame", _0xGui)
    _0xMain.Size = UDim2.new(0, 320, 0, 220)
    _0xMain.Position = UDim2.new(0.5, -160, 0.5, -110)
    _0xMain.BackgroundColor3 = _0xColors[1]
    _0xMain.BorderSizePixel = 1
    _0xMain.BorderColor3 = _0xColors[6]
    
    local _0xTitle = Instance.new("TextLabel", _0xMain)
    _0xTitle.Text = "NATA.MENU CREDITS"
    _0xTitle.Size = UDim2.new(1, 0, 0, 50)
    _0xTitle.TextColor3 = _0xColors[5]
    _0xTitle.Font = Enum.Font.SourceSansBold
    _0xTitle.TextSize = 20
    _0xTitle.BackgroundTransparency = 1
    
    local _0xDesigner = Instance.new("TextLabel", _0xMain)
    _0xDesigner.Text = "🎨 Designer: Farpa"
    _0xDesigner.Size = UDim2.new(1, 0, 0, 30)
    _0xDesigner.Position = UDim2.new(0, 0, 0, 60)
    _0xDesigner.TextColor3 = _0xColors[5]
    _0xDesigner.Font = Enum.Font.SourceSans
    _0xDesigner.TextSize = 16
    _0xDesigner.BackgroundTransparency = 1
    
    local _0xProg = Instance.new("TextLabel", _0xMain)
    _0xProg.Text = "💻 Programmer: Toque"
    _0xProg.Size = UDim2.new(1, 0, 0, 30)
    _0xProg.Position = UDim2.new(0, 0, 0, 95)
    _0xProg.TextColor3 = _0xColors[5]
    _0xProg.Font = Enum.Font.SourceSans
    _0xProg.TextSize = 16
    _0xProg.BackgroundTransparency = 1
    
    local _0xDisc = Instance.new("TextLabel", _0xMain)
    _0xDisc.Text = "📢 Discord: discord.gg/S2uD6TXAVs"
    _0xDisc.Size = UDim2.new(1, 0, 0, 30)
    _0xDisc.Position = UDim2.new(0, 0, 0, 130)
    _0xDisc.TextColor3 = Color3.fromRGB(0, 100, 255)
    _0xDisc.Font = Enum.Font.SourceSansBold
    _0xDisc.TextSize = 14
    _0xDisc.BackgroundTransparency = 1
    
    local _0xCopy = Instance.new("TextButton", _0xMain)
    _0xCopy.Text = "📋 Copy Discord"
    _0xCopy.Size = UDim2.new(0.6, 0, 0, 35)
    _0xCopy.Position = UDim2.new(0.2, 0, 0, 165)
    _0xCopy.BackgroundColor3 = _0xColors[2]
    _0xCopy.TextColor3 = _0xColors[5]
    _0xCopy.Font = Enum.Font.SourceSans
    _0xCopy.TextSize = 14
    
    _0xCopy.MouseButton1Click:Connect(function()
        pcall(function()
            setclipboard("https://discord.gg/S2uD6TXAVs")
            _0xCopy.Text = "✅ Copied!"
            wait(1.5)
            _0xCopy.Text = "📋 Copy Discord"
        end)
    end)
    
    local _0xClose = Instance.new("TextButton", _0xMain)
    _0xClose.Text = "Close"
    _0xClose.Size = UDim2.new(0.4, 0, 0, 35)
    _0xClose.Position = UDim2.new(0.3, 0, 1, -45)
    _0xClose.BackgroundColor3 = _0xColors[2]
    _0xClose.TextColor3 = _0xColors[5]
    _0xClose.Font = Enum.Font.SourceSans
    _0xClose.TextSize = 14
    
    _0xClose.MouseButton1Click:Connect(function()
        _0xGui:Destroy()
    end)
end

_0xServices[1].Stepped:Connect(function()
    if _0xConfig.Misc.NoClip and _0xPlayer.Character then
        for _, _0xPart in pairs(_0xPlayer.Character:GetDescendants()) do
            if _0xPart:IsA("BasePart") then
                _0xPart.CanCollide = false
            end
        end
    end
end)

_0xPlayer.CharacterAdded:Connect(function(_0xChar)
    wait(1)
    if _0xChar then
        local _0xHum = _0xChar:FindFirstChild("Humanoid")
        if _0xHum then
            _0xHum.WalkSpeed = _0xConfig.Misc.WalkSpeed
            _0xHum.JumpPower = _0xConfig.Misc.JumpPower
        end
    end
end)

local _0xMenu = {Tabs = {}}

function _0xMenu:Init()
    local _0xSG = Instance.new("ScreenGui", game:GetService("CoreGui"))
    _0xSG.Name = "NataMenu"
    _0xSG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local _0xMain = Instance.new("Frame", _0xSG)
    _0xMain.Size = UDim2.new(0, 520, 0, 350)
    _0xMain.Position = UDim2.new(0.5, -260, 0.5, -175)
    _0xMain.BackgroundColor3 = _0xColors[1]
    _0xMain.BorderSizePixel = 1
    _0xMain.BorderColor3 = _0xColors[6]
    _0xMain.ClipsDescendants = true
    
    local _0xBG = Instance.new("ImageLabel", _0xMain)
    _0xBG.Image = "rbxassetid://140294694317618"
    _0xBG.Size = UDim2.new(2, 0, 2, 0)
    _0xBG.BackgroundTransparency = 1
    _0xBG.ImageColor3 = Color3.fromRGB(255, 255, 255)
    _0xBG.ImageTransparency = 0.3
    _0xBG.ScaleType = Enum.ScaleType.Fit
    _0xBG.ZIndex = 0
    
    local _0xOverlay = Instance.new("Frame", _0xMain)
    _0xOverlay.Size = UDim2.new(1, 0, 1, 0)
    _0xOverlay.BackgroundColor3 = _0xColors[1]
    _0xOverlay.BackgroundTransparency = 0.3
    _0xOverlay.BorderSizePixel = 0
    _0xOverlay.ZIndex = 1
    
    local _0xSidebar = Instance.new("Frame", _0xMain)
    _0xSidebar.Size = UDim2.new(0, 140, 1, 0)
    _0xSidebar.BackgroundColor3 = _0xColors[2]
    _0xSidebar.BackgroundTransparency = 0.2
    _0xSidebar.BorderSizePixel = 0
    _0xSidebar.ZIndex = 2

    local _0xSBBorder = Instance.new("Frame", _0xSidebar)
    _0xSBBorder.Size = UDim2.new(0, 1, 1, 0)
    _0xSBBorder.Position = UDim2.new(1, -1, 0, 0)
    _0xSBBorder.BackgroundColor3 = _0xColors[6]
    _0xSBBorder.BorderSizePixel = 0
    _0xSBBorder.ZIndex = 3

    local _0xLogoF = Instance.new("Frame", _0xSidebar)
    _0xLogoF.Size = UDim2.new(1, 0, 0, 100)
    _0xLogoF.BackgroundTransparency = 1
    _0xLogoF.BorderSizePixel = 0
    _0xLogoF.ZIndex = 3
    
    local _0xLogo = Instance.new("ImageLabel", _0xLogoF)
    _0xLogo.Size = UDim2.new(0.8, 0, 0.7, 0)
    _0xLogo.Position = UDim2.new(0.1, 0, 0.15, 0)
    _0xLogo.Image = "rbxassetid://107352185324985"
    _0xLogo.BackgroundTransparency = 1
    _0xLogo.ScaleType = Enum.ScaleType.Fit
    _0xLogo.ZIndex = 4
    
    local _0xLogoG = Instance.new("UIGradient", _0xLogo)
    _0xLogoG.Rotation = 90
    _0xLogoG.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
    })
    _0xLogoG.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 0.3)
    })

    local _0xTabC = Instance.new("Frame", _0xSidebar)
    _0xTabC.Position = UDim2.new(0, 0, 0, 110)
    _0xTabC.Size = UDim2.new(1, 0, 1, -110)
    _0xTabC.BackgroundTransparency = 1
    _0xTabC.BorderSizePixel = 0
    _0xTabC.ZIndex = 3
    Instance.new("UIListLayout", _0xTabC)

    local _0xContent = Instance.new("Frame", _0xMain)
    _0xContent.Position = UDim2.new(0, 150, 0, 10)
    _0xContent.Size = UDim2.new(1, -160, 1, -20)
    _0xContent.BackgroundTransparency = 1
    _0xContent.BorderSizePixel = 0
    _0xContent.ZIndex = 2

    function _0xMenu:CreateTab(_0xName, _0xIcon)
        local _0xBtn = Instance.new("TextButton", _0xTabC)
        _0xBtn.Size = UDim2.new(1, 0, 0, 35)
        _0xBtn.BackgroundColor3 = _0xColors[2]
        _0xBtn.Text = _0xIcon .. " " .. _0xName
        _0xBtn.TextColor3 = _0xColors[5]
        _0xBtn.Font = Enum.Font.SourceSans
        _0xBtn.TextSize = 13
        _0xBtn.BorderSizePixel = 1
        _0xBtn.BorderColor3 = _0xColors[6]
        _0xBtn.ZIndex = 4
        _0xBtn.TextXAlignment = Enum.TextXAlignment.Left

        local _0xPage = Instance.new("ScrollingFrame", _0xContent)
        _0xPage.Size = UDim2.new(1, 0, 1, 0)
        _0xPage.BackgroundTransparency = 1
        _0xPage.Visible = false
        _0xPage.ScrollBarThickness = 2
        _0xPage.ScrollBarImageColor3 = _0xColors[4]
        _0xPage.BorderSizePixel = 0
        _0xPage.ZIndex = 2
        Instance.new("UIListLayout", _0xPage).Padding = UDim.new(0, 10)

        _0xBtn.MouseButton1Click:Connect(function()
            for _, _0xV in pairs(_0xMenu.Tabs) do
                _0xV.Page.Visible = false
                _0xV.Btn.TextColor3 = _0xColors[5]
                _0xV.Btn.BackgroundColor3 = _0xColors[2]
            end
            _0xPage.Visible = true
            _0xBtn.TextColor3 = _0xColors[5]
            _0xBtn.BackgroundColor3 = _0xColors[3]
        end)

        _0xMenu.Tabs[_0xName] = {Page = _0xPage, Btn = _0xBtn}
        return _0xPage
    end

    local function _0xAddToggle(_0xParent, _0xText, _0xDefault, _0xCallback)
        local _0xCont = Instance.new("Frame", _0xParent)
        _0xCont.Size = UDim2.new(1, -10, 0, 35)
        _0xCont.BackgroundTransparency = 1
        _0xCont.BorderSizePixel = 0
        _0xCont.ZIndex = 3
        
        local _0xBtn = Instance.new("TextButton", _0xCont)
        _0xBtn.Size = UDim2.new(1, 0, 1, 0)
        _0xBtn.BackgroundColor3 = _0xColors[2]
        _0xBtn.Text = (_0xDefault and "✓ " or "✗ ") .. _0xText
        _0xBtn.TextColor3 = _0xDefault and _0xColors[5] or Color3.fromRGB(100, 100, 100)
        _0xBtn.Font = Enum.Font.SourceSans
        _0xBtn.TextSize = 13
        _0xBtn.TextXAlignment = Enum.TextXAlignment.Left
        _0xBtn.BorderSizePixel = 1
        _0xBtn.BorderColor3 = _0xColors[6]
        _0xBtn.ZIndex = 4

        _0xBtn.MouseButton1Click:Connect(function()
            _0xDefault = not _0xDefault
            _0xBtn.Text = (_0xDefault and "✓ " or "✗ ") .. _0xText
            _0xBtn.TextColor3 = _0xDefault and _0xColors[5] or Color3.fromRGB(100, 100, 100)
            _0xCallback(_0xDefault)
        end)
    end

    local function _0xAddSlider(_0xParent, _0xText, _0xMin, _0xMax, _0xDefault, _0xCallback)
        local _0xCont = Instance.new("Frame", _0xParent)
        _0xCont.Size = UDim2.new(1, -10, 0, 50)
        _0xCont.BackgroundTransparency = 1
        _0xCont.BorderSizePixel = 0
        _0xCont.ZIndex = 3

        local _0xLabel = Instance.new("TextLabel", _0xCont)
        _0xLabel.Text = "📏 " .. _0xText .. ": " .. _0xDefault
        _0xLabel.Size = UDim2.new(1, 0, 0, 20)
        _0xLabel.TextColor3 = _0xColors[5]
        _0xLabel.BackgroundTransparency = 1
        _0xLabel.TextXAlignment = Enum.TextXAlignment.Left
        _0xLabel.Font = Enum.Font.SourceSans
        _0xLabel.TextSize = 13
        _0xLabel.BorderSizePixel = 0
        _0xLabel.ZIndex = 4

        local _0xBar = Instance.new("TextButton", _0xCont)
        _0xBar.Position = UDim2.new(0, 0, 0, 25)
        _0xBar.Size = UDim2.new(1, 0, 0, 6)
        _0xBar.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
        _0xBar.Text = ""
        _0xBar.BorderSizePixel = 1
        _0xBar.BorderColor3 = _0xColors[6]
        _0xBar.ZIndex = 4

        local _0xFill = Instance.new("Frame", _0xBar)
        _0xFill.Size = UDim2.new((_0xDefault-_0xMin)/(_0xMax-_0xMin), 0, 1, 0)
        _0xFill.BackgroundColor3 = _0xColors[7]
        _0xFill.BorderSizePixel = 0
        _0xFill.ZIndex = 5

        _0xBar.MouseButton1Down:Connect(function()
            local _0xConn
            _0xConn = _0xServices[1].RenderStepped:Connect(function()
                local _0xMP = _0xServices[2]:GetMouseLocation().X
                local _0xPer = math.clamp((_0xMP - _0xBar.AbsolutePosition.X)/_0xBar.AbsoluteSize.X, 0, 1)
                local _0xVal = _0xMin + (_0xMax-_0xMin)*_0xPer
                if _0xMax <= 5 then _0xVal = tonumber(string.format("%.1f", _0xVal)) else _0xVal = _0x89abcd(_0xVal) end
                _0xFill.Size = UDim2.new(_0xPer, 0, 1, 0)
                _0xLabel.Text = "📏 " .. _0xText .. ": " .. _0xVal
                _0xCallback(_0xVal)
            end)
            local _0xEndConn = _0xServices[2].InputEnded:Connect(function(_0xI)
                if _0xI.UserInputType == Enum.UserInputType.MouseButton1 then
                    _0xConn:Disconnect()
                    _0xEndConn:Disconnect()
                end
            end)
        end)
    end

    local function _0xAddDropdown(_0xParent, _0xText, _0xOptions, _0xCallback)
        local _0xCont = Instance.new("Frame", _0xParent)
        _0xCont.Size = UDim2.new(1, -10, 0, 35)
        _0xCont.BackgroundTransparency = 1
        _0xCont.BorderSizePixel = 0
        _0xCont.ZIndex = 3

        local _0xBtn = Instance.new("TextButton", _0xCont)
        _0xBtn.Size = UDim2.new(1, 0, 1, 0)
        _0xBtn.BackgroundColor3 = _0xColors[2]
        _0xBtn.Text = "▼ " .. _0xText .. ": " .. _0xOptions[1]
        _0xBtn.TextColor3 = _0xColors[5]
        _0xBtn.Font = Enum.Font.SourceSans
        _0xBtn.TextSize = 13
        _0xBtn.TextXAlignment = Enum.TextXAlignment.Left
        _0xBtn.BorderSizePixel = 1
        _0xBtn.BorderColor3 = _0xColors[6]
        _0xBtn.ZIndex = 4

        local _0xIdx = 1
        _0xBtn.MouseButton1Click:Connect(function()
            _0xIdx = _0xIdx + 1
            if _0xIdx > #_0xOptions then _0xIdx = 1 end
            _0xBtn.Text = "▼ " .. _0xText .. ": " .. _0xOptions[_0xIdx]
            _0xCallback(_0xOptions[_0xIdx])
        end)
    end

    local function _0xAddButton(_0xParent, _0xText, _0xIcon, _0xCallback)
        local _0xBtn = Instance.new("TextButton", _0xParent)
        _0xBtn.Size = UDim2.new(1, -10, 0, 35)
        _0xBtn.BackgroundColor3 = _0xColors[2]
        _0xBtn.Text = _0xIcon .. " " .. _0xText
        _0xBtn.TextColor3 = _0xColors[5]
        _0xBtn.Font = Enum.Font.SourceSans
        _0xBtn.TextSize = 13
        _0xBtn.BorderSizePixel = 1
        _0xBtn.BorderColor3 = _0xColors[6]
        _0xBtn.ZIndex = 4

        _0xBtn.MouseButton1Click:Connect(_0xCallback)
    end

    local _0xAimPage = _0xMenu:CreateTab("Aimbot", "🎯")
    _0xAddToggle(_0xAimPage, "Enable Aimbot", _0xConfig.Aimbot.Enabled, function(_0xV) 
        _0xConfig.Aimbot.Enabled = _0xV 
        _0xSyncAimbot() 
    end)
    _0xAddSlider(_0xAimPage, "Field of View", 10, 600, _0xConfig.Aimbot.FOV, function(_0xV) 
        _0xConfig.Aimbot.FOV = _0xV 
        _0xSyncAimbot() 
    end)
    _0xAddSlider(_0xAimPage, "Smoothness", 0, 5, _0xConfig.Aimbot.Smoothness, function(_0xV) 
        _0xConfig.Aimbot.Smoothness = _0xV 
        _0xSyncAimbot() 
    end)
    _0xAddDropdown(_0xAimPage, "Target Part", {"Head", "HumanoidRootPart", "UpperTorso"}, function(_0xV) 
        _0xConfig.Aimbot.TargetPart = _0xV 
        _0xSyncAimbot() 
    end)
    _0xAddToggle(_0xAimPage, "Team Check", _0xConfig.Aimbot.TeamCheck, function(_0xV) 
        _0xConfig.Aimbot.TeamCheck = _0xV 
        _0xSyncAimbot() 
    end)
    _0xAddToggle(_0xAimPage, "Visible Check", _0xConfig.Aimbot.VisibleCheck, function(_0xV) 
        _0xConfig.Aimbot.VisibleCheck = _0xV 
        _0xSyncAimbot() 
    end)

    local _0xVisPage = _0xMenu:CreateTab("Visuals", "👁")
    _0xAddToggle(_0xVisPage, "Enable ESP", _0xConfig.Visuals.Enabled, function(_0xV) _0xConfig.Visuals.Enabled = _0xV end)
    _0xAddToggle(_0xVisPage, "Boxes", _0xConfig.Visuals.Boxes, function(_0xV) _0xConfig.Visuals.Boxes = _0xV end)
    _0xAddToggle(_0xVisPage, "Names", _0xConfig.Visuals.Names, function(_0xV) _0xConfig.Visuals.Names = _0xV end)
    _0xAddToggle(_0xVisPage, "Health", _0xConfig.Visuals.Health, function(_0xV) _0xConfig.Visuals.Health = _0xV end)
    _0xAddToggle(_0xVisPage, "Team Check", _0xConfig.Visuals.TeamCheck, function(_0xV) _0xConfig.Visuals.TeamCheck = _0xV end)
    _0xAddSlider(_0xVisPage, "Max Distance", 100, 5000, _0xConfig.Visuals.MaxDistance, function(_0xV) _0xConfig.Visuals.MaxDistance = _0xV end)

    local _0xMiscPage = _0xMenu:CreateTab("Misc", "⚙")

    local _0xSkyColors = {"Default", "Blue", "White", "Gray", "Bright", "Clean"}
    local _0xColorMap = {
        Blue = Color3.fromRGB(100, 150, 255),
        White = Color3.fromRGB(255, 255, 255),
        Gray = Color3.fromRGB(200, 200, 200),
        Bright = Color3.fromRGB(255, 255, 230),
        Clean = Color3.fromRGB(220, 240, 255)
    }

    _0xAddDropdown(_0xMiscPage, "Sky Color", _0xSkyColors, function(_0xSelected)
        local _0xSky = _0xServices[5]:FindFirstChild("NataMenu_Sky")
        local _0xCC = _0xServices[5]:FindFirstChild("NataMenu_SkyTint")
        
        if _0xSky then _0xSky:Destroy() end
        if _0xCC then _0xCC:Destroy() end

        if _0xSelected == "Default" then return end

        local _0xNewSky = Instance.new("Sky")
        _0xNewSky.Name = "NataMenu_Sky"
        _0xNewSky.Parent = _0xServices[5]
        _0xNewSky.CelestialBodiesShown = false

        local _0xNewCC = Instance.new("ColorCorrectionEffect")
        _0xNewCC.Name = "NataMenu_SkyTint"
        _0xNewCC.Parent = _0xServices[5]
        _0xNewCC.Enabled = true
        _0xNewCC.TintColor = _0xColorMap[_0xSelected]
        _0xNewCC.Brightness = -0.05
    end)

    _0xAddToggle(_0xMiscPage, "Night Mode", _0xConfig.Misc.NightMode, function(_0xV)
        _0xConfig.Misc.NightMode = _0xV
        _0xMisc:ToggleNightMode(_0xV)
    end)

    _0xAddToggle(_0xMiscPage, "Fullbright", _0xConfig.Misc.Fullbright, function(_0xV)
        _0xConfig.Misc.Fullbright = _0xV
        _0xMisc:ToggleFullbright(_0xV)
    end)

    _0xAddToggle(_0xMiscPage, "Noclip", _0xConfig.Misc.NoClip, function(_0xV)
        _0xConfig.Misc.NoClip = _0xV
        _0xMisc:ToggleNoClip(_0xV)
    end)

    _0xAddSlider(_0xMiscPage, "Walk Speed", 16, 100, _0xConfig.Misc.WalkSpeed, function(_0xV)
        _0xConfig.Misc.WalkSpeed = _0xV
        _0xMisc:SetWalkSpeed(_0xV)
    end)

    _0xAddSlider(_0xMiscPage, "Jump Power", 50, 200, _0xConfig.Misc.JumpPower, function(_0xV)
        _0xConfig.Misc.JumpPower = _0xV
        _0xMisc:SetJumpPower(_0xV)
    end)

    _0xAddToggle(_0xMiscPage, "FPS Boost", _0xConfig.Misc.FPSBoost, function(_0xV)
        _0xConfig.Misc.FPSBoost = _0xV
        _0xMisc:ToggleFPSBoost(_0xV)
    end)

    _0xAddToggle(_0xMiscPage, "Auto Click", _0xConfig.Misc.AutoClick, function(_0xV)
        _0xConfig.Misc.AutoClick = _0xV
        _0xMisc:ToggleAutoClick(_0xV)
    end)

    _0xAddToggle(_0xMiscPage, "Anti-AFK", _0xConfig.Misc.AntiAFK, function(_0xV)
        _0xConfig.Misc.AntiAFK = _0xV
        _0xMisc:ToggleAntiAFK(_0xV)
    end)

    _0xAddToggle(_0xMiscPage, "Bypass", _0xConfig.Misc.Bypass, function(_0xV)
        _0xConfig.Misc.Bypass = _0xV
        _0xMisc:ToggleBypass(_0xV)
    end)

    _0xAddButton(_0xMiscPage, "Refresh ESP", "🔄", function()
        if _0xDrawLib then
            for _, _0xDrawing in pairs(_0xESP.Drawings) do
                for _, _0xD in pairs(_0xDrawing) do
                    if _0xD then _0xD:Remove() end
                end
            end
            _0xESP.Drawings = {}
            for _, _0xP in ipairs(_0xServices[3]:GetPlayers()) do 
                _0xESP:AddPlayer(_0xP) 
            end
        end
    end)

    _0xAddButton(_0xMiscPage, "Copy Discord", "📋", function()
        pcall(function()
            setclipboard("https://discord.gg/S2uD6TXAVs")
        end)
    end)

    _0xAddButton(_0xMiscPage, "Hide Menu (F5)", "👁", function()
        _0xSG.Enabled = not _0xSG.Enabled
    end)

    _0xAddButton(_0xMiscPage, "Credits", "⭐", function()
        _0xMisc:ShowCredits()
    end)

    _0xMenu.Tabs["Aimbot"].Btn.BackgroundColor3 = _0xColors[3]
    _0xMenu.Tabs["Aimbot"].Page.Visible = true

    local _0xDragging, _0xDragStart, _0xStartPos
    _0xMain.InputBegan:Connect(function(_0xInput)
        if _0xInput.UserInputType == Enum.UserInputType.MouseButton1 then
            _0xDragging = true
            _0xDragStart = _0xInput.Position
            _0xStartPos = _0xMain.Position
        end
    end)

    _0xServices[2].InputChanged:Connect(function(_0xInput)
        if _0xDragging and _0xInput.UserInputType == Enum.UserInputType.MouseMovement then
            local _0xDelta = _0xInput.Position - _0xDragStart
            _0xMain.Position = UDim2.new(_0xStartPos.X.Scale, _0xStartPos.X.Offset + _0xDelta.X, _0xStartPos.Y.Scale, _0xStartPos.Y.Offset + _0xDelta.Y)
        end
    end)

    _0xServices[2].InputEnded:Connect(function(_0xInput)
        if _0xInput.UserInputType == Enum.UserInputType.MouseButton1 then
            _0xDragging = false
        end
    end)

    _0xServices[2].InputBegan:Connect(function(_0xInput)
        if _0xInput.KeyCode == Enum.KeyCode.F5 then
            _0xSG.Enabled = not _0xSG.Enabled
        end
    end)

    local _0xWatermark = Instance.new("ScreenGui", game:GetService("CoreGui"))
    _0xWatermark.Name = "NataMenuWatermark"
    _0xWatermark.Enabled = true
    
    local _0xWMFrame = Instance.new("Frame", _0xWatermark)
    _0xWMFrame.Size = UDim2.new(0, 160, 0, 25)
    _0xWMFrame.Position = UDim2.new(1, -165, 0, 10)
    _0xWMFrame.BackgroundColor3 = _0xColors[1]
    _0xWMFrame.BorderSizePixel = 1
    _0xWMFrame.BorderColor3 = _0xColors[6]
    
    local _0xWMLabel = Instance.new("TextLabel", _0xWMFrame)
    _0xWMLabel.Size = UDim2.new(1, 0, 1, 0)
    _0xWMLabel.Text = "NATA.MENU v2.0 | F5"
    _0xWMLabel.TextColor3 = _0xColors[5]
    _0xWMLabel.Font = Enum.Font.SourceSans
    _0xWMLabel.TextSize = 12
    _0xWMLabel.BackgroundTransparency = 1

    _0xMisc:ToggleAntiAFK(true)
    
    print("\n════════════════════════════════")
    print("   NATA.MENU PREMIUM v2.0")
    print("   🎯 Loaded Successfully!")
    print("   📢 Discord: discord.gg/S2uD6TXAVs")
    print("   👨‍🎨 Designer: Farpa")
    print("   👨‍💻 Programmer: Toque")
    print("   🎮 Enjoy your game!")
    print("════════════════════════════════\n")
end

_0xMenu:Init()
