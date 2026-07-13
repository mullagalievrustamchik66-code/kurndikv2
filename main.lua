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
local States = { Aimbot = false, AimAssist = false, Hitbox = false, Autogun = false, Tracers = false, NoSpread = false, Wallbang = false, Noclip = false, Fly = false, AntiFling = false, BHop = false, CoinFarm = false }
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
local ToggleControls = {} -- [stateKey] = {SetVisual, GetState, Callback, BindButton}
local Bindings = {}      -- [stateKey] = Enum.KeyCode (или nil)

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

local MF = Instance.new("Frame") MF.Name = "MainFrame" MF.Size = UDim2.new(0, 720, 0, 450) 
MF.Position = UDim2.new(0.5, -360, 0.5, -225) MF.BackgroundColor3 = MenuBGColor 
MF.Active = true; MF.Draggable = true; MF.Parent = UI
Instance.new("UICorner", MF).CornerRadius = UDim.new(0, 10)

local SB = Instance.new("Frame") SB.Size = UDim2.new(0, 200, 1, 0) SB.BackgroundColor3 = SidebarBGColor SB.Parent = MF
Instance.new("UICorner", SB).CornerRadius = UDim.new(0, 10)

local Div = Instance.new("Frame") Div.Size = UDim2.new(0, 3, 0, 410) Div.Position = UDim2.new(0, 205, 0, 20)
Div.BackgroundColor3 = AccentColor Div.BorderSizePixel = 0; Div.Parent = MF
local Glow = Instance.new("UIStroke", Div) Glow.Color = AccentColor:Lerp(Color3.new(1,1,1), 0.3) Glow.Thickness = 1.5
local Logo = Instance.new("TextLabel") Logo.Size = UDim2.new(0, 180, 0, 40) Logo.Position = UDim2.new(0, 15, 0, 15)
Logo.Text = "Kurindik hub" Logo.TextColor3 = Color3.fromRGB(255, 255, 255) Logo.TextSize = 22
Logo.Font = Enum.Font.GothamBlack; Logo.TextXAlignment = "Left"; Logo.BackgroundTransparency = 1; Logo.Parent = SB

-- Made by @VintuScripts в боковой панели
local CreatorLabel = Instance.new("TextLabel")
CreatorLabel.Size = UDim2.new(1, -20, 0, 20)
CreatorLabel.Position = UDim2.new(0, 10, 1, -40)
CreatorLabel.Text = "Made by VintuScripts"
CreatorLabel.TextColor3 = Color3.fromRGB(180, 150, 255)
CreatorLabel.TextSize = 11
CreatorLabel.Font = Enum.Font.GothamBold
CreatorLabel.TextXAlignment = "Center"
CreatorLabel.BackgroundTransparency = 1
CreatorLabel.Parent = SB

-- Made by @VintuScripts в правом нижнем углу
local CreatorCorner = Instance.new("TextLabel")
CreatorCorner.Size = UDim2.new(0, 140, 0, 18)
CreatorCorner.Position = UDim2.new(1, -150, 1, -25)
CreatorCorner.Text = "Made by @VintuScripts"
CreatorCorner.TextColor3 = Color3.fromRGB(150, 120, 200)
CreatorCorner.TextSize = 10
CreatorCorner.Font = Enum.Font.GothamBold
CreatorCorner.TextXAlignment = "Right"
CreatorCorner.BackgroundTransparency = 1
CreatorCorner.Parent = MF

local TC = Instance.new("Frame") TC.Name = "TabContainer" TC.Size = UDim2.new(1, -20, 0, 190) TC.Position = UDim2.new(0, 10, 0, 70)
TC.BackgroundTransparency = 1; TC.Parent = SB
local TL = Instance.new("UIListLayout", TC) TL.Padding = UDim.new(0, 5)

local CC = Instance.new("Frame") CC.Name = "ContentContainer" CC.Size = UDim2.new(0, 480, 0, 390) 
CC.Position = UDim2.new(0, 225, 0, 20) CC.BackgroundTransparency = 1; CC.Parent = MF

