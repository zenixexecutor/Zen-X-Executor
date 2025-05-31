local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

local zenX = loadstring(game:HttpGet("https://example.com/zen-x.lua"))()

local availableScripts = {
    {name = "AutoFarm", description = "Automatically farms resources"},
    {name = "ESP", description = "Enemy ESP highlight"},
    {name = "Fly", description = "Enables flying ability"},
}

local scriptsQueue = {}
local zenXOn = false

local function isMobile()
    return UserInputService.TouchEnabled
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZenXGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui
screenGui.Enabled = false

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 160, 0, 50)
toggleBtn.Position = UDim2.new(0, 15, 0, 15)
toggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 24
toggleBtn.Text = "Turn On Zen-X"
toggleBtn.Parent = screenGui

local scriptsFrame = Instance.new("Frame")
scriptsFrame.Size = isMobile() and UDim2.new(0.8, 0, 0.4, 0) or UDim2.new(0, 240, 0, 200)
scriptsFrame.Position = isMobile() and UDim2.new(0.1, 0, 0.2, 0) or UDim2.new(0, 15, 0, 80)
scriptsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
scriptsFrame.BorderSizePixel = 0
scriptsFrame.Parent = screenGui

local layout = Instance.new("UIListLayout")
layout.Parent = scriptsFrame
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 8)

local function renderScriptsList()
    for _, child in pairs(scriptsFrame:GetChildren()) do
        if not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end

    for i, scriptInfo in ipairs(availableScripts) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, isMobile() and 50 or 30)
        btn.BackgroundColor3 = table.find(scriptsQueue, scriptInfo.name) and Color3.fromRGB(70, 70, 70) or Color3.fromRGB(50, 50, 50)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = isMobile() and 24 or 18
        btn.Text = scriptInfo.name
        btn.ToolTip = scriptInfo.description
        btn.Parent = scriptsFrame

        btn.MouseButton1Click:Connect(function()
            if table.find(scriptsQueue, scriptInfo.name) then
                for idx, val in ipairs(scriptsQueue) do
                    if val == scriptInfo.name then
                        table.remove(scriptsQueue, idx)
                        break
                    end
                end
            else
                table.insert(scriptsQueue, scriptInfo.name)
            end
            renderScriptsList()
        end)
    end
end

local runBtn = Instance.new("TextButton")
runBtn.Size = isMobile() and UDim2.new(0.8, 0, 0, 60) or UDim2.new(0, 240, 0, 40)
runBtn.Position = isMobile() and UDim2.new(0.1, 0, 0.65, 0) or UDim2.new(0, 15, 0, 290)
runBtn.BackgroundColor3 = Color3.fromRGB(45, 135, 45)
runBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
runBtn.Font = Enum.Font.SourceSansBold
runBtn.TextSize = isMobile() and 26 or 22
runBtn.Text = "Run All Scripts"
runBtn.Parent = screenGui

runBtn.MouseButton1Click:Connect(function()
    for _, scriptName in ipairs(scriptsQueue) do
        if zenX and zenX.RunScript then
            zenX:RunScript(scriptName)
        else
            warn("zenX executor missing RunScript method!")
        end
    end
end)

toggleBtn.MouseButton1Click:Connect(function()
    zenXOn = not zenXOn
    screenGui.Enabled = zenXOn
    toggleBtn.Text = zenXOn and "Stop Zen-X" or "Turn On Zen-X"

    if not zenXOn then
        scriptsQueue = {}
        renderScriptsList()
    end
end)

renderScriptsList()

if zenX and zenX.Init then
    zenX:Init()
else
    warn("zenX executor missing Init method!")
end
