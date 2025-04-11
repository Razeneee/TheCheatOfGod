local theScriptOfGod = {
	esp = {
		CharacterSize = Vector2.new(5,6);
		Box = {
			TeamCheck = false;
			Box = false;
			Name = false;
			Distance = false;
            BoxTransparency = 1;
			Color = Color3.fromRGB(255, 255, 255);
			Outline = false;
			OutlineColor = Color3.fromRGB(0,0,0);
		};

		Tracer = {
			TeamCheck = false;
			TeamColor = false;
			Tracer = false;
			Color = Color3.fromRGB(255, 255, 255);
			Outline = false;
			OutlineColor = Color3.fromRGB(0, 0, 0);
		};

		Highlights = {
			TeamCheck = false;
			Highlights = false;
			AllWaysVisible = false;
			OutlineTransparency = 0.5;
			FillTransparency = 0.5;
			OutlineColor = Color3.fromRGB(255, 0, 0);
			FillColor = Color3.fromRGB(255, 255, 255);
		};
	};
}

local players = game.Players;
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local CurrentCamera = workspace.CurrentCamera
local localPlayer = Players.LocalPlayer

local ESPHolder = Instance.new("Folder", CoreGui)
ESPHolder.Name = "ESPHolder"

local function IsAlive(Player)
    local character = Player and Player.Character
    local worldCharacter = character and character:FindFirstChild("WorldCharacter")
    return worldCharacter and worldCharacter:FindFirstChild("UpperTorso") ~= nil
end

local function GetTeam(Player)
    return Player and Player.Team
end