local Term = Instance.new("TextButton") Term.Name = "TerminateButton" Term.Size = UDim2.new(1, -20, 0, 34) 
Term.Position = UDim2.new(0, 10, 1, -100) Term.BackgroundColor3 = Color3.fromRGB(45, 15, 20)
Term.Text = "   Terminate" Term.TextColor3 = Color3.fromRGB(255, 100, 100) Term.TextSize = 13
Term.Font = Enum.Font.GothamBlack; Term.TextXAlignment = "Left"; Term.Parent = SB
Instance.new("UICorner", Term).CornerRadius = UDim.new(0, 5)
Term.MouseButton1Click:Connect(function() UI:Destroy() end)

local PB = Instance.new("Frame") PB.Size = UDim2.new(0, 180, 0, 46) PB.Position = UDim2.new(0, 10, 1, -60)
PB.BackgroundColor3 = Color3.fromRGB(24, 15, 41) PB.Parent = SB
Instance.new("UICorner", PB).CornerRadius = UDim.new(0, 6)

local PAv = Instance.new("ImageLabel") PAv.Size = UDim2.new(0, 32, 0, 32) PAv.Position = UDim2.new(0, 8, 0, 7)
PAv.Image = AvatarId; PAv.BackgroundTransparency = 1; PAv.Parent = PB
Instance.new("UICorner", PAv).CornerRadius = UDim.new(0, 16)

local PN = Instance.new("TextLabel") PN.Size = UDim2.new(1, -50, 1, 0) PN.Position = UDim2.new(0, 46, 0, 0)
PN.Text = LP.Name; PN.TextColor3 = Color3.fromRGB(255, 255, 255) PN.TextSize = 13
PN.Font = Enum.Font.GothamBlack; PN.TextXAlignment = "Left"; PN.BackgroundTransparency = 1; PN.Parent = PB

local tabs = {"Combat", "Movement", "Misc", "Visuals", "Settings"}
local Pages = {}

