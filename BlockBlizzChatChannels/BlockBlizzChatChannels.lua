--[[
===================================================
Block Blizzard Chat Channels
https://github.com/NinerBull/BlockBlizzChatChannels
===================================================
]]--

local _, L = ...;

local BlockBlizzChatChannels_Frame = CreateFrame("Frame")

-- Need to know when the player joins/leaves a channel so we can /leave the channels we don't want to be in.
BlockBlizzChatChannels_Frame:RegisterEvent("CHANNEL_UI_UPDATE")
BlockBlizzChatChannels_Frame:RegisterEvent("ADDON_LOADED")

BlockBlizzChatChannels_Frame.TextName = FRIENDLY_STATUS_COLOR:WrapTextInColorCode("<" ..  L.BLOCKBLIZZ_ADDONNAME_SHORT .. ">")
BlockBlizzChatChannels_Frame.TextSlash = FRIENDLY_STATUS_COLOR:WrapTextInColorCode("/blockchatchannels")

function BlockBlizzChatChannels_Frame.OnSettingChanged(_, setting, value)
	local variable = setting:GetVariable()
	BlockBlizzChatChannelsData[variable] = value
	BlockBlizzChatChannels_Frame.CheckForChatBlock()
end


BlockBlizzChatChannels_Frame.ChatChannelNames = {
	General = "General",
	Trade = "Trade",
	Services = "Services",
	LocalDefense = "LocalDefense",
	WorldDefense = "WorldDefense",
	LookingForGroup = "LookingForGroup",
	HardcoreDeaths = "HardcoreDeaths",
	GuildRecruitment = "GuildRecruitment"
}




-- https://wago.tools/db2/ChatChannels

if (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE) then

	BlockBlizzChatChannels_Frame.ChatChannelNames.General = C_ChatInfo.GetChannelShortcutForChannelID(1)
	BlockBlizzChatChannels_Frame.ChatChannelNames.Trade = C_ChatInfo.GetChannelShortcutForChannelID(2)
	BlockBlizzChatChannels_Frame.ChatChannelNames.Services = C_ChatInfo.GetChannelShortcutForChannelID(42)
	BlockBlizzChatChannels_Frame.ChatChannelNames.LocalDefense = C_ChatInfo.GetChannelShortcutForChannelID(22)
	BlockBlizzChatChannels_Frame.ChatChannelNames.LookingForGroup = C_ChatInfo.GetChannelShortcutForChannelID(26)

elseif (WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC or WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC) then

	BlockBlizzChatChannels_Frame.ChatChannelNames.General = C_ChatInfo.GetChannelShortcutForChannelID(1)
	BlockBlizzChatChannels_Frame.ChatChannelNames.Trade = C_ChatInfo.GetChannelShortcutForChannelID(2)
	BlockBlizzChatChannels_Frame.ChatChannelNames.LocalDefense = C_ChatInfo.GetChannelShortcutForChannelID(22)
	BlockBlizzChatChannels_Frame.ChatChannelNames.WorldDefense = C_ChatInfo.GetChannelShortcutForChannelID(23)
	BlockBlizzChatChannels_Frame.ChatChannelNames.LookingForGroup = C_ChatInfo.GetChannelShortcutForChannelID(26)

elseif (WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC) then --China Wrath

	BlockBlizzChatChannels_Frame.ChatChannelNames.General = C_ChatInfo.GetChannelShortcutForChannelID(1)
	BlockBlizzChatChannels_Frame.ChatChannelNames.Trade = C_ChatInfo.GetChannelShortcutForChannelID(2)
	BlockBlizzChatChannels_Frame.ChatChannelNames.LocalDefense = C_ChatInfo.GetChannelShortcutForChannelID(22)
	BlockBlizzChatChannels_Frame.ChatChannelNames.WorldDefense = C_ChatInfo.GetChannelShortcutForChannelID(23)
	BlockBlizzChatChannels_Frame.ChatChannelNames.GuildRecruitment = C_ChatInfo.GetChannelShortcutForChannelID(25)
	BlockBlizzChatChannels_Frame.ChatChannelNames.LookingForGroup = C_ChatInfo.GetChannelShortcutForChannelID(26)

