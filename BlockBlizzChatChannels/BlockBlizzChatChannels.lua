--[[
===================================================
Block Blizzard Chat Channels
https://github.com/NinerBull/BlockBlizzChatChannels
===================================================
]]--

local BlockBlizzChatChannels_Frame = CreateFrame("Frame")

-- Need to know when the player joins/leaves a channel so we can /leave the channels we don't want to be in.
BlockBlizzChatChannels_Frame:RegisterEvent("CHANNEL_UI_UPDATE")
BlockBlizzChatChannels_Frame:RegisterEvent("ADDON_LOADED")

local BlockBlizzChatChannels_TextName = FRIENDLY_STATUS_COLOR:WrapTextInColorCode("<Block Blizzard Chat Channels>")
local BlockBlizzChatChannels_TextSlash = FRIENDLY_STATUS_COLOR:WrapTextInColorCode("/blockchatchannels")

local function OnSettingChanged(_, setting, value)
	local variable = setting:GetVariable()
	BlockBlizzChatChannelsData[variable] = value
	BlockBlizzChatChannels_Frame.CheckForChatBlock()
end


BlockBlizzChatChannels_UseNewRegisterSetting = true

if ((select(4, GetBuildInfo())) == 40400) then
	BlockBlizzChatChannels_UseNewRegisterSetting = false
end