for i, name in ipairs(tabs) do
    local Page = Instance.new("ScrollingFrame") Page.Name = name.."Page" Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1; Page.BorderSizePixel = 0; Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = AccentColor Page.Visible = (i == 1)
    Page.AutomaticCanvasSize = "Y"; Page.Parent = CC
    Pages[name] = Page
    table.insert(PageFrames, Page)
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)

    local Btn = Instance.new("TextButton") Btn.Name = name.."TabButton" Btn.Size = UDim2.new(1, 0, 0, 34)
    Btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(28, 18, 48) or Color3.fromRGB(14, 9, 26)
    Btn.BackgroundTransparency = (i == 1) and 0 or 1
    Btn.Text = "   "..name
    Btn.TextColor3 = (i == 1) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 130, 160)
    Btn.TextSize = 13; Btn.Font = Enum.Font.GothamBlack; Btn.TextXAlignment = "Left"; Btn.Parent = TC
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)

    Btn.MouseButton1Click:Connect(function()
        for _, p in pairs(CC:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
        for _, b in pairs(TC:GetChildren()) do if b:IsA("TextButton") then b.BackgroundTransparency = 1; b.TextColor3 = Color3.fromRGB(140, 130, 160) end end
        Page.Visible = true; Btn.BackgroundTransparency = 0; Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Btn.BackgroundColor3 = Color3.fromRGB(28, 18, 48)
    end)
end
local Ver = Instance.new("TextLabel") Ver.Size = UDim2.new(0, 300, 0, 20) Ver.Position = UDim2.new(0, 225, 1, -25)
Ver.Text = "Version: 1.0.0 - Develop by skebob scripts" Ver.TextColor3 = Color3.fromRGB(110, 95, 135)
Ver.TextSize = 11; Ver.Font = Enum.Font.GothamBold; Ver.TextXAlignment = "Left"; Ver.BackgroundTransparency = 1; Parent = MF

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

-- Универсальное создание переключателя с кнопкой бинда и крестиком сброса
local function CreateBoundToggle(text, targetPage, callback, stateKey)
    local FE = Instance.new("Frame") FE.Size = UDim2.new(1, -10, 0, 46) FE.BackgroundColor3 = ButtonBGColor FE.Parent = targetPage
    Instance.new("UICorner", FE).CornerRadius = UDim.new(0, 6)
    table.insert(ButtonFrames, FE)

    -- Название (левая часть)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 130, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = "   "..text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 13
    Label.Font = Enum.Font.GothamBlack
    Label.TextXAlignment = "Left"
    Label.Parent = FE

    -- Кнопка бинда (чуть правее названия)
    local BindBtn = Instance.new("TextButton")
    BindBtn.Size = UDim2.new(0, 55, 0, 20)
    BindBtn.Position = UDim2.new(0, 135, 0.5, -10)
    BindBtn.BackgroundColor3 = Color3.fromRGB(45, 25, 65)
    BindBtn.Text = Bindings[stateKey] and Bindings[stateKey].Name or "Bind"
    BindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    BindBtn.Font = Enum.Font.GothamBold
    BindBtn.TextSize = 10
    BindBtn.Parent = FE
    Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0, 4)

    -- Кнопка сброса (крестик) рядом
    local ClearBindBtn = Instance.new("TextButton")
    ClearBindBtn.Size = UDim2.new(0, 18, 0, 18)
    ClearBindBtn.Position = UDim2.new(0, 193, 0.5, -9)  -- сразу за BindBtn
    ClearBindBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
    ClearBindBtn.Text = "✕"
    ClearBindBtn.TextColor3 = Color3.fromRGB(255, 200, 200)
    ClearBindBtn.Font = Enum.Font.GothamBold
    ClearBindBtn.TextSize = 12
    ClearBindBtn.Parent = FE
    Instance.new("UICorner", ClearBindBtn).CornerRadius = UDim.new(0, 4)

    ClearBindBtn.MouseButton1Click:Connect(function()
        Bindings[stateKey] = nil
        BindBtn.Text = "Bind"
    end)

    -- Переключатель (правая часть)
    local TBtn = Instance.new("TextButton")
    TBtn.Size = UDim2.new(0, 40, 0, 20)
    TBtn.Position = UDim2.new(1, -55, 0.5, -10)
    TBtn.BackgroundColor3 = Color3.fromRGB(35, 25, 55)
    TBtn.Text = ""
    TBtn.Parent = FE
    Instance.new("UICorner", TBtn).CornerRadius = UDim.new(0, 10)
    local TCir = Instance.new("Frame")
    TCir.Size = UDim2.new(0, 14, 0, 14)
    TCir.Position = UDim2.new(0, 3, 0.5, -7)
    TCir.BackgroundColor3 = Color3.fromRGB(120, 110, 140)
    TCir.Parent = TBtn
    Instance.new("UICorner", TCir).CornerRadius = UDim.new(0, 7)
    table.insert(ToggleCircles, TCir)
    local stateValue = Instance.new("BoolValue", TBtn)
    stateValue.Name = "ToggleState"
    stateValue.Value = false
    local act = false

    -- Функция установки визуального состояния
    local function setVisual(value)
        act = value
        stateValue.Value = value
        local targetColor = value and AccentColor or Color3.fromRGB(120, 110, 140)
        Tweens:Create(TCir, TweenInfo.new(0.2), {
            Position = value and UDim2.new(0, 23, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
            BackgroundColor3 = targetColor
        }):Play()
        Tweens:Create(TBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = value and Color3.fromRGB(50, 15, 80) or Color3.fromRGB(35, 25, 55)
        }):Play()
    end

    -- Клик по переключателю
    TBtn.MouseButton1Click:Connect(function()
        local newState = not act
        setVisual(newState)
        callback(newState)
    end)

    -- Назначение бинда через кнопку BindBtn
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
                    -- Сброс бинда при нажатии Escape
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

    -- Сохраняем контрол для внешнего управления
    ToggleControls[stateKey] = {
        SetVisual = setVisual,
        GetState = function() return act end,
        Callback = callback,
        BindButton = BindBtn
    }
end

