if not ModCore then
	RestorationCore.log_shit("[ERROR] Unable to find ModCore from BeardLib! Is BeardLib installed correctly?")
	return
end
RestorationCore = RestorationCore or class(ModCore)

function RestorationCore:init()
	self.super.init(self, ModPath .. "config.xml", true, true)

	
	self:post_init({"Options"})
end

function RestorationCore:all_enabled(...)
	for _, opt in pairs({...}) do
		if self.Options:GetValue(opt) == false then
			return false
		end
	end
	return true
end

function RestorationCore.log_shit(to_log)
	if _G.restoration.we_log then
		log(to_log)
	end
end

if not _G.restoration then
	local success, err = pcall(function() _G.restoration = RestorationCore:new() end)
	if not success then
		RestorationCore.log_shit("[ERROR] Something bad happened with Restoration. " .. tostring(err))
	end
	RestorationCore.log_shit("SC: FUCKING LOADING: " .. ModPath)
	_G.restoration.ModPath = ModPath
	_G.restoration.disable_captain_camper = {
		"pbr2",
		"born",
		"nail",
		"peta"
	}
	_G.restoration.captain_teamwork = {
		"nightclub",
		"welcome_to_the_jungle_2",
		"gallery",
		"pal",
		"mia_2",
		"firestarter_3",
		"mad",
		"jolly"
	}
	_G.restoration.captain_murderdozer = {
		"branchbank",
		"man",
		"firestarter_2",
		"framing_frame_3",
		"four_stores",
		"alex_2",
		"rat",	
		"flat"
	}
	blt.xaudio.setup()
	_G.restoration.BufferedSounds = {
		grenadier = {
			death = {
				XAudio.Buffer:new(ModPath .. "assets/oggs/voiceover/grenadier/grenadier_death1.ogg"),
				XAudio.Buffer:new(ModPath .. "assets/oggs/voiceover/grenadier/grenadier_death2.ogg"),
				XAudio.Buffer:new(ModPath .. "assets/oggs/voiceover/grenadier/grenadier_death3.ogg"),
				XAudio.Buffer:new(ModPath .. "assets/oggs/voiceover/grenadier/grenadier_death4.ogg")
			},
			spawn = {
				XAudio.Buffer:new(ModPath .. "assets/oggs/voiceover/grenadier/grenadier_spawn1.ogg"),
				XAudio.Buffer:new(ModPath .. "assets/oggs/voiceover/grenadier/grenadier_spawn2.ogg"),
				XAudio.Buffer:new(ModPath .. "assets/oggs/voiceover/grenadier/grenadier_spawn3.ogg")
			},
			spot_heister = {
				XAudio.Buffer:new(ModPath .. "assets/oggs/voiceover/grenadier/grenadier_contact3.ogg"),
				XAudio.Buffer:new(ModPath .. "assets/oggs/voiceover/grenadier/grenadier_contact2.ogg"),
				XAudio.Buffer:new(ModPath .. "assets/oggs/voiceover/grenadier/grenadier_contact1.ogg")
			},
			use_gas = {
				XAudio.Buffer:new(ModPath .. "assets/oggs/voiceover/grenadier/grenadier_gas_1.ogg"),
				XAudio.Buffer:new(ModPath .. "assets/oggs/voiceover/grenadier/grenadier_gas_2.ogg"),
				XAudio.Buffer:new(ModPath .. "assets/oggs/voiceover/grenadier/grenadier_gas_3.ogg"),
				XAudio.Buffer:new(ModPath .. "assets/oggs/voiceover/grenadier/grenadier_gas_4.ogg")
			}
		},
		medicdozer = {
			heal = {}
		}
	}
	for i = 1, 31 do
		table.insert(_G.restoration.BufferedSounds.medicdozer.heal, XAudio.Buffer:new(ModPath .. "assets/oggs/voiceover/medicdozer/heal" .. i .. ".ogg"))	end
	end

_G.SC = _G.SC or {}
SC._path = ModPath
SC._data = {}

if SystemFS:exists("mods/DMCWO/mod.txt") then
	SC._data.sc_player_weapon_toggle = false
else
	SC._data.sc_player_weapon_toggle = true
end

if not restoration.Options:GetValue("SC/SC") then
	SC._data.sc_player_weapon_toggle = false
end