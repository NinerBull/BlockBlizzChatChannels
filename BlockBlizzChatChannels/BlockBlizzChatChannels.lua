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




BlockBlizzChatChannels_ChatName_General = "General"
BlockBlizzChatChannels_ChatName_Trade = "Trade"
BlockBlizzChatChannels_ChatName_Services = "Services"
BlockBlizzChatChannels_ChatName_LocalDefense = "LocalDefense"
BlockBlizzChatChannels_ChatName_WorldDefense = "WorldDefense"
BlockBlizzChatChannels_ChatName_LookingForGroup = "LookingForGroup"


-- https://wago.tools/db2/ChatChannels

if (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE) then

	BlockBlizzChatChannels_ChatName_General = C_ChatInfo.GetChannelShortcutForChannelID(1)
	BlockBlizzChatChannels_ChatName_Trade = C_ChatInfo.GetChannelShortcutForChannelID(2)
	BlockBlizzChatChannels_ChatName_Services = C_ChatInfo.GetChannelShortcutForChannelID(42)
	BlockBlizzChatChannels_ChatName_LocalDefense = C_ChatInfo.GetChannelShortcutForChannelID(22)
	BlockBlizzChatChannels_ChatName_LookingForGroup = C_ChatInfo.GetChannelShortcutForChannelID(26)

end


if (WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC or WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC or WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC) then

	BlockBlizzChatChannels_ChatName_General = C_ChatInfo.GetChannelShortcutForChannelID(1)
	BlockBlizzChatChannels_ChatName_Trade = C_ChatInfo.GetChannelShortcutForChannelID(2)
	BlockBlizzChatChannels_ChatName_LocalDefense = C_ChatInfo.GetChannelShortcutForChannelID(22)
	BlockBlizzChatChannels_ChatName_WorldDefense = C_ChatInfo.GetChannelShortcutForChannelID(23)
	BlockBlizzChatChannels_ChatName_LookingForGroup = C_ChatInfo.GetChannelShortcutForChannelID(26)

end


