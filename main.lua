function Library:CreateWindow(opts)
    opts = opts or {}
    local window = {}
    local tabCount = 0
    local activeTab = nil

    Library:Notify("Meena Hub loaded successfully", 4)

    -- Tab container (will hold tab buttons in sidebar)
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 1, 0)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = sidebar

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 6)
    tabLayout.Parent = tabContainer

    local contentContainer = Instance.new("Frame")
    contentContainer.Size = UDim2.new(1, 0, 1, 0)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = content

    -- Function to create a new tab
    function window:CreateTab(name)
        tabCount = tabCount + 1

        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, -12, 0, 36)
        tabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 44)
        tabButton.Text = "  " .. name
        tabButton.TextColor3 = Color3.fromRGB(180, 180, 220)
        tabButton.Font = Enum.Font.GothamSemibold
        tabButton.TextSize = 15
        tabButton.TextXAlignment = Enum.TextXAlignment.Left
        tabButton.BackgroundTransparency = 1
        tabButton.AutoButtonColor = false
        tabButton.LayoutOrder = tabCount
        tabButton.Parent = tabContainer

        local btnCorner = Instance.new("UICorner", tabButton)
        btnCorner.CornerRadius = UDim.new(0, 8)

        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = "Tab_" .. name
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 4
        tabContent.Visible = false
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.Parent = contentContainer

        local contentLayout = Instance.new("UIListLayout")
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Padding = UDim.new(0, 10)
        contentLayout.Parent = tabContent

        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
        end)

        -- Tab switching logic
        local function selectTab()
            if activeTab and activeTab ~= tabContent then
                activeTab.Visible = false
                activeTab.Parent:FindFirstChildWhichIsA("TextButton").BackgroundTransparency = 1
                activeTab.Parent:FindFirstChildWhichIsA("TextButton").TextColor3 = Color3.fromRGB(180, 180, 220)
            end

            tabContent.Visible = true
            tabButton.BackgroundTransparency = 0.4
            tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            activeTab = tabContent
        end

        tabButton.MouseButton1Click:Connect(selectTab)

        -- Auto-select first tab
        if tabCount == 1 then
            selectTab()
        end

        local tab = {}

        -- ───────────────────────────────────────
        -- Toggle
        -- ───────────────────────────────────────
        function tab:CreateToggle(options)
            options = options or {}
            local toggleName = options.Name or "Toggle"
            local default = options.Default or false
            local callback = options.Callback or function() end

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -16, 0, 38)
            frame.BackgroundTransparency = 1
            frame.Parent = tabContent

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -60, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = toggleName
            label.TextColor3 = Color3.fromRGB(220, 220, 255)
            label.Font = Enum.Font.GothamSemibold
            label.TextSize = 15
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = frame

            local indicator = Instance.new("Frame")
            indicator.Size = UDim2.new(0, 34, 0, 18)
            indicator.Position = UDim2.new(1, -44, 0.5, -9)
            indicator.BackgroundColor3 = default and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(90, 90, 110)
            indicator.Parent = frame

            local ic = Instance.new("UICorner", indicator)
            ic.CornerRadius = UDim.new(1, 0)

            local circle = Instance.new("Frame")
            circle.Size = UDim2.new(0, 14, 0, 14)
            circle.Position = default and UDim2.new(0, 18, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            circle.BackgroundColor3 = Color3.new(1,1,1)
            circle.Parent = indicator

            local cc = Instance.new("UICorner", circle)
            cc.CornerRadius = UDim.new(1, 0)

            local value = default

            local function update()
                if value then
                    TS:Create(indicator, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(80, 200, 120)}):Play()
                    TS:Create(circle, TweenInfo.new(0.25), {Position = UDim2.new(0, 18, 0.5, -7)}):Play()
                else
                    TS:Create(indicator, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(90, 90, 110)}):Play()
                    TS:Create(circle, TweenInfo.new(0.25), {Position = UDim2.new(0, 2, 0.5, -7)}):Play()
                end
            end

            frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    value = not value
                    update()
                    callback(value)
                end
            end)

            update() -- initial state

            return { Set = function(v) value = v; update(); callback(v) end }
        end

        -- ───────────────────────────────────────
        -- Button
        -- ───────────────────────────────────────
        function tab:CreateButton(options)
            options = options or {}
            local name = options.Name or "Button"
            local callback = options.Callback or function() end

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -16, 0, 38)
            btn.BackgroundColor3 = Color3.fromRGB(70, 120, 255)
            btn.Text = name
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 15
            btn.Parent = tabContent

            local bc = Instance.new("UICorner", btn)
            bc.CornerRadius = UDim.new(0, 9)

            btn.MouseButton1Click:Connect(callback)

            return { Fire = callback }
        end

        -- ───────────────────────────────────────
        -- Slider (simple number slider)
        -- ───────────────────────────────────────
        function tab:CreateSlider(options)
            options = options or {}
            local name = options.Name or "Slider"
            local min = options.Min or 0
            local max = options.Max or 100
            local default = options.Default or min
            local callback = options.Callback or function() end
            local increment = options.Increment or 1

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -16, 0, 50)
            frame.BackgroundTransparency = 1
            frame.Parent = tabContent

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 20)
            label.BackgroundTransparency = 1
            label.Text = name .. ": " .. default
            label.TextColor3 = Color3.fromRGB(220, 220, 255)
            label.Font = Enum.Font.GothamSemibold
            label.TextSize = 14
            label.Parent = frame

            local bar = Instance.new("Frame")
            bar.Size = UDim2.new(1, 0, 0, 8)
            bar.Position = UDim2.new(0, 0, 0, 28)
            bar.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            bar.Parent = frame

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(100, 160, 255)
            fill.Parent = bar

            local corner = Instance.new("UICorner", bar)
            corner.CornerRadius = UDim.new(1, 0)

            local fcorner = Instance.new("UICorner", fill)
            fcorner.CornerRadius = UDim.new(1, 0)

            local dragging = false

            bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)

            bar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            UIS.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    local mousePos = input.Position.X
                    local barPos = bar.AbsolutePosition.X
                    local barSize = bar.AbsoluteSize.X
                    local relative = math.clamp((mousePos - barPos) / barSize, 0, 1)
                    local value = min + (max - min) * relative
                    value = math.floor(value / increment + 0.5) * increment
                    fill.Size = UDim2.new(relative, 0, 1, 0)
                    label.Text = name .. ": " .. value
                    callback(value)
                end
            end)

            -- Set initial
            local initialRelative = (default - min) / (max - min)
            fill.Size = UDim2.new(initialRelative, 0, 1, 0)
            label.Text = name .. ": " .. default

            return { Set = function(v) 
                v = math.clamp(v, min, max)
                v = math.floor(v / increment + 0.5) * increment
                local rel = (v - min) / (max - min)
                fill.Size = UDim2.new(rel, 0, 1, 0)
                label.Text = name .. ": " .. v
                callback(v)
            end }
        end

        -- You can continue adding Dropdown, Keybind, ColorPicker similarly.
        -- Let me know which one you'd like to implement next.

        return tab
    end

    return window
end