BlockBlizzChatChannels_Frame:SetScript("OnEvent", function(self, event, arg1, arg2)

	if (event == "ADDON_LOADED" and arg1 == "BlockBlizzChatChannels") then
		
		
		-- Create options table and write in chat
		if (type(BlockBlizzChatChannelsData) ~= "table") then
			BlockBlizzChatChannelsData = {}
			print(BlockBlizzChatChannels_TextName .. " Addon Loaded for the first time! Type " .. BlockBlizzChatChannels_TextSlash .. " to configure.")
		end

		-- Using the new style of options menu for this!
		local category, layout = Settings.RegisterVerticalLayoutCategory("Block Blizzard Chat Channels Account Wide")
		
		BlockBlizzChatChannels_OptionsPanelFrameCategoryID = category:GetID()

		do
			layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Select Channels to Block Below", "All characters on your account will be prevented from joining the channels you check below.\n\nYou will need to manually rejoin these channels if you change your mind later on.\n\nChanges take effect immediately."));
		end

		do
			local variable = "BlockGeneral"
			local name = "Block General Chat"
			local tooltip = "Checking this box will prevent all of your characters from joining the General Chat Channel.\n\nThis is the zone-wide public chat channel, and even works in instances."
			local defaultValue = false
			local setting = nil
			
			if (BlockBlizzChatChannels_UseNewRegisterSetting == true) then
				-- New Style of Tickbox
				setting = Settings.RegisterAddOnSetting(category, variable, variable, BlockBlizzChatChannelsData, type(defaultValue), name, (BlockBlizzChatChannelsData[variable] or defaultValue))
			else
				-- For Classic, will need to edit this in future most likely
				setting = Settings.RegisterAddOnSetting(category, name, variable, type(defaultValue), (BlockBlizzChatChannelsData[variable] or defaultValue))
			end
			
			Settings.SetOnValueChangedCallback(variable, OnSettingChanged)
			
			if (BlockBlizzChatChannels_UseNewRegisterSetting == true) then
				Settings.CreateCheckbox(category, setting, tooltip)
			else
				Settings.CreateCheckBox(category, setting, tooltip)
			end
		end

		do
			local variable = "BlockTrade"
			local name = "Block Trade Chat"
			local tooltip = "Checking this box will prevent all of your characters from joining the Trade Chat Channel.\n\nThis channel is accessible in all major cities, and discussions can often fill the chat box very quickly during peak hours on populated realms."
			local defaultValue = false
			local setting = nil

			if (BlockBlizzChatChannels_UseNewRegisterSetting == true) then
				-- New Style of Tickbox
				setting = Settings.RegisterAddOnSetting(category, variable, variable, BlockBlizzChatChannelsData, type(defaultValue), name, (BlockBlizzChatChannelsData[variable] or defaultValue))
			else
				-- For Classic, will need to edit this in future most likely
				setting = Settings.RegisterAddOnSetting(category, name, variable, type(defaultValue), (BlockBlizzChatChannelsData[variable] or defaultValue))
			end
			
			Settings.SetOnValueChangedCallback(variable, OnSettingChanged)
			
			if (BlockBlizzChatChannels_UseNewRegisterSetting == true) then
				Settings.CreateCheckbox(category, setting, tooltip)
			else
				Settings.CreateCheckBox(category, setting, tooltip)
			end
		end

		-- Services channel only exists in Retail
		if (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE) then
			do
				local variable = "BlockServices"
				local name = "Block Services Chat"
				local tooltip = "Checking this box will prevent all of your characters from joining the Services Chat Channel.\n\nThis channel was introduced in 9.2.7 and is accessible in major cities.\n\nIt is mostly used by players selling Raid/M+/PVP Boosting/Carrying services and the like, and it can get extremely spammy on some populated realms."
				local defaultValue = true
				local setting = nil

				if (BlockBlizzChatChannels_UseNewRegisterSetting == true) then
					-- New Style of Tickbox
					setting = Settings.RegisterAddOnSetting(category, variable, variable, BlockBlizzChatChannelsData, type(defaultValue), name, (BlockBlizzChatChannelsData[variable] or defaultValue))
				else
					-- For Classic, will need to edit this in future most likely
					setting = Settings.RegisterAddOnSetting(category, name, variable, type(defaultValue), (BlockBlizzChatChannelsData[variable] or defaultValue))
				end
				
				Settings.SetOnValueChangedCallback(variable, OnSettingChanged)
				
				if (BlockBlizzChatChannels_UseNewRegisterSetting == true) then
					Settings.CreateCheckbox(category, setting, tooltip)
				else
					Settings.CreateCheckBox(category, setting, tooltip)
				end
			end
		end
		
		do
			local variable = "BlockLocalDefense"
			local name = "Block LocalDefense Chat"
			local tooltip = "Checking this box will prevent all of your characters from joining the LocalDefense Chat Channel.\n\nThis channel is zone-wide, and will show 'X is under attack!' notices when a friendly NPC is killed by the opposite faction, which could get spammy in War Mode/PVP Realms."
			local defaultValue = false
			local setting = nil

			if (BlockBlizzChatChannels_UseNewRegisterSetting == true) then
				-- New Style of Tickbox
				setting = Settings.RegisterAddOnSetting(category, variable, variable, BlockBlizzChatChannelsData, type(defaultValue), name, (BlockBlizzChatChannelsData[variable] or defaultValue))
			else
				-- For Classic, will need to edit this in future most likely
				setting = Settings.RegisterAddOnSetting(category, name, variable, type(defaultValue), (BlockBlizzChatChannelsData[variable] or defaultValue))
			end
			
			Settings.SetOnValueChangedCallback(variable, OnSettingChanged)
			
			if (BlockBlizzChatChannels_UseNewRegisterSetting == true) then
				Settings.CreateCheckbox(category, setting, tooltip)
			else
				Settings.CreateCheckBox(category, setting, tooltip)
			end
		end
		
		-- WorldDefense channel is only in Classic
		if (WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE) then
			do
				local variable = "BlockWorldDefense"
				local name = "Block WorldDefense Chat"
				local tooltip = "Checking this box will prevent all of your characters from joining the WorldDefense Chat Channel.\n\nSimiar to LocalDefense, except it will show attack notices for the entire world, rather than just the zone you are in."
				local defaultValue = false
				local setting = nil

				if (BlockBlizzChatChannels_UseNewRegisterSetting == true) then
					-- New Style of Tickbox
					setting = Settings.RegisterAddOnSetting(category, variable, variable, BlockBlizzChatChannelsData, type(defaultValue), name, (BlockBlizzChatChannelsData[variable] or defaultValue))
				else
					-- For Classic, will need to edit this in future most likely
					setting = Settings.RegisterAddOnSetting(category, name, variable, type(defaultValue), (BlockBlizzChatChannelsData[variable] or defaultValue))
				end
				
				Settings.SetOnValueChangedCallback(variable, OnSettingChanged)
				
				if (BlockBlizzChatChannels_UseNewRegisterSetting == true) then
					Settings.CreateCheckbox(category, setting, tooltip)
				else
					Settings.CreateCheckBox(category, setting, tooltip)
				end
			end
		end
		
		do
			local variable = "BlockLookingForGroup"
			local name = "Block LookingForGroup Chat"
			local tooltip = "Checking this box will prevent all of your characters from joining the LookingForGroup Chat Channel.\n\nThis channel is realm-wide. It's meant to help find groups for content, and can see heavy use on Cataclysm and Era Realms.\n\nLeaving this channel won't prevent you from using the Dungeon/Raid/Group Finders in Retail/Cataclysm, but addons such as 'LFG Group Bulletin Board' can read this channel to parse text for data, therefore it is not recommended to block this channel if you use such an addon."
			local defaultValue = false
			local setting = nil

			if (BlockBlizzChatChannels_UseNewRegisterSetting == true) then
				-- New Style of Tickbox
				setting = Settings.RegisterAddOnSetting(category, variable, variable, BlockBlizzChatChannelsData, type(defaultValue), name, (BlockBlizzChatChannelsData[variable] or defaultValue))
			else
				-- For Classic, will need to edit this in future most likely
				setting = Settings.RegisterAddOnSetting(category, name, variable, type(defaultValue), (BlockBlizzChatChannelsData[variable] or defaultValue))
			end
			
			Settings.SetOnValueChangedCallback(variable, OnSettingChanged)
			
			if (BlockBlizzChatChannels_UseNewRegisterSetting == true) then
				Settings.CreateCheckbox(category, setting, tooltip)
			else
				Settings.CreateCheckBox(category, setting, tooltip)
			end
		end
		
		do
			layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Rejoin Blizzard Chat Channels"));
		end
		
		
		-- Join button will try to join all the channels below. It'll auto kick us out of channels we don't wanna be in.
		do
			local function OnButtonClick()
				JoinPermanentChannel("General")
				ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, "General")
				
				JoinPermanentChannel("LocalDefense")
				ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, "LocalDefense")
				
				JoinPermanentChannel("Trade")
				ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, "Trade")
				
				JoinPermanentChannel("LookingForGroup")
				ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, "LookingForGroup")
				
				if (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE) then
					JoinPermanentChannel("Services")
					ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, "Services")
				else
					JoinPermanentChannel("WorldDefense")
					ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, "WorldDefense")
				end
				BlockBlizzChatChannels_Frame.CheckForChatBlock()
				print(BlockBlizzChatChannels_TextName .. " Rejoined all channels, where possible.")
			end

			local addSearchTags = true;
			local initializer = CreateSettingsButtonInitializer("Rejoin All Channels", "Rejoin", OnButtonClick, "Click to attempt to rejoin all the default chat channels on your current character.\n\nYou won't join any channels you have blocked above.", addSearchTags);
			layout:AddInitializer(initializer);
		end

		Settings.RegisterAddOnCategory(category)
		
		SLASH_BLOCKBLIZZCHATCHANNELS1 = "/blockblizzchatchannels"
		SLASH_BLOCKBLIZZCHATCHANNELS2 = "/blockchatchannels"
		function SlashCmdList.BLOCKBLIZZCHATCHANNELS(msg)
			Settings.OpenToCategory(BlockBlizzChatChannels_OptionsPanelFrameCategoryID)
		end
		
	end
	
	-- Remove player from channels if they're blocked
	if (event == "CHANNEL_UI_UPDATE") then
		BlockBlizzChatChannels_Frame.CheckForChatBlock()
	end
			
