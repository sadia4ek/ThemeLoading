-- https://lua.expert/ [ОРИГИНАЛ]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("PhysicsService")
local RequestDestroy = ReplicatedStorage:WaitForChild("RequestDestroy")
local destroyAsync = ReplicatedStorage:WaitForChild("ClientBinds"):WaitForChild("destroyAsync")
local GlobalParts = workspace:WaitForChild("GlobalParts")
game:GetService("Debris")
local LocalPlayer = game.Players.LocalPlayer
local Camera = workspace:WaitForChild("Camera")
local TweenService = game:GetService("TweenService")
function stringrandom(p1) --[[ stringrandom | Line: 11 ]]
	local v1 = ""
	for i = 1, p1 do
		v1 = v1 .. string.char(math.random(97, 122))
	end
	return v1
end
function comma_value(p1) --[[ comma_value | Line: 18 ]]
	local v1 = p1
	local v2
	while true do
		local v3
		v2, v3 = string.gsub(v1, "^(-?%d+)(%d%d%d)", "%1,%2")
		if v3 == 0 then
			break
		end
		v1 = v2
	end
	return v2
end
destroyAsync.Event:Connect(function(...) --[[ Line: 29 | Upvalues: RequestDestroy (copy) ]]
	local t = { ... }
	if type(t[1]) == "table" then
		t[1].Reciept = stringrandom(10)
		RequestDestroy:FireServer(t[1])
		return
	end
	if type(t[1]) ~= "string" or not t[2] then
		return
	end
	local t2 = {
		Reciept = stringrandom(10)
	}
	t2.Position = if type(t[2]) == "table" then t[2] else { t[2] }
	t2.Damage = {
		DamageType = t[1]
	}
	RequestDestroy:FireServer(t2)
end)
local t = {
	isShown = false,
	addition = 0,
	gui = game.Players.LocalPlayer.PlayerGui:WaitForChild("Main"):WaitForChild("voxelsDamaged"),
	showVoxelBrokeGui = LocalPlayer.PlayerScripts:WaitForChild("Settings"):WaitForChild("showVoxelBrokeGui")
}
t.gui.amount.Value:GetPropertyChangedSignal("Value"):Connect(function() --[[ Line: 51 | Upvalues: t (copy) ]]
	local v1 = comma_value
	t.gui.amount.Text = v1(math.ceil(t.gui.amount.Value.Value) .. " Voxels")
end)
RequestDestroy.OnClientEvent:Connect(function(p1, p2, p3) --[[ Line: 54 | Upvalues: t (copy), TweenService (copy) ]]
	if p1 == "processed" then
		return
	end
	if p1 ~= "amount" and p1 ~= "amount_special" then
		return
	end
	if not t.showVoxelBrokeGui.Value then
		return
	end
	local function closeMiniEarnedGui(p1) --[[ closeMiniEarnedGui | Line: 57 | Upvalues: TweenService (ref) ]]
		if not p1:GetAttribute("closing") and p1:IsA("TextLabel") then
			p1:SetAttribute("closing", true)
			TweenService:Create(p1.UIScale, TweenInfo.new(0.4), {
				Scale = 0
			}):Play()
			TweenService:Create(p1, TweenInfo.new(0.4), {
				TextTransparency = 1
			}):Play()
			task.delay(0.4, function() --[[ Line: 62 | Upvalues: p1 (copy) ]]
				p1:Destroy()
			end)
		end
	end
	local extra = t.gui:WaitForChild("extra")
	if p1 == "amount_special" then
		local aa = t.gui.extra.UIListLayout.aa
		for v1, v2 in p2 do
			local v3 = extra:FindFirstChild(v1)
			if v3 and (not v3:GetAttribute("closing") and v3:IsA("TextLabel")) then
				local v4 = v3.Value
				v4.Value = v4.Value + v2
				local v5 = comma_value
				v3.Text = ("+ %* %*"):format(v5((math.ceil(v3.Value.Value))), v1)
				v3.age.Value = 30
				continue
			end
			local v6 = aa:Clone()
			v6.age.Value = 30
			v6.Name = v1
			v6.UIScale.Scale = 0
			v6.Text = ("+ %* %*"):format(comma_value((math.ceil(v2))), v1)
			v6.Value.Value = v2
			v6.Parent = extra
			TweenService:Create(v6.UIScale, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
				Scale = 1
			}):Play()
		end
		p2 = 0
	elseif p2 <= 0 then
		return
	end
	if not t.isShown then
		TweenService:Create(t.gui.amount, TweenInfo.new(0.2), {
			TextTransparency = 0,
			TextStrokeTransparency = 0
		}):Play()
		t.addition = p2
		t.isShown = 35
		t.gui.amount.Value.Value = 0
		TweenService:Create(t.gui.amount.Value, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
			Value = t.addition
		}):Play()
		spawn(function() --[[ Line: 96 | Upvalues: extra (copy), closeMiniEarnedGui (copy), t (ref), TweenService (ref) ]]
			repeat
				if not task.wait(0.1) then
					TweenService:Create(t.gui.amount, TweenInfo.new(0.2), {
						TextTransparency = 1,
						TextStrokeTransparency = 1
					}):Play()
					TweenService:Create(t.gui.add, TweenInfo.new(0.2), {
						TextTransparency = 1,
						TextStrokeTransparency = 1
					}):Play()
					t.isShown = nil
					return
				end
				for v1, v2 in extra:GetChildren() do
					if not v2:GetAttribute("closing") and v2:IsA("TextLabel") then
						local age = v2.age
						age.Value = age.Value - 1
						if v2.age.Value <= 0 then
							closeMiniEarnedGui(v2)
						end
					end
				end
				local v3 = t
				v3.isShown = v3.isShown - 1
			until t.isShown <= 0
			for v4, v5 in extra:GetChildren() do
				closeMiniEarnedGui(v5)
			end
			TweenService:Create(t.gui.amount, TweenInfo.new(0.2), {
				TextTransparency = 1,
				TextStrokeTransparency = 1
			}):Play()
			TweenService:Create(t.gui.add, TweenInfo.new(0.2), {
				TextTransparency = 1,
				TextStrokeTransparency = 1
			}):Play()
			t.isShown = nil
		end)
		return
	end
	local gui = t.gui
	t.isShown = 35
	local v7 = t
	v7.addition = v7.addition + p2
	gui.add.Size = UDim2.new(1, 0, 0, 15)
	TweenService:Create(gui.add, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
		Size = UDim2.new(1, 0, 0, 20)
	}):Play()
	gui.add.Text = "+" .. comma_value((math.ceil(p2)))
	TweenService:Create(gui.add, TweenInfo.new(0.2), {
		TextTransparency = 0,
		TextStrokeTransparency = 0
	}):Play()
	TweenService:Create(gui.amount.Value, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
		Value = t.addition
	}):Play()