elseif (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then

	BlockBlizzChatChannels_Frame.ChatChannelNames.General = C_ChatInfo.GetChannelShortcutForChannelID(1)
	BlockBlizzChatChannels_Frame.ChatChannelNames.Trade = C_ChatInfo.GetChannelShortcutForChannelID(2)
	BlockBlizzChatChannels_Frame.ChatChannelNames.Services = C_ChatInfo.GetChannelShortcutForChannelID(45)
	BlockBlizzChatChannels_Frame.ChatChannelNames.LocalDefense = C_ChatInfo.GetChannelShortcutForChannelID(22)
	BlockBlizzChatChannels_Frame.ChatChannelNames.WorldDefense = C_ChatInfo.GetChannelShortcutForChannelID(23)
	BlockBlizzChatChannels_Frame.ChatChannelNames.LookingForGroup = C_ChatInfo.GetChannelShortcutForChannelID(24)
	BlockBlizzChatChannels_Frame.ChatChannelNames.HardcoreDeaths = C_ChatInfo.GetChannelShortcutForChannelID(44)
	BlockBlizzChatChannels_Frame.ChatChannelNames.GuildRecruitment = C_ChatInfo.GetChannelShortcutForChannelID(25)

end


BlockBlizzChatChannels_Frame:SetScript("OnEvent", function(self, event, arg1, arg2)

	if (event == "ADDON_LOADED" and arg1 == "BlockBlizzChatChannels") then
		
		
		-- Create options table and write in chat
		if (type(BlockBlizzChatChannelsData) ~= "table") then
			BlockBlizzChatChannelsData = {}
			print(BlockBlizzChatChannels_Frame.TextName .. " " ..  string.format(L.BLOCKBLIZZ_FIRSTIME, BlockBlizzChatChannels_Frame.TextSlash))
		end

		-- Using the new style of options menu for this!
		local category, layout = Settings.RegisterVerticalLayoutCategory(L.BLOCKBLIZZ_ADDONNAME)
		
		BlockBlizzChatChannels_OptionsPanelFrameCategoryID = category:GetID()

		do
			layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L.BLOCKBLIZZ_OPT_TITLE, L.BLOCKBLIZZ_OPT_TITLE_DESC));
		end

		do
			local variable = "BlockGeneral"
			local name =  string.format(L.BLOCKBLIZZ_OPT_CHECKBOX_NAME, BlockBlizzChatChannels_Frame.ChatChannelNames.General)
			local tooltip = string.format(L.BLOCKBLIZZ_OPT_CHECKBOX_DESC, BlockBlizzChatChannels_Frame.ChatChannelNames.General)
			local defaultValue = false
			local setting = nil
		
			setting = Settings.RegisterAddOnSetting(category, variable, variable, BlockBlizzChatChannelsData, type(defaultValue), name, (BlockBlizzChatChannelsData[variable] or defaultValue))
		
			Settings.SetOnValueChangedCallback(variable, BlockBlizzChatChannels_Frame.OnSettingChanged)
			
			Settings.CreateCheckbox(category, setting, tooltip)

		end

		do
			local variable = "BlockTrade"
			local name =  string.format(L.BLOCKBLIZZ_OPT_CHECKBOX_NAME, BlockBlizzChatChannels_Frame.ChatChannelNames.Trade)
			local tooltip = string.format(L.BLOCKBLIZZ_OPT_CHECKBOX_DESC, BlockBlizzChatChannels_Frame.ChatChannelNames.Trade)
			local defaultValue = false
			local setting = nil

			setting = Settings.RegisterAddOnSetting(category, variable, variable, BlockBlizzChatChannelsData, type(defaultValue), name, (BlockBlizzChatChannelsData[variable] or defaultValue))
			
			Settings.SetOnValueChangedCallback(variable, BlockBlizzChatChannels_Frame.OnSettingChanged)
			
			Settings.CreateCheckbox(category, setting, tooltip)
		end

		-- Services channel only exists in Retail and 20th Anniversary Classic Era
		if (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE or WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
			do
				local variable = "BlockServices"
				local name =  string.format(L.BLOCKBLIZZ_OPT_CHECKBOX_NAME, BlockBlizzChatChannels_Frame.ChatChannelNames.Services)
				local tooltip = string.format(L.BLOCKBLIZZ_OPT_CHECKBOX_DESC, BlockBlizzChatChannels_Frame.ChatChannelNames.Services)
				local defaultValue = false
				local setting = nil
				
				if (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE) then
					defaultValue = true
				end

				setting = Settings.RegisterAddOnSetting(category, variable, variable, BlockBlizzChatChannelsData, type(defaultValue), name, (BlockBlizzChatChannelsData[variable] or defaultValue))
				
				
				Settings.SetOnValueChangedCallback(variable, BlockBlizzChatChannels_Frame.OnSettingChanged)
				
				Settings.CreateCheckbox(category, setting, tooltip)
			end
		end
		
		do
			local variable = "BlockLocalDefense"
			local name =  string.format(L.BLOCKBLIZZ_OPT_CHECKBOX_NAME, BlockBlizzChatChannels_Frame.ChatChannelNames.LocalDefense)
			local tooltip = string.format(L.BLOCKBLIZZ_OPT_CHECKBOX_DESC, BlockBlizzChatChannels_Frame.ChatChannelNames.LocalDefense)
			local defaultValue = false
			local setting = nil

			setting = Settings.RegisterAddOnSetting(category, variable, variable, BlockBlizzChatChannelsData, type(defaultValue), name, (BlockBlizzChatChannelsData[variable] or defaultValue))
			
			Settings.SetOnValueChangedCallback(variable, BlockBlizzChatChannels_Frame.OnSettingChanged)
			
			Settings.CreateCheckbox(category, setting, tooltip)
		end
		
		-- WorldDefense channel is only in Classic
		if (WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE) then
			do
				local variable = "BlockWorldDefense"
				local name =  string.format(L.BLOCKBLIZZ_OPT_CHECKBOX_NAME, BlockBlizzChatChannels_Frame.ChatChannelNames.WorldDefense)
				local tooltip = string.format(L.BLOCKBLIZZ_OPT_CHECKBOX_DESC, BlockBlizzChatChannels_Frame.ChatChannelNames.WorldDefense)
				local defaultValue = false
				local setting = nil

				setting = Settings.RegisterAddOnSetting(category, variable, variable, BlockBlizzChatChannelsData, type(defaultValue), name, (BlockBlizzChatChannelsData[variable] or defaultValue))
				
				Settings.SetOnValueChangedCallback(variable, BlockBlizzChatChannels_Frame.OnSettingChanged)
				
				Settings.CreateCheckbox(category, setting, tooltip)
			end
		end
		
		do
			local variable = "BlockLookingForGroup"
			local name =  string.format(L.BLOCKBLIZZ_OPT_CHECKBOX_NAME, BlockBlizzChatChannels_Frame.ChatChannelNames.LookingForGroup)
			local tooltip = string.format(L.BLOCKBLIZZ_OPT_CHECKBOX_DESC, BlockBlizzChatChannels_Frame.ChatChannelNames.LookingForGroup)
			local defaultValue = false
			local setting = nil


			setting = Settings.RegisterAddOnSetting(category, variable, variable, BlockBlizzChatChannelsData, type(defaultValue), name, (BlockBlizzChatChannelsData[variable] or defaultValue))
			
			
			Settings.SetOnValueChangedCallback(variable, BlockBlizzChatChannels_Frame.OnSettingChanged)
			
			Settings.CreateCheckbox(category, setting, tooltip)
		end
		
		
		
		-- Guild Recuitment is in Classic Era and China Wrath
		if (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC or WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC) then
			do
				local variable = "BlockGuildRecruitment"
				local name =  string.format(L.BLOCKBLIZZ_OPT_CHECKBOX_NAME, BlockBlizzChatChannels_Frame.ChatChannelNames.GuildRecruitment)
				local tooltip = string.format(L.BLOCKBLIZZ_OPT_CHECKBOX_DESC, BlockBlizzChatChannels_Frame.ChatChannelNames.GuildRecruitment)
				local defaultValue = false
				local setting = nil
				

				setting = Settings.RegisterAddOnSetting(category, variable, variable, BlockBlizzChatChannelsData, type(defaultValue), name, (BlockBlizzChatChannelsData[variable] or defaultValue))
				
				
				Settings.SetOnValueChangedCallback(variable, BlockBlizzChatChannels_Frame.OnSettingChanged)
				
				Settings.CreateCheckbox(category, setting, tooltip)
			end
		end
			
		-- HardcoreDeaths is only in Classic Era
		if (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
			do
				local variable = "BlockHardcoreDeaths"
				local name =  string.format(L.BLOCKBLIZZ_OPT_CHECKBOX_NAME, BlockBlizzChatChannels_Frame.ChatChannelNames.HardcoreDeaths)
				local tooltip = string.format(L.BLOCKBLIZZ_OPT_CHECKBOX_DESC, BlockBlizzChatChannels_Frame.ChatChannelNames.HardcoreDeaths)
				local defaultValue = false
				local setting = nil
				

				setting = Settings.RegisterAddOnSetting(category, variable, variable, BlockBlizzChatChannelsData, type(defaultValue), name, (BlockBlizzChatChannelsData[variable] or defaultValue))
				
				
				Settings.SetOnValueChangedCallback(variable, BlockBlizzChatChannels_Frame.OnSettingChanged)
				
				Settings.CreateCheckbox(category, setting, tooltip)
			end
			
			
		end
		

		
		
		do
			layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L.BLOCKBLIZZ_OPT_REJOIN_TITLE));
		end
		
		
		-- Join button will try to join all the channels below. It'll auto kick us out of channels we don't wanna be in.
		do
			local function OnButtonClick()
				JoinPermanentChannel(BlockBlizzChatChannels_Frame.ChatChannelNames.General)
				if (ChatFrame_AddChannel) then
					ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, BlockBlizzChatChannels_Frame.ChatChannelNames.General)
				else
					ChatFrameMixin.AddChannel(DEFAULT_CHAT_FRAME, BlockBlizzChatChannels_Frame.ChatChannelNames.General) -- 12.0.0
				end
				
				JoinPermanentChannel(BlockBlizzChatChannels_Frame.ChatChannelNames.LocalDefense)
				if (ChatFrame_AddChannel) then
					ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, BlockBlizzChatChannels_Frame.ChatChannelNames.LocalDefense)
				else
					ChatFrameMixin.AddChannel(DEFAULT_CHAT_FRAME, BlockBlizzChatChannels_Frame.ChatChannelNames.LocalDefense) -- 12.0.0
				end
				
				JoinPermanentChannel(BlockBlizzChatChannels_Frame.ChatChannelNames.Trade)
				if (ChatFrame_AddChannel) then
					ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, BlockBlizzChatChannels_Frame.ChatChannelNames.Trade)
				else
					ChatFrameMixin.AddChannel(DEFAULT_CHAT_FRAME, BlockBlizzChatChannels_Frame.ChatChannelNames.Trade) -- 12.0.0
				end
				
				JoinPermanentChannel(BlockBlizzChatChannels_Frame.ChatChannelNames.LookingForGroup)
				if (ChatFrame_AddChannel) then
					ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, BlockBlizzChatChannels_Frame.ChatChannelNames.LookingForGroup)
				else
					ChatFrameMixin.AddChannel(DEFAULT_CHAT_FRAME, BlockBlizzChatChannels_Frame.ChatChannelNames.LookingForGroup) -- 12.0.0
				end
				
				if (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE or WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
					JoinPermanentChannel(BlockBlizzChatChannels_Frame.ChatChannelNames.Services)
					if (ChatFrame_AddChannel) then
						ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, BlockBlizzChatChannels_Frame.ChatChannelNames.Services)
					else
						ChatFrameMixin.AddChannel(DEFAULT_CHAT_FRAME, BlockBlizzChatChannels_Frame.ChatChannelNames.Services) -- 12.0.0
					end
				end
				
				if (WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE) then
					JoinPermanentChannel(BlockBlizzChatChannels_Frame.ChatChannelNames.WorldDefense)
					if (ChatFrame_AddChannel) then
						ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, BlockBlizzChatChannels_Frame.ChatChannelNames.WorldDefense)
					else
						ChatFrameMixin.AddChannel(DEFAULT_CHAT_FRAME, BlockBlizzChatChannels_Frame.ChatChannelNames.WorldDefense) -- 12.0.0
					end
				end
				
				if (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC or WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC) then
					JoinPermanentChannel(BlockBlizzChatChannels_Frame.ChatChannelNames.GuildRecruitment)
					if (ChatFrame_AddChannel) then
						ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, BlockBlizzChatChannels_Frame.ChatChannelNames.GuildRecruitment)
					else
						ChatFrameMixin.AddChannel(DEFAULT_CHAT_FRAME, BlockBlizzChatChannels_Frame.ChatChannelNames.GuildRecruitment) -- 12.0.0
					end
				end
				
				if (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
					JoinPermanentChannel(BlockBlizzChatChannels_Frame.ChatChannelNames.HardcoreDeaths)
					if (ChatFrame_AddChannel) then
						ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, BlockBlizzChatChannels_Frame.ChatChannelNames.HardcoreDeaths)
					else
						ChatFrameMixin.AddChannel(DEFAULT_CHAT_FRAME, BlockBlizzChatChannels_Frame.ChatChannelNames.HardcoreDeaths) -- 12.0.0
					end				
				end
								
				BlockBlizzChatChannels_Frame.CheckForChatBlock()
				print(BlockBlizzChatChannels_Frame.TextName .. " " .. L.BLOCKBLIZZ_OPT_REJOIN_CHATOUTPUT)
			end

			local addSearchTags = true;
			local initializer = CreateSettingsButtonInitializer(L.BLOCKBLIZZ_OPT_REJOIN_BUTTON, L.BLOCKBLIZZ_OPT_REJOIN_BUTTON_SHORT, OnButtonClick, BLOCKBLIZZ_OPT_REJOIN_BUTTON_DESC, addSearchTags);
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
		if (GetChannelName((GetChannelName(BlockBlizzChatChannels_Frame.ChatChannelNames.General))) > 0) then
			LeaveChannelByName(BlockBlizzChatChannels_Frame.ChatChannelNames.General)
			print(BlockBlizzChatChannels_Frame.TextName .. " " ..  string.format(L.BLOCKBLIZZ_LEAVING_CHANNEL, BlockBlizzChatChannels_Frame.ChatChannelNames.General, BlockBlizzChatChannels_Frame.TextSlash))
		end
	end
	
	if (BlockBlizzChatChannelsData["BlockLocalDefense"] == true) then
		if (GetChannelName((GetChannelName(BlockBlizzChatChannels_Frame.ChatChannelNames.LocalDefense))) > 0) then
			LeaveChannelByName(BlockBlizzChatChannels_Frame.ChatChannelNames.LocalDefense)
			print(BlockBlizzChatChannels_Frame.TextName .. " " ..  string.format(L.BLOCKBLIZZ_LEAVING_CHANNEL, BlockBlizzChatChannels_Frame.ChatChannelNames.LocalDefense, BlockBlizzChatChannels_Frame.TextSlash))
		end
	end
	
	if (BlockBlizzChatChannelsData["BlockTrade"] == true) then
		if (GetChannelName((GetChannelName(BlockBlizzChatChannels_Frame.ChatChannelNames.Trade))) > 0) then
			LeaveChannelByName(BlockBlizzChatChannels_Frame.ChatChannelNames.Trade)
			print(BlockBlizzChatChannels_Frame.TextName .. " " ..  string.format(L.BLOCKBLIZZ_LEAVING_CHANNEL, BlockBlizzChatChannels_Frame.ChatChannelNames.Trade, BlockBlizzChatChannels_Frame.TextSlash))
		end
	end
	
	if (BlockBlizzChatChannelsData["BlockLookingForGroup"] == true) then
		if (GetChannelName((GetChannelName(BlockBlizzChatChannels_Frame.ChatChannelNames.LookingForGroup))) > 0) then
			LeaveChannelByName(BlockBlizzChatChannels_Frame.ChatChannelNames.LookingForGroup)
			print(BlockBlizzChatChannels_Frame.TextName .. " " ..  string.format(L.BLOCKBLIZZ_LEAVING_CHANNEL, BlockBlizzChatChannels_Frame.ChatChannelNames.LookingForGroup, BlockBlizzChatChannels_Frame.TextSlash))
		end
	end
	
	if (WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE) then
		if (BlockBlizzChatChannelsData["BlockWorldDefense"] == true) then
			if (GetChannelName((GetChannelName(BlockBlizzChatChannels_Frame.ChatChannelNames.WorldDefense))) > 0) then
				LeaveChannelByName(BlockBlizzChatChannels_Frame.ChatChannelNames.WorldDefense)
				print(BlockBlizzChatChannels_Frame.TextName .. " " ..  string.format(L.BLOCKBLIZZ_LEAVING_CHANNEL, BlockBlizzChatChannels_Frame.ChatChannelNames.WorldDefense, BlockBlizzChatChannels_Frame.TextSlash))
			end
		end
	end
	
	if (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE or WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
		if (BlockBlizzChatChannelsData["BlockServices"] == true) then
			if (GetChannelName((GetChannelName(BlockBlizzChatChannels_Frame.ChatChannelNames.Services))) > 0) then
				LeaveChannelByName(BlockBlizzChatChannels_Frame.ChatChannelNames.Services)
				print(BlockBlizzChatChannels_Frame.TextName .. " " ..  string.format(L.BLOCKBLIZZ_LEAVING_CHANNEL, BlockBlizzChatChannels_Frame.ChatChannelNames.Services, BlockBlizzChatChannels_Frame.TextSlash))
			end
		end
	end
	
	if (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC or WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC) then
		if (BlockBlizzChatChannelsData["BlockGuildRecruitment"] == true) then
			if (GetChannelName((GetChannelName(BlockBlizzChatChannels_Frame.ChatChannelNames.GuildRecruitment))) > 0) then
				LeaveChannelByName(BlockBlizzChatChannels_Frame.ChatChannelNames.GuildRecruitment)
				print(BlockBlizzChatChannels_Frame.TextName .. " " ..  string.format(L.BLOCKBLIZZ_LEAVING_CHANNEL, BlockBlizzChatChannels_Frame.ChatChannelNames.GuildRecruitment, BlockBlizzChatChannels_Frame.TextSlash))
			end
		end
	end
		
	if (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
		if (BlockBlizzChatChannelsData["BlockHardcoreDeaths"] == true) then
			if (GetChannelName((GetChannelName(BlockBlizzChatChannels_Frame.ChatChannelNames.HardcoreDeaths))) > 0) then
				LeaveChannelByName(BlockBlizzChatChannels_Frame.ChatChannelNames.HardcoreDeaths)
				print(BlockBlizzChatChannels_Frame.TextName .. " " ..  string.format(L.BLOCKBLIZZ_LEAVING_CHANNEL, BlockBlizzChatChannels_Frame.ChatChannelNames.HardcoreDeaths, BlockBlizzChatChannels_Frame.TextSlash))
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
	BlockBlizzChatChannels_Tooltip:SetText(L.BLOCKBLIZZ_ADDONNAME_SHORT)
	
	BlockBlizzChatChannels_Tooltip:AddLine(" ")
	BlockBlizzChatChannels_Tooltip:AddLine(L.BLOCKBLIZZ_ADCOM_CURRENT,  WHITE_FONT_COLOR.r, WHITE_FONT_COLOR.g, WHITE_FONT_COLOR.b)
	BlockBlizzChatChannels_Tooltip:AddLine(" ")
	
	BlockBlizzChatChannels_Tooltip:AddDoubleLine(string.format(L.BLOCKBLIZZ_OPT_CHECKBOX_NAME, BlockBlizzChatChannels_Frame.ChatChannelNames.General) .. ":", BlockBlizzChatChannels_Frame:IsChatBlockActive("BlockGeneral"), nil, nil, nil,  WHITE_FONT_COLOR.r, WHITE_FONT_COLOR.g, WHITE_FONT_COLOR.b)
	
	BlockBlizzChatChannels_Tooltip:AddDoubleLine(string.format(L.BLOCKBLIZZ_OPT_CHECKBOX_NAME, BlockBlizzChatChannels_Frame.ChatChannelNames.Trade) .. ":", BlockBlizzChatChannels_Frame:IsChatBlockActive("BlockTrade"), nil, nil, nil,  WHITE_FONT_COLOR.r, WHITE_FONT_COLOR.g, WHITE_FONT_COLOR.b)
	
	if (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE or WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
		BlockBlizzChatChannels_Tooltip:AddDoubleLine(string.format(L.BLOCKBLIZZ_OPT_CHECKBOX_NAME, BlockBlizzChatChannels_Frame.ChatChannelNames.Services) .. ":", BlockBlizzChatChannels_Frame:IsChatBlockActive("BlockServices"), nil, nil, nil,  WHITE_FONT_COLOR.r, WHITE_FONT_COLOR.g, WHITE_FONT_COLOR.b)
	end
	
	BlockBlizzChatChannels_Tooltip:AddDoubleLine(string.format(L.BLOCKBLIZZ_OPT_CHECKBOX_NAME, BlockBlizzChatChannels_Frame.ChatChannelNames.LocalDefense) .. ":", BlockBlizzChatChannels_Frame:IsChatBlockActive("BlockLocalDefense"), nil, nil, nil,  WHITE_FONT_COLOR.r, WHITE_FONT_COLOR.g, WHITE_FONT_COLOR.b)
	
	if (WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE) then
		BlockBlizzChatChannels_Tooltip:AddDoubleLine(string.format(L.BLOCKBLIZZ_OPT_CHECKBOX_NAME, BlockBlizzChatChannels_Frame.ChatChannelNames.WorldDefense) .. ":", BlockBlizzChatChannels_Frame:IsChatBlockActive("BlockWorldDefense"), nil, nil, nil,  WHITE_FONT_COLOR.r, WHITE_FONT_COLOR.g, WHITE_FONT_COLOR.b)
	end
	
	BlockBlizzChatChannels_Tooltip:AddDoubleLine(string.format(L.BLOCKBLIZZ_OPT_CHECKBOX_NAME, BlockBlizzChatChannels_Frame.ChatChannelNames.LookingForGroup) .. ":", BlockBlizzChatChannels_Frame:IsChatBlockActive("BlockLookingForGroup"), nil, nil, nil,  WHITE_FONT_COLOR.r, WHITE_FONT_COLOR.g, WHITE_FONT_COLOR.b)
	
	BlockBlizzChatChannels_Tooltip:AddLine(" ")
	BlockBlizzChatChannels_Tooltip:AddLine(L.BLOCKBLIZZ_ADCOM_CHANGE,  GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	
	BlockBlizzChatChannels_Tooltip:Show()
end

function BlockBlizzChatChannels_CompartmentLeave(buttonName)
	BlockBlizzChatChannels_Tooltip:Hide()
end