end)

function BlockBlizzChatChannels_Frame:CheckForChatBlock()

	if (BlockBlizzChatChannelsData["BlockGeneral"] == true) then
		if (GetChannelName((GetChannelName("General"))) > 0) then
			LeaveChannelByName("General")
		end
	end
	
	if (BlockBlizzChatChannelsData["BlockLocalDefense"] == true) then
		if (GetChannelName((GetChannelName("LocalDefense"))) > 0) then
			LeaveChannelByName("LocalDefense")
		end
	end
	
	if (BlockBlizzChatChannelsData["BlockTrade"] == true) then
		if (GetChannelName((GetChannelName("Trade"))) > 0) then
			LeaveChannelByName("Trade")
		end
	end
	
	if (BlockBlizzChatChannelsData["BlockLookingForGroup"] == true) then
		if (GetChannelName((GetChannelName("LookingForGroup"))) > 0) then
			LeaveChannelByName("LookingForGroup")
		end
	end
	
	if (WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE) then
		if (BlockBlizzChatChannelsData["BlockWorldDefense"] == true) then
			if (GetChannelName((GetChannelName("WorldDefense"))) > 0) then
				LeaveChannelByName("WorldDefense")
			end
		end
	end
	
	if (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE) then
		if (BlockBlizzChatChannelsData["BlockServices"] == true) then
			if (GetChannelName((GetChannelName("Services"))) > 0) then
				LeaveChannelByName("Services")
			end
		end
	end

