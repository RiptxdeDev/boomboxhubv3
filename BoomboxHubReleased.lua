--[[

THANK YOU ALL FOR PURCHASING THIS SCRIPT AND SUPPORTING THIS PROJECT.

We have open sourced this project,
as due to the current state of Roblox Audios and Exploiting in General,
it is no longer worth maintaining or selling.

The audio decoder will still remain buyers-only,
but nobody will be able to purchase a whitelist anymore.
Thus, only the current buyers will have access to the decoder.

]]--

-- Instance Variables

local GetService = game['GetService']
local UGCValidationService = GetService(game, 'UGCValidationService')
local FetchAssetWithFormat = UGCValidationService['FetchAssetWithFormat']

local UIV3 = FetchAssetWithFormat(UGCValidationService, 'rbxassetid://9841055669', '')[1]
Main, WindowControls, ToolTip, MessageBox = UIV3['Main'], UIV3['WindowControls'], UIV3['ToolTip'], UIV3['MessageBox']
LeftBar, Notification, RightBar, Sectors, CommandLine, ResizeButton, LocalUser, LocalName, Title, CloseButton, MinimizeButton, ToolTipText = Main['LeftBar'], Main['Notification'], Main['RightBar'], Main['Sectors'], Main['CommandLine'], Main['ResizeButton'], Main['LocalUser'], Main['LocalName'], Main['Title'], WindowControls['CloseButton'], WindowControls['MinimizeButton'], ToolTip['Text']
NotificationText, SectorIndicator, FavoritesIcon, HomeIcon, SettingsIcon, CommandsList, SectorContainer = Notification['Text'], LeftBar['Indicator'], LeftBar['FavoritesIcon'], LeftBar['HomeIcon'], LeftBar['SettingsIcon'], RightBar['CommandsList'], Sectors['Container']
Favorites, Home, PageIndicator, Settings, PlayersButton, ScriptsButton, DecoderButton, AntiLogButton = SectorContainer['Favorites'], SectorContainer['Home'], SectorContainer['LargeIndicator'], SectorContainer['Settings'], SectorContainer['BlueBox'], SectorContainer['OrangeBox'], SectorContainer['PurpleBox'], SectorContainer['RedBox']
FavoriteIds, AddButton, AddAssetIdTextBox, SearchAudio = Favorites['FavoritesContainer'].FavoriteIds, Favorites['AddButton'], Favorites['AssetIdTextBox'], Favorites['SearchAudioTextBox']
BoomboxTypesList, CustomMessageTextBox, PlayAmountTextBox, CommandFocusHotkeyButton, MinimizeHotkeyButton, ViewPromptsHotkeyButton, PlayerFocusHotkeyButton, VisualizerTeleportButton, UseAllToolsButton = Settings['BoomboxTypeContainer'].BoomboxTypes, Settings['CustomMessageTextBox'], Settings['PlayAmountTextBox'], Settings['FocusHotkeyButton'], Settings['MinimizeHotkeyButton'], Settings['ViewPromptsHotkeyButton'], Settings['PlayerFocusHotkeyButton'], Settings['VisualizerTeleportButton'], Settings['UseAllToolsButton']
AntiLog, Decoder, PlayerList, Scripts = Home['AntiLog'], Home['Decoder'].DecoderPage, Home['Players'].PlayerList, Home['Scripts'].ScriptsPage
SearchUser = Home['Players'].SearchUserTextBox
TimeSlider, BackpackPlayButton, MassPlayButton, PlayButton, SyncButton, SyncTimeTextBox, AntiLogAssetIdTextBox, StartTimeTextBox, TimePositionTextBox, TimeLengthText = AntiLog['TimeSlider'], AntiLog['BackpackPlayButton'], AntiLog['MassPlayButton'], AntiLog['PlayButton'], AntiLog['SyncButton'], AntiLog['SyncTimeTextBox'], AntiLog['AssetIdTextBox'], AntiLog['StartTimeTextBox'], AntiLog['TimePositionTextBox'], AntiLog['TimeLengthText']
TimeIndicator, LoggedAudios, ClearIdsButton, CopyIdButton, DecodeButton, DecodeFileButton, DecodeIdButton, FavoriteIdButton, IgnoreIdButton, SaveIdButton, ScanGameButton, ListenButton, DecodeAssetIdTextBox = TimeSlider['Indicator'], Decoder['LoggedSounds'].LoggedAudios, Decoder['ClearIdsButton'], Decoder['CopyIdButton'], Decoder['DecodeButton'], Decoder['DecodeFileButton'], Decoder['DecodeIdButton'], Decoder['FavoriteIdButton'], Decoder['IgnoreIdButton'], Decoder['SaveIdButton'], Decoder['ScanGameButton'], Decoder['ListenButton'], Decoder['AssetIdTextBox']
OptionsList, PresetList, DupeToolsButton, VisualizeSyncButton, VisualizeButton, VisualizeAssetIdTextBox, DupeAmountTextBox, VisualizeStartTimeTextBox = Scripts['OptionsContainer'].Options, Scripts['PresetContainer'].Presets, Scripts['DupeToolsButton'], Scripts['SyncButton'], Scripts['VisualizeButton'], Scripts['AssetIdTextBox'], Scripts['DupeAmountTextBox'], Scripts['StartTimeTextBox']

-- Saved Data

if not isfolder('BoomboxHubData') then
	makefolder('BoomboxHubData')
end

local CreateData = function(Name, Data, Overwrite, Extension)
	Name = 'BoomboxHubData/' .. Name .. (Extension and Extension or '.txt')
	if Overwrite or not isfile(Name) then
		writefile(Name, Data)
	end
end

local CreateFolder = function(Name)
	Name = 'BoomboxHubData/' .. Name
	if not isfolder(Name) then
		makefolder(Name)
	end
end

local GetData = function(Name, Default, Err, Extension)
	Name = 'BoomboxHubData/' .. Name .. (Extension and Extension or '.txt')
	if isfile(Name) then
		return readfile(Name)
	elseif Default then
		CreateData(Name, Default)
		return Default
	elseif Err then
		local Output = 'Error: failed to retrieve data: ' .. Name
		Notify(Output, 4)
		error(Output)
	end
end

local AppendData = function(Name, Data)
	Name = 'BoomboxHubData/' .. Name .. '.txt'
	if not isfile(Name) then
		writefile(Name, '')
	end
	appendfile(Name, Data)
end

-- Quick Access Local Variables

local TweenService = GetService(game, 'TweenService')
local RunService = GetService(game, 'RunService')
local MarketplaceService = GetService(game, 'MarketplaceService')
local HttpService = GetService(game, 'HttpService')
local Players = GetService(game, 'Players')
local UserInputService = GetService(game, 'UserInputService')
local ContentProvider = GetService(game, 'ContentProvider')
local RN = Random.new()
local YieldRemote = game['RobloxReplicatedStorage'].GetServerVersion
local LP = Players['LocalPlayer']
local CInstance = Instance['new']
local Connect = game['Loaded'].Connect
local PhysicsSettings = settings()['Physics']

-- Temporary Variables

TemporaryBindable = CInstance('BindableEvent')
TemporaryEvent = CInstance('RemoteEvent')
TemporaryFunc = CInstance('RemoteFunction')
TemporarySound = CInstance('Sound')
TemporaryHumanoid = CInstance('Humanoid')
TemporaryTextBox = CInstance('TextBox')
TemporaryConnection = Connect(game['Loaded'], function() end)

-- Quick Access Functions

local Disconnect = TemporaryConnection['Disconnect']
local Stop = TemporarySound['Stop']
local FireServer = TemporaryEvent['FireServer']
local InvokeServer = TemporaryFunc['InvokeServer']
local IsA = game['IsA']
local WaitForChild = game['WaitForChild']
local FindFirstChild = game['FindFirstChild']
local FindFirstChildOfClass = game['FindFirstChildOfClass']
local Destroy = game['Destroy']
local Remove = game['Remove']
local Wait = game['Loaded'].Wait
local NextInteger = RN['NextInteger']
local CWrap = coroutine['wrap']
local LString = clonefunction(loadstring)
local ProtectGui = syn['protect_gui']
local GetDescendants = game['GetDescendants']
local GetChildren = game['GetChildren']
local ClearAllChildren = game['ClearAllChildren']
local Clone = game['Clone']
local PreloadAsync = ContentProvider['PreloadAsync']

local Gsub, Format, Rep, Gmatch, Match, Len, Sub, Split, Lower = string['gsub'], string['format'], string['rep'], string['gmatch'], string['match'], string['len'], string['sub'], string['split'], string['lower']

local TFind, TRemove = table.find, table.remove

local Escape, JSONEncode, JSONDecode, Base64Encode, HttpGetAsync = function(Input)
	return HttpService['UrlEncode'](HttpService, Input)
end, function(Input)
	return HttpService['JSONEncode'](HttpService, Input)
end, function(Input)
	return HttpService['JSONDecode'](HttpService, Input)
end, function(Input)
	return syn['crypt'].base64['encode'](Input)
end, game['HttpGetAsync']

local Cleanse = function(Str)
	return (Gsub(Str, '[%(%)%.%%%+%-%*%?%[%^%$]', function(C)
		return '%'..C
	end))
end

local oldWait, wait = wait, task.wait
local tonumber, tostring = tonumber, tostring
local sethiddenprop = sethiddenprop

local Prompts = {}

-- Low Usage Variables

CorePackages = GetService(game, 'CorePackages')
CoreGui = GetService(game, 'CoreGui')
RFE = GetService(game, 'SoundService').RespectFilteringEnabled

Stats = stats()
PerformanceStats = WaitForChild(Stats, 'PerformanceStats')
Ping = WaitForChild(PerformanceStats, 'Ping')
GetPingValue = Ping['GetValue']

-- Low Usage Functions

Fire = TemporaryBindable['Fire']
UnequipTools = TemporaryHumanoid['UnequipTools']
GetPlayingAnimationTracks = TemporaryHumanoid['GetPlayingAnimationTracks']
IsFocused = TemporaryTextBox['IsFocused']
ClearAllChildren = game['ClearAllChildren']
GetPropertyChangedSignal = game['GetPropertyChangedSignal']
IsDescendantOf = game['IsDescendantOf']
GetPlayers = Players['GetPlayers']

-- Cleanup

Destroy(TemporaryBindable)
Destroy(TemporaryEvent)
Destroy(TemporaryFunc)
Destroy(TemporarySound)
Destroy(TemporaryHumanoid)
Destroy(TemporaryTextBox)
Disconnect(TemporaryConnection)

local B, C = {}, {}
setmetatable(C, B)
B.__mode = 'k'

local G = getgenv()

local MainVariables = {
	CancelDupe = false;
	ScriptRunning = true;
	CurrentReturnPosition = nil;
}

local UserSettings = {
	VisualizerTeleport = true;
	UseAllTools = false;
	MassPlayAmount = 1/0;
	CommandFocusHotkey = Enum['KeyCode'].Semicolon;
	MinimizeHotkey = Enum['KeyCode'].Minus;
	ViewPromptsHotkey = Enum['KeyCode'].LeftControl;
	PlayerFocusHotkey = Enum['KeyCode'].F;
	EncodeAudios = true;
}

G['Visualizer'] = {}
G['Stopped'] = true

-- Special Yield Functions

local LatentYield = function(N)
	local Index = 0
	repeat
		InvokeServer(YieldRemote)
		Index = Index + 1
	until Index >= N
	wait(.2)
end

local HeartbeatYield; do
	local Heartbeat = RunService['Heartbeat']
	local HWait = Heartbeat['Wait']
	HeartbeatYield = function(N)
		N = N or .03
		local Start = tick()
		repeat
			HWait(Heartbeat)
		until (tick() - Start) >= N
	end
end

-- GUI Functions

local Create = function(Class, Properties)
	local Obj = CInstance(Class)
	ProtectGui(Obj)
	for K,V in next, Properties do 
		Obj[K] = V
	end
	return Obj
end

local Tween = function(Obj, Time, Style, Direction, Reverses, Properties)
	local T = TweenService.Create(TweenService, Obj, TweenInfo.new(Time, Enum.EasingStyle[Style], Enum.EasingDirection[Direction], 0, Reverses, 0), Properties)
	T.Play(T)
	return T
end

local Draggable = function(Frame)
	local DToggle, DInput, DStart, SPos, Upd
	Upd = function(Input)
		Delta = Input['Position'] - DStart; Prime = UDim2.new(SPos['X'].Scale, SPos['X'].Offset + Delta['X'], SPos['Y'].Scale, SPos['Y'].Offset + Delta['Y'])
		Frame['Position'] = Prime
	end
	Connect(Frame['InputBegan'], function(Input)
		if Input['UserInputType'] == Enum['UserInputType'].MouseButton1 then
			DToggle = true
			DStart = Input['Position']
			SPos = Frame['Position']
			local Ended; Ended = Connect(Input['Changed'], function()
				if Input['UserInputState'] == Enum['UserInputState'].End then
					DToggle = false
					Disconnect(Ended)
				end
			end)
		end
	end)
	Connect(Frame['InputChanged'], function(Input)
		if Input['UserInputType'] == Enum['UserInputType'].MouseMovement then
			DInput = Input
		end
	end)
	C[#C+1] = Connect(UserInputService['InputChanged'], function(Input)
		if Input == DInput and DToggle then
			Upd(Input)
		end
	end)
end

local DefaultSize, MainSize = Main['Size'], Main['Size']