if (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then

	BlockBlizzChatChannels_ChatName_General = C_ChatInfo.GetChannelShortcutForChannelID(1)
	BlockBlizzChatChannels_ChatName_Trade = C_ChatInfo.GetChannelShortcutForChannelID(2)
	BlockBlizzChatChannels_ChatName_Services = C_ChatInfo.GetChannelShortcutForChannelID(45)
	BlockBlizzChatChannels_ChatName_LocalDefense = C_ChatInfo.GetChannelShortcutForChannelID(22)
	BlockBlizzChatChannels_ChatName_WorldDefense = C_ChatInfo.GetChannelShortcutForChannelID(23)
	BlockBlizzChatChannels_ChatName_LookingForGroup = C_ChatInfo.GetChannelShortcutForChannelID(24)

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
			local name = "Block " .. BlockBlizzChatChannels_ChatName_General .. " Chat"
			local tooltip = "Checking this box will prevent all of your characters from joining the " .. BlockBlizzChatChannels_ChatName_General .. " Chat Channel."
			local defaultValue = false
			local setting = nil
		
			setting = Settings.RegisterAddOnSetting(category, variable, variable, BlockBlizzChatChannelsData, type(defaultValue), name, (BlockBlizzChatChannelsData[variable] or defaultValue))
		
			Settings.SetOnValueChangedCallback(variable, OnSettingChanged)
			
			Settings.CreateCheckbox(category, setting, tooltip)

		end

		do
			local variable = "BlockTrade"
			local name = "Block " .. BlockBlizzChatChannels_ChatName_Trade .. " Chat"
			local tooltip = "Checking this box will prevent all of your characters from joining the " .. BlockBlizzChatChannels_ChatName_Trade .. " Chat Channel."
			local defaultValue = false
			local setting = nil

			setting = Settings.RegisterAddOnSetting(category, variable, variable, BlockBlizzChatChannelsData, type(defaultValue), name, (BlockBlizzChatChannelsData[variable] or defaultValue))
			
			Settings.SetOnValueChangedCallback(variable, OnSettingChanged)
			
			Settings.CreateCheckbox(category, setting, tooltip)
		end

		-- Services channel only exists in Retail and 20th Anniversary Classic Era
		if (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE or WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
			do
				local variable = "BlockServices"
				local name = "Block " .. BlockBlizzChatChannels_ChatName_Services .. " Chat"
				local tooltip = "Checking this box will prevent all of your characters from joining the " .. BlockBlizzChatChannels_ChatName_Services .. " Chat Channel."
				local defaultValue = false
				local setting = nil
				
				if (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE) then
					defaultValue = true
				end

				setting = Settings.RegisterAddOnSetting(category, variable, variable, BlockBlizzChatChannelsData, type(defaultValue), name, (BlockBlizzChatChannelsData[variable] or defaultValue))
				
				
				Settings.SetOnValueChangedCallback(variable, OnSettingChanged)
				
				Settings.CreateCheckbox(category, setting, tooltip)
			end
		end
		
		do
			local variable = "BlockLocalDefense"
			local name = "Block " .. BlockBlizzChatChannels_ChatName_LocalDefense .. " Chat"
			local tooltip = "Checking this box will prevent all of your characters from joining the " .. BlockBlizzChatChannels_ChatName_LocalDefense .. " Chat Channel."
			local defaultValue = false
			local setting = nil

			setting = Settings.RegisterAddOnSetting(category, variable, variable, BlockBlizzChatChannelsData, type(defaultValue), name, (BlockBlizzChatChannelsData[variable] or defaultValue))
			
			Settings.SetOnValueChangedCallback(variable, OnSettingChanged)
			
			Settings.CreateCheckbox(category, setting, tooltip)
		end
		
		-- WorldDefense channel is only in Classic
		if (WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE) then
			do
				local variable = "BlockWorldDefense"
				local name = "Block " .. BlockBlizzChatChannels_ChatName_WorldDefense .. " Chat"
				local tooltip = "Checking this box will prevent all of your characters from joining the " .. BlockBlizzChatChannels_ChatName_WorldDefense .. " Chat Channel."
				local defaultValue = false
				local setting = nil

				setting = Settings.RegisterAddOnSetting(category, variable, variable, BlockBlizzChatChannelsData, type(defaultValue), name, (BlockBlizzChatChannelsData[variable] or defaultValue))
				
				Settings.SetOnValueChangedCallback(variable, OnSettingChanged)
				
				Settings.CreateCheckbox(category, setting, tooltip)
			end
		end
		
		do
			local variable = "BlockLookingForGroup"
			local name = "Block " .. BlockBlizzChatChannels_ChatName_LookingForGroup .. " Chat"
			local tooltip = "Checking this box will prevent all of your characters from joining the " .. BlockBlizzChatChannels_ChatName_LookingForGroup .. " Chat Channel."
			local defaultValue = false
			local setting = nil


			setting = Settings.RegisterAddOnSetting(category, variable, variable, BlockBlizzChatChannelsData, type(defaultValue), name, (BlockBlizzChatChannelsData[variable] or defaultValue))
			
			
			Settings.SetOnValueChangedCallback(variable, OnSettingChanged)
			
			Settings.CreateCheckbox(category, setting, tooltip)
		end
		
		do
			layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Rejoin Blizzard Chat Channels"));
		end
		
		
		-- Join button will try to join all the channels below. It'll auto kick us out of channels we don't wanna be in.
		do
			local function OnButtonClick()
				JoinPermanentChannel(BlockBlizzChatChannels_ChatName_General)
				ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, BlockBlizzChatChannels_ChatName_General)
				
				JoinPermanentChannel(BlockBlizzChatChannels_ChatName_LocalDefense)
				ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, BlockBlizzChatChannels_ChatName_LocalDefense)
				
				JoinPermanentChannel(BlockBlizzChatChannels_ChatName_Trade)
				ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, BlockBlizzChatChannels_ChatName_Trade)
				
				JoinPermanentChannel(BlockBlizzChatChannels_ChatName_LookingForGroup)
				ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, BlockBlizzChatChannels_ChatName_LookingForGroup)
				
				if (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE or WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
					JoinPermanentChannel(BlockBlizzChatChannels_ChatName_Services)
					ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, BlockBlizzChatChannels_ChatName_Services)
				end
				
				if (WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE) then
					JoinPermanentChannel(BlockBlizzChatChannels_ChatName_WorldDefense)
					ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, BlockBlizzChatChannels_ChatName_WorldDefense)
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
		if (GetChannelName((GetChannelName(BlockBlizzChatChannels_ChatName_General))) > 0) then
			LeaveChannelByName(BlockBlizzChatChannels_ChatName_General)
		end
	end
	
	if (BlockBlizzChatChannelsData["BlockLocalDefense"] == true) then
		if (GetChannelName((GetChannelName(BlockBlizzChatChannels_ChatName_LocalDefense))) > 0) then
			LeaveChannelByName(BlockBlizzChatChannels_ChatName_LocalDefense)
		end
	end
	
	if (BlockBlizzChatChannelsData["BlockTrade"] == true) then
		if (GetChannelName((GetChannelName(BlockBlizzChatChannels_ChatName_Trade))) > 0) then
			LeaveChannelByName(BlockBlizzChatChannels_ChatName_Trade)
		end
	end
	
	if (BlockBlizzChatChannelsData["BlockLookingForGroup"] == true) then
		if (GetChannelName((GetChannelName(BlockBlizzChatChannels_ChatName_LookingForGroup))) > 0) then
			LeaveChannelByName(BlockBlizzChatChannels_ChatName_LookingForGroup)
		end
	end
	
	if (WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE) then
		if (BlockBlizzChatChannelsData["BlockWorldDefense"] == true) then
			if (GetChannelName((GetChannelName(BlockBlizzChatChannels_ChatName_WorldDefense))) > 0) then
				LeaveChannelByName(BlockBlizzChatChannels_ChatName_WorldDefense)
			end
		end
	end
	
	if (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE or WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
		if (BlockBlizzChatChannelsData["BlockServices"] == true) then
			if (GetChannelName((GetChannelName(BlockBlizzChatChannels_ChatName_Services))) > 0) then
				LeaveChannelByName(BlockBlizzChatChannels_ChatName_Services)
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
	
	BlockBlizzChatChannels_Tooltip:AddDoubleLine("Blocking " .. BlockBlizzChatChannels_ChatName_General .. " Chat" .. ":", BlockBlizzChatChannels_Frame:IsChatBlockActive("BlockGeneral"), nil, nil, nil,  WHITE_FONT_COLOR.r, WHITE_FONT_COLOR.g, WHITE_FONT_COLOR.b)
	
	BlockBlizzChatChannels_Tooltip:AddDoubleLine("Blocking " .. BlockBlizzChatChannels_ChatName_Trade .. " Chat" .. ":", BlockBlizzChatChannels_Frame:IsChatBlockActive("BlockTrade"), nil, nil, nil,  WHITE_FONT_COLOR.r, WHITE_FONT_COLOR.g, WHITE_FONT_COLOR.b)
	
	if (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE) then
		BlockBlizzChatChannels_Tooltip:AddDoubleLine("Blocking " .. BlockBlizzChatChannels_ChatName_Services .. " Chat" .. ":", BlockBlizzChatChannels_Frame:IsChatBlockActive("BlockServices"), nil, nil, nil,  WHITE_FONT_COLOR.r, WHITE_FONT_COLOR.g, WHITE_FONT_COLOR.b)
	end
	
	BlockBlizzChatChannels_Tooltip:AddDoubleLine("Blocking " .. BlockBlizzChatChannels_ChatName_LocalDefense .. " Chat" .. ":", BlockBlizzChatChannels_Frame:IsChatBlockActive("BlockLocalDefense"), nil, nil, nil,  WHITE_FONT_COLOR.r, WHITE_FONT_COLOR.g, WHITE_FONT_COLOR.b)
	
	if (WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE) then
		BlockBlizzChatChannels_Tooltip:AddDoubleLine("Blocking " .. BlockBlizzChatChannels_ChatName_WorldDefense .. " Chat" .. ":", BlockBlizzChatChannels_Frame:IsChatBlockActive("BlockWorldDefense"), nil, nil, nil,  WHITE_FONT_COLOR.r, WHITE_FONT_COLOR.g, WHITE_FONT_COLOR.b)
	end
	
	BlockBlizzChatChannels_Tooltip:AddDoubleLine("Blocking " .. BlockBlizzChatChannels_ChatName_LookingForGroup .. " Chat" .. ":", BlockBlizzChatChannels_Frame:IsChatBlockActive("BlockLookingForGroup"), nil, nil, nil,  WHITE_FONT_COLOR.r, WHITE_FONT_COLOR.g, WHITE_FONT_COLOR.b)
	
	BlockBlizzChatChannels_Tooltip:AddLine(" ")
	BlockBlizzChatChannels_Tooltip:AddLine("Click to change settings.",  GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	
	BlockBlizzChatChannels_Tooltip:Show()
end

function BlockBlizzChatChannels_CompartmentLeave(buttonName)
	BlockBlizzChatChannels_Tooltip:Hide()
end