local function LoadESP(Player)
    local PlayerESP = Instance.new("Folder", ESPHolder)
    PlayerESP.Name = Player.Name .. "ESP"

    -- Box
    local BoxHolder = Instance.new("ScreenGui", PlayerESP)
    BoxHolder.Name = "Box"
    BoxHolder.DisplayOrder = 2

    local TracerHolder = Instance.new("ScreenGui", PlayerESP)
    TracerHolder.Name = "Tracer"

    local HilightHolder = Instance.new("Folder", PlayerESP)
    HilightHolder.Name = "Hilight"

    local LeftOutline = Instance.new("Frame", BoxHolder)
    LeftOutline.BackgroundColor3 = theScriptOfGod.esp.Box.OutlineColor
    LeftOutline.Visible = false
    LeftOutline.BorderSizePixel = 1

    local RightOutline = Instance.new("Frame", BoxHolder)
    RightOutline.BackgroundColor3 = theScriptOfGod.esp.Box.OutlineColor
    RightOutline.Visible = false
    RightOutline.BorderSizePixel = 1

    local TopOutline = Instance.new("Frame", BoxHolder)
    TopOutline.BackgroundColor3 = theScriptOfGod.esp.Box.OutlineColor
    TopOutline.Visible = false
    TopOutline.BorderSizePixel = 1

    local BottomOutline = Instance.new("Frame", BoxHolder)
    BottomOutline.BackgroundColor3 = theScriptOfGod.esp.Box.OutlineColor
    BottomOutline.Visible = false
    BottomOutline.BorderSizePixel = 1

    local Left = Instance.new("Frame", BoxHolder)
    Left.BackgroundColor3 = theScriptOfGod.esp.Box.Color
    Left.Visible = false
    Left.BorderSizePixel = 0

    local Right = Instance.new("Frame", BoxHolder)
    Right.BackgroundColor3 = theScriptOfGod.esp.Box.Color
    Right.Visible = false
    Right.BorderSizePixel = 0

    local Top = Instance.new("Frame", BoxHolder)
    Top.BackgroundColor3 = theScriptOfGod.esp.Box.Color
    Top.Visible = false
    Top.BorderSizePixel = 0

    local Bottom = Instance.new("Frame", BoxHolder)
    Bottom.BackgroundColor3 = theScriptOfGod.esp.Box.Color
    Bottom.Visible = false
    Bottom.BorderSizePixel = 0

    local Name = Instance.new("TextLabel", BoxHolder)
    Name.BackgroundTransparency = 1
    Name.Text = Player.Name
    Name.Visible = false
    Name.AnchorPoint = Vector2.new(0.5, 0.5)
    Name.TextSize = 12
    Name.Font = Enum.Font.SourceSansBold
    Name.TextColor3 = Color3.fromRGB(255, 255, 255)
    Name.TextStrokeTransparency = 0

    local Distance = Instance.new("TextLabel", BoxHolder)
    Distance.BackgroundTransparency = 1
    Distance.Text = ""
    Distance.Visible = false
    Distance.AnchorPoint = Vector2.new(0.5, 0.5)
    Distance.TextSize = 12
    Distance.Font = Enum.Font.SourceSansBold
    Distance.TextColor3 = Color3.fromRGB(255, 255, 255)
    Distance.TextStrokeTransparency = 0

    local HealthBackground = Instance.new("Frame", BoxHolder)
    HealthBackground.Visible = false
    HealthBackground.BorderSizePixel = 1
    HealthBackground.BorderColor3 = theScriptOfGod.esp.Box.OutlineColor

    -- local HealthBar = Instance.new("Frame", BoxHolder)
    -- HealthBar.Visible = false
    -- HealthBar.BorderSizePixel = 0
    -- HealthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

    -- local Health = Instance.new("TextLabel", BoxHolder)
    -- Health.BackgroundTransparency = 1
    -- Health.Text = ""
    -- Health.Visible = false
    -- Health.AnchorPoint = Vector2.new(0.5, 0.5)
    -- Health.TextSize = 12
    -- Health.Font = Enum.Font.SourceSansBold
    -- Health.TextColor3 = Color3.fromRGB(255, 255, 255)
    -- Health.TextStrokeTransparency = 0

    -- Tracer
    local TracerOutline = Instance.new("Frame", TracerHolder)
    TracerOutline.BackgroundColor3 = theScriptOfGod.esp.Tracer.OutlineColor
    TracerOutline.Visible = false
    TracerOutline.BorderSizePixel = 1
    TracerOutline.AnchorPoint = Vector2.new(0.5, 0.5)

    local Tracer = Instance.new("Frame", TracerHolder)
    Tracer.BackgroundColor3 = theScriptOfGod.esp.Tracer.Color
    Tracer.Visible = false
    Tracer.BorderSizePixel = 0
    Tracer.AnchorPoint = Vector2.new(0.5, 0.5)

    -- Hilight
    local Hilight = Instance.new("Highlight", HilightHolder)
    Hilight.Enabled = false

    local co = coroutine.create(function()
        RunService.Heartbeat:Connect(function()
            if IsAlive(Player) then
                local worldCharacter = Player.Character:FindFirstChild("WorldCharacter")
                if worldCharacter then
                    local upperTorso = worldCharacter:FindFirstChild("UpperTorso")
                    if upperTorso then
                        local screen, onScreen = CurrentCamera:WorldToScreenPoint(upperTorso.Position)
                        local frustumHeight = math.tan(math.rad(CurrentCamera.FieldOfView * 0.5)) * 2 * screen.Z
                        local size = CurrentCamera.ViewportSize.Y / frustumHeight * theScriptOfGod.esp.CharacterSize
                        local position = Vector2.new(screen.X, screen.Y) - (size / 2 - Vector2.new(0, size.Y) / 20)

                        if onScreen then
                            -- Box
                            if theScriptOfGod.esp.Box.TeamCheck ~= true or GetTeam(Player) ~= GetTeam(localPlayer) then
                                -- local health = Player.Character.Humanoid.Health
                                -- local healthScale = health / Player.Character.Humanoid.MaxHealth
                                -- local healthSizeY = size.Y * healthScale

                                LeftOutline.Visible = theScriptOfGod.esp.Box.Box and theScriptOfGod.esp.Box.Outline
                                RightOutline.Visible = theScriptOfGod.esp.Box.Box and theScriptOfGod.esp.Box.Outline
                                TopOutline.Visible = theScriptOfGod.esp.Box.Box and theScriptOfGod.esp.Box.Outline
                                BottomOutline.Visible = theScriptOfGod.esp.Box.Box and theScriptOfGod.esp.Box.Outline
                                HealthBackground.Visible = theScriptOfGod.esp.Box.HealthBar

                                Left.Visible = theScriptOfGod.esp.Box.Box
                                Right.Visible = theScriptOfGod.esp.Box.Box
                                Top.Visible = theScriptOfGod.esp.Box.Box
                                Bottom.Visible = theScriptOfGod.esp.Box.Box
                                -- HealthBar.Visible = theScriptOfGod.esp.Box.HealthBar
                                Name.Visible = theScriptOfGod.esp.Box.Name
                                Distance.Visible = theScriptOfGod.esp.Box.Distance and not theScriptOfGod.esp.Box.Name
                                -- Health.Visible = theScriptOfGod.esp.Box.Health

                                Left.Size = UDim2.fromOffset(size.X, 1)
                                Right.Size = UDim2.fromOffset(size.X, 1)
                                Top.Size = UDim2.fromOffset(1, size.Y)
                                Bottom.Size = UDim2.fromOffset(1, size.Y)

                                LeftOutline.Size = Left.Size
                                RightOutline.Size = Right.Size
                                TopOutline.Size = Top.Size
                                BottomOutline.Size = Bottom.Size
                                HealthBackground.Size = UDim2.fromOffset(4, size.Y)
                                -- HealthBar.Size = UDim2.fromOffset(2, -healthSizeY)

                                Left.Position = UDim2.fromOffset(position.X, position.Y)
                                Right.Position = UDim2.fromOffset(position.X, position.Y + size.Y - 1)
                                Top.Position = UDim2.fromOffset(position.X, position.Y)
                                Bottom.Position = UDim2.fromOffset(position.X + size.X - 1, position.Y)
                                Name.Position = UDim2.fromOffset(screen.X, screen.Y - (size.Y + Name.TextBounds.Y + 14) / 2)
                                Distance.Position = UDim2.fromOffset(screen.X, screen.Y - (size.Y + Name.TextBounds.Y + 19) / 2)
                                HealthBackground.Position = UDim2.fromOffset(position.X - 8, position.Y)
                                -- HealthBar.Position = UDim2.fromOffset(position.X - 7, position.Y + size.Y)
                                -- Health.Position = theScriptOfGod.esp.Box.HealthBar and UDim2.fromOffset(position.X - 25, position.Y + size.Y - healthSizeY) or UDim2.fromOffset(position.X - 25, position.Y + size.Y)

                                LeftOutline.Position = Left.Position
                                RightOutline.Position = Right.Position
                                TopOutline.Position = Top.Position
                                BottomOutline.Position = Bottom.Position

                                LeftOutline.BorderColor3 = theScriptOfGod.esp.Box.OutlineColor
                                RightOutline.BorderColor3 = theScriptOfGod.esp.Box.OutlineColor
                                TopOutline.BorderColor3 = theScriptOfGod.esp.Box.OutlineColor
                                BottomOutline.BorderColor3 = theScriptOfGod.esp.Box.OutlineColor
                                LeftOutline.Transparency = theScriptOfGod.esp.Box.BoxTransparency
                                RightOutline.Transparency = theScriptOfGod.esp.Box.BoxTransparency
                                TopOutline.Transparency = theScriptOfGod.esp.Box.BoxTransparency
                                BottomOutline.Transparency = theScriptOfGod.esp.Box.BoxTransparency
                                -- HealthBackground.BackgroundColor3 = theScriptOfGod.esp.Box.OutlineColor
                                -- HealthBackground.BorderColor3 = theScriptOfGod.esp.Box.OutlineColor

                                Left.BackgroundColor3 = theScriptOfGod.esp.Box.Color
                                Right.BackgroundColor3 = theScriptOfGod.esp.Box.Color
                                Top.BackgroundColor3 = theScriptOfGod.esp.Box.Color
                                Bottom.BackgroundColor3 = theScriptOfGod.esp.Box.Color
                                LeftOutline.BackgroundColor3 = theScriptOfGod.esp.Box.Color
                                RightOutline.BackgroundColor3 = theScriptOfGod.esp.Box.Color
                                TopOutline.BackgroundColor3 = theScriptOfGod.esp.Box.Color
                                BottomOutline.BackgroundColor3 = theScriptOfGod.esp.Box.Color

                                Distance.Text = math.floor(0.5 + (CurrentCamera.CFrame.Position - Player.Character.HumanoidRootPart.Position).magnitude)
                                Name.Text = theScriptOfGod.esp.Box.Name and theScriptOfGod.esp.Box.Distance and Player.Name .. " (" .. math.floor(0.5 + (CurrentCamera.CFrame.Position - Player.Character.HumanoidRootPart.Position).magnitude) .. ")" or Player.Name
                                -- Health.Text = math.floor(Player.Character.Humanoid.Health)
                            else
                                LeftOutline.Visible = false
                                RightOutline.Visible = false
                                TopOutline.Visible = false
                                BottomOutline.Visible = false
                                Left.Visible = false
                                Right.Visible = false
                                Top.Visible = false
                                Bottom.Visible = false
                                Name.Visible = false
                                Distance.Visible = false
                                -- HealthBackground.Visible = false
                                -- HealthBar.Visible = false
                                -- Health.Visible = false
                            end

                            -- Tracer
                            if theScriptOfGod.esp.Tracer.TeamCheck ~= true or GetTeam(Player) ~= GetTeam(localPlayer) then
                                local ScreenVec2 = Vector2.new(screen.X, screen.Y + size.Y / 2 + size.Y / 20)
                                local Origin = Vector2.new(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y - 1)
                                local TracerPosition = (Origin + ScreenVec2) / 2

                                TracerOutline.Visible = theScriptOfGod.esp.Tracer.Outline and theScriptOfGod.esp.Tracer.Tracer
                                Tracer.Visible = theScriptOfGod.esp.Tracer.Tracer

                                Tracer.Rotation = math.deg(math.atan2(ScreenVec2.Y - Origin.Y, ScreenVec2.X - Origin.X))
                                Tracer.Position = UDim2.new(0, TracerPosition.X, 0, TracerPosition.Y)
                                Tracer.Size = UDim2.fromOffset((Origin - ScreenVec2).Magnitude, 1)

                                TracerOutline.Rotation = Tracer.Rotation
                                TracerOutline.Position = Tracer.Position
                                TracerOutline.Size = Tracer.Size

                                TracerOutline.BorderColor3 = theScriptOfGod.esp.Tracer.OutlineColor
                                Tracer.BackgroundColor3 = theScriptOfGod.esp.Tracer.Color
                            else
                                TracerOutline.Visible = false
                                Tracer.Visible = false
                            end

                            -- Hilight
                            if theScriptOfGod.esp.Highlights.TeamCheck ~= true or GetTeam(Player) ~= GetTeam(localPlayer) then
                                Hilight.Enabled = theScriptOfGod.esp.Highlights.Highlights
                                Hilight.Adornee = Player.Character

                                Hilight.OutlineColor = theScriptOfGod.esp.Highlights.OutlineColor
                                Hilight.FillColor = theScriptOfGod.esp.Highlights.FillColor

                                Hilight.FillTransparency = theScriptOfGod.esp.Highlights.FillTransparency
                                Hilight.OutlineTransparency = theScriptOfGod.esp.Highlights.OutlineTransparency

                                Hilight.DepthMode = (theScriptOfGod.esp.Highlights.AllWaysVisible and "AlwaysOnTop" or not theScriptOfGod.esp.Highlights.AllWaysVisible and "Occluded");
                            else
                                Hilight.Enabled = false
                                Hilight.Adornee = nil
                            end
                        else
                            LeftOutline.Visible = false
                            RightOutline.Visible = false
                            TopOutline.Visible = false
                            BottomOutline.Visible = false
                            Left.Visible = false
                            Right.Visible = false
                            Top.Visible = false
                            Bottom.Visible = false
                            TracerOutline.Visible = false
                            Tracer.Visible = false
                            Name.Visible = false
                            Distance.Visible = false
                            -- HealthBackground.Visible = false
                            -- HealthBar.Visible = false
                            -- Health.Visible = false
                        end
                    end
                end
            else
                LeftOutline.Visible = false
                RightOutline.Visible = false
                TopOutline.Visible = false
                BottomOutline.Visible = false
                Left.Visible = false
                Right.Visible = false
                Top.Visible = false
                Bottom.Visible = false
                TracerOutline.Visible = false
                Tracer.Visible = false
                Name.Visible = false
                Distance.Visible = false
                HealthBackground.Visible = false
                -- HealthBar.Visible = false
                -- Health.Visible = false
                Hilight.Adornee = nil
                -- PlayerESP:Destroy()
            end
        end)
        if not Players:FindFirstChild(Player.Name) then
            PlayerESP:Destroy()
            coroutine.yield()
        end
    end)
    coroutine.resume(co)
