local Library = {}
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local mouse = lp:GetMouse()

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MeenaUI_" .. math.random(10000, 99999)
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = (gethui and gethui()) or game.CoreGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 580, 0, 380)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 36)
TitleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -100, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 14, 0, 0)
TitleLabel.Text = "Meena Hub"
TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 15
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -38, 0, 3)
CloseButton.BackgroundColor3 = Color3.fromRGB(210, 60, 60)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.new(1,1,1)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = TitleBar

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Dragging
local dragging, dragInput, dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Sidebar
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 150, 1, -36)
Sidebar.Position = UDim2.new(0, 0, 0, 36)
Sidebar.BackgroundTransparency = 1
Sidebar.ScrollBarThickness = 3
Sidebar.Parent = MainFrame

local SidebarList = Instance.new("UIListLayout")
SidebarList.Padding = UDim.new(0, 6)
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Parent = Sidebar

-- Content Area
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -160, 1, -44)
Content.Position = UDim2.new(0, 150, 0, 40)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Tabs
local Tabs = {}
local ActiveTab = nil

local function CreateTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, -12, 0, 34)
    TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    TabButton.Text = name
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.TextSize = 14
    TabButton.TextColor3 = Color3.new(1,1,1)
    TabButton.Parent = Sidebar

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabButton

    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.Visible = false
    TabPage.ScrollBarThickness = 4
    TabPage.CanvasSize = UDim2.new(0,0,0,0)
    TabPage.Parent = Content

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Padding = UDim.new(0, 10)
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Parent = TabPage

    TabPage.ChildAdded:Connect(function()
        TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
    end)

    TabButton.MouseButton1Click:Connect(function()
        if ActiveTab then
            ActiveTab.Page.Visible = false
            ActiveTab.Button.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        end
        TabPage.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(60, 100, 255)
        ActiveTab = {Button = TabButton, Page = TabPage}
    end)

    if #Tabs == 0 then
        TabButton.BackgroundColor3 = Color3.fromRGB(60, 100, 255)
        TabPage.Visible = true
        ActiveTab = {Button = TabButton, Page = TabPage}
    end

    table.insert(Tabs, {Button = TabButton, Page = TabPage})

    Sidebar.CanvasSize = UDim2.new(0, 0, 0, SidebarList.AbsoluteContentSize.Y + 20)

    local tabAPI = {}

    function tabAPI:CreateSection(title)
        local Section = Instance.new("TextLabel")
        Section.Size = UDim2.new(1, -20, 0, 26)
        Section.BackgroundTransparency = 1
        Section.Text = title:upper()
        Section.TextColor3 = Color3.fromRGB(120, 180, 255)
        Section.Font = Enum.Font.GothamBold
        Section.TextSize = 13
        Section.TextXAlignment = Enum.TextXAlignment.Left
        Section.Parent = TabPage
    end

    function tabAPI:CreateButton(options)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, -20, 0, 36)
        Button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        Button.Text = options.Name or "Button"
        Button.TextColor3 = Color3.new(1,1,1)
        Button.Font = Enum.Font.GothamSemibold
        Button.TextSize = 14
        Button.Parent = TabPage

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = Button

        -- Hover effect
        Button.MouseEnter:Connect(function()
            TS:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55,55,80)}):Play()
        end)
        Button.MouseLeave:Connect(function()
            TS:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40,40,60)}):Play()
        end)

        Button.MouseButton1Click:Connect(options.Callback or function() end)
    end

    function tabAPI:CreateToggle(options)
        local ToggleFrame = Instance.new("TextButton")
        ToggleFrame.Size = UDim2.new(1, -20, 0, 36)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        ToggleFrame.Text = ""
        ToggleFrame.AutoButtonColor = false
        ToggleFrame.Parent = TabPage

        local tfCorner = Instance.new("UICorner")
        tfCorner.CornerRadius = UDim.new(0, 6)
        tfCorner.Parent = ToggleFrame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -70, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Text = options.Name or "Toggle"
        Label.TextColor3 = Color3.new(1,1,1)
        Label.Font = Enum.Font.GothamSemibold
        Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.Parent = ToggleFrame

        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 34, 0, 18)
        Indicator.Position = UDim2.new(1, -50, 0.5, -9)
        Indicator.BackgroundColor3 = options.Default and Color3.fromRGB(60, 180, 80) or Color3.fromRGB(100, 100, 120)
        Indicator.BorderSizePixel = 0
        Indicator.Parent = ToggleFrame

        local indCorner = Instance.new("UICorner")
        indCorner.CornerRadius = UDim.new(1, 0)
        indCorner.Parent = Indicator

        local Knob = Instance.new("Frame")
        Knob.Size = UDim2.new(0, 24, 0, 24)
        Knob.Position = UDim2.new(0, -3, 0.5, -12)
        Knob.BackgroundColor3 = Color3.new(1,1,1)
        Knob.BorderSizePixel = 0
        Knob.Parent = Indicator

        local knobCorner = Instance.new("UICorner")
        knobCorner.CornerRadius = UDim.new(1, 0)
        knobCorner.Parent = Knob

        local value = options.Default or false

        local function UpdateToggle(v)
            value = v
            if options.Callback then
                options.Callback(v)
            end

            TS:Create(Indicator, TweenInfo.new(0.25), {
                BackgroundColor3 = v and Color3.fromRGB(60, 180, 80) or Color3.fromRGB(100, 100, 120)
            }):Play()

            TS:Create(Knob, TweenInfo.new(0.25), {
                Position = v and UDim2.new(1, -27, 0.5, -12) or UDim2.new(0, -3, 0.5, -12)
            }):Play()
        end

        ToggleFrame.MouseButton1Click:Connect(function()
            UpdateToggle(not value)
        end)

        -- Apply initial state
        UpdateToggle(value)

        return {
            Toggle = function() return value end,
            Set = UpdateToggle
        }
    end

    function tabAPI:CreateSlider(options)
        local Min = options.Min or 0
        local Max = options.Max or 100
        local Increment = options.Increment or 1
        local Default = options.Default or Min

        local SliderFrame = Instance.new("Frame")
        SliderFrame.Size = UDim2.new(1, -20, 0, 44)
        SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        SliderFrame.Parent = TabPage

        local sfCorner = Instance.new("UICorner")
        sfCorner.CornerRadius = UDim.new(0, 6)
        sfCorner.Parent = SliderFrame

        local NameLabel = Instance.new("TextLabel")
        NameLabel.Size = UDim2.new(0.6, 0, 0, 20)
        NameLabel.BackgroundTransparency = 1
        NameLabel.Text = options.Name or "Slider"
        NameLabel.TextColor3 = Color3.new(1,1,1)
        NameLabel.Font = Enum.Font.GothamSemibold
        NameLabel.TextSize = 13
        NameLabel.TextXAlignment = Enum.TextXAlignment.Left
        NameLabel.Position = UDim2.new(0, 12, 0, 4)
        NameLabel.Parent = SliderFrame

        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Size = UDim2.new(0, 60, 0, 20)
        ValueLabel.Position = UDim2.new(1, -72, 0, 4)
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Text = tostring(Default)
        ValueLabel.TextColor3 = Color3.fromRGB(180, 180, 255)
        ValueLabel.Font = Enum.Font.Gotham
        ValueLabel.TextSize = 13
        ValueLabel.Parent = SliderFrame

        local Bar = Instance.new("Frame")
        Bar.Size = UDim2.new(1, -24, 0, 6)
        Bar.Position = UDim2.new(0, 12, 0, 28)
        Bar.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        Bar.BorderSizePixel = 0
        Bar.Parent = SliderFrame

        local BarCorner = Instance.new("UICorner")
        BarCorner.CornerRadius = UDim.new(1, 0)
        BarCorner.Parent = Bar

        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new(0.5, 0, 1, 0)
        Fill.BackgroundColor3 = Color3.fromRGB(80, 140, 255)
        Fill.BorderSizePixel = 0
        Fill.Parent = Bar

        local FillCorner = Instance.new("UICorner")
        FillCorner.CornerRadius = UDim.new(1, 0)
        FillCorner.Parent = Fill

        local draggingSlider = false

        local function UpdateSlider(val)
            val = math.clamp(math.round((val - Min) / Increment) * Increment, Min, Max)
            ValueLabel.Text = tostring(val)
            local percent = (val - Min) / (Max - Min)
            Fill.Size = UDim2.new(percent, 0, 1, 0)
            if options.Callback then
                options.Callback(val)
            end
        end

        UpdateSlider(Default)

        Bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingSlider = true
            end
        end)

        Bar.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingSlider = false
            end
        end)

        UIS.InputChanged:Connect(function(input)
            if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mousePos = input.Position.X
                local barPos = Bar.AbsolutePosition.X
                local barWidth = Bar.AbsoluteSize.X
                local relative = math.clamp((mousePos - barPos) / barWidth, 0, 1)
                local value = Min + (Max - Min) * relative
                UpdateSlider(value)
            end
        end)

        return {
            Value = function() return tonumber(ValueLabel.Text) end,
            Set = UpdateSlider
        }
    end

    function tabAPI:CreateDropdown(options)
        local values = options.List or {}
        local default = options.Default or values[1]

        local Dropdown = Instance.new("TextButton")
        Dropdown.Size = UDim2.new(1, -20, 0, 36)
        Dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        Dropdown.Text = ""
        Dropdown.AutoButtonColor = false
        Dropdown.Parent = TabPage

        local ddCorner = Instance.new("UICorner")
        ddCorner.CornerRadius = UDim.new(0, 6)
        ddCorner.Parent = Dropdown

        -- Hover
        Dropdown.MouseEnter:Connect(function()
            TS:Create(Dropdown, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55,55,80)}):Play()
        end)
        Dropdown.MouseLeave:Connect(function()
            TS:Create(Dropdown, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40,40,60)}):Play()
        end)

        local ddLabel = Instance.new("TextLabel")
        ddLabel.Size = UDim2.new(1, -90, 1, 0)
        ddLabel.BackgroundTransparency = 1
        ddLabel.Text = options.Name or "Dropdown"
        ddLabel.TextColor3 = Color3.new(1,1,1)
        ddLabel.Font = Enum.Font.GothamSemibold
        ddLabel.TextSize = 14
        ddLabel.TextXAlignment = Enum.TextXAlignment.Left
        ddLabel.Position = UDim2.new(0, 12, 0, 0)
        ddLabel.Parent = Dropdown

        local Selected = Instance.new("TextLabel")
        Selected.Size = UDim2.new(0, 80, 1, 0)
        Selected.Position = UDim2.new(1, -92, 0, 0)
        Selected.BackgroundTransparency = 1
        Selected.Text = default or "Select..."
        Selected.TextColor3 = Color3.fromRGB(170, 170, 255)
        Selected.Font = Enum.Font.Gotham
        Selected.TextSize = 14
        Selected.TextXAlignment = Enum.TextXAlignment.Right
        Selected.Parent = Dropdown

        local Arrow = Instance.new("TextLabel")
        Arrow.Size = UDim2.new(0, 20, 1, 0)
        Arrow.Position = UDim2.new(1, -25, 0, 0)
        Arrow.BackgroundTransparency = 1
        Arrow.Text = "▼"
        Arrow.TextColor3 = Color3.fromRGB(170, 170, 255)
        Arrow.Font = Enum.Font.Gotham
        Arrow.TextSize = 14
        Arrow.Parent = Dropdown

        local currentValue = default

        local function SetValue(val)
            currentValue = val
            Selected.Text = tostring(val)
            if options.Callback then
                options.Callback(val)
            end
        end

        Dropdown.MouseButton1Click:Connect(function()
            local nextIndex = table.find(values, currentValue) or 1
            nextIndex = (nextIndex % #values) + 1
            SetValue(values[nextIndex])
        end)

        -- Initial value
        if default then
            SetValue(default)
        end

        return {
            Value = function() return currentValue end,
            Set = SetValue
        }
    end

    return tabAPI
end

-- Window API
function Library:CreateWindow()
    MainFrame.Visible = true
    local windowAPI = {}
    windowAPI.CreateTab = CreateTab
    return windowAPI
end

-- Show UI
Library:CreateWindow()

return Library