end)
local t2 = {}
local Stepped = game:GetService("RunService").Stepped
local t3 = { workspace:WaitForChild("GlobalParts") }
local v1 = OverlapParams.new()
v1.FilterType = Enum.RaycastFilterType.Include
v1.FilterDescendantsInstances = t3
function getPartVolume(p1) --[[ getPartVolume | Line: 136 ]]
	return p1:GetMass() / PhysicalProperties.new(p1.Material).Density
end
local function updateCheck() --[[ updateCheck | Line: 139 | Upvalues: t2 (copy), v1 (copy) ]]
	local v12 = os.clock()
	for v2, v3 in t2 do
		local v4 = v3[1]
		local Color = v4.Color
		local Material = v4.Material
		if v3[2] < v12 then
			v3[1]:Destroy()
			table.remove(t2, v2)
			continue
		end
		v4.Size = v4.Size - Vector3.new(0.1, 0.1, 0.1)
		local v5 = workspace:GetPartsInPart(v4, v1)
		v4.Size = v4.Size + Vector3.new(0.1, 0.1, 0.1)
		local sum = 0
		for v6, v7 in v5 do
			if v7.Anchored and (v7.Material == Material and v7.Color == Color) then
				sum = sum + getPartVolume(v7)
			end
		end
		if v3[3] / 4 <= sum then
			v4:Destroy()
			table.remove(t2, v2)
		end
	end
end
GlobalParts.ChildRemoved:Connect(function(p1) --[[ Line: 169 | Upvalues: Camera (copy), t2 (copy) ]]
	local v1 = p1:IsA("BasePart") and p1.Size
	if not (v1 and (v1.X + v1.Y + v1.Z > 30 and (p1.Anchored and p1.Position.Y - Camera.CFrame.Position.Y < -5))) then
		return
	end
	p1.Archivable = true
	local placeHolder = p1:Clone()
	placeHolder.Transparency = 0.5
	placeHolder.Anchored = true
	placeHolder.Name = "placeHolder"
	placeHolder.CollisionGroup = "antiStuck"
	placeHolder.Parent = workspace.ClientDebris
	t2[#t2 + 1] = { placeHolder, os.clock() + 2, getPartVolume(placeHolder) }
end)
while task.wait(0.1) do
	updateCheck()
end