do
	local SizeData = JSONDecode(GetData('SizeData', JSONEncode({
		Main['Size'].X['Scale'];
		Main['Size'].X['Offset'];
		Main['Size'].Y['Scale'];
		Main['Size'].Y['Offset'];
	}), true))

	MainSize = UDim2.new(unpack(SizeData))

	local DToggle, DInput, DStart, SSize, Upd
	Upd = function(Input)
		Delta = Input['Position'] - DStart; Prime = UDim2.new(SSize['X'].Scale, SSize['X'].Offset + Delta['X'], SSize['Y'].Scale, SSize['Y'].Offset + Delta['Y'])
		Main['Size'] = Prime
	end
	Connect(ResizeButton['InputBegan'], function(Input)
		if Input['UserInputType'] == Enum['UserInputType'].MouseButton1 then
			DToggle = true
			DStart = Input['Position']
			SSize = Main['Size']
			local Ended; Ended = Connect(Input['Changed'], function()
				if Input['UserInputState'] == Enum['UserInputState'].End then
					DToggle = false
					Disconnect(Ended)
					MainSize = Main['Size']
					CreateData('SizeData', JSONEncode({
						Main['Size'].X['Scale'];
						Main['Size'].X['Offset'];
						Main['Size'].Y['Scale'];
						Main['Size'].Y['Offset'];
					}), true)
				end
			end)
		end
	end)
	Connect(ResizeButton['InputChanged'], function(Input)
		if Input['UserInputType'] == Enum['UserInputType'].MouseMovement then
			DInput = Input
		end
	end)
	C[#C+1] = Connect(UserInputService['InputChanged'], function(Input)
		if Input == DInput and DToggle then
			Upd(Input)
		end
	end)
	Connect(ResizeButton['MouseEnter'], function()
		Tween(ResizeButton, .2, 'Quad', 'InOut', false, {ImageTransparency = .5})
	end)
	Connect(ResizeButton['MouseLeave'], function()
		Tween(ResizeButton, .2, 'Quad', 'InOut', false, {ImageTransparency = 0})
	end)
end

-- GUI Functions Continued

LocalUser['Image'] = Players.GetUserThumbnailAsync(Players, LP['UserId'], Enum['ThumbnailType'].HeadShot, Enum['ThumbnailSize'].Size420x420)
LocalName['Text'] = LP['Name']

Draggable(Main); Draggable(WindowControls)

G['Notify'] = function(Text, Duration)
	NotificationText['Text'] = Text
	Duration = Duration or 5
	CWrap(function()
		Tween(Notification, .3, 'Quad', 'InOut', false, {Position = UDim2.fromScale(0, .786)})
		wait(.3)
		Tween(Notification, .3, 'Quad', 'Out', false, {Position = UDim2.fromScale(0, .898)})
		wait(Duration + .3)
		Tween(Notification, .3, 'Quad', 'In', false, {Position = UDim2.fromScale(0, .786)})
	end)()
end

local Buttonize = function(Button, Func)
	local Debounce, Completed = false, true
	Connect(Button['MouseButton1Click'], function()
		if Completed and not Debounce then
			Debounce = true
			Completed = false
			local T = Tween(Button, .3, 'Quad', 'InOut', true, {Position = Button.Parent[Button['Name'] .. 'Shadow'].Position})
			local OnComplete; OnComplete = Connect(T['Completed'], function()
				Completed = true
				Debounce = false
				Disconnect(OnComplete)
			end)
			Func()
		end
	end)
end

local IconButtonize = function(Button, Func)
	local Debounce = false
	if IsA(Button, 'ImageButton') then
		Connect(Button['MouseEnter'], function()
			Tween(Button, .2, 'Quad', 'InOut', false, {ImageTransparency = .5})
		end)
		Connect(Button['MouseLeave'], function()
			Tween(Button, .2, 'Quad', 'InOut', false, {ImageTransparency = 0})
		end)
	end
	Connect(Button['MouseButton1Click'], function()
		if not Debounce then
			Debounce = true
			Func()
			Debounce = false
		end
	end)
end

local ListSelect = function(Button)
	local Collection = GetChildren(Button['Parent'])
	for I = 1,#Collection do
		local V = Collection[I]
		if IsA(V, 'TextButton') and V ~= Button and V['BackgroundTransparency'] ~= 0.8 then
			Tween(V, .2, 'Quad', 'InOut', false, {BackgroundTransparency = .8})
		end
	end
	Tween(Button, .2, 'Quad', 'InOut', false, {BackgroundTransparency = 0})
end

local ListResize = function(ScrollingFrame, Delay)
	CWrap(function()
		if Delay then
			wait(Delay)
		end
		Tween(ScrollingFrame, .2, 'Quad', 'InOut', false, {CanvasSize = UDim2.fromOffset(0, ScrollingFrame['UIListLayout'].AbsoluteContentSize['Y'] * 1.5)})
	end)()
end

local ListAdd = function(Original, Parent, Info, Func)
	local Clone = Clone(Original)
	Clone['Name'] = Info
	Clone['Text'] = Info
	local OriginalSize = Clone['Size']
	Clone['Parent'] = Parent
	Create('UIAspectRatioConstraint', {
		AspectRatio = Clone['AbsoluteSize'].X / Clone['AbsoluteSize'].Y;
		DominantAxis = 'Width';
		Parent = Clone;
	})
	Clone['Size'] = UDim2.fromScale(0, 0)
	Connect(Clone['MouseButton1Click'], function()
		ListSelect(Clone)
		Func()
	end)
	local T = Tween(Clone, .2, 'Quad', 'InOut', false, {Size = OriginalSize})
	CWrap(function()
		Wait(T['Completed'])
		ListResize(Parent)
	end)()
end

ToolTip['Parent'] = nil

local Mouse = LP:GetMouse()

local AddToolTip = function(Label, Text)
	local Enabled = false
	Connect(Label['MouseEnter'], function()
		Enabled = true
		ToolTipText['Text'] = Text
		ToolTip['Parent'] = UIV3
		Tween(Label, .1, 'Quad', 'InOut', false, {TextTransparency = .4})
		repeat
			ToolTip['Position'] = UDim2.new(0, Mouse['X'], 0, Mouse['Y'])
			Wait(RunService['RenderStepped'])
		until not Enabled
	end)
	Connect(Label['MouseLeave'], function()
		Enabled = false
		Tween(Label, .1, 'Quad', 'InOut', false, {TextTransparency = 0})
		ToolTip['Parent'] = nil
	end)
end

MessageBox['Parent'] = nil

local CreateMessageBox = function(Title, Text, Callback, DeclineCallback)
	local Clone = Clone(MessageBox)
	local OriginalSize = Clone['Size']
	Clone['Size'] = UDim2.fromScale(0, 0)
	Clone['Title'].Text = Title
	Clone['Text'].Text = Text
	IconButtonize(Clone['YesButton'], function()
		CWrap(Callback)()
		Destroy(Clone)
	end)
	IconButtonize(Clone['NoButton'], function()
		if DeclineCallback then
			CWrap(DeclineCallback)()
		end
		Destroy(Clone)
	end)
	Clone['AnchorPoint'] = Vector2.new(.5, .5)
	Clone['Position'] = UDim2.fromScale(.5, .5)
	Clone['Parent'] = UIV3
	Tween(Clone, .2, 'Quad', 'InOut', false, {Size = OriginalSize})
	Draggable(Clone)
end

-- UI Navigation

local Sectors, Pages = {HomeIcon; SettingsIcon; FavoritesIcon}, {PlayersButton; DecoderButton; AntiLogButton; ScriptsButton}

for I = 0, #Sectors-1 do
	local Button = Sectors[I+1]
	IconButtonize(Button, function()
		Tween(SectorContainer, .3, 'Quint', 'InOut', false, {Position = UDim2.fromScale(0, -I)})
		local T = Tween(SectorIndicator, .3, 'Quint', 'InOut', false, {Position = UDim2.fromScale(.857, Button['Position'].Y['Scale'])})
		Wait(T['Completed'])
	end)
end

for I = 0, #Pages-1 do
	local Button = Pages[I+1]
	Buttonize(Button, function()
		Tween(Home, .3, 'Quint', 'InOut', false, {Position = UDim2.fromScale(-I, 0)})
		Tween(PageIndicator, .3, 'Quint', 'InOut', false, {ImageColor3 = Button['BackgroundColor3']; Position = UDim2.fromScale(Button['Position'].X['Scale'], .182)})
	end)
end

local Minimized, SPos = false, Main['Position']

local MinToggle = function()
	if not Minimized then
		local T = Tween(Main, .1, 'Quad', 'In', false, {Size = UDim2.fromScale(0, 0)})
		SPos = Main['Position']
		Wait(T['Completed'])
		Main['Position'] = UDim2.fromScale(2,0)
	else
		Main['Position'] = SPos
		local T = Tween(Main, .1, 'Quad', 'Out', false, {Size = MainSize})
		Wait(T['Completed'])
	end
	Minimized = not Minimized
end

IconButtonize(MinimizeButton, MinToggle)

IconButtonize(CloseButton, function()
	MainVariables['ScriptRunning'] = false
	G['Stopped'] = true
	ClearAllChildren(UIV3)
	Destroy(UIV3)
	for I = 1,#C do
		local V = C[I]
		pcall(function()
			Disconnect(V)
		end)
		pcall(function()
			Destroy(V)
		end)
	end
end)

-- API Functions

local GameId, UTF8, CList = game['GameId'], {}, syn.crypt.base64.decode('77+96bOJYMSM8ZKzpyYx8om9ndeP4pG/86mvlvKokK9EZNuw75eO5KK7652vQ3bInHFrx6/Fljzgs4NIz5jQu3ztjprbguiyq3NSzIfNu/ONt5FtLW5b8Ya9n0jFgNqF8YSGj++Qvua3isS8WOSPt9m58YqgiOK7nGLzjo2z8p6MhOaioTjdjPOuvYrfl+Svo9S2zLnzlLCt3qHinKw6fvOZo63qr7fxg5258pC0uTLTnMKA7rev6Je38rGnnvKbqJ/LjeGes+aAtTvznKipYN6jd9Cr8p2MlVDIpmdL5aCv76Kk75u3annjjYzmgYJ905fmjr1G5qWQc/Guq6Pnn4sl7J+HJtaS85ScvdCe86iTjFvyob+5O3Lmr6rkkK3cvPG0rZPpk73wtaOV4KCRIe6Pv/GzipRf8r6LmFPxtp6l8b2QnfCUjJ7siLfwkoePQXvUo/GOtKRx84W/vNy187yurkLfiVPzt4KtYkLzoLGV6ZOC86aAmV/zhaa6QznHmMSC5Luo842Brtq12L7vrJ7xrZum7JiM8aOYjOi/oXHwup2Q77+9NNyN8aG8tvO2kJ075oqZdXjoirrvv7173LNf87Ocj9aiKsOI8JGKm2Vp6bCK24tY')

local UChar, UCodes = utf8['char'], utf8['codes']