-- Обычные слайдеры и кнопки (без изменений)
local function CreateNewSlider(text, min, max, default, targetPage, callback)
    local FE = Instance.new("Frame") FE.Size = UDim2.new(1, -10, 0, 55) FE.BackgroundColor3 = ButtonBGColor FE.Parent = targetPage
    Instance.new("UICorner", FE).CornerRadius = UDim.new(0, 6)
    table.insert(ButtonFrames, FE)
    local Label = Instance.new("TextLabel") Label.Size = UDim2.new(1, -10, 0, 25) Label.BackgroundTransparency = 1 Label.Text = "   "..text
    Label.TextColor3 = Color3.fromRGB(180, 170, 200) Label.TextSize = 12 Label.Font = Enum.Font.GothamBlack Label.TextXAlignment = "Left" Label.Parent = FE
    local Track = Instance.new("Frame") Track.Size = UDim2.new(1, -30, 0, 6) Track.Position = UDim2.new(0, 15, 0, 35) Track.BackgroundColor3 = Color3.fromRGB(35, 25, 55) Track.Parent = FE
    Instance.new("UICorner", Track).CornerRadius = UDim.new(0, 3)
    local Bar = Instance.new("Frame") Bar.Size = UDim2.new((default-min)/(max-min), 0, 1, 0) Bar.BackgroundColor3 = AccentColor Bar.Parent = Track
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(0, 3)
    table.insert(SliderBars, Bar)
    local ValL = Instance.new("TextLabel") ValL.Size = UDim2.new(0, 40, 0, 20) ValL.Position = UDim2.new(1, -45, 0, 5) ValL.BackgroundTransparency = 1 ValL.Text = tostring(default) ValL.TextColor3 = Color3.fromRGB(255,255,255) ValL.Font = Enum.Font.GothamBold ValL.TextSize = 11 ValL.Parent = FE
    local down = false
    local function update(input)
        local dist = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        Bar.Size = UDim2.new(dist, 0, 1, 0)
        local val = math.floor(min + (dist * (max - min)))
        ValL.Text = tostring(val) callback(val)
    end
    Track.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then down = true update(i) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then down = false end end)
    UIS.InputChanged:Connect(function(i) if down and i.UserInputType == Enum.UserInputType.MouseMovement then update(i) end end)
end

