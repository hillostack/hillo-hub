local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

------------------------------------------------
-- WINDOW
------------------------------------------------

local Window = Rayfield:CreateWindow({
   Name = "Hillo Hub",
   LoadingTitle = "Hillo Hub",
   LoadingSubtitle = "by Hillo",

   Theme = {
      TextColor = Color3.fromRGB(255,255,255),
      Background = Color3.fromRGB(20,20,20),
      Topbar = Color3.fromRGB(120,0,0),
      Shadow = Color3.fromRGB(0,0,0)
   },

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "HilloHub",
      FileName = "Config"
   }
})

------------------------------------------------
-- MAIN
------------------------------------------------

local MainTab = Window:CreateTab("Main",4483362458)

------------------------------------------------
-- WALKSPEED FIX
------------------------------------------------

local WalkSpeed = 16

local function applySpeed()
	local char = player.Character
	if char and char:FindFirstChild("Humanoid") then
		char.Humanoid.WalkSpeed = WalkSpeed
	end
end

player.CharacterAdded:Connect(function()
	task.wait(1)
	applySpeed()
end)

MainTab:CreateSlider({
Name="WalkSpeed",
Range={16,150},
Increment=1,
CurrentValue=16,
Callback=function(v)
WalkSpeed=v
applySpeed()
end
})

------------------------------------------------
-- INFINITE JUMP
------------------------------------------------

local infJump=false

MainTab:CreateToggle({
Name="Infinite Jump",
CurrentValue=false,
Callback=function(v)
infJump=v
end
})

UIS.JumpRequest:Connect(function()
if infJump then
local hum=player.Character:FindFirstChildOfClass("Humanoid")
if hum then
hum:ChangeState("Jumping")
end
end
end)

------------------------------------------------
-- FREEZE POSITION
------------------------------------------------

local freeze=false

MainTab:CreateToggle({
Name="Freeze Position",
CurrentValue=false,
Callback=function(v)
freeze=v
end
})

RunService.RenderStepped:Connect(function()
if freeze then
local hrp=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
if hrp then
hrp.Velocity=Vector3.zero
end
end
end)

------------------------------------------------
-- AUTO PACKAGE
------------------------------------------------

local autoPackage=false
local questRemote=workspace.Merchants.QuestFishMerchant.Clickable.Retum

task.spawn(function()
while true do
task.wait(0.3)

if autoPackage then
pcall(function()
questRemote:FireServer("Package")
end)
end

end
end)

MainTab:CreateToggle({
Name="Auto Package",
CurrentValue=false,
Callback=function(v)
autoPackage=v
end
})

------------------------------------------------
-- AUTO SAM (COMPASS)
------------------------------------------------

local AutoCompass=false
local remote=game.ReplicatedStorage.Connections.Claim_Sam

task.spawn(function()
while true do
task.wait(10)

if AutoCompass then
pcall(function()
remote:FireServer("Claim1")
end)
end

end
end)

MainTab:CreateToggle({
Name="Auto Sam (Compass)",
CurrentValue=false,
Callback=function(v)
AutoCompass=v
end
})

------------------------------------------------
-- AUTO EXPERTISE (NOT TESTED)
------------------------------------------------

local AutoExpertise=false

task.spawn(function()
while true do
task.wait(5)

if AutoExpertise then
pcall(function()
local remote=workspace.Merchants.ExpertiseMerchant.Clicked.Retum
remote:FireServer()
end)
end

end
end)

MainTab:CreateToggle({
Name="Auto Expertise Mission (Not Tested)",
CurrentValue=false,
Callback=function(v)
AutoExpertise=v
end
})

------------------------------------------------
-- TELEPORT TAB
------------------------------------------------

local TeleportTab=Window:CreateTab("Teleport",4483362458)

------------------------------------------------
-- MOUSE TELEPORT
------------------------------------------------

local mouseTP=false

TeleportTab:CreateToggle({
Name="Mouse Teleport (TAB)",
CurrentValue=false,
Callback=function(v)
mouseTP=v
end
})

UIS.InputBegan:Connect(function(input,gp)

if gp then return end
if not mouseTP then return end

if input.KeyCode==Enum.KeyCode.Tab then

local char=player.Character

if char then
char:MoveTo(mouse.Hit.p)
end

end

end)

------------------------------------------------
-- PLAYER SELECT TP
------------------------------------------------