end

for i,plr in pairs(players:GetChildren()) do
	if plr ~= localPlayer then
		LoadESP(plr);
	end
end

players.PlayerAdded:Connect(function(plr)
	if plr ~= localPlayer then
		LoadESP(plr);
	end
end)

local repo = 'https://raw.githubusercontent.com/DaniHRE/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

Library:SetWatermarkVisibility(true)

local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter += 1;

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter;
        FrameTimer = tick();
        FrameCounter = 0;
    end;

    Library:SetWatermark(('TheScriptOfGod V0.0.1 | %s fps | %s ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ));
end);

Library:OnUnload(function()
    WatermarkConnection:Disconnect()
    Library.Unloaded = true
end)

local Window = Library:CreateWindow({
    Title = tostring(cloneref(game:GetService("MarketplaceService")):GetProductInfo(game.PlaceId).Name) .. "| " .. "theScriptOfGod V0.0.3";
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    Main = Window:AddTab('Main'), 
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local BoxGB = Tabs.Main:AddLeftGroupbox('Box')
local EnemyGB = Tabs.Main:AddLeftGroupbox('Enemy')
local TracerGB = Tabs.Main:AddRightGroupbox("Tracer");
local HighlightGB = Tabs.Main:AddRightGroupbox("Highlight");
local SettingsGB = Tabs['UI Settings']:AddRightGroupbox("Menu");

SettingsGB:AddButton('Unload', function() Library:Unload() end)

BoxGB:AddToggle('BoxEnabled', {
    Text = 'Enabled',
    Default = TheScriptOfGod.esp.Box.Box,
    Tooltip = 'Enable or disable Box ESP',
    Callback = function(Value)
        TheScriptOfGod.esp.Box.Box = Value;
    end
})

BoxGB:AddSlider('BoxTransparency', {
    Text = 'Transparency',
    Default = TheScriptOfGod.esp.Box.BoxTransparency,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        TheScriptOfGod.esp.Box.BoxTransparency = Value;
    end
})

BoxGB:AddLabel('Color'):AddColorPicker('BoxColor', {
    Default = TheScriptOfGod.esp.Box.Color,
    Title = 'Color',
    Transparency = 0,
    Callback = function(Value)
        TheScriptOfGod.esp.Box.Color = Value;
    end
})

BoxGB:AddDivider()

BoxGB:AddToggle('BoxOutlineEnabled', {
    Text = 'Outline',
    Default = TheScriptOfGod.esp.Box.Outline,
    Tooltip = 'Enable or disable Box Outline',
    Callback = function(Value)
        TheScriptOfGod.esp.Box.Outline = Value;
    end
})

BoxGB:AddLabel('Outline Color'):AddColorPicker('BoxOutlineColor', {
    Default = TheScriptOfGod.esp.Box.OutlineColor,
    Title = 'Outline Color',
    Transparency = 0,
    Callback = function(Value)
        TheScriptOfGod.esp.Box.OutlineColor = Value;
    end
})

EnemyGB:AddToggle('NameEnabled', {
    Text = 'Name',
    Default = TheScriptOfGod.esp.Box.Name,
    Tooltip = 'Enable or disable Name',
    Callback = function(Value)
        TheScriptOfGod.esp.Box.Name = Value;
    end
})

EnemyGB:AddToggle('DistanceEnabled', {
    Text = 'Distance',
    Default = TheScriptOfGod.esp.Box.Distance,
    Tooltip = 'Enable or disable Distance',
    Callback = function(Value)
        TheScriptOfGod.esp.Box.Distance = Value;
    end
})

TracerGB:AddToggle('TracerEnabled', {
    Text = 'Enabled',
    Default = TheScriptOfGod.esp.Tracer.Tracer,
    Tooltip = 'Enable or disable Tracer',
    Callback = function(Value)
        TheScriptOfGod.esp.Tracer.Tracer = Value;
    end
})

TracerGB:AddLabel('Color'):AddColorPicker('TracerColor', {
    Default = TheScriptOfGod.esp.Tracer.Color,
    Title = 'Color',
    Transparency = 0,
    Callback = function(Value)
        TheScriptOfGod.esp.Tracer.Color = Value;
    end
})

TracerGB:AddToggle('TracerOutline', {
    Text = 'Outline',
    Default = TheScriptOfGod.esp.Tracer.Outline,
    Tooltip = 'Enable or disable Tracer Outline',
    Callback = function(Value)
        TheScriptOfGod.esp.Tracer.Outline = Value;
    end
})


TracerGB:AddLabel('Outline Color'):AddColorPicker('TracerOutlineColor', {
    Default = TheScriptOfGod.esp.Tracer.OutlineColor,
    Title = 'Outline Color',
    Transparency = 0,
    Callback = function(Value)
        TheScriptOfGod.esp.Tracer.OutlineColor = Value;
    end
})

HighlightGB:AddToggle('HighlightEnabled', {
    Text = 'Enabled',
    Default = TheScriptOfGod.esp.Highlights.Highlights,
    Tooltip = 'Enable or disable Highlights',
    Callback = function(Value)
        TheScriptOfGod.esp.Highlights.Highlights = Value;
    end
})

HighlightGB:AddSlider('HighlightOutlineTransparency', {
    Text = 'Outline Transparency',
    Default = TheScriptOfGod.esp.Highlights.OutlineTransparency,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        TheScriptOfGod.esp.Highlights.OutlineTransparency = Value;
    end
})

HighlightGB:AddLabel('Outline Color'):AddColorPicker('HighlightOutlineColor', {
    Default = TheScriptOfGod.esp.Highlights.OutlineColor,
    Title = 'Outline Color',
    Transparency = 0,
    Callback = function(Value)
        TheScriptOfGod.esp.Highlights.OutlineColor = Value;
    end
})

HighlightGB:AddSlider('HighlightFillTransparency', {
    Text = 'Fill Transparency',
    Default = TheScriptOfGod.esp.Highlights.FillTransparency,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        TheScriptOfGod.esp.Highlights.FillTransparency = Value;
    end
})

HighlightGB:AddLabel('Fill Color'):AddColorPicker('HighlightFillColor', {
    Default = TheScriptOfGod.esp.Highlights.FillColor,
    Title = 'Fill Color',
    Transparency = 0,
    Callback = function(Value)
        TheScriptOfGod.esp.Highlights.FillColor = Value;
    end
})

HighlightGB:AddToggle('HighlightAlwaysVisible', {
    Text = 'Always Visible',
    Default = TheScriptOfGod.esp.Highlights.AlwaysVisible,
    Tooltip = 'Enable or disable Highlights',
    Callback = function(Value)
        TheScriptOfGod.esp.Highlights.AlwaysVisible = Value;
    end
})

ThemeManager:SetLibrary(Library);
ThemeManager:SetFolder('TheScriptOfGod')
ThemeManager:ApplyToTab(Tabs['UI Settings']);
ThemeManager:ApplyTheme("BBot");

SaveManager:SetLibrary(Library);
SaveManager:IgnoreThemeSettings();
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
SaveManager:SetFolder('TheScriptOfGod');
SaveManager:BuildConfigSection(Tabs['UI Settings']);
SaveManager:LoadAutoloadConfig();
