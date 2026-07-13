-- // Встроенный Анти-АФК (Не мешает основному коду)
local VirtualUser = game:GetService("VirtualUser")
pcall(function()
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0, 0), game.Workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), game.Workspace.CurrentCamera.CFrame)
    end)
end)

local Plrs, UIS = game:GetService("Players"), game:GetService("UserInputService")
local LP = Plrs.LocalPlayer
local Tweens = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Таблицы состояний функций
local States = {
    Aimbot = false, AimAssist = false, Hitbox = false, Autogun = false,
    Tracers = false, NoSpread = false, Wallbang = false,
    Noclip = false, Fly = false, AntiFling = false, BHop = false,
    CoinFarm = false,
    FlingTarget = false,
    FlingAll = false
}
local Hitbox_Size = 5
local FOV_Radius = 100
local TargetSpeed = 16
local FlySpeed = 30
local BHopSpeed = 16
local LastHitboxSize = Hitbox_Size

-- Настройки интерфейса
local AccentColor = Color3.fromRGB(200, 0, 255)
local MenuBGColor = Color3.fromRGB(11, 7, 19)
local SidebarBGColor = Color3.fromRGB(14, 9, 26)
local ButtonBGColor = Color3.fromRGB(20, 13, 35)
local MenuKey = Enum.KeyCode.K

-- Таблицы для обновления цвета и биндов
local SliderBars = {}
local ToggleCircles = {}
local PageFrames = {}
local ButtonFrames = {}
local ToggleControls = {}
local Bindings = {}

local AvatarId = "rbxassetid://0"
pcall(function() AvatarId = Plrs:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150) end)

-- Безопасная очистка старого интерфейса
local Old = game:GetService("CoreGui"):FindFirstChild("KurindikHubUI") or LP:WaitForChild("PlayerGui"):FindFirstChild("KurindikHubUI")
if Old then Old:Destroy() end

local UI = Instance.new("ScreenGui") UI.Name = "KurindikHubUI"; UI.ResetOnSpawn = false

local function SafeParent()
    local success, _ = pcall(function()
        if gethui then UI.Parent = gethui() else UI.Parent = game:GetService("CoreGui") end
    end)
    if not success or not UI.Parent then UI.Parent = LP:WaitForChild("PlayerGui") end
end
SafeParent()

-- Увеличенный GUI
local MF = Instance.new("Frame") MF.Name = "MainFrame"
MF.Size = UDim2.new(0, 850, 0, 550)
MF.Position = UDim2.new(0.5, -425, 0.5, -275)
MF.BackgroundColor3 = MenuBGColor
MF.Active = true; MF.Draggable = true; MF.Parent = UI
Instance.new("UICorner", MF).CornerRadius = UDim.new(0, 10)

local SB = Instance.new("Frame")
SB.Size = UDim2.new(0, 230, 1, 0)
SB.BackgroundColor3 = SidebarBGColor
SB.Parent = MF
Instance.new("UICorner", SB).CornerRadius = UDim.new(0, 10)

local Div = Instance.new("Frame")
Div.Size = UDim2.new(0, 3, 0, 480)
Div.Position = UDim2.new(0, 235, 0, 20)
Div.BackgroundColor3 = AccentColor
Div.BorderSizePixel = 0; Div.Parent = MF
local Glow = Instance.new("UIStroke", Div)
Glow.Color = AccentColor:Lerp(Color3.new(1,1,1), 0.3)
Glow.Thickness = 1.5

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(0, 200, 0, 45)
Logo.Position = UDim2.new(0, 15, 0, 15)
Logo.Text = "Kurindik hub"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.TextSize = 26
Logo.Font = Enum.Font.GothamBlack
Logo.TextXAlignment = "Left"
Logo.BackgroundTransparency = 1
Logo.Parent = SB

local CreatorLabel = Instance.new("TextLabel")
CreatorLabel.Size = UDim2.new(1, -20, 0, 20)
CreatorLabel.Position = UDim2.new(0, 10, 1, -40)
CreatorLabel.Text = "Made by VintuScripts"
CreatorLabel.TextColor3 = Color3.fromRGB(180, 150, 255)
CreatorLabel.TextSize = 12
CreatorLabel.Font = Enum.Font.GothamBlack
CreatorLabel.TextXAlignment = "Center"
CreatorLabel.BackgroundTransparency = 1
CreatorLabel.Parent = SB

local CreatorCorner = Instance.new("TextLabel")
CreatorCorner.Size = UDim2.new(0, 160, 0, 20)
CreatorCorner.Position = UDim2.new(1, -170, 1, -25)
CreatorCorner.Text = "Made by @VintuScripts"
CreatorCorner.TextColor3 = Color3.fromRGB(150, 120, 200)
CreatorCorner.TextSize = 11
CreatorCorner.Font = Enum.Font.GothamBold
CreatorCorner.TextXAlignment = "Right"
CreatorCorner.BackgroundTransparency = 1
CreatorCorner.Parent = MF

local TC = Instance.new("Frame") TC.Name = "TabContainer"
TC.Size = UDim2.new(1, -20, 0, 210)
TC.Position = UDim2.new(0, 10, 0, 75)
TC.BackgroundTransparency = 1
TC.Parent = SB
local TL = Instance.new("UIListLayout", TC)
TL.Padding = UDim.new(0, 5)

local CC = Instance.new("Frame") CC.Name = "ContentContainer"
CC.Size = UDim2.new(0, 580, 0, 490)
CC.Position = UDim2.new(0, 255, 0, 20)
CC.BackgroundTransparency = 1
CC.Parent = MF

local Term = Instance.new("TextButton") Term.Name = "TerminateButton"
Term.Size = UDim2.new(1, -20, 0, 40)
Term.Position = UDim2.new(0, 10, 1, -110)
Term.BackgroundColor3 = Color3.fromRGB(45, 15, 20)
Term.Text = "   Terminate"
Term.TextColor3 = Color3.fromRGB(255, 100, 100)
Term.TextSize = 15
Term.Font = Enum.Font.GothamBlack
Term.TextXAlignment = "Left"
Term.Parent = SB
Instance.new("UICorner", Term).CornerRadius = UDim.new(0, 5)
Term.MouseButton1Click:Connect(function() UI:Destroy() end)

local PB = Instance.new("Frame")
PB.Size = UDim2.new(0, 200, 0, 50)
PB.Position = UDim2.new(0, 10, 1, -65)
PB.BackgroundColor3 = Color3.fromRGB(24, 15, 41)
PB.Parent = SB
Instance.new("UICorner", PB).CornerRadius = UDim.new(0, 6)