end


-- For use in the Addon Compartment Tooltip
function BlockBlizzChatChannels_Frame:IsChatBlockActive(thisChannel)
	if (BlockBlizzChatChannelsData[thisChannel] == true) then
		return("|TInterface\\RaidFrame\\ReadyCheck-Ready:0|t")
	else
		return("|TInterface\\RaidFrame\\ReadyCheck-NotReady:0|t")
	end	
end



--Addon Compartment Stuff
local BlockBlizzChatChannels_Tooltip

function BlockBlizzChatChannels_CompartmentClick(addonName, buttonName)
	Settings.OpenToCategory(BlockBlizzChatChannels_OptionsPanelFrameCategoryID)
end

-- Create a tooltip when hovering over the Addon Compartment option
function BlockBlizzChatChannels_CompartmentHover(addonName, buttonName)
	if (not BlockBlizzChatChannels_Tooltip) then
		BlockBlizzChatChannels_Tooltip = CreateFrame("GameTooltip", "BlockBlizzChatChannels_Tooltip_Compartment", UIParent, "GameTooltipTemplate")
	end
	
	local classColorString = C_ClassColor.GetClassColor(UnitClass("player")) or NORMAL_FONT_COLOR
	
	BlockBlizzChatChannels_Tooltip:SetOwner(buttonName, "ANCHOR_LEFT");
	BlockBlizzChatChannels_Tooltip:SetText("Block Blizzard Chat Channels")
	
	BlockBlizzChatChannels_Tooltip:AddLine(" ")
	BlockBlizzChatChannels_Tooltip:AddLine("Current Settings:",  WHITE_FONT_COLOR.r, WHITE_FONT_COLOR.g, WHITE_FONT_COLOR.b)
	BlockBlizzChatChannels_Tooltip:AddLine(" ")
	
	BlockBlizzChatChannels_Tooltip:AddDoubleLine("Blocking General Chat" .. ":", BlockBlizzChatChannels_Frame:IsChatBlockActive("BlockGeneral"), nil, nil, nil,  WHITE_FONT_COLOR.r, WHITE_FONT_COLOR.g, WHITE_FONT_COLOR.b)
	
	BlockBlizzChatChannels_Tooltip:AddDoubleLine("Blocking Trade Chat" .. ":", BlockBlizzChatChannels_Frame:IsChatBlockActive("BlockTrade"), nil, nil, nil,  WHITE_FONT_COLOR.r, WHITE_FONT_COLOR.g, WHITE_FONT_COLOR.b)
	
	if (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE) then
		BlockBlizzChatChannels_Tooltip:AddDoubleLine("Blocking Services Chat" .. ":", BlockBlizzChatChannels_Frame:IsChatBlockActive("BlockServices"), nil, nil, nil,  WHITE_FONT_COLOR.r, WHITE_FONT_COLOR.g, WHITE_FONT_COLOR.b)
	end
	
	BlockBlizzChatChannels_Tooltip:AddDoubleLine("Blocking LocalDefense Chat" .. ":", BlockBlizzChatChannels_Frame:IsChatBlockActive("BlockLocalDefense"), nil, nil, nil,  WHITE_FONT_COLOR.r, WHITE_FONT_COLOR.g, WHITE_FONT_COLOR.b)
	
	if (WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE) then
		BlockBlizzChatChannels_Tooltip:AddDoubleLine("Blocking WorldDefense Chat" .. ":", BlockBlizzChatChannels_Frame:IsChatBlockActive("BlockWorldDefense"), nil, nil, nil,  WHITE_FONT_COLOR.r, WHITE_FONT_COLOR.g, WHITE_FONT_COLOR.b)
	end
	
	BlockBlizzChatChannels_Tooltip:AddDoubleLine("Blocking LookingForGroup Chat" .. ":", BlockBlizzChatChannels_Frame:IsChatBlockActive("BlockLookingForGroup"), nil, nil, nil,  WHITE_FONT_COLOR.r, WHITE_FONT_COLOR.g, WHITE_FONT_COLOR.b)
	
	BlockBlizzChatChannels_Tooltip:AddLine(" ")
	BlockBlizzChatChannels_Tooltip:AddLine("Click to change settings.",  GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	
	BlockBlizzChatChannels_Tooltip:Show()
end

function BlockBlizzChatChannels_CompartmentLeave(buttonName)
	BlockBlizzChatChannels_Tooltip:Hide()
end