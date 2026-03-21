local GetGender = loadstring(game:HttpGet("https://raw.githubusercontent.com/ReliefScript/roblox-get-user-gender/refs/heads/main/main.lua"))()

local Players = game:GetService("Players")

local GenderColors = {
    Male = Color3.fromRGB(100, 180, 255),
    Female = Color3.fromRGB(255, 150, 200),
    Unknown = Color3.fromRGB(180, 180, 180)
}

local GenderIcons = {
    Male = "♂",
    Female = "♀",
    Unknown = "?"
}

local function CreateOverhead(Player, Result)
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local Head = Character:WaitForChild("Head")

    local Existing = Head:FindFirstChild("GenderGui")
    if Existing then Existing:Destroy() end

    local Gender = Result and Result.Gender or "Unknown"
    local Color = GenderColors[Gender]
    local Icon = GenderIcons[Gender]

    local MethodText = "No Match"
    if Result and Result.Method then
        local M = Result.Method
        MethodText = M.Name .. ": " .. (M.Value or "?")
    end

    local Billboard = Instance.new("BillboardGui")
    Billboard.Name = "GenderGui"
    Billboard.Size = UDim2.new(5, 0, 1.6, 0)
    Billboard.StudsOffset = Vector3.new(0, 2.8, 0)
    Billboard.AlwaysOnTop = false
    Billboard.ResetOnSpawn = false
    Billboard.Parent = Head

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Frame.BackgroundTransparency = 0.3
    Frame.BorderSizePixel = 0
    Frame.Parent = Billboard

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0.15, 0)
    Corner.Parent = Frame

    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0.06, 0)
    Padding.PaddingRight = UDim.new(0.06, 0)
    Padding.PaddingTop = UDim.new(0.08, 0)
    Padding.PaddingBottom = UDim.new(0.08, 0)
    Padding.Parent = Frame

    local Layout = Instance.new("UIListLayout")
    Layout.FillDirection = Enum.FillDirection.Vertical
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Layout.VerticalAlignment = Enum.VerticalAlignment.Center
    Layout.Padding = UDim.new(0.04, 0)
    Layout.Parent = Frame

    local GenderLabel = Instance.new("TextLabel")
    GenderLabel.Size = UDim2.new(1, 0, 0.58, 0)
    GenderLabel.BackgroundTransparency = 1
    GenderLabel.Text = Icon .. "  " .. Gender
    GenderLabel.TextColor3 = Color
    GenderLabel.TextScaled = true
    GenderLabel.Font = Enum.Font.GothamBold
    GenderLabel.Parent = Frame

    local MethodLabel = Instance.new("TextLabel")
    MethodLabel.Size = UDim2.new(1, 0, 0.30, 0)
    MethodLabel.BackgroundTransparency = 1
    MethodLabel.Text = MethodText
    MethodLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    MethodLabel.TextScaled = true
    MethodLabel.TextTruncate = Enum.TextTruncate.AtEnd
    MethodLabel.Font = Enum.Font.Gotham
    MethodLabel.Parent = Frame
end

local function HandlePlayer(Player)
    task.spawn(function()
        local R = GetGender(Player)
        CreateOverhead(Player, R)

        Player.CharacterAdded:Connect(function()
            CreateOverhead(Player, R)
        end)
    end)
end

for _, Player in Players:GetPlayers() do
    HandlePlayer(Player)
end

Players.PlayerAdded:Connect(HandlePlayer)