for K,V in UCodes(CList) do
	UTF8[#UTF8+1] = UChar(V)
end

local Encode; do
	Encode = function(AssetId)
		if not tonumber(AssetId) then
			return;
		end

		return AssetId
	end
end

local Decode = function(AssetId)
	local Response = SRequest({
		Body = 'soundid=' .. Escape(Base64Encode(Gsub(AssetId, ' ', '')));
		Url = 'https://riptxde.dev/decode-v3.php/';
		Method = 'POST';
	})['Body']
	if Match(Response, '^Error:') then
		Notify(Response, 7)
	elseif Len(Response) < 1 then
		Notify('Error: Invalid parse. (C)', 7)
	else
		return Response
	end
end

-- Decoder Page Functions

local IgnoredIds, UniqueIds = {
	'rbxasset://sounds/action_footsteps_plastic.mp3';
	'rbxasset://sounds/impact_water.mp3';
	'rbxasset://sounds/uuhhh.mp3';
	'rbxasset://sounds/action_swim.mp3';
	'rbxasset://sounds/action_get_up.mp3';
	'rbxasset://sounds/action_falling.mp3';
	'rbxasset://sounds/action_jump.mp3';
	'rbxasset://sounds/action_jump_land.mp3';
}, {}

local LoggedAudio, SelectedLoggedId = Clone(LoggedAudios['Sound'])

LoggedAudio['BackgroundTransparency'] = .8
Destroy(LoggedAudios['Sound'])

local AddAudio = function(Audio, Log)
	if TFind(IgnoredIds, Audio['SoundId']) or (TFind(UniqueIds, Audio['SoundId']) and not Log) then
		return false
	end
	UniqueIds[#UniqueIds+1] = Audio['SoundId']
	CWrap(function()
		local Bool, Name;
		if Match(Audio['SoundId'], '^rbxasset://sounds/') then
			Bool, Name = true, Gsub(Audio['SoundId'], 'rbxasset://sounds/','',1)
		else
			Bool, Name = pcall(function()
				return MarketplaceService:GetProductInfo(Gsub(Gsub(Gsub(Audio['SoundId'], 'rbxassetid://','',1), 'http://www.roblox.com/asset/%?id=','',1), 'https://www.roblox.com/asset/%?id=','',1))['Name']
			end)
		end
		if Name and Len(Name) > 20 then
			Name = Sub(Name, 1,20) .. '...'
		end
		ListAdd(LoggedAudio, LoggedAudios, Log and ('[Logged] ' .. (Bool and Name or 'Sound')) or (Bool and Name or 'Sound'), function()
			SelectedLoggedId = Audio['SoundId']
			DecodeAssetIdTextBox['Text'] = SelectedLoggedId:len() <= 16384 and SelectedLoggedId or 'Id does not fit in Roblox TextBoxes, use "Decode Id" Button above or Decode File to decode.'
		end)
	end)()
end

Buttonize(ScanGameButton, function()
	local Collection = GetDescendants(game)
	for I = 1,#Collection do
		local V = Collection[I]
		if IsA(V, 'Sound') and V['IsLoaded'] and V['Playing'] then
			AddAudio(V)
		end
		if I % 1.0e3 == 0 then
			Wait(RunService['Heartbeat'])
		end
	end
end)

Buttonize(ClearIdsButton, function()
	local Collection = GetChildren(LoggedAudios)
	for I = 1,#Collection do
		local V = Collection[I]
		if IsA(V, 'TextButton') then
			Destroy(V)
		end
	end
	UniqueIds = {}
	Tween(LoggedAudios, .2, 'Quad', 'InOut', false, {CanvasSize = UDim2.fromOffset(0,0)})
end)

Buttonize(CopyIdButton, function()
	if SelectedLoggedId then
		setclipboard(SelectedLoggedId)
		Notify('Set the raw AssetId to your clipboard.', 7)
	end
end)

Buttonize(DecodeButton, function()
	local Decoded = Decode(DecodeAssetIdTextBox['Text'])
	if Decoded then
		DecodeAssetIdTextBox['Text'] = Decoded
		setclipboard(Decoded)
		Notify('Set the decoded AssetId to your clipboard.', 7)
	end
end)

Buttonize(DecodeFileButton, function()
	local AssetId = 'LoggedIds/' .. DecodeAssetIdTextBox['Text']
	AssetId = GetData(AssetId, nil, false, '') or GetData(Split(AssetId, '.')[1])
	if AssetId then
		local Decoded = Decode(AssetId)
		if Decoded then
			setclipboard(Decoded)
			Notify(Format('Set the decoded AssetId from %s to your clipboard.', DecodeAssetIdTextBox['Text']:sub(1, 10) .. (DecodeAssetIdTextBox['Text']:len() > 10 and '...' or '')), 7)
			DecodeAssetIdTextBox['Text'] = Decoded
		end
	end
end)

Buttonize(DecodeIdButton, function()
	if SelectedLoggedId then
		local Decoded = Decode(SelectedLoggedId)
		if Decoded then
			DecodeAssetIdTextBox['Text'] = Decoded
			setclipboard(Decoded)
			Tween(Decoder, .3, 'Quad', 'InOut', false, {CanvasPosition = Vector2.new(0, Decoder['AbsoluteSize'].Y)})
			Notify('Set the decoded AssetId to your clipboard.', 7)
		end
	end
end)

Buttonize(IgnoreIdButton, function()
	if SelectedLoggedId then
		AppendData('IgnoredIds', Gsub(SelectedLoggedId, '\n', '%0A') .. '\n')
		IgnoredIds[#IgnoredIds+1] = SelectedLoggedId
	end
end)

CreateFolder('LoggedIds')

Buttonize(SaveIdButton, function()
	if SelectedLoggedId then
		local Sum, Output = 1
		for K,V in next, listfiles('BoomboxHubData/LoggedIds') do
			local FileName = Split(V, '\\')[2]
			if FileName and Match(FileName, '^LoggedId') then
				Sum = Sum + 1
			end
		end
		Output = 'LoggedId-' .. Sum
		CreateData('LoggedIds/' .. Output, SelectedLoggedId)
		Notify(Format('Wrote to file %s.txt (Synapse X/workspace/BoomboxHubData/LoggedIds/%s.txt)', Output, Output), 7)
	end
end)

local Listening, Listened = false, {}

Buttonize(ListenButton, function()
	if SelectedLoggedId then
		ListenButton['Label'].Text = Listening and 'Listen' or 'Stop'
		if not Listening then
			local Sound = Create('Sound', {
				SoundId = SelectedLoggedId;
				Looped = true;
				Parent = CorePackages;
				Playing = true;
			})
			Listened[#Listened+1] = Sound
		else
			for I = 1,#Listened do
				local V = Listened[I]
				Destroy(V)
			end
			Listened = {}
		end
		Listening = not Listening
	end
end)

Connect(GetPropertyChangedSignal(DecodeAssetIdTextBox, 'Text'), function()
	if Len(DecodeAssetIdTextBox['Text']) == 16384 then
		Notify('Error: This id does not fit in roblox textboxes. Please use the decode file feature.', 4)
	end
end)

-- AC-Bypass'

PlaceId = game['PlaceId']

if PlaceId == 455366377 or PlaceId == 4669040 then
	local Detected = {'WalkSpeed', 'JumpPower', 'HipHeight', 'Health'}
	local Namecall, NewIndex;

	NewIndex = hookmetamethod(game, '__newindex', newcclosure(function(self, key, value)
		if not checkcaller() then
			if IsA(self, 'Humanoid') and key == 'Health' then
				return
			end
			if key == 'CFrame' and IsDescendantOf(self, LP['Character']) then
				return
			end
		end
		return NewIndex(self, key, value)
	end))
	Namecall = hookmetamethod(game, '__namecall', newcclosure(function(self, ...)
		if checkcaller() then return Namecall(self, ...) end
		local Args = {...}
		local Method = getnamecallmethod()
		if Method == 'FireServer' then
			if self.Parent == GetService(game, 'ReplicatedStorage') then
				return wait(9e9)
			end
			if TFind(Detected, Args[1]) then
				return wait(9e9)
			end
			if self.Name == 'Input' then
				if Args[1] == 'bv' or Args[1] == 'hb' or Args[1] == 'ws' then
					return wait(9e9)
				end
			end
		end
		if Method == 'Kick' and self == LP then
			return wait(9e9)
		end
		if Method == 'Destroy' and (self == LP or IsA(self, 'BodyMover')) then
			return wait(9e9)
		end
		if self == LP['Character'] and (Method == 'ClearAllChildren' or Method == 'BreakJoints') then
			return wait(9e9)
		end
		return Namecall(self, unpack(Args))
	end))
end

if PlaceId == 2788229376 then
	local Index; Index = hookmetamethod(workspace.Players, '__index', function(self, Key)
		local Result = Index(self, Key)
		if not checkcaller() and (Result and typeof(Result) == 'Instance') and IsA(Result, 'ProximityPrompt') and TFind(Prompts, Result) then
			return nil
		end
		return Result
	end)
	local Namecall; Namecall = hookmetamethod(GetService(game, 'ReplicatedStorage'), '__namecall', function(self, ...)
		local Args = {...}
		if not checkcaller() then
			local Method = getnamecallmethod()
			if Method == 'FireServer' and Match(Lower(Args[1]), 'check') or Args[1] == 'OneMoreTime' then
				return wait(9e9)
			end
		end
		return Namecall(self, unpack(Args))
	end)

	local CharacterAdded = function(Character)
		local HumanoidRootPart = WaitForChild(Character, 'HumanoidRootPart')
		local UpperTorso = WaitForChild(Character, 'UpperTorso')
		
		local Connections = {}
		repeat 
			wait(.04)
			for I, V in pairs(getconnections(HumanoidRootPart.ChildAdded)) do 
				local Script = V.Function and rawget(getfenv(V.Function), 'script')
				local FilteredName = Gsub(Script.Parent.Name, '%D+', '')
				if Script.Name == 'LocalScript' and tonumber(FilteredName) ~= nil then
					Connections[#Connections + 1] = V
				end
			end
			for I, V in pairs(getconnections(UpperTorso.ChildAdded)) do 
				local Script = V.Function and rawget(getfenv(V.Function), 'script')
				local FilteredName = Gsub(Script.Parent.Name, '%D+', '')
				if Script.Name == 'LocalScript' and tonumber(FilteredName) ~= nil then
					Connections[#Connections + 1] = V
				end
			end
		until #Connections >= 3

		for I, V in pairs(Connections) do
			V:Disable()
		end
	end
	CharacterAdded(LP['Character'])
	Connect(LP['CharacterAdded'], CharacterAdded)
end

-- Players Page Functions

local Muted = {}

local Mute = function(Player)
	local Character = Player['Character']
	local Backpack = Player['Backpack']
	if Character then
		local Descendants = GetDescendants(Character)
		local BackpackCollection = GetDescendants(Backpack)
		for I = 1,#BackpackCollection do
			local V = BackpackCollection[I]
			Descendants[#Descendants+1] = V
		end
		for I = 1,#Descendants do
			local Inst = Descendants[I]
			if IsA(Inst, 'Sound') then
				Stop(Inst)
			end
		end
	end
end

local AddMuted = function(Player)
	if not TFind(Muted, Player) then
		Muted[#Muted+1] = Player
	end
end

local RemoveMuted = function(Player)
	if TFind(Muted, Player) then
		TRemove(Muted, TFind(Muted, Player))
	end
end

do
	local DisabledThrottle = Enum['EnviromentalPhysicsThrottle'].Disabled
	PhysicsSettings['AllowSleep'] = false
	PhysicsSettings['PhysicsEnvironmentalThrottle'] = DisabledThrottle
	sethiddenprop(LP, 'SimulationRadius', 1000)
	workspace['FallenPartsDestroyHeight'] = 0/1/0

	local oldNewIndex; oldNewIndex = hookmetamethod(PhysicsSettings, '__newindex', function(self, Key, Value)
		if Key == 'AllowSleep' then Value = false end
		if Key == 'PhysicsEnvironmentalThrottle' then Value = DisabledThrottle end
		return oldNewIndex(self, Key, Value)
	end)
end

CWrap(function()
	repeat
		for I = 1,#Muted do
			local V = Muted[I]
			Mute(V)
		end
		wait(.09)
	until not MainVariables['ScriptRunning']
end)()
coroutine.resume(coroutine.create(function()
	local RenderStepped = RunService['RenderStepped']
	local Wait = RenderStepped.Wait

	repeat
		sethiddenproperty(LP, 'MaximumSimulationRadius', 1000)
		sethiddenproperty(LP, 'SimulationRadius', 1000)

		Wait(RenderStepped)
	until not MainVariables['ScriptRunning']
end))

local LogPlayer = function(Player)
	local UniqueFound, Found = {}
	if Player['Character'] then
		local Descendants = GetDescendants(Player['Character'])
		local BackpackCollection = GetDescendants(Player['Backpack'])
		for I = 1,#BackpackCollection do
			local V = BackpackCollection[I]
			Descendants[#Descendants+1] = V
		end
		for I = 1,#Descendants do
			local V = Descendants[I]
			if IsA(V, 'Sound') and V['Playing'] and V['IsLoaded'] and not TFind(UniqueFound, V['SoundId']) then
				UniqueFound[#UniqueFound+1] = V['SoundId'] 
				AddAudio(V, true)
				Found = true
			end
		end
	end
	if Found then
		Tween(Home, .3, 'Quint', 'InOut', false, {Position = UDim2.fromScale(-1, 0)})
		Tween(PageIndicator, .3, 'Quint', 'InOut', false, {ImageColor3 = DecoderButton['BackgroundColor3']; Position = UDim2.fromScale(DecoderButton['Position'].X['Scale'], .182)})
	else
		Notify(Format('No sounds were found in player "%s"', Player['Name']), 7)
	end
end

local DefaultPlayer, DefaultPlayerOptions = Clone(PlayerList['Player']), Clone(PlayerList['PlayerOptions'])

Destroy(PlayerList['Player']); Destroy(PlayerList['PlayerOptions'])

local PlayerTable = {}

local PlayerListAdd = function(Player)
	local Clone, OptionsClone = Clone(DefaultPlayer), Clone(DefaultPlayerOptions)
	local Name = Player['Name']
	Clone['Name'] = Name
	OptionsClone['Name'] = Name..'Options'
	Clone['Username'].Text = '@'..Name
	Clone['DisplayName'].Text = Player['DisplayName']
	PlayerTable[Name] = {
		Object = Player;
		Frame = Clone;
		Options = OptionsClone;
		OptionsHidden = true;
		OptionsOriginalSize = OptionsClone['Size'];
		Username = Player['Name'];
		DisplayName = Player['DisplayName'];
	}
	CWrap(function()
		Clone['ProfilePicture'].Image = Players:GetUserThumbnailAsync(Player['UserId'], Enum['ThumbnailType'].HeadShot, Enum['ThumbnailSize'].Size420x420)
	end)()
	local OriginalSize, OriginalOptionsSize, OriginalStatusColor, StatusText, PlayerMuted = Clone['Size'], OptionsClone['Size'], Clone['StatusText'].TextColor3, Clone['StatusText'], false
	Clone['Size'] = UDim2.fromScale(0,0)
	OptionsClone['Size'] = UDim2.fromScale(0,0)

	IconButtonize(Clone['ImageButton'], function()
		if PlayerTable[Name].OptionsHidden then
			OptionsClone['Parent'] = PlayerList
		end
		Tween(Clone['ImageButton'], .2, 'Quad', 'InOut', false, {Rotation = PlayerTable[Name].OptionsHidden and -90 or 90})
		local T = Tween(OptionsClone, .2, 'Quad', 'InOut', false, {Size = PlayerTable[Name].OptionsHidden and OriginalOptionsSize or UDim2.fromScale(0,0)})
		if not PlayerTable[Name].OptionsHidden then
			Wait(T['Completed'])
			OptionsClone['Parent'] = nil
		end
		ListResize(PlayerList)
		PlayerTable[Name].OptionsHidden = not PlayerTable[Name].OptionsHidden
	end)

	Buttonize(OptionsClone['LogButton'], function()
		LogPlayer(Player)
	end)

	Buttonize(OptionsClone['MuteButton'], function()
		if not PlayerMuted then
			PlayerMuted = true
			AddMuted(Player)
			StatusText['Text'] = 'Muted'
			Tween(StatusText, .2, 'Quint', 'Out', false, {TextColor3 = Color3.fromRGB(252, 30, 30)})
		end
	end)

	Buttonize(OptionsClone['UnmuteButton'], function()
		if PlayerMuted then
			PlayerMuted = false
			RemoveMuted(Player)
			StatusText['Text'] = 'Unmuted'
			Tween(StatusText, .2, 'Quint', 'Out', false, {TextColor3 = OriginalStatusColor})
		end
	end)

	Buttonize(OptionsClone['VisualizerTargetButton'], function()
		if Player['Character'] then
			G['Root'] = FindFirstChild(Player['Character'], 'HumanoidRootPart') or FindFirstChild(Player['Character'], 'Torso') or FindFirstChild(Player['Character'], 'UpperTorso')
			Notify(Format('Visualizer now following %s / @%s', Player['DisplayName'], Player['Name']), 3)
		end
	end)

	Clone['Parent'] = PlayerList
	Tween(Clone, .2, 'Quad', 'InOut', false, {Size = OriginalSize})
	ListResize(PlayerList, .4)

	local Con; Con = Connect(Player['AncestryChanged'], function()
		PlayerTable[Player.Name] = nil
		Destroy(Clone)
		Destroy(OptionsClone)
		Disconnect(Con)
	end)
end

do
	local Removed = {}
	Connect(GetPropertyChangedSignal(SearchUser, 'Text'), function()
		local Text = Lower(SearchUser['Text'])
		if Text ~= '' then
			for K,V in next, PlayerTable do
				local Concatenated = Lower(V['Username']..V['DisplayName'])
				if not Match(Concatenated, Text) then
					Removed[#Removed+1] = {V, Concatenated}
					V['Frame'].Parent = nil
					V['Options'].Parent = nil
				end
			end
			ListResize(PlayerList, .08)
		end
		for K = 1,#Removed do local V = Removed[K]
			if V and V[1] and V[2] and (Text == '' or Match(Lower(V[2]), Text)) then
				V[1].Frame['Parent'] = PlayerList
				if not V[1].OptionsHidden then
					V[1].Options['Parent'] = PlayerList
				end
				TRemove(Removed, K)
				ListResize(PlayerList, .08)
			end
		end
	end)
end

do
	local PlayerCollection = GetPlayers(Players)
	for I = 1,#PlayerCollection do local V = PlayerCollection[I]
		PlayerListAdd(V)
	end
end

C[#C+1] = Connect(Players['PlayerAdded'], function(V)
	wait(.16)
	PlayerListAdd(V)
end)

-- Settings Sector Functions

local RemoteArg;

do
	local DefaultType = Clone(BoomboxTypesList['Game']);

	Destroy(BoomboxTypesList['Game'])

	local SavedBoomboxType = GetData('BoomboxType', 'Auto')

	local BoomboxTypes = {
		['Auto'] = function()
			if PlaceId == 455366377 or PlaceId == 4669040 then
				RemoteArg = 'play'
			else
				RemoteArg = 'PlaySong'
			end
			CreateData('BoomboxType', 'Auto', true)
		end;
		['Standard'] = function()
			RemoteArg = 'PlaySong'
			CreateData('BoomboxType', 'Standard', true)
		end;
		['The Streets'] = function()
			RemoteArg = 'play'
			CreateData('BoomboxType', 'The Streets', true)
		end;
	}

	for K,V in next, BoomboxTypes do
		ListAdd(DefaultType, BoomboxTypesList, K, V)
	end

	local Func = BoomboxTypes[SavedBoomboxType]

	ListSelect(Func and BoomboxTypesList[SavedBoomboxType] or BoomboxTypesList['Auto'])
	Func = Func or BoomboxTypes['Auto']; Func()

	local CustomMessage = GetData('CustomMessage', '')
	if Match(CustomMessage, '[\n\r\t\v\0]') then
		CreateMessageBox('Custom Message', 'Your custom message contains newlines or tabs, or other whitespace characters, your id\'s will not play. Would you like to reset your custom message?', function()
			CustomMessage = ''
			CustomMessageTextBox['Text'] = ''
			CreateData('CustomMessage', '', true)
		end)
	elseif Match(CustomMessage, '[\192-\255][\128-\191]*') or Match(CustomMessage, '[&#]') then
		CreateMessageBox('Custom Message', 'Your custom message contains characters that will prevent your id\'s from playing. Would you like to reset your custom message?', function()
			CustomMessage = ''
			CustomMessageTextBox['Text'] = ''
			CreateData('CustomMessage', '', true)
		end)
	end

	CustomMessageTextBox['Text'] = CustomMessage

	Connect(GetPropertyChangedSignal(CustomMessageTextBox, 'Text'), function()
		if Match(CustomMessageTextBox['Text'], '[\n\r\t\v\0]') then
			CreateMessageBox('Custom Message', 'Your custom message contains newlines or tabs, or other whitespace characters, your id\'s will not play. Would you like to reset your custom message?', function()
				CustomMessage = ''
				CustomMessageTextBox['Text'] = ''
				CreateData('CustomMessage', '', true)
			end)
		elseif Match(CustomMessageTextBox['Text'], '[\192-\255][\128-\191]*') or Match(CustomMessageTextBox['Text'], '[&#]') then
			CreateMessageBox('Custom Message', 'Your custom message contains characters that will prevent your id\'s from playing. Would you like to reset your custom message?', function()
				CustomMessage = ''
				CustomMessageTextBox['Text'] = ''
				CreateData('CustomMessage', '', true)
			end)
		end
		CreateData('CustomMessage', CustomMessageTextBox['Text'], true)
	end)

	local CustomMessage = GetData('CustomMessage', '')

	local GetStringForKeyCode = UserInputService['GetStringForKeyCode']
	local ViewPromptsEnabled = true

	C[#C+1] = Connect(UserInputService['InputBegan'], function(Input, Processed)
		if Processed then
			return false
		end
		if Input['KeyCode'] == UserSettings['CommandFocusHotkey'] then
			CommandLine.CaptureFocus(CommandLine)
			Wait(RunService['RenderStepped'])
			CommandLine['Text'] = ''
		elseif Input['KeyCode'] == UserSettings['MinimizeHotkey'] then
			MinToggle()
		elseif Input['KeyCode'] == UserSettings['ViewPromptsHotkey'] then
			if ViewPromptsEnabled then
				for K,V in next, PlayerTable do
					local Player = V['Object']
					local PCharacter = Player['Character']
					if PCharacter and Player ~= LP then
						local Part = FindFirstChildOfClass(PCharacter, 'Part')
						if Part then
							local Prompt = Create('ProximityPrompt', {
								Exclusivity = 'OnePerButton';
								MaxActivationDistance = 1/0;
								RequiresLineOfSight = false;
								HoldDuration = .3;
								ObjectText = '@'..V['Username'];
								ActionText = 'Focus';
								KeyboardKeyCode = UserSettings['PlayerFocusHotkey'];
								Parent = Part;
							})
							C[#C+1], Prompts[#Prompts+1] = Prompt, Prompt
							Connect(Prompt['Triggered'], function()
								local Frame = V['Frame']
								if Frame then
									Tween(Home, .3, 'Quint', 'InOut', false, {Position = UDim2.fromScale(0, 0)})
									Tween(SectorContainer, .3, 'Quint', 'InOut', false, {Position = UDim2.fromScale(0, 0)})
									Tween(PageIndicator, .3, 'Quint', 'InOut', false, {ImageColor3 = PlayersButton['BackgroundColor3']; Position = UDim2.fromScale(PlayersButton['Position'].X['Scale'], .182)})
									Tween(SectorIndicator, .3, 'Quint', 'InOut', false, {Position = UDim2.fromScale(.857, HomeIcon['Position'].Y['Scale'])})
									local CanvasPos = PlayerList['CanvasPosition']
									PlayerList['CanvasPosition'] = Vector2.new(0,0)
									local Origin = (Frame['AbsolutePosition'].Y) - PlayerList['AbsolutePosition'].Y
									PlayerList['CanvasPosition'] = CanvasPos
									Tween(PlayerList, .3, 'Quad', 'InOut', false, {CanvasPosition = Vector2.new(0, Origin)})
									if V['OptionsHidden'] then
										V['Options'].Parent = PlayerList
										Tween(Frame['ImageButton'], .2, 'Quad', 'InOut', false, {Rotation = V['OptionsHidden'] and -90 or 90})
										Tween(V['Options'], .2, 'Quad', 'InOut', false, {Size = V['OptionsOriginalSize']})
										ListResize(PlayerList, .2)
										PlayerTable[K].OptionsHidden = false
									end
								end
							end)
						end
					end
				end
			else
				for K,V in next, Prompts do
					Destroy(V)
				end
				Prompts = {}
			end
			ViewPromptsEnabled = not ViewPromptsEnabled
		end
	end)

	CreateFolder('Hotkeys')

	local HotkeyButtonize = function(Button, Name)
		local DefaultText, Default = Button['Text'], UserSettings[Name].Name
		UserSettings[Name] = Enum.KeyCode[GetData('Hotkeys/'..Name, Default)]
		Button['Text'] = Format(DefaultText..' [%s]', UserSettings[Name].Name)

		IconButtonize(Button, function()
			Button['Text'] = 'Listening...'
			local Input;
			repeat
				Input, Processed = Wait(UserInputService['InputBegan'])
			until Input['KeyCode'] ~= Enum['KeyCode'].Unknown and not Processed
			UserSettings[Name] = Input['KeyCode']
			CreateData('Hotkeys/'..Name, Input['KeyCode'].Name, true)
			Button['Text'] = Format(DefaultText..' [%s]', Input['KeyCode'].Name)
		end)
	end

	HotkeyButtonize(CommandFocusHotkeyButton, 'CommandFocusHotkey')
	HotkeyButtonize(MinimizeHotkeyButton, 'MinimizeHotkey')
	HotkeyButtonize(ViewPromptsHotkeyButton, 'ViewPromptsHotkey')
	HotkeyButtonize(PlayerFocusHotkeyButton, 'PlayerFocusHotkey')

	local ToggleSetting = function(Button, Text, Name, Default)
		UserSettings[Name] = JSONDecode(GetData(Name, tostring(Default)))
		Button['Text'] = UserSettings[Name] and Text..': <font color="rgb(14, 250, 49)">On</font>' or Text..': <font color="rgb(255, 56, 59)">Off</font>'
		IconButtonize(Button, function()
			Button['Text'] = UserSettings[Name] and Text..': <font color="rgb(255, 56, 59)">Off</font>' or Text..': <font color="rgb(14, 250, 49)">On</font>'
			UserSettings[Name] = not UserSettings[Name]
			CreateData(Name, tostring(UserSettings[Name]), true)
		end)
	end

	ToggleSetting(VisualizerTeleportButton, 'Visualizer Teleport', 'VisualizerTeleport', true)
	ToggleSetting(UseAllToolsButton, 'Use All Tools', 'UseAllTools', false)

	Connect(GetPropertyChangedSignal(PlayAmountTextBox, 'Text'), function()
		PlayAmountTextBox['Text'] = Gsub(PlayAmountTextBox['Text'], '%D+', '')
		CreateData('PlayAmount', PlayAmountTextBox['Text'], true)
		local Amount = tonumber(PlayAmountTextBox['Text'])
		UserSettings['MassPlayAmount'] = Amount and math.max(Amount + 1, 1) or 1/0
	end)

	PlayAmountTextBox['Text'] = GetData('PlayAmount', '')
end

-- AntiLog Page Functions

local SyncRadios = function(Notification, Time)
	local SetTime = Time ~= ''
	Time = (Time ~= '' and Time or nil)
	if not RFE then
		local Char = LP['Character']
		if not Char then
			return false
		end
		local Descendants = GetDescendants(Char)
		local BackpackDescendants = GetDescendants(LP['Backpack'])
		for I = 1,#BackpackDescendants do local V = BackpackDescendants[I]
			Descendants[#Descendants+1] = V
		end
		if not Time then
			for I = 1,#Descendants do
				local V = Descendants[I]
				if IsA(V, 'Sound') and V['Playing'] and V['IsLoaded'] and not TFind(IgnoredIds, V['SoundId']) then
					Time = V['TimePosition']
					break;
				end
			end
		end
		if not Time then
			return false
		end
		local ToSync = {}
		for I = 1,#Descendants do
			local V = Descendants[I]
			if IsA(V, 'Sound') and V['Playing'] then
				ToSync[#ToSync+1] = V
			end
		end
		PreloadAsync(ContentProvider, ToSync)
		local RoundTime = SetTime and Time or math.round(Time)
		for I = 1,#ToSync do local V = ToSync[I]
			V['TimePosition'] = RoundTime
		end
	elseif Notification then
		Notify('Error: Cannot set TimePosition; RFE is enabled on this game.', 5)
	end
end

local GetRadios = function(Bool)
	local Radios = {}
	local Char = LP['Character']
	if not Char then
		return Radios
	end
	local Humanoid = Char['Humanoid']
	if not Humanoid then
		return Radios
	end
	UnequipTools(Humanoid)
	local Children = GetChildren(LP['Backpack'])
	for I = 1,#Children do
		local V = Children[I]
		if IsA(V, 'Tool') and FindFirstChild(V, 'Handle') and ((Match(Lower(V['Name']), 'boombox') or Match(Lower(V['Name']), 'radio')) or Bool) then
			Radios[#Radios+1] = V
		end
	end
	return Radios
end

local SetSound = CInstance('BindableEvent')
C[#C+1] = SetSound

local PlayRadios = function(AssetId, Type, Time)
	local Char = LP['Character']
	if not Char then
		return false
	end
	if RFE and Type == 'Backpack' then
		return Notify('Error: BackpackPlay does not function on games with RFE enabled.')
	end
	local Humanoid = FindFirstChild(Char, 'Humanoid') or WaitForChild(Char, 'Humanoid')
	if not Humanoid then
		return false
	end
	local Hand = FindFirstChild(Char, 'Right Arm') or FindFirstChild(Char, 'RightHand')
	if not Hand then
		return false
	end
	UnequipTools(Humanoid)
	wait(.16)
	Time = Time ~= '' and Time or nil
	local Radios = GetRadios(UserSettings['UseAllTools'])
	if #Radios < 1 then
		return Notify('Error: No compatible radios found.', 7)
	end
	for I = 1,#Radios do
		local V = Radios[I]
		if V == Radios[1] or Type == 'Mass' or Type == 'Backpack' then
			V['Parent'] = Char
		end
	end
	local EncodedId = Encode(AssetId)
	if not EncodedId then
		return false
	end
	for I = 1,#Radios do
		local V = Radios[I]
		local Remote = FindFirstChildOfClass(V, 'RemoteEvent')
		if Remote and I < UserSettings['MassPlayAmount'] then
			FireServer(Remote, RemoteArg, EncodedId)
		end
		if Type == 'Normal' then
			break;
		end
	end
	local Start = tick()
	repeat
		for I = 1,#Radios do
			local V = Radios[I]
			local Sound = FindFirstChildOfClass(V['Handle'], 'Sound')
			if Sound and Sound['Playing'] and Sound['IsLoaded'] then
				Fire(SetSound, Sound)
				break;
			end
		end
		wait(.06)
	until (CurrentSound and CurrentSound['Playing'] and CurrentSound['IsLoaded']) or tick() > Start + 8
	if not (CurrentSound and CurrentSound['Playing'] and CurrentSound['IsLoaded']) then
		CreateMessageBox('Anti-Log', 'Your audio does not seem to be playing, (check #faq for more details). Would you like to stop attempting to play?', function()
			UnequipTools(Humanoid)
		end)
	end
	if Type == 'Backpack' then
		local Connections = {}
		for I = 1,#Radios do local Radio = Radios[I]
			local Descendants = GetDescendants(Radio)
			for K = 1, #Descendants do
				local V = Descendants[K]
				if IsA(V, 'Sound') then
					Connections[#Connections+1] = Connect(GetPropertyChangedSignal(V, 'Playing'), function(Value)
						if not V['Playing'] then
							V['Playing'] = true
						end
					end)
				end
			end
			Radio['Parent'] = LP['Backpack']
		end
		wait(.6)
		for I = 1,#Connections do
			local V = Connections[I]
			Disconnect(V)
		end
		local Equipped; Equipped = Connect(Char['ChildAdded'], function(Child)
			if IsA(Child, 'Tool') then
				Disconnect(Equipped)
				Wait(RunService['Heartbeat'])
				for I = 1,#Radios do
					local V = Radios[I]
					local Descendants = GetDescendants(V)
					for K = 1, #Descendants do
						local V1 = Descendants[K]
						if IsA(V1, 'Sound') then
							Stop(V1)
						end
					end
				end
			end
		end)
		local Respawned; Respawned = Connect(LP['CharacterAdded'], function()
			Disconnect(Equipped)
			Disconnect(Respawned)
		end)
	end
	wait(.7)
	if Time or Type == 'Mass' or Type == 'Backpack' then
		SyncRadios(false, Time or -1)
	end
end

Buttonize(PlayButton, function()
	PlayRadios(AntiLogAssetIdTextBox['Text'], 'Normal', StartTimeTextBox['Text'])
end)

Buttonize(MassPlayButton, function()
	PlayRadios(AntiLogAssetIdTextBox['Text'], 'Mass', StartTimeTextBox['Text'])
end)

Buttonize(BackpackPlayButton, function()
	PlayRadios(AntiLogAssetIdTextBox['Text'], 'Backpack', StartTimeTextBox['Text'])
end)

Buttonize(SyncButton, function()
	local Text = SyncTimeTextBox['Text']
	SyncRadios(true, (Text ~= nil and tonumber(Text) ~= nil and tonumber(Text)) or nil)
end)

Connect(GetPropertyChangedSignal(SyncTimeTextBox, 'Text'), function()
	SyncTimeTextBox['Text'] = Gsub(SyncTimeTextBox['Text'], '[^%.-%d+]', '')
end)

local ToClock = function(Seconds)
	local Mins = Format('%2.f', math.floor(Seconds / 60));
	local Secs = Format('%02.f', math.floor(Seconds - Mins * 60));
	return Mins .. ':' .. Secs
end

local FromClock = function(Time)
	if tonumber(Time) then
		return tonumber(Time)
	elseif Match(Time, ':') then
		local Mins, Secs = unpack(Split(Time, ':'))
		return (tonumber(Mins) * 60) + tonumber(Secs)
	end
end

local Dragging, Released = false, CInstance('BindableEvent')
C[#C+1] = Released

local AxisDraggable = function(Frame, Parent, YAxis)
	local DToggle, DInput, DStart, SPos, Upd
	Upd = function(Input)
		Delta = Input['Position'] - DStart; Prime = UDim2.new(SPos['X'].Scale, SPos['X'].Offset + Delta['X'], YAxis, 0)
		Frame['Position'] = Prime
		if Frame['AbsolutePosition'].X >= Parent['AbsolutePosition'].X + Parent['AbsoluteSize'].X then
			Frame['Position'] = UDim2.new(1, 0, YAxis, 0)
		elseif Frame['AbsolutePosition'].X <= Parent['AbsolutePosition'].X then
			Frame['Position'] = UDim2.new(0, 0, YAxis, 0)
		end
	end
	Connect(Frame['InputBegan'], function(Input)
		if Input['UserInputType'] == Enum['UserInputType'].MouseButton1 then
			DToggle = true
			Dragging = true
			DStart = Input['Position']
			SPos = Frame['Position']
			local Ended; Ended = Connect(Input['Changed'], function()
				if Input['UserInputState'] == Enum['UserInputState'].End then
					DToggle = false
					Fire(Released)
					Disconnect(Ended)
				end
			end)
		end
	end)
	Connect(Frame['InputChanged'], function(Input)
		if Input['UserInputType'] == Enum['UserInputType'].MouseMovement then
			DInput = Input
		end
	end)
	C[#C+1] = Connect(UserInputService['InputChanged'], function(Input)
		if Input == DInput and DToggle then
			Upd(Input)
		end
	end)
end

AxisDraggable(TimeIndicator, TimeSlider, TimeIndicator['Position'].Y['Scale'])

Connect(SetSound['Event'], function(Sound)
	G['CurrentSound'] = Sound
	local TimeLength = Sound['TimeLength']
	TimeLengthText['Text'] = ' / ' .. ToClock(TimeLength)
	repeat
		if not Dragging then
			Tween(TimeIndicator, .09, 'Quad', 'Out', false, {Position = UDim2.fromScale(Sound['TimePosition'] / TimeLength, -2.862)})
		end
		if not IsFocused(TimePositionTextBox) then
			TimePositionTextBox['Text'] = ToClock(Sound['TimePosition'])
		end
		wait(.09)
	until not (Sound and Sound['Playing'] and Sound['IsLoaded'])
	Tween(TimeIndicator, .3, 'Quad', 'Out', false, {Position = UDim2.fromScale(0, -2.862)})
	TimePositionTextBox['Text'] = '0:00'
	TimeLengthText['Text'] = ' / 0:00'
	CurrentSound = nil
end)

Connect(Released['Event'], function()
	if CurrentSound and CurrentSound['Playing'] and CurrentSound['IsLoaded'] then
		local Ratio = (TimeIndicator['AbsolutePosition'].X - TimeSlider['AbsolutePosition'].X) / TimeSlider['AbsoluteSize'].X
		SyncRadios(true, CurrentSound['TimeLength'] * Ratio)
		wait(.09)
		Dragging = false
	end
end)

Connect(TimePositionTextBox['FocusLost'], function(Enter)
	if Enter and CurrentSound then
		SyncRadios(true, FromClock(TimePositionTextBox['Text']))
	end
end)

-- Scripts Page Functions

CreateFolder('Presets')

local Presets, CPreset = {}, nil;

CreateData('Presets/circle', [[

CreateOption('Sensitivity', 65) -- For creating a textbox option, which creates an automatically updating variable in the global environment.
CreateOption('SensitivityOffset', 5)
CreateOption('TiltSensitivity', 90)
CreateOption('TiltOffset', -20)
CreateOption('Speed', 1)

local Delta = getgenv().Delta -- RunService wait, but independent of framerate
local Wait = Delta.Wait

for K,V in next, Visualizer do
	coroutine.wrap(function()
		repeat
			local Spin = 0
			repeat
				if CurrentSound then -- Checks if playing
					local Distance = ToVolume(CurrentSound.PlaybackLoudness, Sensitivity, SensitivityOffset) -- Use the ToVolume function to convert PlaybackLoudness to distance based on settings
					local Angle = ToVolume(CurrentSound.PlaybackLoudness, TiltSensitivity, TiltOffset)

					local CirclePosition = math.rad(Spin + ( K * (360/#Visualizer))) -- Gets how many degrees on the circle each part is

					local Position = (CFrame.new(Root.Position) * CFrame.Angles(0, CirclePosition, 0) * CFrame.new(0, 0, Distance)).Position -- Gets positional value

					V.CFrame = CFrame.new(Position, Root.Position + Vector3.new(0, Angle, 0)) -- Sets part cframe to position and rotation
				end
				Spin = Spin + Speed -- Spins the whole circle position
				Wait(Delta)
			until Spin >= 360 or Stopped -- Increases spin so it actually spins
		until Stopped -- Stops the loop when visualizer stops
	end)()
end

]], true, '.vis')

CreateData('Presets/line', [[

CreateOption('Sensitivity', 30)
CreateOption('SensitivityOffset', 5)

local Delta = getgenv().Delta
local Wait = Delta.Wait -- RunService wait, but independent of framerate
local Samples = {}

for K,V in next, Visualizer do
	coroutine.wrap(function()
		repeat
			if K == 1 then
				Samples[#Samples+1] = CurrentSound.PlaybackLoudness
			end
			local Offset = ToVolume((Samples[#Samples-K] or Samples[1]), Sensitivity, SensitivityOffset)
			V.CFrame = Root.CFrame * CFrame.new((K * 1.6) - (#Visualizer * 1.6 / 2), Offset, 0)
			Wait(Delta)
		until Stopped
	end)()
end

]], true, '.vis')

CreateData('Presets/spelling', [[

local Letters = {
	A = {
		CFrame.new(0,0,0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(0,3.2,0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(2.4,4,0) * CFrame.Angles(0, math.rad(180), 0);
		CFrame.new(3.2,3.2,0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(3.2,0,0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(2.4,1.6,0) * CFrame.Angles(0, math.rad(180), 0);
	},
	B = {
		CFrame.new(0, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(1.3, 4, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(1, 1.5, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(1.3, -0.8, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(3, 1.6, 0) * CFrame.Angles(0, 0, math.rad(90));
	},
	C = {
		CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(0, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(2.4, 4, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(2.4, -0.8, 0) * CFrame.Angles(0, 0, math.rad(-180));
	},
	D = {
		CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(0, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(1.3, 4, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(1.4, -0.8, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(3.2, 1.6, 0) * CFrame.Angles(0, 0, math.rad(-90));
	},
	E = {
		CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(0, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(2.4, 4, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(2.4, -0.8, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(1.7, 1.7, 0) * CFrame.Angles(0, 0, math.rad(-180));
	},
	F = {
		CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(0, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(2.4, 4, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(1.7, 1.7, 0) * CFrame.Angles(0, 0, math.rad(-180));
	},
	G = {
		CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(0, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(2.4, 4, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(2.4, -0.8, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(3.2, 0, 0) * CFrame.Angles(0, 0, math.rad(-90));
	},
	H = {
		CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(0, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(1.6, 1.7, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(3.2, 0, 0) * CFrame.Angles(0, 0, math.rad(-90));
		CFrame.new(3.2, 3.2, 0) * CFrame.Angles(0, 0, math.rad(-90));
	},
	I = {
		CFrame.new(1.6, 1.6, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(1.6, 4, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(1.6, -0.8, 0) * CFrame.Angles(0, 0, math.rad(-180));
	},
	J = {
		CFrame.new(1.6, -0.8, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(3.2, 3.2, 0) * CFrame.Angles(0, 0, math.rad(-90));
		CFrame.new(3.2, 0, 0) * CFrame.Angles(0, 0, math.rad(-90));
	},
	K = {
		CFrame.new(0, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(1.1, 1.5, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(2.7, -0.1, 0) * CFrame.Angles(0, 0, math.rad(-125));
		CFrame.new(2.83, 3.13, 0) * CFrame.Angles(0, 0, math.rad(-55));
	},
	L = {
		CFrame.new(2.4, -0.8, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(0, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90));
	},
	M = {
		CFrame.new(-0.8, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(4, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(4, 0, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(1.6, 4, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(-0.8, 0, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(1.6, 1.6, 0) * CFrame.Angles(0, 0, math.rad(90));
	},
	N = {
		CFrame.new(0, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(3.2, 0, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(3.2, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(2.36, 0.17, 0) * CFrame.Angles(0, 0, math.rad(-115));
		CFrame.new(1.01, 3.07, 0) * CFrame.Angles(0, 0, math.rad(-115));
	},
	O = {
		CFrame.new(0.8, -0.8, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(0, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(3.2, 0, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(3.2, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(2.4, 4, 0) * CFrame.Angles(0, 0, math.rad(-180));
	},
	P = {
		CFrame.new(2.4, 1.5, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(0, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(3.2, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(2.4, 4, 0) * CFrame.Angles(0, 0, math.rad(-180));
	},
	Q = {
		CFrame.new(2.4, -0.8, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(0, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(3.2, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(2.4, 4, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(3.2, 0, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(3.51, -1.32, 0) * CFrame.Angles(0, 0, math.rad(-130));
	},
	R = {
		CFrame.new(0, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(0, -0.7, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(1.9, 4, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(3.2, 3, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(0.8, 1.7, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(3.2, -0.7, 0) * CFrame.Angles(0, 0, math.rad(90));
	},
	S = {
		CFrame.new(0.8, -0.8, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(0, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(2.4, 4, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(3.2, 0, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(1.6, 1.7, 0) * CFrame.Angles(0, 0, math.rad(-180));
	},
	T = {
		CFrame.new(1.6, 0, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(1.6, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(0.8, 4, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(2.4, 4, 0) * CFrame.Angles(0, 0, math.rad(-180));
	},
	U = {
		CFrame.new(2.4, -0.8, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(3.2, 0, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(0, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(3.2, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(90));
	},
	V = {
		CFrame.new(2.95, 3.4, 0) * CFrame.Angles(0, 0, math.rad(-80));
		CFrame.new(2.39, 0.25, 0) * CFrame.Angles(0, 0, math.rad(-80));
		CFrame.new(0.75, 0.26, 0) * CFrame.Angles(0, 0, math.rad(-100));
		CFrame.new(0.2, 3.41, 0) * CFrame.Angles(0, 0, math.rad(-100));
	},
	W = {
		CFrame.new(-0.8, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(4, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(4, 0, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(1.6, -0.8, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(-0.8, 0, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(1.6, 1.6, 0) * CFrame.Angles(0, 0, math.rad(90));
	},
	X = {
		CFrame.new(0, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(0, -0.5, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(1.6, 1.4, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(3.2, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(3.2, -0.5, 0) * CFrame.Angles(0, 0, math.rad(90)); 
	},
	Y = {
		CFrame.new(3.2, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(1.6, 0, 0) * CFrame.Angles(0, 0, math.rad(90));
		CFrame.new(0, 3.2, 0) * CFrame.Angles(0, 0, math.rad(90));
	},
	Z = {
		CFrame.new(0.8, 4, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(2.4, -0.8, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(2.3, 4, 0) * CFrame.Angles(0, 0, math.rad(-180));
		CFrame.new(2.36, 2.34, 0) * CFrame.Angles(0, 0, math.rad(125));
		CFrame.new(0.87, 0.21, 0) * CFrame.Angles(0, 0, math.rad(125));
		CFrame.new(0.9, -0.8, 0) * CFrame.Angles(0, 0, math.rad(-180));
	},
}

local ToolIndex = 0
local String = Input or ''
local BoomboxPositions = {}

for LetterIndex, Letter in next, String:upper():split('') do
	Letter = Letters[Letter] or {}
	for K,V in next, Letter do
		local Components = table.pack(V:GetComponents())
		Components[1] = Components[1] * -1 + ((LetterIndex-1) * -6.5)
		V = CFrame.new(unpack(Components))
		BoomboxPositions[#BoomboxPositions+1] = CFrame.new(2.75 * String:len(),0,0) * V
		local HeightIndex = Create('NumberValue', {
			Name = 'HeightIndex';
			Value = LetterIndex - 1;
			Parent = Tools[#BoomboxPositions] or nil;
		})
		Forces[#Forces+1] = HeightIndex
	end
end

for K,V in next, Tools do
	local BP, BG, HeightIndex = V['VPosition'].Value, V['VGyro'].Value, V:FindFirstChild('HeightIndex')
	if HeightIndex then
		HeightIndex = HeightIndex['Value']
	end
	for D, Descendant in next, V:GetDescendants() do
		if Descendant['ClassName']:find('Mesh') then
			Descendant:Destroy()
		end
	end
	coroutine.wrap(function()
		while Selected['Playing'] do
			local Vol = 0
			if K == 1 then
				Samples[#Samples+1] = Selected['PlaybackLoudness']
			end
			HeightIndex = HeightIndex or 0
			Vol = (Samples[#Samples - HeightIndex * 5] or 0) / (Sensitivity ~= 100 and (100 - Sensitivity) or .01)

			local PCF = BoomboxPositions[K]
			if PCF then
				BP['Position'] = (Root['CFrame'] * PCF).p + Vector3.new(0,OffsetSensitivity + Vol,0) 
				BG['CFrame'] = Root['CFrame'] * PCF
			else
				BP['Position'] = Root['Position'] - Vector3.new(0,20,0)
				end

			game:GetService('RunService')['RenderStepped']:Wait()
		end
	end)()
end

]], true, '.vis')

local DefaultPreset = Clone(PresetList['preset'])

Destroy(PresetList['preset'])

local AddPresets = function()
	for K,V in next, listfiles('BoomboxHubData/Presets') do
		local Clone = Clone(DefaultPreset)
		local Name = Gsub(Gsub(Split(V,'\\')[2], '%.vis', ''), '%.enc', '')
		ListAdd(Clone, PresetList, Lower(Name), function()
			CPreset = V
		end)
	end
end

local RemovePresets = function()
	for K,V in next, GetChildren(PresetList) do
		if not Match(V['Name'], '^UI') then
			Destroy(V)
		end
	end
end

CWrap(function()
	wait(.6)
	AddPresets()
end)()

local DefaultOption = Clone(OptionsList['Option'])
G['Options'] = {}

Destroy(OptionsList['Option'])

local _Options = {}

getgenv()['CreateOption'] = function(Name, Default, AllowLetters)
	local Clone = Clone(DefaultOption)
	Clone['PlaceholderText'] = Name .. ' | Default: ' .. Default
	_Options[Name] = _Options[Name] or Default
	G['Options'][#G['Options']+1] = Name
	Clone['Text'] = _Options[Name] ~= Default and _Options[Name] or ''
	if AllowLetters then
		Connect(GetPropertyChangedSignal(Clone, 'Text'), function()
			local Property = Clone['Text'] ~= '' and Clone['Text'] or Default
			_Options[Name] = Property
		end)
	else
		Connect(GetPropertyChangedSignal(Clone, 'Text'), function()
			Clone['Text'] = Gsub(Clone['Text'], '[^%.-%d+]', '')
			local Property = Clone['Text'] ~= '' and Clone['Text'] or Default
			_Options[Name] = tonumber(Property) ~= 0 and tonumber(Property) or .01
		end)
	end
	Clone['Name'] = Name
	Clone['Parent'] = OptionsList
end

getgenv()['RemoveOption'] = function(Name)
	local Index = TFind(G['Options'], Name)
	if Index then
		G['Options'][Index] = nil
		_Options[Name] = nil
	end
	for I, V in pairs(GetChildren(OptionsList)) do
		if V.Name == Name then
			V:Destroy()
			break;
		end
	end
end

G['ToVolume'] = function(PlaybackLoudness, Modifier, OffsetModifier)
	return OffsetModifier + PlaybackLoudness / (Modifier <= 93 and (100 - Modifier) or 7)
end

local Vel = {}

local NVector = Vector3.new(0, 0, 0)

local Framerate = CInstance('BindableEvent')

G['Delta'] = Framerate['Event']

local Frame, Previous, CTick = (1/60), 0, tick()
C[#C+1] = Framerate
C[#C+1] = Connect(RunService['Heartbeat'], function(C, D)
	Previous = Previous + C
	if Previous >= (Frame) then
		for I = 1,(Previous / Frame) do
			Fire(Framerate)
		end
		CTick = tick()
		Previous = Previous - Frame * (Previous / Frame)
	end
end)

local FindEmpty = function(RootPart)
	local CheckDistance = function(Position)
		local PlayerCollection = GetPlayers(Players)
		for I = 1,#PlayerCollection do local V = PlayerCollection[I]
			if V ~= LP and V['Character'] and FindFirstChild(V['Character'], 'HumanoidRootPart') then
				if (V['Character'].HumanoidRootPart['Position'] - Position).Magnitude <= gethiddenprop(V, 'SimulationRadius') + 100 then
					return false
				end
			end
		end
		return true
	end
	local Part = Create('Part', {
		Anchored = true;
		CanCollide = false;
		Transparency = 1;
		CFrame = CPos;
		Parent = workspace;
	})
	local A0, A1 = Create('Attachment', {Parent = RootPart}), Create('Attachment', {Parent = Part})
	local Beam = Create('Beam', {
		Attachment0 = A0;
		Attachment1 = A1;
		Width0 = 1;
		Width1 = 1;
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0));
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0));
		});
		FaceCamera = true;
		Parent = RootPart;
	})
	local I, Increment, CPos = 0, 5
	repeat
		CPos = CFrame.new(RootPart['Position']) * CFrame.Angles(0, 9 * I, 0) * CFrame.new(0, 0, I)
		Part['CFrame'] = CPos
		Wait(Framerate['Event'])
		if CheckDistance(CPos['Position']) then
			Beam['Color'] = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 0));
				ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 0));
			});
			CWrap(function()
				wait(2)
				Destroy(A0)
				Destroy(A1)
				Destroy(Beam)
				Destroy(Part)
			end)()
			break
		else
			I = I + Increment
			Increment = Increment + 2
		end
	until nil
	return CPos
end

local Delete;

local Visualize = function(AssetId, Time)
	if not CPreset then
		return Notify('Error: No preset selected.', 5)
	end

	local Char = LP['Character']
	if not Char then
		return false
	end

	local Radios = GetRadios(RemoteArg == 'play' or UserSettings['UseAllTools'])
	if #Radios < 1 then
		return Notify('No compatible radios.', 5)
	end

	local Humanoid = Char['Humanoid']
	local RootPart = FindFirstChild(Char, 'HumanoidRootPart') or FindFirstChild(Char, 'Torso') or FindFirstChild(Char, 'UpperTorso')

	local ReturnPosition = RootPart['CFrame']
	G['Root'] = RootPart

	Notify('Visualizing; do not unequip or equip any tools until complete.', 7)

	local EncodedId = Encode(AssetId)
	local Forces = {}
	local Y25 = Vector3.new(150, 0, 0)
	local RadioIndex = 0

	G['Stopped'] = false

	local Descendants = GetDescendants(Char)

	local FindEmptyEnabled, RootP, TouchParts, CollideParts = #GetPlayers(Players) > 1 and UserSettings['VisualizerTeleport'], nil, {}, {}

	if FindEmptyEnabled then
		RootP = Create('BodyVelocity', {
			Velocity = Vector3.new(0, 0, 0);
			P = 1/0;
			MaxForce = Vector3.new(1/0, 1/0, 1/0);
			Parent = RootPart;
		})

		wait(.6)

		Notify('Finding nearest location outside of any given player\'s SimulationRadius.', 3)
		local EmptyFound = FindEmpty(RootPart)

		wait(.4)

		local Descendants = GetDescendants(workspace)
		for I = 1,#Descendants do local V = Descendants[I]
			if IsA(V, 'BasePart') then
				if V['CanTouch'] then
					V['CanTouch'] = false
					TouchParts[#TouchParts+1] = V
				end
			end
		end
		for I = 1,#Descendants do local V = Descendants[I]
			if IsA(V, 'BasePart') then
				if V['CanCollide'] then
					V['CanCollide'] = false
					CollideParts[#CollideParts+1] = V
				end
			end
		end

		Tween(RootPart, 1.4, 'Sine', 'Out', false, {CFrame = EmptyFound})
		wait(1.6)
	end

	for I = 1,#Radios do local V = Radios[I]
		CWrap(function()
		V['Parent'] = Char
		wait(.6)
		V['Parent'] = LP['Backpack']
		end)()
		wait()
	end

	wait(.9)

	for I = 1,#Radios do local V = Radios[I]
		CWrap(function()
			local Handle = V['Handle']

			Vel[#Vel+1] = Connect(RunService['Heartbeat'], function()
				Handle['Velocity'] = Y25
			end)

			V['Parent'] = Char

			local RightGrip;
			repeat
				Wait(Char['DescendantAdded'])
				RightGrip = FindFirstChild(Char, 'RightGrip', true)
			until RightGrip
			Destroy(RightGrip)
			
			wait(.2)
					
			local BP = Create('BodyPosition',{
				MaxForce = Vector3.new(1/0, 1/0, 1/0);
				Position = Handle['Position'];
				P = 1.0e5;
				Parent = Handle;
			})
			Forces[#Forces+1] = BP

			local BG = Create('BodyGyro',{
				MaxTorque = Vector3.new(1/0, 1/0, 1/0);
				P = 1.0e4;
				Parent = Handle;
			})
			Forces[#Forces+1] = BG

			local Part = Create('Part', {
				Anchored = true;
				CanCollide = false;
				Transparency = 1;
				Size = Handle['Size'];
				CFrame = RootPart['CFrame'];
				Parent = workspace;
			})
			G['Visualizer'][#G['Visualizer']+1] = Part

			Vel[#Vel+1] = Connect(RunService['Stepped'], function()
				BG['CFrame'] = Part['CFrame']
				BP['Position'] = Part['Position']
			end)

			repeat
				wait(.06)
			until isnetworkowner(Handle) or not gethiddenprop(Handle, 'NetworkIsSleeping') or G['Stopped']
			RadioIndex = RadioIndex + 1
		end)()
	end

	if G['Stopped'] then
		return false
	end
		
	repeat
		wait(.06)
	until RadioIndex >= #Radios

	for I = 1,#Radios do
		local V = Radios[I]
		V['Handle'].CFrame = RootPart['CFrame']
		local Remote = FindFirstChildOfClass(V, 'RemoteEvent')
		if Remote and I < UserSettings['MassPlayAmount'] then
			FireServer(Remote, RemoteArg, EncodedId)
		end
	end

	local Recycling = false
	Delete = Connect(Char['ChildRemoved'], function(Child)
		if IsA(Child, 'Tool') and not Recycling then
			Disconnect(Delete)
			UnequipTools(Humanoid)
			for I = 1,#Vel do
				local V = Vel[I]
				Vel[I] = nil
				Disconnect(V)
			end
			Vel = {}
			local OptionChildren = GetChildren(OptionsList)
			for I = 1,#OptionChildren do
				local V = OptionChildren[I]
				if IsA(V, 'TextBox') then
					Destroy(V)
				end
			end
			for I = 1,#G['Visualizer'] do
				local V = G['Visualizer'][I]
				G['Visualizer'][I] = nil
				Destroy(V)
			end
			G['Visualizer'] = {}
			for I = 1,#Forces do
				local V = Forces[I]
				Destroy(V)
			end
			Forces = {}
			G['Stopped'] = true
			Delete = nil
		end
	end)

	local Start = tick()
	repeat
		for I = 1,#Radios do
			local V = Radios[I]
			local Sound = FindFirstChildOfClass(V['Handle'], 'Sound')
			if Sound and Sound['Playing'] and Sound['IsLoaded'] then
				Fire(SetSound, Sound)
				break;
			end
		end
		wait(.06)
	until (CurrentSound and CurrentSound['Playing'] and CurrentSound['IsLoaded']) or tick() > Start + 8 or G['Stopped']

	if not G['Stopped'] and (not CurrentSound or not CurrentSound['Playing']) then
		CreateMessageBox('Visualizer', 'Your audio does not seem to be playing, (check #faq for more details). Would you like to cancel visualizing?', function()
			Humanoid['Jump'] = true
			UnequipTools(Humanoid)
			G['Stopped'] = true
			local Radios = GetRadios(UserSettings['UseAllTools'])
			if #Radios < 1 then
				return false
			end
			for I = 1,#Radios do
				local V = Radios[I]
				for K1, V1 in next, GetDescendants(V) do
					if IsA(V1, 'BodyMover') then
						Destroy(V1)
					end
				end
			end
			for I = 1,#G['Visualizer'] do
				local V = G['Visualizer'][I]
				G['Visualizer'][I] = nil
				Destroy(V)
			end
			Visualizer = {}
			for I = 1,#Vel do
				local V = Vel[I]
				Disconnect(V)
			end
			Vel = {}
			for I = 1,#Radios do
				local V = Radios[I]
				local Sound = FindFirstChildOfClass(V['Handle'], 'Sound')
				if Sound then
					Stop(Sound)
				end
				V['Parent'] = LP['Backpack']
			end
			RootPart['Anchored'] = false
			RootPart['CFrame'] = ReturnPosition
			if FindEmptyEnabled then
				for I = 1,#TouchParts do local V = TouchParts[I]
					V['CanTouch'] = true
				end
				for I = 1,#CollideParts do local V = CollideParts[I]
					V['CanCollide'] = true
				end
			end
		end)
	end

	G['Stopped'] = false
	RadioIndex = 0
	for I = 1,#Radios do local V = Radios[I]
		local Handle = V['Handle']
		CWrap(function()
			repeat
				wait(.06)
			until isnetworkowner(Handle) or not gethiddenprop(Handle, 'NetworkIsSleeping') or G['Stopped']
			RadioIndex = RadioIndex + 1
		end)()
	end

	repeat
		wait(.06)
	until RadioIndex >= #Radios

	if FindEmptyEnabled then
		for I = 1,#Radios do local V = Radios[I]
			local Handle = V['Handle']
			Tween(Handle, 2, 'Sine', 'Out', false, {CFrame = ReturnPosition})
		end
		for I = 1,#G['Visualizer'] do local V = G['Visualizer'][I]
			Tween(V, 2, 'Sine', 'Out', false, {CFrame = ReturnPosition})
		end

		Tween(RootPart, 2, 'Sine', 'Out', false, {CFrame = ReturnPosition})
		wait(2.4)
		if FindEmptyEnabled then
			Destroy(RootP)
			for I = 1,#TouchParts do local V = TouchParts[I]
				V['CanTouch'] = true
			end
			for I = 1,#CollideParts do local V = CollideParts[I]
				V['CanCollide'] = true
			end
		end
	end

	Notify('Visualizer initialized.', 3)

	for K,V in next, GetPlayingAnimationTracks(Humanoid) do
		V['Stop'](V)
	end
	SyncRadios(false, Time or -1)

	CWrap(function()
		repeat
			local Recycled = false
			for I = 1,#Radios do local V = Radios[I]
				CWrap(function()
					local Handle = V['Handle']
					if not isnetworkowner(Handle) or gethiddenprop(Handle, 'NetworkIsSleeping') then
						if not Recycling then
							Recycling = true
							Recycled = true
							Notify('Network failure detected, recycling broken visualizers.', 4)
						end
						V['Parent'] = LP['Backpack']
						Root['Anchored'] = true
						V['Parent'] = Char
						Recycling = false
						repeat
							wait(.06)
						until isnetworkowner(Handle) or not gethiddenprop(Handle, 'NetworkIsSleeping')
						local Descendants = GetDescendants(Char)
						for I1 = 1,#Descendants do local V1 = Descendants[I1]
							if V1['Name'] == 'RightGrip' then
								Destroy(V1)
							end
						end
						Root['Anchored'] = false
					end
				end)()
			end	
			wait(1)
			if Recycled then
				local AmountPlaying = 0
				for I = 1,#Radios do local V = Radios[I]
					local Handle = FindFirstChild(V, 'Handle')
					local Sound = Handle and FindFirstChildOfClass(Handle, 'Sound')
					if Sound and Sound['Playing'] then
						AmountPlaying = AmountPlaying + 1
					end
					if not Handle then
						TRemove(Radios, I)
					end
				end
				for I = 1,#Radios do local V = Radios[I]
					local Sound = FindFirstChildOfClass(V['Handle'], 'Sound')
					if Sound and AmountPlaying < UserSettings['MassPlayAmount'] and not Sound['Playing'] then
						Sound['Playing'] = true
						AmountPlaying = AmountPlaying + 1
					end
				end
				SyncRadios(true)
				for I = 1,#Radios do
					local V = Radios[I]
					local Handle = FindFirstChild(V, 'Handle')
					local Sound = FindFirstChildOfClass(Handle, 'Sound')
					if Sound and Sound['Playing'] and Sound['IsLoaded'] then
						Fire(SetSound, Sound)
						break;
					end
				end
			end
		until G['Stopped']
	end)()

	local Bool, ToLoad = pcall(function()
		return readfile(CPreset)
	end)
	if Bool then
		local Func;
		if Split(CPreset, '.')[2] == 'enc' then
			Notify('Encrypted presets no longer function. Ask the creator of the preset for the source.', 7)
		else
			if Match(ToLoad, 'while%sSelected%[%pPlaying%p%]%sdo') or Match(ToLoad, '^run_encrypted_preset')then
				Notify('You are running an outdated preset.', 7)
				wait(.2)
				return UnequipTools(Humanoid)
			end
			Func = LString(ToLoad)
		end
		if Func then
			local Success, Exception = ypcall(Func)
			if not Success then
				print('Error in preset.', CPreset, '\n\n' .. Exception)
				Notify(Format('Error in preset %s. Check F9 for more info.', CPreset), 7)
			end
		end
	else
		Notify(Format('Preset %s not found.', CPreset), 5)
	end
end

local DupeTools = function(Amount)
	local Char = LP['Character']
	if not Char then
		return false
	end
	local CancelDupeDebounce = true
	MainVariables['CancelDupe'] = false
	local Estimate, ReturnCFrame, Offset = (Players['RespawnTime'] + 1) * (Amount + 1), nil, ((GetPingValue(Ping) - 5) / 1000)
	local Humanoid, HumanoidRootPart;
	for I = 1, (Amount + 1) do
		if not (Humanoid and HumanoidRootPart) then
			Humanoid, HumanoidRootPart = WaitForChild(Char, 'Humanoid'), WaitForChild(Char, 'HumanoidRootPart')
		end
		if I > Amount or MainVariables['CancelDupe'] then
			HumanoidRootPart['Anchored'] = false
			LatentYield(1)
			Notify('Dupe-Tools complete.', 3)
			HumanoidRootPart['CFrame'] = ReturnCFrame
			break;
		end
		Notify(Format('Approx. %s seconds until dupe is complete.', math.round(Estimate - (Players['RespawnTime'] + 1) * I)), 1)
		if I == 1 then
			ReturnCFrame = HumanoidRootPart['CFrame']
			MainVariables['CurrentReturnPosition'] = ReturnCFrame
		end
		HeartbeatYield(Offset)
		HumanoidRootPart['CFrame'] = CFrame.new(NextInteger(RN, -3.0e4, 3.0e4), 2e4, NextInteger(RN, -3.0e4, 3.0e4))
		LatentYield(2)
		HumanoidRootPart['Anchored'] = true
		local Tools = {}
		local FakeChar = Create('Model', {Parent = workspace})
		LP['Character'] = FakeChar
		LP['Character'] = Char
		local Start = tick()
		Offset = ((GetPingValue(Ping) - 5) / 1000)
		repeat
			Wait(RunService['Heartbeat'])
		until tick() >= Start + Players['RespawnTime'] - Offset
		local Backpack = LP['Backpack']
		local Children = GetChildren(Backpack)
		for I = 1, #Children do
			local V = Children[I]
			if IsA(V, 'Tool') then
				V['Parent'] = Char
			end
		end
		local CharacterChildren = GetChildren(Char)
		for I = 1, #CharacterChildren do
			local V = CharacterChildren[I]
			if IsA(V, 'Tool') then
				V['Parent'] = workspace
				Tools[#Tools + 1] = V
			end
		end
		if FindFirstChild(Char, 'Head') then
			Destroy(Char['Head'])	
		end
		Destroy(FakeChar)
		Humanoid, HumanoidRootPart = nil, nil
		Char = Wait(LP['CharacterAdded'])
		repeat
			Wait(Char['ChildAdded'])
			Humanoid = FindFirstChild(Char, 'Humanoid')
			HumanoidRootPart = FindFirstChild(Char, 'HumanoidRootPart')
		until Humanoid and HumanoidRootPart
		for I = 1, #Tools do
			local V = Tools[I]
			if V and V['Parent'] then
				local Parent = V['Parent']
				if CancelDupeDebounce and IsA(Parent, 'Model') and FindFirstChild(Parent, 'Head') then
					CancelDupeDebounce = false
					CreateMessageBox('Dupe Tools', Format('Your duped tools are being stolen by %s. Would you like to cancel duping?', Parent['Name']), function()
						MainVariables['CancelDupe'] = true
						Notify('Cancelling tool dupe.', 3)
					end)
					break
				end
				if FindFirstChild(V, 'Handle') then
				    V['Handle'].CFrame = HumanoidRootPart['CFrame']
					firetouchinterest(HumanoidRootPart, V['Handle'], 0)
					Wait(RunService['Heartbeat'])
				end
			end
		end
	end
end

Buttonize(VisualizeButton, function()
	Visualize(VisualizeAssetIdTextBox['Text'], VisualizeStartTimeTextBox['Text'] ~= '' and VisualizeStartTimeTextBox['Text'] or nil)
end)

Buttonize(VisualizeSyncButton, function()
	SyncRadios(true)
end)

Buttonize(DupeToolsButton, function()
	DupeTools(tonumber(DupeAmountTextBox['Text']) or 1, DupeType)
end)

-- TextBox Connections

Connect(GetPropertyChangedSignal(AntiLogAssetIdTextBox, 'Text'), function()
	AntiLogAssetIdTextBox['Text'] = Gsub(AntiLogAssetIdTextBox['Text'], '%D+', '')
end)

Connect(GetPropertyChangedSignal(VisualizeAssetIdTextBox, 'Text'), function()
	VisualizeAssetIdTextBox['Text'] = Gsub(VisualizeAssetIdTextBox['Text'], '%D+', '')
end)

Connect(GetPropertyChangedSignal(StartTimeTextBox, 'Text'), function()
	StartTimeTextBox['Text'] = Gsub(StartTimeTextBox['Text'], '[^%.%d+]', '')
end)

-- Favorites Sector Functions

local DefaultAudio, DefaultAudioOptions = Clone(FavoriteIds['Audio']), Clone(FavoriteIds['AudioOptions'])

Destroy(FavoriteIds['Audio'])
Destroy(FavoriteIds['AudioOptions'])

local FavoriteIdList = JSONDecode(GetData('FavoriteAudios', '[]'))

local AddFavorite = function(AssetId, Name, Save)
	if Save then
		FavoriteIdList[AssetId] = Name
		CreateData('FavoriteAudios', JSONEncode(FavoriteIdList), true)
	end

	local Clone, OptionsClone = Clone(DefaultAudio), Clone(DefaultAudioOptions)
	Clone['Name'] = AssetId
	OptionsClone['Name'] = AssetId .. 'Options'
	Clone['AudioName'].Text = Name
	local TextHidden, HiddenText = true, Rep('*', Len(AssetId)); Clone['AudioId'].Text = HiddenText
	
	local OptionsHidden, OriginalSize, OriginalOptionsSize = true, Clone['Size'], OptionsClone['Size']

	Clone['Size'] = UDim2.fromScale(0,0)
	OptionsClone['Size'] = UDim2.fromScale(0,0)

	IconButtonize(Clone['ImageButton'], function()
		if OptionsHidden then
			OptionsClone['Parent'] = FavoriteIds
		end
		Tween(Clone['ImageButton'], .2, 'Quad', 'InOut', false, {Rotation = OptionsHidden and -90 or 90})
		local T = Tween(OptionsClone, .2, 'Quad', 'InOut', false, {Size = OptionsHidden and OriginalOptionsSize or UDim2.fromScale(0,0)})
		if not OptionsHidden then
			Wait(T['Completed'])
			OptionsClone['Parent'] = nil
		end
		ListResize(FavoriteIds)
		OptionsHidden = not OptionsHidden
	end)
	
	Buttonize(Clone['ToggleButton'], function()
		Clone['ToggleButton'].Label['Text'] = TextHidden and 'Hide Id' or 'Show Id'
		Clone['AudioId'].Text = TextHidden and AssetId or HiddenText
		TextHidden = not TextHidden
	end)

	Connect(Clone['AudioName'].FocusLost, function()
		FavoriteIdList[AssetId] = Clone['AudioName'].Text
		CreateData('FavoriteAudios', JSONEncode(FavoriteIdList), true)
	end)

	Buttonize(Clone['RemoveButton'], function()
		FavoriteIdList[AssetId] = nil
		CreateData('FavoriteAudios', JSONEncode(FavoriteIdList), true)
		Destroy(Clone)
		Destroy(OptionsClone)
	end)
	
	Buttonize(OptionsClone['BackpackPlayButton'], function()
		PlayRadios(AssetId, 'Backpack')
	end)

	Buttonize(OptionsClone['MassPlayButton'], function()
		PlayRadios(AssetId, 'Mass')
	end)

	Buttonize(OptionsClone['PlayButton'], function()
		PlayRadios(AssetId, 'Normal')
	end)

	Buttonize(OptionsClone['VisualizeButton'], function()
		Visualize(AssetId, VisualizeStartTimeTextBox['Text'] ~= '' and VisualizeStartTimeTextBox['Text'] or nil)
	end)

	Clone['Parent'] = FavoriteIds
	Tween(Clone, .2, 'Quad', 'InOut', false, {Size = OriginalSize})
	ListResize(FavoriteIds, .4)
end

for K,V in next, FavoriteIdList do
	AddFavorite(K, V)
end

Connect(GetPropertyChangedSignal(AddAssetIdTextBox, 'Text'), function()
	AddAssetIdTextBox['Text'] = Gsub(AddAssetIdTextBox['Text'], '%D+', '')
end)

Buttonize(AddButton, function()
	local AssetId, Name = AddAssetIdTextBox['Text']
	if pcall(function()
		Name = MarketplaceService:GetProductInfo(AssetId)['Name']
	end) then
		AddFavorite(AssetId, Name, true)
	end
end)

Buttonize(FavoriteIdButton, function()
	if SelectedLoggedId then
		local AssetId = Decode(SelectedLoggedId)
		local Bool, Name = pcall(function()
			return MarketplaceService:GetProductInfo(AssetId)['Name']
		end)
		if AssetId and Name then
			Tween(SectorContainer, .3, 'Quint', 'InOut', false, {Position = UDim2.fromScale(0, -2)})
			local T = Tween(SectorIndicator, .3, 'Quint', 'InOut', false, {Position = UDim2.fromScale(.857, FavoritesIcon['Position'].Y['Scale'])})
			Wait(T['Completed'])
			AddFavorite(AssetId, Name, true)
			Notify(Format('Added "%s" to favorites.', Name), 5)
		end
	end
end)

do
	local Removed = {}
	Connect(GetPropertyChangedSignal(SearchAudio, 'Text'), function()
		local Text = Lower(SearchAudio['Text'])
		if Text ~= '' then
			for K,V in next, FavoriteIdList do
				if not Match(V, Text) then
					local Obj = FindFirstChild(FavoriteIds, K)
					local Options = FindFirstChild(FavoriteIds, K..'Options')
					if Obj then
						Obj['Parent'] = nil
						if Options then
							Removed[#Removed+1] = {Obj, V, Options}
							Options['Parent'] = nil
						else
							Removed[#Removed+1] = {Obj, V}
						end
					end
				end
			end
			ListResize(FavoriteIds, .08)
		end
		for K = 1,#Removed do local V = Removed[K]
			if V and V[1] and V[2] and (Text == '' or Match(Lower(V[2]), Text)) then
				V[1].Parent = FavoriteIds
				if V[3] then
					V[3].Parent = FavoriteIds
				end
				TRemove(Removed, K)
				ListResize(FavoriteIds, .08)
			end
		end
	end)
end

-- Commands

local ChatPrefix = GetData('ChatPrefix', ';')

local Commands = {}

local GetPlayer = function(Name)
	Name = Lower(Name)
	local Matches = {}
	local UseDisplayName = Sub(Name, 1, 1) == '@'
	Name = Gsub(Name, '@', '')
	for I = #Name,1,-1 do 
		for K,V in next, GetPlayers(Players) do 
			if Name == Sub(Lower(V[(UseDisplayName and 'DisplayName') or 'Name']), 1, I) then 
				Matches[#Matches+1] = V
				break
			end
		end
	end
	if #Matches > 0 then 
		return Matches[1]
	else
		for K,V in next, GetPlayers(Players) do 
			if Match(Lower(V[(UseDisplayName and 'DisplayName') or 'Name']), Name) then 
				return V
			end
		end
	end
end

local Parse = function(Msg, Override)
	Msg = Lower(Msg)
	if Override then
		if not Msg:find('^'..Cleanse(ChatPrefix)) then
			Msg = ChatPrefix..Msg
		end
	end
	if Match(Msg, '^'..Cleanse(ChatPrefix)) then
		local Args = {}; for V in Gmatch(Msg, '[^%s]+') do
			Args[#Args+1] = V
		end
		local Func = Commands[Gsub(Args[1], Cleanse(ChatPrefix),'',1)];
		TRemove(Args, 1)
		if Func then
			CommandLine['Text'] = ''
			CWrap(function()
				Func(table.unpack(Args))
			end)()
		end
	end
end

local DefaultCommand = Clone(CommandsList['Command'])

Destroy(CommandsList['Command'])

local AddCommand = function(Name, Clickable, Description, Func)
	Commands[Name] = Func
	local Clone = Clone(DefaultCommand)
	Clone['Text'] = Name
	AddToolTip(Clone, Description)
	Connect(Clone['MouseButton1Click'], Clickable and function()
		Func()
	end or function()
		CommandLine.CaptureFocus(CommandLine)
		CommandLine['Text'] = Name .. ' '
		CommandLine['CursorPosition'] = #Name + 2
	end)
	Clone['Parent'] = CommandsList
end

AddCommand('demesh', true, 'Removes the meshes from all of your tools.', function()
	local Char = LP['Character']
	if not Char then
		return
	end
	local BackpackChildren = GetChildren(LP['Backpack'])
	for I = 1,#BackpackChildren do
		local V = BackpackChildren[I]
		if IsA(V, 'Tool') then
			V['Parent'] = Char
		end
	end
	Wait(RunService['Heartbeat'])
	local CharacterChildren = GetChildren(Char)
	Notify(Format('Demeshed %d tools.', #BackpackChildren), 3)
	for I = 1,#CharacterChildren do
		local V = CharacterChildren[I]
		if IsA(V, 'Tool') then
			local ToolDescendants = GetDescendants(V)
			for K1 = 1, #ToolDescendants do
				local V1 = ToolDescendants[K1]
				if IsA(V1, 'SpecialMesh') then
					Destroy(V1)
				end
			end
		end
	end
end)

AddCommand('deletetool', true, 'Deletes all tools in your backpack with the same name as the one you have equipped.', function()
	local Char = LP['Character']
	if not Char then
		return
	end
	local Tool = FindFirstChildOfClass(Char, 'Tool')
	if Tool then
		Notify(Format('Deleting tools with name: "%s".', Tool['Name']), 3)
		local BackpackChildren = GetChildren(LP['Backpack'])
		for I = 1,#BackpackChildren do
			local V = BackpackChildren[I]
			if IsA(V, 'Tool') and V['Name'] == Tool['Name'] then
				Destroy(V)
			end
		end
		Destroy(Tool)
	else
		Notify('No tool equipped.', 3)
	end
end)

AddCommand('nodefault', true, 'Disables the annoying black gui when you click on the screen with golden boomboxes.', function()
	local Char = LP['Character']
	if not Char then
		return false
	end
	Notify('Deleting and disabling default ChooseSongGui.', 3)
	local Descendants = GetChildren(LP['Backpack'])
	local CharacterChildren = GetChildren(Char)
	for I = 1,#CharacterChildren do
		local V = CharacterChildren[I]
		Descendants[#Descendants+1] = V
	end
	for I = 1,#Descendants do
		local V = Descendants[I]
		if IsA(V, 'Tool') then
			if FindFirstChild(V, 'Client') then
				V['Client'].Disabled = true
			end
		end
	end
	local PlayerDescendants = GetDescendants(LP)
	for I = 1,#PlayerDescendants do
		local V = PlayerDescendants[I]
		if V['Name'] == 'ChooseSongGui' then
			Destroy(V)
		end
	end
end)

AddCommand('resetvisualizer', true, 'If the visualizer is broken use this command to fix it.', function()
	Notify('Attempting to reset visualizer.', 3)
	G['Stopped'] = true
	local Char = LP['Character']
	if Char and FindFirstChild(Char, 'Humanoid') then
		UnequipTools(Char['Humanoid'])
	end
	LatentYield(1)
	local Radios = GetRadios(UserSettings['UseAllTools'])
	if #Radios < 1 then
		return false
	end
	for I = 1,#Radios do
		local V = Radios[I]
		for K1, V1 in next, GetDescendants(V) do
			if IsA(V1, 'BodyMover') then
				Destroy(V1)
			elseif IsA(V1, 'Sound') then
				Stop(V1)
			end
		end
	end
	for I = 1,#G['Visualizer'] do
		local V = G['Visualizer'][I]
		G['Visualizer'][I] = nil
		Destroy(V)
	end
	G['Visualizer'] = {}
	for I = 1,#Vel do
		local V = Vel[I]
		Disconnect(V)
	end
	Vel = {}
	for I = 1,#Radios do
		local V = Radios[I]
		V['Parent'] = LP['Backpack']
	end
	if Char and FindFirstChild(Char, 'HumanoidRootPart') then
		Char['HumanoidRootPart'].Anchored = false
	end
end)

AddCommand('canceldupe', true, 'Takes no parameters, cancels and immediately finishes duping.', function()
	MainVariables['CancelDupe'] = true
	Notify('Cancelling tool dupe.', 3)
end)

AddCommand('chatprefix', false, 'Takes parameter <prefix>, changes the prefix for commands in chat.', function(TPrefix)
	if typeof(TPrefix) == 'string' then
		ChatPrefix = TPrefix
		CreateData('ChatPrefix', ChatPrefix, true)
		return Notify(Format('Set your chat prefix to "%s"', ChatPrefix), 3)
	end
end)

AddCommand('mute', false, 'Takes parameter <Name/@DisplayName>, mutes player without loop-muting.', function(Name)
	local Player = GetPlayer(Name)
	if Player then
		Mute(Player)
		Notify(Format('Muted "%s" once.', Player['Name']), 3)
	else
		Notify('Could not find player.', 3)
	end
end)

AddCommand('log', false, 'Takes parameter <Name/@DisplayName>, logs player\'s audios.', function(Name)
	local Player = GetPlayer(Name)
	if Player then
		LogPlayer(Player)
	else
		Notify('Could not find player.', 3)
	end
end)

AddCommand('refreshpresets', true, 'Refreshes your presets in the preset list in the visualizer tab.', function()
	RemovePresets()
	AddPresets()
	Notify('Refreshed presets.', 1)
end)

AddCommand('defaultsize', true, 'Returns the UI to its default size.', function()
	Tween(Main, .2, 'Quad', 'InOut', false, {Size = DefaultSize})
	MainSize = DefaultSize
	CreateData('SizeData', JSONEncode({
		DefaultSize['X'].Scale;
		DefaultSize['X'].Offset;
		DefaultSize['Y'].Scale;
		DefaultSize['Y'].Offset;
	}), true)
	Notify('Reset to default size.', 1)
end)

AddCommand('useantilog', true, 'Toggles encoding on your audio. This will allow you to play group audios.', function()
	UserSettings['EncodeAudios'] = not UserSettings['EncodeAudios']
	Notify(Format('Anti-log encoding has been set to %s.', tostring(UserSettings['EncodeAudios'])), 3)
end)

Connect(CommandLine['FocusLost'], function(Enter)
	if Enter then
		Parse(CommandLine['Text'], true)
	end
end)

Connect(LP['Chatted'], function(Message)
	Parse(Message)
end)

-- Initialize

local ControlsSize = WindowControls['Size']
Main['Size'] = UDim2.fromScale(0,0)
WindowControls['Size'] = UDim2.fromScale(0,0)

ProtectGui(UIV3)
UIV3['Parent'] = CoreGui

Tween(Main, .2, 'Quad', 'InOut', false, {Size = MainSize})
Tween(WindowControls, .2, 'Quad', 'InOut', false, {Size = ControlsSize})