local PAv = Instance.new("ImageLabel")
PAv.Size = UDim2.new(0, 34, 0, 34)
PAv.Position = UDim2.new(0, 8, 0, 8)
PAv.Image = AvatarId
PAv.BackgroundTransparency = 1
PAv.Parent = PB
Instance.new("UICorner", PAv).CornerRadius = UDim.new(0, 17)

local PN = Instance.new("TextLabel")
PN.Size = UDim2.new(1, -50, 1, 0)
PN.Position = UDim2.new(0, 48, 0, 0)
PN.Text = LP.Name
PN.TextColor3 = Color3.fromRGB(255, 255, 255)
PN.TextSize = 15
PN.Font = Enum.Font.GothamBlack
PN.TextXAlignment = "Left"
PN.BackgroundTransparency = 1
PN.Parent = PB

-- Вкладки
local tabs = {"Combat", "Movement", "Misc", "Visuals", "Settings"}
local Pages = {}

for i, name in ipairs(tabs) do
    local Page = Instance.new("ScrollingFrame") Page.Name = name.."Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 4
    Page.ScrollBarImageColor3 = AccentColor
    Page.Visible = (i == 1)
    Page.AutomaticCanvasSize = "Y"
    Page.Parent = CC
    Pages[name] = Page
    table.insert(PageFrames, Page)
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)

    local Btn = Instance.new("TextButton") Btn.Name = name.."TabButton"
    Btn.Size = UDim2.new(1, 0, 0, 38)
    Btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(28, 18, 48) or Color3.fromRGB(14, 9, 26)
    Btn.BackgroundTransparency = (i == 1) and 0 or 1
    Btn.Text = "   "..name
    Btn.TextColor3 = (i == 1) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 130, 160)
    Btn.TextSize = 15
    Btn.Font = Enum.Font.GothamBlack
    Btn.TextXAlignment = "Left"
    Btn.Parent = TC
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)

    Btn.MouseButton1Click:Connect(function()
        for _, p in pairs(CC:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
        for _, b in pairs(TC:GetChildren()) do if b:IsA("TextButton") then b.BackgroundTransparency = 1; b.TextColor3 = Color3.fromRGB(140, 130, 160) end end
        Page.Visible = true
        Btn.BackgroundTransparency = 0
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Btn.BackgroundColor3 = Color3.fromRGB(28, 18, 48)
    end)
end

-- Изменено: убрано упоминание "skebob scripts"
local Ver = Instance.new("TextLabel")
Ver.Size = UDim2.new(0, 350, 0, 22)
Ver.Position = UDim2.new(0, 255, 1, -28)
Ver.Text = "Version: 1.0.0"
Ver.TextColor3 = Color3.fromRGB(110, 95, 135)
Ver.TextSize = 12
Ver.Font = Enum.Font.GothamBold
Ver.TextXAlignment = "Left"
Ver.BackgroundTransparency = 1
Ver.Parent = MF

local MOpen = true
UIS.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == MenuKey then
        MOpen = not MOpen
        MF.Visible = MOpen
    end
end)

-- Функции обновления цветов
local function UpdateAccentColor(newColor)
    AccentColor = newColor
    Div.BackgroundColor3 = newColor
    Glow.Color = newColor:Lerp(Color3.new(1,1,1), 0.3)
    for _, bar in ipairs(SliderBars) do bar.BackgroundColor3 = newColor end
    for _, circle in ipairs(ToggleCircles) do
        if circle.Parent and circle.Parent:FindFirstChild("ToggleState") and circle.Parent.ToggleState.Value then
            circle.BackgroundColor3 = newColor
        end
    end
    for _, page in ipairs(PageFrames) do page.ScrollBarImageColor3 = newColor end
end
local function UpdateButtonBGColor(newColor)
    ButtonBGColor = newColor
    for _, frame in ipairs(ButtonFrames) do
        if frame and frame.Parent then frame.BackgroundColor3 = newColor end
    end
end
local function UpdateMenuBGColor(mainColor, sidebarColor)
    MenuBGColor = mainColor; SidebarBGColor = sidebarColor
    MF.BackgroundColor3 = mainColor; SB.BackgroundColor3 = sidebarColor
end

-- Универсальное создание переключателя с кнопкой бинда и крестиком сброса (исправлено)
local function CreateBoundToggle(text, targetPage, callback, stateKey)
    local FE = Instance.new("Frame")
    FE.Size = UDim2.new(1, -10, 0, 60)
    FE.BackgroundColor3 = ButtonBGColor
    FE.Parent = targetPage
    Instance.new("UICorner", FE).CornerRadius = UDim.new(0, 6)
    table.insert(ButtonFrames, FE)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 160, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = "   "..text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 15
    Label.Font = Enum.Font.GothamBlack
    Label.TextXAlignment = "Left"
    Label.Parent = FE

    local BindBtn = Instance.new("TextButton")
    BindBtn.Size = UDim2.new(0, 75, 0, 28)
    BindBtn.Position = UDim2.new(0, 165, 0.5, -14)
    BindBtn.BackgroundColor3 = Color3.fromRGB(45, 25, 65)
    BindBtn.Text = Bindings[stateKey] and Bindings[stateKey].Name or "Bind"
    BindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    BindBtn.Font = Enum.Font.GothamBold
    BindBtn.TextSize = 14
    BindBtn.Parent = FE
    Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0, 4)

    -- ИСПРАВЛЕННАЯ КНОПКА СБРОСА
    local ClearBindBtn = Instance.new("TextButton")
    ClearBindBtn.Size = UDim2.new(0, 28, 0, 28)
    ClearBindBtn.Position = UDim2.new(0, 250, 0.5, -14)
    ClearBindBtn.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
    ClearBindBtn.Text = "✕"
    ClearBindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ClearBindBtn.Font = Enum.Font.GothamBold
    ClearBindBtn.TextSize = 18
    ClearBindBtn.Parent = FE
    Instance.new("UICorner", ClearBindBtn).CornerRadius = UDim.new(0, 6)
    ClearBindBtn.ZIndex = 10

    ClearBindBtn.MouseButton1Click:Connect(function()
        Bindings[stateKey] = nil
        BindBtn.Text = "Bind"
    end)

    local TBtn = Instance.new("TextButton")
    TBtn.Size = UDim2.new(0, 50, 0, 26)
    TBtn.Position = UDim2.new(1, -60, 0.5, -13)
    TBtn.BackgroundColor3 = Color3.fromRGB(35, 25, 55)
    TBtn.Text = ""
    TBtn.Parent = FE
    Instance.new("UICorner", TBtn).CornerRadius = UDim.new(0, 13)
    local TCir = Instance.new("Frame")
    TCir.Size = UDim2.new(0, 18, 0, 18)
    TCir.Position = UDim2.new(0, 4, 0.5, -9)
    TCir.BackgroundColor3 = Color3.fromRGB(120, 110, 140)
    TCir.Parent = TBtn
    Instance.new("UICorner", TCir).CornerRadius = UDim.new(0, 9)
    table.insert(ToggleCircles, TCir)
    local stateValue = Instance.new("BoolValue", TBtn)
    stateValue.Name = "ToggleState"
    stateValue.Value = false
    local act = false

    local function setVisual(value)
        act = value
        stateValue.Value = value
        local targetColor = value and AccentColor or Color3.fromRGB(120, 110, 140)
        Tweens:Create(TCir, TweenInfo.new(0.2), {
            Position = value and UDim2.new(0, 28, 0.5, -9) or UDim2.new(0, 4, 0.5, -9),
            BackgroundColor3 = targetColor
        }):Play()
        Tweens:Create(TBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = value and Color3.fromRGB(50, 15, 80) or Color3.fromRGB(35, 25, 55)
        }):Play()
    end

    TBtn.MouseButton1Click:Connect(function()
        local newState = not act
        setVisual(newState)
        callback(newState)
    end)

    local listening = false
    BindBtn.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true
        BindBtn.Text = "..."
        local con
        con = UIS.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.Escape then
                    Bindings[stateKey] = nil
                    BindBtn.Text = "Bind"
                else
                    Bindings[stateKey] = input.KeyCode
                    BindBtn.Text = input.KeyCode.Name
                end
                listening = false
                con:Disconnect()
            end
        end)
    end)

    ToggleControls[stateKey] = {
        SetVisual = setVisual,
        GetState = function() return act end,
        Callback = callback,
        BindButton = BindBtn
    }