local function CreateNewButton(text, color, targetPage, callback)
    local Btn = Instance.new("TextButton") Btn.Size = UDim2.new(1, -10, 0, 40) Btn.BackgroundColor3 = color Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255) Btn.Font = Enum.Font.GothamBlack Btn.TextSize = 13 Btn.Parent = targetPage
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
CreateBoundToggle("No Spread (No Recoil)", Pages.Combat, function(state) States.NoSpread = state end, "NoSpread")
CreateBoundToggle("Wallbang (Shoot Walls)", Pages.Combat, function(state) States.Wallbang = state end, "Wallbang")
CreateNewButton("Murderer Kill All", Color3.fromRGB(200, 0, 50), Pages.Combat, function()
    local myChar = LP.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    local knife = myChar:FindFirstChild("Knife") or LP.Backpack:FindFirstChild("Knife")
    if not knife then return end
    if knife.Parent == LP.Backpack then knife.Parent = myChar end
    local myHrp = myChar.HumanoidRootPart
    local lobbyPos = Vector3.new(-108.5, 140, -11.5)
    local oldCF = myHrp.CFrame
    local myHum = myChar:FindFirstChild("Humanoid")
    if not myHum then return end
    task.spawn(function()
        for _, p in pairs(Plrs:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then
                local hum = p.Character.Humanoid
                local hrp = p.Character.HumanoidRootPart
                if hum.Health > 0 and (hrp.Position - lobbyPos).Magnitude > 50 then
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
        for _, part in ipairs(LP.Character:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end, "Noclip")
CreateBoundToggle("Fly Mode", Pages.Movement, function(state) States.Fly = state end, "Fly")
CreateNewSlider("Fly Speed Control", 10, 100, 30, Pages.Movement, function(val) FlySpeed = val end)

-- Misc
CreateBoundToggle("Anti-Fling Protect", Pages.Misc, function(state) States.AntiFling = state end, "AntiFling")
CreateBoundToggle("Auto-Farm Coins", Pages.Misc, function(state) States.CoinFarm = state end, "CoinFarm")

-- Auto Teleport Gun (переключатель с слайдером)
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

local function FlingPlayer(target)
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
    local myChar = LP.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") or not myChar:FindFirstChild("Humanoid") then return end
    local myHrp = myChar.HumanoidRootPart
    local targetHrp = target.Character.HumanoidRootPart
    local oldCFrame = myHrp.CFrame
    for _, part in pairs(myChar:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = false end end
    local endTime = tick() + 2.0
    local angle = 0
    while tick() < endTime and myChar and myHrp and targetHrp and targetHrp.Parent do
        RunService.Heartbeat:Wait()
        angle = angle + 1.2
        local offset = Vector3.new(math.sin(angle) * 1.3, 0.3, math.cos(angle) * 1.3)
        myHrp.Velocity = Vector3.new(95000, 95000, 95000)
        myHrp.RotVelocity = Vector3.new(95000, 95000, 95000)
        myHrp.CFrame = CFrame.new(targetHrp.Position + offset)
    end
    if myHrp then myHrp.Velocity = Vector3.new(0, 0, 0) myHrp.RotVelocity = Vector3.new(0, 0, 0) myHrp.CFrame = oldCFrame end
    task.wait(0.1)
end

local FlingInputFrame = Instance.new("Frame")
FlingInputFrame.Size = UDim2.new(1, -10, 0, 40); FlingInputFrame.BackgroundColor3 = Color3.fromRGB(20, 13, 35); FlingInputFrame.Parent = Pages.Misc
Instance.new("UICorner", FlingInputFrame).CornerRadius = UDim.new(0, 6)
table.insert(ButtonFrames, FlingInputFrame)

local FlingTextBox = Instance.new("TextBox")
FlingTextBox.Size = UDim2.new(1, -20, 1, 0); FlingTextBox.Position = UDim2.new(0, 10, 0, 0); FlingTextBox.BackgroundTransparency = 1; FlingTextBox.Text = ""
FlingTextBox.PlaceholderText = "Type player name for Fling Target..."; FlingTextBox.PlaceholderColor3 = Color3.fromRGB(110, 95, 135)
FlingTextBox.TextColor3 = Color3.fromRGB(255, 255, 255); FlingTextBox.Font = Enum.Font.GothamBold; FlingTextBox.TextSize = 13; FlingTextBox.TextXAlignment = "Left"; FlingTextBox.Parent = FlingInputFrame
local HubBtnColor = Color3.fromRGB(35, 20, 60)

local function TeleportToActiveMap()
    local myChar = LP.Character
    local hrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    hrp.Velocity = Vector3.new(0, 0, 0)
    hrp.RotVelocity = Vector3.new(0, 0, 0)
    local lobbyPos = Vector3.new(-108.5, 140, -11.5)
    local function isInLobby(obj) return obj and (obj.Position - lobbyPos).Magnitude < 80 end
    for _, folderName in pairs({"Normal", "Map", "CurrentMap"}) do
        local mapFolder = workspace:FindFirstChild(folderName)
        if mapFolder and not isInLobby(mapFolder) then
            for _, part in pairs(mapFolder:GetDescendants()) do
                if part:IsA("SpawnLocation") then
                    hrp.CFrame = part.CFrame * CFrame.new(0, 4, 0)
                    return true
                end
            end
        end
    end
    for _, spawn in pairs(workspace:GetDescendants()) do
        if spawn:IsA("SpawnLocation") and not isInLobby(spawn) then
            hrp.CFrame = spawn.CFrame * CFrame.new(0, 4, 0)
            return true
        end
    end
    hrp.CFrame = CFrame.new(0, 20, 0)
    return true
end

CreateNewButton("Fling Target", HubBtnColor, Pages.Misc, function()
    local text = FlingTextBox.Text:lower()
    local target = nil
    if text ~= "" then
        for _, p in pairs(Plrs:GetPlayers()) do if p ~= LP and p.Name:lower():sub(1, #text) == text then target = p; break end end
    else target = GetClosestPlayer(false) end
    if target then FlingPlayer(target) end
end)

CreateNewButton("Fling All", HubBtnColor, Pages.Misc, function()
    task.spawn(function() for _, p in pairs(Plrs:GetPlayers()) do if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then FlingPlayer(p) end end end)
end)

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
        hrp.CFrame = CFrame.new(-108.5, 140, -11.5)
    end
end)

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

RunService.Heartbeat:Connect(function()
    local myChar = LP.Character if not myChar then return end
    if States.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosestPlayer(false)
        if target and target.Character and target.Character:FindFirstChild("Head") then workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Character.Head.Position) end
    elseif States.AimAssist then
        local target = GetClosestPlayer(true)
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local camCF = workspace.CurrentCamera.CFrame; workspace.CurrentCamera.CFrame = camCF:Lerp(CFrame.new(camCF.Position, target.Character.Head.Position), 0.15)
        end
    end
    if myChar:FindFirstChild("Humanoid") and TargetSpeed ~= 16 and not States.BHop and not States.CoinFarm then
        myChar.Humanoid.WalkSpeed = TargetSpeed
        if myChar:FindFirstChild("HumanoidRootPart") then myChar.HumanoidRootPart.AssemblyLinearVelocity = myChar.Humanoid.MoveDirection * TargetSpeed end
    end
    if States.BHop and myChar:FindFirstChild("Humanoid") and myChar:FindFirstChild("HumanoidRootPart") then
        local hum = myChar.Humanoid; local hrp = myChar.HumanoidRootPart
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            if hum.FloorMaterial ~= Enum.Material.Air then hum:ChangeState(Enum.HumanoidStateType.Jumping) BHopSpeed = math.clamp(BHopSpeed + 4, 16, 85) end
            hrp.AssemblyLinearVelocity = Vector3.new(hum.MoveDirection.X * BHopSpeed, hrp.AssemblyLinearVelocity.Y, hum.MoveDirection.Z * BHopSpeed)
        else BHopSpeed = 16 end
    end

    if States.Noclip or States.CoinFarm then
        local hrp = myChar:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, part in ipairs(myChar:GetChildren()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
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
        end
    end

    if States.Fly and myChar:FindFirstChild("HumanoidRootPart") then
        local hrp = myChar.HumanoidRootPart; local cam = workspace.CurrentCamera; local moveDir = Vector3.new(0, 0, 0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
        hrp.Velocity = moveDir.Unit * (moveDir.Magnitude > 0 and FlySpeed or 0)
        if moveDir.Magnitude == 0 then hrp.Velocity = Vector3.new(0, 0.1, 0) end
    end
    if States.NoSpread then
        local tool = myChar:FindFirstChild("Tool") or myChar:FindFirstChildOfClass("Tool")
        if tool and (tool:FindFirstChild("KnifeLocal") or tool:FindFirstChild("GunLocal")) then
            local client = tool:FindFirstChildOfClass("LocalScript")
            if client then local env = getsenv(client); if env and env.Spread then env.Spread = 0 end end
        end
    end
    if States.Wallbang then
        local bulletNames = {"Bullet", "Projectile", "PlayerProjectile", "Part", "Handle"}
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and table.find(bulletNames, obj.Name) then
                obj.CanCollide = false
                obj.Transparency = 0.5
            end
        end
    end
    if States.AntiFling then
        for _, p in pairs(Plrs:GetPlayers()) do
            if p ~= LP and p.Character then
                for _, part in pairs(p.Character:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = false part.Velocity = Vector3.new(0,0,0) part.RotVelocity = Vector3.new(0,0,0) end end
            end
        end
    end
end)

function UpdateAllHitboxes()
    for _, p in pairs(Plrs:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Head") then
            local hrp = p.Character.HumanoidRootPart
            local head = p.Character.Head
            if States.Hitbox then
                local size = Vector3.new(Hitbox_Size, Hitbox_Size, Hitbox_Size)
                hrp.Size = size
                head.Size = size
                local transparency = Hitbox_Size > 50 and 1 or 0.7
                hrp.Transparency = transparency
                head.Transparency = transparency
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
                    if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then CreateESP(p, Color3.fromRGB(255, 0, 0), "Murderer 🔪")
                    elseif p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then CreateESP(p, Color3.fromRGB(0, 0, 255), "Sheriff ︻╦╤─")
                    else CreateESP(p, Color3.fromRGB(0, 255, 0), "Innocent 👤") end
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
-- Цвет акцента
local rAcc, gAcc, bAcc = 200, 0, 255
CreateNewSlider("Accent Red", 0, 255, 200, Pages.Settings, function(val) rAcc = val end)
CreateNewSlider("Accent Green", 0, 255, 0, Pages.Settings, function(val) gAcc = val end)
CreateNewSlider("Accent Blue", 0, 255, 255, Pages.Settings, function(val) bAcc = val end)
CreateNewButton("Apply Accent Color", Color3.fromRGB(80, 30, 120), Pages.Settings, function()
    UpdateAccentColor(Color3.fromRGB(rAcc, gAcc, bAcc))
end)

-- Фон меню
local rMenu, gMenu, bMenu = 11, 7, 19
local rSide, gSide, bSide = 14, 9, 26
CreateNewSlider("Menu BG Red", 0, 255, 11, Pages.Settings, function(val) rMenu = val end)
CreateNewSlider("Menu BG Green", 0, 255, 7, Pages.Settings, function(val) gMenu = val end)
CreateNewSlider("Menu BG Blue", 0, 255, 19, Pages.Settings, function(val) bMenu = val end)
CreateNewButton("Apply Menu BG", Color3.fromRGB(60, 20, 80), Pages.Settings, function()
    UpdateMenuBGColor(Color3.fromRGB(rMenu, gMenu, bMenu), Color3.fromRGB(rSide, gSide, bSide))
end)

-- Фон кнопок
local rBtn, gBtn, bBtn = 20, 13, 35
CreateNewSlider("Button BG Red", 0, 255, 20, Pages.Settings, function(val) rBtn = val end)
CreateNewSlider("Button BG Green", 0, 255, 13, Pages.Settings, function(val) gBtn = val end)
CreateNewSlider("Button BG Blue", 0, 255, 35, Pages.Settings, function(val) bBtn = val end)
CreateNewButton("Apply Button BG", Color3.fromRGB(70, 25, 100), Pages.Settings, function()
    UpdateButtonBGColor(Color3.fromRGB(rBtn, gBtn, bBtn))
end)

-- Клавиша меню
local KeybindFrame = Instance.new("Frame")
KeybindFrame.Size = UDim2.new(1, -10, 0, 46)
KeybindFrame.BackgroundColor3 = ButtonBGColor
KeybindFrame.Parent = Pages.Settings
Instance.new("UICorner", KeybindFrame).CornerRadius = UDim.new(0, 6)
table.insert(ButtonFrames, KeybindFrame)

local KeyLabel = Instance.new("TextLabel")
KeyLabel.Size = UDim2.new(1, -120, 1, 0)
KeyLabel.Position = UDim2.new(0, 10, 0, 0)
KeyLabel.BackgroundTransparency = 1
KeyLabel.Text = "   Menu Keybind"
KeyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyLabel.TextSize = 13
KeyLabel.Font = Enum.Font.GothamBlack
KeyLabel.TextXAlignment = "Left"
KeyLabel.Parent = KeybindFrame

local KeybindButton = Instance.new("TextButton")
KeybindButton.Size = UDim2.new(0, 90, 0, 24)
KeybindButton.Position = UDim2.new(1, -105, 0.5, -12)
KeybindButton.BackgroundColor3 = Color3.fromRGB(45, 25, 65)
KeybindButton.Text = MenuKey.Name
KeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
KeybindButton.Font = Enum.Font.GothamBold
KeybindButton.TextSize = 12
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
        -- Fallback для функций без GUI
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
                for _, part in ipairs(LP.Character:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
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
