-- ============================================
-- 🦘 БЕСКОНЕЧНЫЙ ПРЫЖОК (LocalScript)
-- Место: StarterPlayer > StarterPlayerScripts
-- ============================================

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local enabled = true          -- true = включено сразу
local jumpPower = 50          -- сила отталкивания (можешь менять)

-- ============================================
-- GUI (кнопка вкл/выкл + перетаскивание)
-- ============================================
local gui = Instance.new("ScreenGui")
gui.Name = "InfJumpGui"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 90)
frame.Position = UDim2.new(0, 20, 0.5, -45)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
title.Text = "🦘 Бесконечный прыжок"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.BorderSizePixel = 0
title.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = title

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, -20, 0, 40)
btn.Position = UDim2.new(0, 10, 0, 40)
btn.BackgroundColor3 = Color3.fromRGB(60, 180, 75)
btn.Text = "ВКЛ"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 15
btn.BorderSizePixel = 0
btn.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = btn

btn.MouseButton1Click:Connect(function()
	enabled = not enabled
	if enabled then
		btn.Text = "ВКЛ"
		btn.BackgroundColor3 = Color3.fromRGB(60, 180, 75)
	else
		btn.Text = "ВЫКЛ"
		btn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
	end
end)

-- ============================================
-- ЛОГИКА БЕСКОНЕЧНОГО ПРЫЖКА
-- ============================================
UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if not enabled then return end
	if input.KeyCode ~= Enum.KeyCode.Space then return end

	local char = player.Character
	if not char then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	local humanoid = char:FindFirstChild("Humanoid")
	if not hrp or not humanoid then return end
	if humanoid.Health <= 0 then return end

	-- Отталкивание вверх в воздухе (сохраняет горизонтальную скорость)
	hrp.AssemblyLinearVelocity = Vector3.new(
		hrp.AssemblyLinearVelocity.X,
		jumpPower,
		hrp.AssemblyLinearVelocity.Z
	)
end)

print("🦘 Скрипт бесконечного прыжка загружен!")
