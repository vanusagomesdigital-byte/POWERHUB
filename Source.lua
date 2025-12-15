-- POWERHUB | LocalScript (StarterPlayer > StarterPlayerScripts)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LP = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "POWERHUB"
gui.Parent = game.CoreGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,420)
frame.Position = UDim2.new(0.65,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- TopBar
local top = Instance.new("Frame", frame)
top.Size = UDim2.new(1,0,0,35)
top.BackgroundColor3 = Color3.fromRGB(30,30,30)
top.BorderSizePixel = 0

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1,-70,1,0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "POWERHUB"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left

local minimize = Instance.new("TextButton", top)
minimize.Size = UDim2.new(0,30,0,25)
minimize.Position = UDim2.new(1,-65,0,5)
minimize.Text = "-"
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 18
minimize.BackgroundColor3 = Color3.fromRGB(0,140,255)
minimize.TextColor3 = Color3.new(1,1,1)
minimize.BorderSizePixel = 0

local close = Instance.new("TextButton", top)
close.Size = UDim2.new(0,30,0,25)
close.Position = UDim2.new(1,-30,0,5)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.BackgroundColor3 = Color3.fromRGB(255,60,60)
close.TextColor3 = Color3.new(1,1,1)
close.BorderSizePixel = 0

-- Holder
local holder = Instance.new("Frame", frame)
holder.Position = UDim2.new(0,0,0,40)
holder.Size = UDim2.new(1,0,1,-40)
holder.BackgroundTransparency = 1

local function makeButton(text, y)
	local b = Instance.new("TextButton", holder)
	b.Size = UDim2.new(1,-20,0,35)
	b.Position = UDim2.new(0,10,0,y)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(0,140,255)
	b.BorderSizePixel = 0
	return b
end

local walkBtn   = makeButton("WalkSpeed",0)
local flyBtn    = makeButton("Fly",40)
local noclipBtn = makeButton("NoClip",80)
local xrayBtn   = makeButton("XRay",120)
local invisBtn  = makeButton("Invisible",160)
local stunBtn   = makeButton("Anti-Stun",200)
local bypassBtn = makeButton("Bypass",240)
local aimBtn    = makeButton("Aimbot",280)

-- Window controls
local minimized = false
minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	holder.Visible = not minimized
	frame.Size = minimized and UDim2.new(0,260,0,35) or UDim2.new(0,260,0,420)
end)

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- WalkSpeed
local fast = false
walkBtn.MouseButton1Click:Connect(function()
	fast = not fast
	if LP.Character and LP.Character:FindFirstChild("Humanoid") then
		LP.Character.Humanoid.WalkSpeed = fast and 40 or 16
	end
end)

-- NoClip
local noclip = false
noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
end)

RunService.Stepped:Connect(function()
	if noclip and LP.Character then
		for _,v in pairs(LP.Character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

-- Fly
local flying = false
flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
	local hrp = LP.Character.HumanoidRootPart
	local bv = Instance.new("BodyVelocity", hrp)
	bv.MaxForce = Vector3.new(9e9,9e9,9e9)
	while flying do
		bv.Velocity = Camera.CFrame.LookVector * 50
		RunService.RenderStepped:Wait()
	end
	bv:Destroy()
end)

-- XRay
local xray = false
xrayBtn.MouseButton1Click:Connect(function()
	xray = not xray
	for _,p in pairs(workspace:GetDescendants()) do
		if p:IsA("BasePart") then
			p.Transparency = xray and 0.6 or 0
		end
	end
end)

-- Invisible
local invis = false
invisBtn.MouseButton1Click:Connect(function()
	invis = not invis
	if LP.Character then
		for _,v in pairs(LP.Character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Transparency = invis and 1 or 0
			end
		end
	end
end)

-- Anti-Stun
stunBtn.MouseButton1Click:Connect(function()
	if LP.Character and LP.Character:FindFirstChild("Humanoid") then
		LP.Character.Humanoid.PlatformStand = false
	end
end)

-- Bypass (visual)
bypassBtn.MouseButton1Click:Connect(function()
	print("POWERHUB: Bypass visual ativado")
end)

-- Aimbot
local aimbot = false
aimBtn.MouseButton1Click:Connect(function()
	aimbot = not aimbot
end)

RunService.RenderStepped:Connect(function()
	if not aimbot then return end
	local closest, dist = nil, math.huge
	for _,p in pairs(Players:GetPlayers()) do
		if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
			local pos, on = Camera:WorldToViewportPoint(p.Character.Head.Position)
			if on then
				local d = (Vector2.new(pos.X,pos.Y) - UIS:GetMouseLocation()).Magnitude
				if d < dist then
					dist = d
					closest = p.Character.Head
				end
			end
		end
	end
	if closest then
		Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Position)
	end
end)