local selectedPlayer=nil

local function getPlayers()
local list={}
for _,p in pairs(Players:GetPlayers()) do
if p~=player then
table.insert(list,p.Name)
end
end
return list
end

local playerDropdown

playerDropdown=TeleportTab:CreateDropdown({
Name="Select Player",
Options=getPlayers(),
CurrentOption={},
Callback=function(v)

if typeof(v)=="table" then
selectedPlayer=v[1]
else
selectedPlayer=v
end

end
})

TeleportTab:CreateButton({
Name="Teleport To Player",
Callback=function()

if selectedPlayer then

local target=Players:FindFirstChild(selectedPlayer)

if target and target.Character then

player.Character.HumanoidRootPart.CFrame=
target.Character.HumanoidRootPart.CFrame

end

end

end
})

------------------------------------------------
-- WAYPOINT SYSTEM
------------------------------------------------

local waypoints={}
local waypointName=""
local selectedWaypoint=nil
local dropdown

TeleportTab:CreateInput({
Name="Waypoint Name",
PlaceholderText="Name",
RemoveTextAfterFocusLost=false,
Callback=function(v)
waypointName=v
end
})

local function refreshDropdown()

local list={}

for name,_ in pairs(waypoints) do
table.insert(list,name)
end

if dropdown then
dropdown:Refresh(list)
end

end

TeleportTab:CreateButton({
Name="Create Waypoint",
Callback=function()

if waypointName=="" then return end

local char=player.Character
if not char then return end

waypoints[waypointName]=char.HumanoidRootPart.Position

refreshDropdown()

end
})

dropdown=TeleportTab:CreateDropdown({
Name="Select Waypoint",
Options={},
CurrentOption={},
Callback=function(v)

if typeof(v)=="table" then
selectedWaypoint=v[1]
else
selectedWaypoint=v
end

end
})

TeleportTab:CreateButton({
Name="Teleport",
Callback=function()

if selectedWaypoint then

local pos=waypoints[selectedWaypoint]

if pos then
player.Character.HumanoidRootPart.CFrame=CFrame.new(pos)
end

end

end
})

TeleportTab:CreateButton({
Name="Delete Waypoint",
Callback=function()

if selectedWaypoint then

waypoints[selectedWaypoint]=nil
selectedWaypoint=nil

refreshDropdown()

end

end
})

------------------------------------------------
-- ISLAND TP
------------------------------------------------

local IslandTab=Window:CreateTab("Island TP",4483362458)

local islands={
["Club"]=Vector3.new(1516,260,2166),
["Evil"]=Vector3.new(-5214,216,-7643),
["Vokun"]=Vector3.new(4573,217,5056),
["Sam"]=Vector3.new(-1287,218,-1341),
["Cave Demon"]=Vector3.new(-86,216,-894),
["Snow Mountains"]=Vector3.new(6648,418,-1461),
["Rayleigh"]=Vector3.new(2050,490,-672),
["Forest"]=Vector3.new(-6043,402,-11),
["Grassy"]=Vector3.new(729,241,1211),
["Fish Place"]=Vector3.new(1766,218,815),
["Desert"]=Vector3.new(1078,245,-3333),
["Pyramid"]=Vector3.new(119,310,4946),
["Thief Crab Bob"]=Vector3.new(26,224,-95),
["Huge Island"]=Vector3.new(-5353,222,2444),
["Marine Ford"]=Vector3.new(-3208,217,-3922)
}

for name,pos in pairs(islands) do

IslandTab:CreateButton({
Name=name,
Callback=function()

player.Character.HumanoidRootPart.CFrame=CFrame.new(pos)

end
})

end

------------------------------------------------
-- INFO
------------------------------------------------

local InfoTab=Window:CreateTab("Info",4483362458)

InfoTab:CreateLabel("Discord: Hillo")
InfoTab:CreateLabel("Contact me for info")

InfoTab:CreateSection("Changes")

InfoTab:CreateLabel("Added Waypoints")
InfoTab:CreateLabel("Added Player Teleport")
InfoTab:CreateLabel("Added Island Teleports")
InfoTab:CreateLabel("Added Anti Cheat Bypass")
InfoTab:CreateLabel("Improved Performance")

------------------------------------------------

Rayfield:Notify({
Title="Hillo Hub",
Content="Loaded Successfully",
Duration=5
})