end

-- Увеличенный слайдер
local function CreateNewSlider(text, min, max, default, targetPage, callback)
    local FE = Instance.new("Frame")
    FE.Size = UDim2.new(1, -10, 0, 70)
    FE.BackgroundColor3 = ButtonBGColor
    FE.Parent = targetPage
    Instance.new("UICorner", FE).CornerRadius = UDim.new(0, 6)
    table.insert(ButtonFrames, FE)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -10, 0, 28)
    Label.BackgroundTransparency = 1
    Label.Text = "   "..text
    Label.TextColor3 = Color3.fromRGB(180, 170, 200)
    Label.TextSize = 14
    Label.Font = Enum.Font.GothamBlack
    Label.TextXAlignment = "Left"
    Label.Parent = FE

    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, -30, 0, 8)
    Track.Position = UDim2.new(0, 15, 0, 42)
    Track.BackgroundColor3 = Color3.fromRGB(35, 25, 55)
    Track.Parent = FE
    Instance.new("UICorner", Track).CornerRadius = UDim.new(0, 4)

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    Bar.BackgroundColor3 = AccentColor
    Bar.Parent = Track
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(0, 4)
    table.insert(SliderBars, Bar)

    local ValL = Instance.new("TextLabel")
    ValL.Size = UDim2.new(0, 50, 0, 24)
    ValL.Position = UDim2.new(1, -55, 0, 5)
    ValL.BackgroundTransparency = 1
    ValL.Text = tostring(default)
    ValL.TextColor3 = Color3.fromRGB(255,255,255)
    ValL.Font = Enum.Font.GothamBold
    ValL.TextSize = 14
    ValL.Parent = FE

    local down = false
    local function update(input)
        local dist = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        Bar.Size = UDim2.new(dist, 0, 1, 0)
        local val = math.floor(min + (dist * (max - min)))
        ValL.Text = tostring(val)
        callback(val)
    end
    Track.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then down = true update(i) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then down = false end end)
    UIS.InputChanged:Connect(function(i) if down and i.UserInputType == Enum.UserInputType.MouseMovement then update(i) end end)
end

-- Увеличенная кнопка
local function CreateNewButton(text, color, targetPage, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 50)
    Btn.BackgroundColor3 = color
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBlack
    Btn.TextSize = 15
    Btn.Parent = targetPage
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(callback)
end

local Lighting = game:GetService("Lighting")

local function GetClosestPlayer(checkFov)
    local closest, maxDist = nil, math.huge
    local mousePos = UIS:GetMouseLocation()
    for _, p in pairs(Plrs:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                if checkFov and dist <= FOV_Radius and dist < maxDist then maxDist = dist; closest = p
                elseif not checkFov and dist < maxDist then maxDist = dist; closest = p end
            end
        end
    end
    return closest
end

-- Найти убийцу
local function GetMurderer()
    for _, p in pairs(Plrs:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then
                return p
            end
        end
    end
    return nil
end

local ESP_Objects = {}
local GunESP_Object = nil

local function CreateESP(player, color, text)
    if ESP_Objects[player] then 
        local char = player.Character
        if char and char:FindFirstChild("Head") and char.Head:FindFirstChild("KurindikText") then
            char.Head.KurindikText.TextLabel.Text = text
            char.Head.KurindikText.TextLabel.TextColor3 = color
        end
        if char and char:FindFirstChild("KurindikESP") then char.KurindikESP.FillColor = color end
        return 
    end
    local function apply()
        local char = player.Character
        if not char then return end
        local highlight = Instance.new("Highlight")
        highlight.Name = "KurindikESP"; highlight.FillColor = color; highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255); highlight.OutlineTransparency = 0
        highlight.Adornee = char; highlight.Parent = char
        local head = char:WaitForChild("Head", 5)
        if head then
            local bb = Instance.new("BillboardGui")
            bb.Name = "KurindikText"; bb.Size = UDim2.new(0, 150, 0, 30); bb.AlwaysOnTop = true; bb.StudsOffset = Vector3.new(0, 3, 0)
            local tl = Instance.new("TextLabel")
            tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1; tl.Text = text; tl.TextColor3 = color
            tl.Font = Enum.Font.GothamBold; tl.TextSize = 12; tl.Parent = bb; bb.Parent = head
        end
    end
    apply()
    local conn = player.CharacterAdded:Connect(apply)
    ESP_Objects[player] = {Connection = conn}
end

local function ClearESP()
    for player, data in pairs(ESP_Objects) do
        if data.Connection then data.Connection:Disconnect() end
        if player.Character then
            local hl = player.Character:FindFirstChild("KurindikESP")
            if hl then hl:Destroy() end
            if player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("KurindikText") then
                player.Character.Head.KurindikText:Destroy()
            end
        end
    end
    ESP_Objects = {}
end

-- ========== НАПОЛНЕНИЕ ВКЛАДОК ==========
-- Combat
CreateBoundToggle("Aimbot (Lock)", Pages.Combat, function(state) States.Aimbot = state end, "Aimbot")
CreateBoundToggle("Aim Assist (Smooth)", Pages.Combat, function(state) States.AimAssist = state end, "AimAssist")
CreateNewSlider("Aim Assist FOV Radius", 30, 300, 100, Pages.Combat, function(val) FOV_Radius = val end)
CreateBoundToggle("Hitbox Expander", Pages.Combat, function(state) States.Hitbox = state; UpdateAllHitboxes() end, "Hitbox")
CreateNewSlider("Hitbox Size Radius", 2, 500, 5, Pages.Combat, function(val) Hitbox_Size = val; if States.Hitbox and val ~= LastHitboxSize then LastHitboxSize = val; UpdateAllHitboxes() end end)
CreateNewButton("Giant Hitbox (500)", Color3.fromRGB(200, 50, 150), Pages.Combat, function()
    Hitbox_Size = 500
    if States.Hitbox then UpdateAllHitboxes() end
end)
CreateBoundToggle("Autogun (Fast Fire)", Pages.Combat, function(state) States.Autogun = state end, "Autogun")
CreateBoundToggle("No Recoil/Spread", Pages.Combat, function(state) States.NoSpread = state; ToggleNoSpread(state) end, "NoSpread")
CreateBoundToggle("Wallbang (Shoot Walls)", Pages.Combat, function(state) States.Wallbang = state end, "Wallbang")

CreateNewButton("Kill Murderer (Sheriff)", Color3.fromRGB(0, 100, 255), Pages.Combat, function()
    local myChar = LP.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    local gun = myChar:FindFirstChild("Gun") or LP.Backpack:FindFirstChild("Gun")
    if not gun then return end
    if gun.Parent == LP.Backpack then gun.Parent = myChar end
    
    local murderer = GetMurderer()
    if not murderer or not murderer.Character or not murderer.Character:FindFirstChild("Head") then return end
    
    local myHrp = myChar.HumanoidRootPart
    local targetHead = murderer.Character.Head
    
    local oldCF = myHrp.CFrame
    
    for i = 1, 3 do
        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, targetHead.Position)
        gun:Activate()
        task.wait(0.1)
    end
    
    if myHrp then
        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, targetHead.Position)
    end
end)

CreateNewButton("Murderer Kill All", Color3.fromRGB(200, 0, 50), Pages.Combat, function()
    local myChar = LP.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    local knife = myChar:FindFirstChild("Knife") or LP.Backpack:FindFirstChild("Knife")
    if not knife then return end
    if knife.Parent == LP.Backpack then knife.Parent = myChar end
    local myHrp = myChar.HumanoidRootPart
    local lobby = workspace:FindFirstChild("Lobby")
    local oldCF = myHrp.CFrame
    local myHum = myChar:FindFirstChild("Humanoid")
    if not myHum then return end
    task.spawn(function()
        for _, p in pairs(Plrs:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then
                local hum = p.Character.Humanoid
                local hrp = p.Character.HumanoidRootPart
                if hum.Health > 0 and (not lobby or not hrp:IsDescendantOf(lobby)) then
                    local startTime = tick()
                    while tick() - startTime < 0.5 and p.Character and hum.Health > 0 and myHrp and myHum.Health > 0 do
                        RunService.Heartbeat:Wait()
                        myHrp.CFrame = hrp.CFrame * CFrame.new(0, 0, 1.8)
                        myHrp.Velocity = Vector3.new(0, 0, 0)
                        knife:Activate()
                        task.wait(0.05)
                    end
                end
            end
        end
        if myHrp and myHum.Health > 0 then myHrp.CFrame = oldCF end
    end)
end)

-- Visuals
local EspEnabled = false
local GunEspEnabled = false
CreateBoundToggle("ESP Player Roles", Pages.Visuals, function(state) EspEnabled = state; if not state then ClearESP() end end, "ESP")
CreateBoundToggle("ESP Dropped Gun", Pages.Visuals, function(state) GunEspEnabled = state; if not state and GunESP_Object then GunESP_Object:Destroy(); GunESP_Object = nil end end, "GunESP")
CreateBoundToggle("Tracers (Lines)", Pages.Visuals, function(state) States.Tracers = state end, "Tracers")
CreateNewSlider("Fog End (Distance)", 50, 5000, 1000, Pages.Visuals, function(val) Lighting.FogEnd = val end)
CreateBoundToggle("Night Ambience", Pages.Visuals, function(state)
    if state then Lighting.Ambient = Color3.fromRGB(15, 15, 35); Lighting.OutdoorAmbient = Color3.fromRGB(10, 10, 25)
    else Lighting.Ambient = Color3.fromRGB(130, 130, 130); Lighting.OutdoorAmbient = Color3.fromRGB(130, 130, 130) end
end, "NightAmbience")

-- Movement
CreateNewSlider("WalkSpeed Control", 16, 120, 16, Pages.Movement, function(val) TargetSpeed = val end)
CreateBoundToggle("BunnyHop (CS 1.6)", Pages.Movement, function(state) States.BHop = state end, "BHop")
CreateBoundToggle("Noclip (Keep Floor)", Pages.Movement, function(state)
    States.Noclip = state
    if not state and LP.Character then
        -- Восстанавливаем коллизию и гравитацию при выключении ноклипа
        local hum = LP.Character:FindFirstChild("Humanoid")
        if hum then hum.PlatformStand = false end
        for _, part in ipairs(LP.Character:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end, "Noclip")
CreateBoundToggle("Fly Mode", Pages.Movement, function(state)
    States.Fly = state
    if not state and LP.Character then
        -- Восстанавливаем гравитацию при выключении полёта
        local hum = LP.Character:FindFirstChild("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end, "Fly")
CreateNewSlider("Fly Speed Control", 10, 100, 30, Pages.Movement, function(val) FlySpeed = val end)

-- Misc
CreateBoundToggle("Anti-Fling Protect", Pages.Misc, function(state) States.AntiFling = state end, "AntiFling")
CreateBoundToggle("Auto-Farm Coins", Pages.Misc, function(state) States.CoinFarm = state end, "CoinFarm")

local GunTPEnabled = false
local GunTPDelay = 1
CreateBoundToggle("Auto Teleport Gun", Pages.Misc, function(state)
    GunTPEnabled = state
    if state then
        task.spawn(function()
            while GunTPEnabled and task.wait(GunTPDelay) do
                local myChar = LP.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    local gunDrop = workspace:FindFirstChild("GunDrop") or workspace:FindFirstChild("Gun")
                    if gunDrop and gunDrop:IsA("BasePart") then
                        myChar.HumanoidRootPart.CFrame = gunDrop.CFrame * CFrame.new(0, 2, 0)
                    end
                end
            end
        end)
    end
end, "AutoTeleportGun")
CreateNewSlider("Gun TP Delay (s)", 0.5, 5, 1, Pages.Misc, function(val) GunTPDelay = val end)

-- ===== ПОЛЕ ВВОДА ДЛЯ FLING TARGET =====
local FlingInputFrame = Instance.new("Frame")
FlingInputFrame.Size = UDim2.new(1, -10, 0, 50)
FlingInputFrame.BackgroundColor3 = Color3.fromRGB(20, 13, 35)
FlingInputFrame.Parent = Pages.Misc
Instance.new("UICorner", FlingInputFrame).CornerRadius = UDim.new(0, 6)
table.insert(ButtonFrames, FlingInputFrame)

local FlingTextBox = Instance.new("TextBox")
FlingTextBox.Size = UDim2.new(1, -20, 1, 0)
FlingTextBox.Position = UDim2.new(0, 10, 0, 0)
FlingTextBox.BackgroundTransparency = 1
FlingTextBox.Text = ""
FlingTextBox.PlaceholderText = "Type player name for Fling Target..."
FlingTextBox.PlaceholderColor3 = Color3.fromRGB(110, 95, 135)
FlingTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
FlingTextBox.Font = Enum.Font.GothamBold
FlingTextBox.TextSize = 15
FlingTextBox.TextXAlignment = "Left"
FlingTextBox.Parent = FlingInputFrame

-- ===== ИСПРАВЛЕННАЯ ФУНКЦИЯ ФЛИНГА (с возможностью остановки) =====
local function FlingPlayer(target, stopCheck)
    if not target or not target.Character then
        print("FlingPlayer: target or character nil")
        return false
    end
    local targetHrp = target.Character:FindFirstChild("HumanoidRootPart")
    if not targetHrp then
        print("FlingPlayer: target has no HumanoidRootPart")
        return false
    end
    local myChar = LP.Character
    if not myChar then
        print("FlingPlayer: local player has no character")
        return false
    end
    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
    local myHum = myChar:FindFirstChild("Humanoid")
    if not myHrp or not myHum or myHum.Health <= 0 then
        print("FlingPlayer: local player invalid")
        return false
    end

    local oldCFrame = myHrp.CFrame
    -- Отключаем коллизии у себя
    for _, part in pairs(myChar:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    local endTime = tick() + 2.0
    local angle = 0
    while tick() < endTime and myChar and myHrp and targetHrp and targetHrp.Parent do
        if stopCheck and stopCheck() then
            print("Fling stopped by user")
            break
        end
        RunService.Heartbeat:Wait()
        angle = angle + 1.2
        local offset = Vector3.new(math.sin(angle) * 1.5, 0.5, math.cos(angle) * 1.5)
        myHrp.Velocity = Vector3.new(95000, 95000, 95000)
        myHrp.RotVelocity = Vector3.new(95000, 95000, 95000)
        myHrp.CFrame = CFrame.new(targetHrp.Position + offset)
    end

    -- Восстанавливаем
    if myHrp then
        myHrp.Velocity = Vector3.new(0, 0, 0)
        myHrp.RotVelocity = Vector3.new(0, 0, 0)
        myHrp.CFrame = oldCFrame
    end
    task.wait(0.1)
    return true
end

-- ===== ТУМБЛЕРЫ FLING =====
CreateBoundToggle("Fling Target", Pages.Misc, function(state)
    States.FlingTarget = state
    print("Fling Target toggled:", state)
    if state then
        task.spawn(function()
            while States.FlingTarget do
                if not States.FlingTarget then break end
                local text = FlingTextBox.Text:lower()
                local target = nil
                if text ~= "" then
                    for _, p in pairs(Plrs:GetPlayers()) do
                        if p ~= LP and p.Name:lower():sub(1, #text) == text then
                            target = p
                            break
                        end
                    end
                else
                    target = GetClosestPlayer(false)
                end
                if target then
                    print("Flinging target:", target.Name)
                    FlingPlayer(target, function() return not States.FlingTarget end)
                else
                    print("No target found for Fling Target")
                end
                task.wait(2.5)
            end
        end)
    end
end, "FlingTarget")

CreateBoundToggle("Fling All", Pages.Misc, function(state)
    States.FlingAll = state
    print("Fling All toggled:", state)
    if state then
        task.spawn(function()
            while States.FlingAll do
                if not States.FlingAll then break end
                local playersFlinged = 0
                for _, p in pairs(Plrs:GetPlayers()) do
                    if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        FlingPlayer(p, function() return not States.FlingAll end)
                        playersFlinged = playersFlinged + 1
                    end
                end
                print("Flinged", playersFlinged, "players")
                task.wait(2.5)
            end
        end)
    end
end, "FlingAll")

-- Остальные кнопки (одноразовые)
local HubBtnColor = Color3.fromRGB(35, 20, 60)
CreateNewButton("Fling Sheriff", HubBtnColor, Pages.Misc, function()
    for _, p in pairs(Plrs:GetPlayers()) do if p ~= LP and p.Character and (p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun")) then FlingPlayer(p); break end end
end)
CreateNewButton("Fling Murderer", HubBtnColor, Pages.Misc, function()
    for _, p in pairs(Plrs:GetPlayers()) do if p ~= LP and p.Character and (p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")) then FlingPlayer(p); break end end
end)

CreateNewButton("TP Map", Color3.fromRGB(55, 20, 90), Pages.Misc, function()
    TeleportToActiveMap()
end)
CreateNewButton("TP Lobby", Color3.fromRGB(25, 15, 45), Pages.Misc, function()
    local myChar = LP.Character
    if myChar and myChar:FindFirstChild("HumanoidRootPart") then
        local hrp = myChar.HumanoidRootPart
        hrp.Velocity = Vector3.new(0, 0, 0)
        hrp.RotVelocity = Vector3.new(0, 0, 0)
        local lobby = workspace:FindFirstChild("Lobby")
        if lobby then
            local lobbyParts = {}
            for _, part in pairs(lobby:GetDescendants()) do
                if part:IsA("BasePart") and part.Size.Magnitude > 5 then
                    table.insert(lobbyParts, part)
                end
            end
            if #lobbyParts > 0 then
                table.sort(lobbyParts, function(a, b) return a.Size.Magnitude > b.Size.Magnitude end)
                hrp.CFrame = lobbyParts[1].CFrame * CFrame.new(0, 5, 0)
                return
            end
        end
        hrp.CFrame = CFrame.new(-108.5, 140, -11.5)
    end
end)

-- Функция телепорта на активную карту
local function TeleportToActiveMap()
    local myChar = LP.Character
    local hrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    hrp.Velocity = Vector3.new(0, 0, 0)
    hrp.RotVelocity = Vector3.new(0, 0, 0)
    local lobby = workspace:FindFirstChild("Lobby")
    local mapParts = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Size.Magnitude > 10 then
            local isInLobby = false
            if lobby then
                local parent = obj.Parent
                while parent do
                    if parent == lobby then isInLobby = true; break end
                    parent = parent.Parent
                end
            end
            if not isInLobby then table.insert(mapParts, obj) end
        end
    end
    if #mapParts > 0 then
        table.sort(mapParts, function(a, b) return a.Size.Magnitude > b.Size.Magnitude end)
        local targetPart = mapParts[1]
        hrp.CFrame = targetPart.CFrame * CFrame.new(0, 5, 0)
        return true
    end
    hrp.CFrame = CFrame.new(0, 50, 0)
    return true
end

-- ===== ОСТАЛЬНОЙ КОД =====
local MouseDown = false
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        MouseDown = true
        while MouseDown and States.Autogun do
            local character = LP.Character
            if character then local tool = character:FindFirstChildOfClass("Tool") if tool then tool:Activate() end end
            task.wait(0.05)
        end
    end
end)
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then MouseDown = false end end)

local StatFrame = Instance.new("Frame") StatFrame.Size = UDim2.new(0, 200, 0, 80) StatFrame.Position = UDim2.new(1, -220, 0, 20)
StatFrame.BackgroundColor3 = Color3.fromRGB(14, 9, 26) StatFrame.Visible = false StatFrame.Parent = UI
Instance.new("UICorner", StatFrame).CornerRadius = UDim.new(0, 8)
local StatStroke = Instance.new("UIStroke", StatFrame) StatStroke.Color = Color3.fromRGB(200, 0, 255) StatStroke.Thickness = 1.5

local StatTitle = Instance.new("TextLabel") StatTitle.Size = UDim2.new(1, 0, 0, 25) StatTitle.Text = "📊 Coin Farm Stats"
StatTitle.TextColor3 = Color3.fromRGB(255, 255, 255) StatTitle.Font = Enum.Font.GothamBlack StatTitle.TextSize = 12 StatTitle.BackgroundTransparency = 1 StatTitle.Parent = StatFrame

local CollectedLabel = Instance.new("TextLabel") CollectedLabel.Size = UDim2.new(1, -20, 0, 20) CollectedLabel.Position = UDim2.new(0, 10, 0, 25)
CollectedLabel.Text = "Coins Collected: 0" CollectedLabel.TextColor3 = Color3.fromRGB(180, 170, 200) CollectedLabel.Font = Enum.Font.GothamBold CollectedLabel.TextSize = 11 CollectedLabel.TextXAlignment = "Left" CollectedLabel.BackgroundTransparency = 1 CollectedLabel.Parent = StatFrame

local HourlyLabel = Instance.new("TextLabel") HourlyLabel.Size = UDim2.new(1, -20, 0, 20) HourlyLabel.Position = UDim2.new(0, 10, 0, 45)
HourlyLabel.Text = "Est. Coins / Hour: 0" HourlyLabel.TextColor3 = Color3.fromRGB(0, 255, 150) HourlyLabel.Font = Enum.Font.GothamBlack HourlyLabel.TextSize = 11 HourlyLabel.TextXAlignment = "Left" HourlyLabel.BackgroundTransparency = 1 HourlyLabel.Parent = StatFrame

local TotalCollected, StartTime = 0, tick()

local function GetClosestCoin(hrp)
    local closestCoin, shortestDistance = nil, math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("TouchTransmitter") and obj.Parent then
            local p = obj.Parent
            if p.Name == "Coin" or p.Name == "Candy" or p.Name == "Snowflake" or p:FindFirstChild("CoinVisual") then
                local part = p:IsA("BasePart") and p or p:FindFirstChildByClass("BasePart")
                if part and part.Parent then
                    local distance = (hrp.Position - part.Position).Magnitude
                    if distance < shortestDistance then shortestDistance = distance; closestCoin = part end
                end
            end
        end
    end
    return closestCoin
end
LP.CharacterAdded:Connect(function(newChar)
    task.wait(1.5)
    if States.CoinFarm then TeleportToActiveMap() end
end)
task.spawn(function()
    while task.wait(0.2) do
        StatFrame.Visible = States.CoinFarm
        if States.CoinFarm then
            local myChar = LP.Character; local hrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if hrp and myChar.Humanoid.Health > 0 then
                local bag = LP.PlayerGui:FindFirstChild("MainGui") and LP.PlayerGui.MainGui:FindFirstChild("Game") and LP.PlayerGui.MainGui.Game:FindFirstChild("CoinBag")
                if bag and bag.Text:find("40/40") then States.CoinFarm = false; break end
                local targetCoin = GetClosestCoin(hrp)
                if targetCoin and States.CoinFarm and myChar.Humanoid.Health > 0 then
                    local distance = (hrp.Position - targetCoin.Position).Magnitude
                    hrp.Velocity = Vector3.new(0, 0, 0)
                    local tween = Tweens:Create(hrp, TweenInfo.new(distance / 24, Enum.EasingStyle.Linear), {CFrame = targetCoin.CFrame})
                    tween:Play() tween.Completed:Wait()
                    TotalCollected = TotalCollected + 1
                    CollectedLabel.Text = "Coins Collected: " .. tostring(TotalCollected)
                    HourlyLabel.Text = "Est. Coins / Hour: ~" .. tostring(math.floor((TotalCollected / (tick() - StartTime)) * 3600))
                    task.wait(0.22)
                end
            end
        end
    end
end)

-- NoSpread/NoRecoil
local NoSpreadConnections = {}
local function ToggleNoSpread(state)
    if state then
        for _, conn in pairs(NoSpreadConnections) do conn:Disconnect() end
        NoSpreadConnections = {}
        local function setupTool(tool)
            if tool and tool:IsA("Tool") then
                local conn = RunService.Heartbeat:Connect(function()
                    if tool.Parent and States.NoSpread then
                        pcall(function()
                            local handle = tool:FindFirstChild("Handle")
                            if handle and handle:FindFirstChild("Recoil") then handle.Recoil:Destroy() end
                        end)
                        pcall(function()
                            if tool:FindFirstChild("Recoil") then tool.Recoil:Destroy() end
                        end)
                    end
                end)
                table.insert(NoSpreadConnections, conn)
            end
        end
        if LP.Character then
            local currentTool = LP.Character:FindFirstChildOfClass("Tool")
            if currentTool then setupTool(currentTool) end
        end
        if LP.Character then
            local conn = LP.Character.ChildAdded:Connect(function(child)
                if child:IsA("Tool") then setupTool(child) end
            end)
            table.insert(NoSpreadConnections, conn)
        end
    else
        for _, conn in pairs(NoSpreadConnections) do conn:Disconnect() end
        NoSpreadConnections = {}
    end
end

-- ===== ИЗМЕНЕННАЯ МЕХАНИКА FLY И NOCLIP (без телепортации под карту) =====
RunService.Heartbeat:Connect(function()
    local myChar = LP.Character
    if not myChar then return end
    local hum = myChar:FindFirstChild("Humanoid")
    local hrp = myChar:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    -- Aimbot и Aim Assist (только при зажатой ПКМ)
    if States.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosestPlayer(false)
        if target and target.Character and target.Character:FindFirstChild("Head") then 
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Character.Head.Position) 
        end
    elseif States.AimAssist and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosestPlayer(true)
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local camCF = workspace.CurrentCamera.CFrame
            workspace.CurrentCamera.CFrame = camCF:Lerp(CFrame.new(camCF.Position, target.Character.Head.Position), 0.15)
        end
    end

    -- WalkSpeed (если не активен BHop и не CoinFarm)
    if not States.BHop and not States.CoinFarm then
        hum.WalkSpeed = TargetSpeed
    end

    -- BHop
    if States.BHop then
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            if hum.FloorMaterial ~= Enum.Material.Air then 
                hum:ChangeState(Enum.HumanoidStateType.Jumping) 
                BHopSpeed = math.clamp(BHopSpeed + 4, 16, 85) 
            end
            hrp.AssemblyLinearVelocity = Vector3.new(hum.MoveDirection.X * BHopSpeed, hrp.AssemblyLinearVelocity.Y, hum.MoveDirection.Z * BHopSpeed)
        else 
            BHopSpeed = 16 
        end
    end

    -- Noclip (свободное перемещение без гравитации и коллизий)
    if States.Noclip then
        for _, part in ipairs(myChar:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        hum.PlatformStand = true
    end

    -- Fly (управление с клавиатуры, без гравитации)
    if States.Fly then
        hum.PlatformStand = true
        local cam = workspace.CurrentCamera
        local moveDir = Vector3.new(0, 0, 0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
        if moveDir.Magnitude > 0 then
            hrp.Velocity = moveDir.Unit * FlySpeed
        else
            hrp.Velocity = Vector3.new(0, 0.1, 0) -- чтобы не падать
        end
    end

    -- CoinFarm (использует старую логику с рейкастом и телепортацией, но только если CoinFarm активен)
    if States.CoinFarm then
        -- отключаем коллизию для прохода сквозь стены
        for _, part in ipairs(myChar:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        -- Притягиваем к полу, чтобы не улететь
        local rayOrigin = hrp.Position + Vector3.new(0, 2, 0)
        local rayDirection = Vector3.new(0, -15, 0)
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.FilterDescendantsInstances = {myChar}
        local rayResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
        if rayResult then
            local floorY = rayResult.Position.Y + 3.2
            local currentY = hrp.Position.Y
            if currentY > floorY + 0.2 then
                hrp.CFrame = CFrame.new(hrp.Position.X, floorY, hrp.Position.Z)
                hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
            elseif currentY < floorY - 0.1 then
                hrp.CFrame = CFrame.new(hrp.Position.X, floorY, hrp.Position.Z)
            end
        end
        -- Оставляем PlatformStand = false, чтобы гравитация действовала
        hum.PlatformStand = false
    end

    -- Если ни один режим (Noclip, Fly, CoinFarm) не активен, восстанавливаем коллизию и гравитацию
    if not States.Noclip and not States.Fly and not States.CoinFarm then
        for _, part in ipairs(myChar:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        hum.PlatformStand = false
    end

    -- Wallbang
    if States.Wallbang then
        local bulletNames = {"Bullet", "Projectile", "PlayerProjectile", "Part", "Handle"}
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and table.find(bulletNames, obj.Name) then
                obj.CanCollide = false
                obj.Transparency = 0.5
            end
        end
    end

    -- AntiFling
    if States.AntiFling then
        for _, p in pairs(Plrs:GetPlayers()) do
            if p ~= LP and p.Character then
                for _, part in pairs(p.Character:GetChildren()) do 
                    if part:IsA("BasePart") then 
                        part.CanCollide = false 
                        part.Velocity = Vector3.new(0,0,0) 
                        part.RotVelocity = Vector3.new(0,0,0) 
                    end 
                end
            end
        end
    end
end)

-- Обновление хитбоксов
function UpdateAllHitboxes()
    for _, p in pairs(Plrs:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Head") then
            local hrp = p.Character.HumanoidRootPart
            local head = p.Character.Head
            if States.Hitbox then
                local size = Vector3.new(Hitbox_Size, Hitbox_Size, Hitbox_Size)
                hrp.Size = size
                head.Size = size
                if Hitbox_Size > 50 then
                    hrp.Transparency = 1
                    head.Transparency = 1
                else
                    hrp.Transparency = 0.7
                    head.Transparency = 0.7
                end
                hrp.Color = AccentColor
                head.Color = AccentColor
                hrp.CanCollide = false
                head.CanCollide = false
            else
                hrp.Size = Vector3.new(2, 2, 1)
                head.Size = Vector3.new(1.2, 1.2, 1.2)
                hrp.Transparency = 1
                head.Transparency = 1
                hrp.CanCollide = true
                head.CanCollide = true
            end
        end
    end
end

task.spawn(function()
    while task.wait(0.5) do
        if States.Hitbox then UpdateAllHitboxes() end
        if EspEnabled then
            for _, p in pairs(Plrs:GetPlayers()) do
                if p ~= LP and p.Character then
                    if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then 
                        CreateESP(p, Color3.fromRGB(255, 0, 0), "Murderer 🔪")
                    elseif p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then 
                        CreateESP(p, Color3.fromRGB(0, 0, 255), "Sheriff ︻╦╤─")
                    else 
                        CreateESP(p, Color3.fromRGB(0, 255, 0), "Innocent 👤") 
                    end
                end
            end
        end
        if GunEspEnabled then
            local gunDrop = workspace:FindFirstChild("GunDrop") or workspace:FindFirstChild("Gun")
            if gunDrop and gunDrop:IsA("BasePart") and not GunESP_Object then
                local bb = Instance.new("BillboardGui") bb.Name = "GunKurindikESP"; bb.Size = UDim2.new(0, 150, 0, 30); bb.AlwaysOnTop = true
                local tl = Instance.new("TextLabel") tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1; tl.Text = "🚨 GUN DROPPED 🚨"; tl.TextColor3 = Color3.fromRGB(255, 170, 0); tl.Font = Enum.Font.GothamBlack; tl.TextSize = 14; tl.Parent = bb
                bb.Parent = gunDrop; GunESP_Object = bb
            end
        end
    end
end)

workspace.DescendantAdded:Connect(function(desc)
    if States.Wallbang and desc:IsA("BasePart") then
        local bulletNames = {"Bullet", "Projectile", "PlayerProjectile", "Part", "Handle"}
        if table.find(bulletNames, desc.Name) then
            desc.CanCollide = false
            desc.Transparency = 0.5
        end
    end
end)

-- ========== НАСТРОЙКИ (Settings) ==========
local rAcc, gAcc, bAcc = 200, 0, 255
CreateNewSlider("Accent Red", 0, 255, 200, Pages.Settings, function(val) rAcc = val end)
CreateNewSlider("Accent Green", 0, 255, 0, Pages.Settings, function(val) gAcc = val end)
CreateNewSlider("Accent Blue", 0, 255, 255, Pages.Settings, function(val) bAcc = val end)
CreateNewButton("Apply Accent Color", Color3.fromRGB(80, 30, 120), Pages.Settings, function()
    UpdateAccentColor(Color3.fromRGB(rAcc, gAcc, bAcc))
end)

local rMenu, gMenu, bMenu = 11, 7, 19
local rSide, gSide, bSide = 14, 9, 26
CreateNewSlider("Menu BG Red", 0, 255, 11, Pages.Settings, function(val) rMenu = val end)
CreateNewSlider("Menu BG Green", 0, 255, 7, Pages.Settings, function(val) gMenu = val end)
CreateNewSlider("Menu BG Blue", 0, 255, 19, Pages.Settings, function(val) bMenu = val end)
CreateNewButton("Apply Menu BG", Color3.fromRGB(60, 20, 80), Pages.Settings, function()
    UpdateMenuBGColor(Color3.fromRGB(rMenu, gMenu, bMenu), Color3.fromRGB(rSide, gSide, bSide))
end)

local rBtn, gBtn, bBtn = 20, 13, 35
CreateNewSlider("Button BG Red", 0, 255, 20, Pages.Settings, function(val) rBtn = val end)
CreateNewSlider("Button BG Green", 0, 255, 13, Pages.Settings, function(val) gBtn = val end)
CreateNewSlider("Button BG Blue", 0, 255, 35, Pages.Settings, function(val) bBtn = val end)
CreateNewButton("Apply Button BG", Color3.fromRGB(70, 25, 100), Pages.Settings, function()
    UpdateButtonBGColor(Color3.fromRGB(rBtn, gBtn, bBtn))
end)

local KeybindFrame = Instance.new("Frame")
KeybindFrame.Size = UDim2.new(1, -10, 0, 50)
KeybindFrame.BackgroundColor3 = ButtonBGColor
KeybindFrame.Parent = Pages.Settings
Instance.new("UICorner", KeybindFrame).CornerRadius = UDim.new(0, 6)
table.insert(ButtonFrames, KeybindFrame)

local KeyLabel = Instance.new("TextLabel")
KeyLabel.Size = UDim2.new(1, -130, 1, 0)
KeyLabel.Position = UDim2.new(0, 10, 0, 0)
KeyLabel.BackgroundTransparency = 1
KeyLabel.Text = "   Menu Keybind"
KeyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyLabel.TextSize = 15
KeyLabel.Font = Enum.Font.GothamBlack
KeyLabel.TextXAlignment = "Left"
KeyLabel.Parent = KeybindFrame

local KeybindButton = Instance.new("TextButton")
KeybindButton.Size = UDim2.new(0, 100, 0, 28)
KeybindButton.Position = UDim2.new(1, -115, 0.5, -14)
KeybindButton.BackgroundColor3 = Color3.fromRGB(45, 25, 65)
KeybindButton.Text = MenuKey.Name
KeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
KeybindButton.Font = Enum.Font.GothamBold
KeybindButton.TextSize = 14
KeybindButton.Parent = KeybindFrame
Instance.new("UICorner", KeybindButton).CornerRadius = UDim.new(0, 5)

local listeningMenu = false
KeybindButton.MouseButton1Click:Connect(function()
    if listeningMenu then return end
    listeningMenu = true
    KeybindButton.Text = "..."
    local con
    con = UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            MenuKey = input.KeyCode
            KeybindButton.Text = input.KeyCode.Name
            listeningMenu = false
            con:Disconnect()
        end
    end)
end)

-- ========== БИНДЫ – глобальный обработчик ==========
local function ToggleFunction(stateKey)
    local control = ToggleControls[stateKey]
    if not control then
        if stateKey == "ESP" then
            EspEnabled = not EspEnabled
            if not EspEnabled then ClearESP() end
        elseif stateKey == "GunESP" then
            GunEspEnabled = not GunEspEnabled
            if not GunEspEnabled and GunESP_Object then
                GunESP_Object:Destroy()
                GunESP_Object = nil
            end
        elseif stateKey == "NightAmbience" then
            if Lighting.Ambient == Color3.fromRGB(15, 15, 35) then
                Lighting.Ambient = Color3.fromRGB(130, 130, 130)
                Lighting.OutdoorAmbient = Color3.fromRGB(130, 130, 130)
            else
                Lighting.Ambient = Color3.fromRGB(15, 15, 35)
                Lighting.OutdoorAmbient = Color3.fromRGB(10, 10, 25)
            end
        else
            States[stateKey] = not States[stateKey]
            if stateKey == "Noclip" and not States.Noclip and LP.Character then
                local hum = LP.Character:FindFirstChild("Humanoid")
                if hum then hum.PlatformStand = false end
                for _, part in ipairs(LP.Character:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
            elseif stateKey == "Fly" and not States.Fly and LP.Character then
                local hum = LP.Character:FindFirstChild("Humanoid")
                if hum then hum.PlatformStand = false end
            elseif stateKey == "Hitbox" then
                UpdateAllHitboxes()
            elseif stateKey == "AutoTeleportGun" then
                GunTPEnabled = not GunTPEnabled
                if GunTPEnabled then
                    task.spawn(function()
                        while GunTPEnabled and task.wait(GunTPDelay) do
                            local myChar = LP.Character
                            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                                local gunDrop = workspace:FindFirstChild("GunDrop") or workspace:FindFirstChild("Gun")
                                if gunDrop and gunDrop:IsA("BasePart") then
                                    myChar.HumanoidRootPart.CFrame = gunDrop.CFrame * CFrame.new(0, 2, 0)
                                end
                            end
                        end
                    end)
                end
            end
        end
        return
    end
    local newState = not control.GetState()
    control.SetVisual(newState)
    control.Callback(newState)
end

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        for stateKey, key in pairs(Bindings) do
            if key == input.KeyCode then
                ToggleFunction(stateKey)
                break
            end
        end
    end
end)
