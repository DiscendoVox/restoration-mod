if SC and SC._data.sc_ai_toggle or restoration and restoration.Options:GetValue("SC/SC") then

local job = Global.level_data and Global.level_data.level_id

local old_init = CharacterTweakData.init
function CharacterTweakData:init(tweak_data, presets)
	old_init(self, tweak_data, presets)
	log("here be SC Tweak Data loading")
	local presets = self:_presets(tweak_data)
	local func = "_init_region_" .. tostring(tweak_data.levels:get_ai_group_type())

	self[func](self)

	self._prefix_data_p1 = {
		cop = function ()
			return self._unit_prefixes.cop
		end,
		swat = function ()
			return self._unit_prefixes.swat
		end,
		heavy_swat = function ()
			return self._unit_prefixes.heavy_swat
		end,
		taser = function ()
			return self._unit_prefixes.taser
		end,
		cloaker = function ()
			return self._unit_prefixes.cloaker
		end,
		bulldozer = function ()
			return self._unit_prefixes.bulldozer
		end,
		medic = function ()
			return self._unit_prefixes.medic
		end
	}
	
	self:_init_boom(presets)
	self:_init_spring(presets)
	self:_init_summers(presets)
	self:_init_omnia_lpf(presets)
	self:_init_tank_biker(presets)
	self:_init_omnia(presets)
	self:_init_deathvox(presets)
	self:_process_weapon_usage_table()
end

function CharacterTweakData:_init_region_america()
	self._default_chatter = "dispatch_generic_message"
	self._unit_prefixes = {
		cop = "l",
		swat = "l",
		heavy_swat = "l",
		taser = "tsr",
		cloaker = "clk",
		bulldozer = "bdz",
		medic = "mdc"
	}
	self._speech_prefix_p2 = "d"
end

function CharacterTweakData:_init_region_russia()
	self._default_chatter = "dsp_radio_russian"
	self._unit_prefixes = {
		cop = "r",
		swat = "r",
		heavy_swat = "r",
		taser = "rtsr",
		cloaker = "rclk",
		bulldozer = "rbdz",
		medic = "rmdc"
	}
	self._speech_prefix_p2 = "n"
end

function CharacterTweakData:_init_region_zombie()
	self._default_chatter = "dsp_radio_russian"
	self._unit_prefixes = {
		cop = "z",
		swat = "z",
		heavy_swat = "z",
		taser = "z1n",
		cloaker = "z2n",
		bulldozer = "z3n",
		medic = "z4n"
	}
	self._speech_prefix_p2 = "n"
end

function CharacterTweakData:_init_region_murky()
	self._default_chatter = "dispatch_generic_message"
	self._unit_prefixes = {
		cop = "l",
		swat = "l",
		heavy_swat = "l",
		taser = "tsr",
		cloaker = "clk",
		bulldozer = "bdz",
		medic = "mdc"
	}
	self._speech_prefix_p2 = "d"
end

function CharacterTweakData:_init_security(presets)
	self.security = deep_clone(presets.base)
	self.security.experience = {}
	self.security.weapon = presets.weapon.normal
	self.security.detection = presets.detection.guard
	self.security.HEALTH_INIT = 4
	self.security.headshot_dmg_mul = 2.25
	self.security.move_speed = presets.move_speed.normal
	self.security.crouch_move = nil
	self.security.surrender_break_time = {20, 30}
	self.security.suppression = presets.suppression.easy
	self.security.surrender = presets.surrender.easy
	self.security.ecm_vulnerability = 1
	self.security.ecm_hurts = {
		ears = {min_duration = 8, max_duration = 10}
	}
	self.security.weapon_voice = "3"
	self.security.experience.cable_tie = "tie_swat"
	self.security.speech_prefix_p1 = "l"
	self.security.speech_prefix_p2 = "n"
	self.security.speech_prefix_count = 4
	self.security.access = "security"
	self.security.rescue_hostages = false
	self.security.use_radio = nil
	self.security.silent_priority_shout = "f37"
	self.security.dodge = presets.dodge.poor
	self.security.deathguard = false
	self.security.chatter = presets.enemy_chatter.cop
	self.security.has_alarm_pager = true
	self.security.melee_weapon = nil
	self.security.steal_loot = nil
	self.security.static_dodge_preset = true
	table.insert(self._enemy_list, "security")
	self.security_undominatable = deep_clone(self.security)
	self.security_undominatable.surrender = nil
	table.insert(self._enemy_list, "security_undominatable")
end

function CharacterTweakData:_init_gensec(presets)
	self.gensec = deep_clone(presets.base)
	self.gensec.experience = {}
	self.gensec.weapon = presets.weapon.normal
	self.gensec.detection = presets.detection.guard
	self.gensec.HEALTH_INIT = 6
	self.gensec.headshot_dmg_mul = 3.4
	self.gensec.move_speed = presets.move_speed.very_fast
	self.gensec.crouch_move = nil
	self.gensec.surrender_break_time = {20, 30}
	self.gensec.suppression = presets.suppression.hard_def
	self.gensec.surrender = presets.surrender.easy
	self.gensec.ecm_vulnerability = 1
	self.gensec.ecm_hurts = {
		ears = {min_duration = 8, max_duration = 10}
	}
	self.gensec.weapon_voice = "3"
	self.gensec.experience.cable_tie = "tie_swat"
	self.gensec.speech_prefix_p1 = "l"
	self.gensec.speech_prefix_p2 = "n"
	self.gensec.speech_prefix_count = 4
	self.gensec.access = "security"
	self.gensec.rescue_hostages = false
	self.gensec.use_radio = nil
	self.gensec.silent_priority_shout = "f37"
	self.gensec.dodge = presets.dodge.athletic
	self.gensec.deathguard = false
	self.gensec.chatter = presets.enemy_chatter.cop
	self.gensec.has_alarm_pager = true
	self.gensec.melee_weapon = "baton"
	self.gensec.steal_loot = nil
	table.insert(self._enemy_list, "gensec")
end

function CharacterTweakData:_init_cop(presets)
	self.cop = deep_clone(presets.base)
	self.cop.experience = {}
	self.cop.weapon = presets.weapon.normal
	self.cop.detection = presets.detection.normal
	self.cop.HEALTH_INIT = 4
	self.cop.headshot_dmg_mul = 2.25
	self.cop.move_speed = presets.move_speed.normal
	self.cop.surrender_break_time = {10, 15}
	self.cop.suppression = presets.suppression.easy
	self.cop.surrender = presets.surrender.easy
	self.cop.ecm_vulnerability = 1
	self.cop.ecm_hurts = {
		ears = {min_duration = 8, max_duration = 10}
	}
	self.cop.weapon_voice = "1"
	self.cop.experience.cable_tie = "tie_swat"
	self.cop.speech_prefix_p1 = self._prefix_data_p1.cop()
	self.cop.speech_prefix_p2 = "n"
	self.cop.speech_prefix_count = 4
	self.cop.access = "cop"
	self.cop.silent_priority_shout = "f37"
	self.cop.dodge = presets.dodge.average
	self.cop.deathguard = true
	self.cop.chatter = presets.enemy_chatter.cop
	self.cop.melee_weapon = nil
	if job == "chill_combat" then
		self.cop.steal_loot = true
	else
		self.cop.steal_loot = true
	end
	self.cop.static_dodge_preset = true
 	table.insert(self._enemy_list, "cop")
	self.cop_scared = deep_clone(self.cop)
	self.cop_scared.surrender = presets.surrender.always
	self.cop_scared.surrender_break_time = nil
	table.insert(self._enemy_list, "cop_scared")
	self.cop_female = deep_clone(self.cop)
	self.cop_female.speech_prefix_p1 = "fl"
	self.cop_female.speech_prefix_p2 = self._speech_prefix_p2
	self.cop_female.speech_prefix_count = 1
 	table.insert(self._enemy_list, "cop_female")
	self.cop_civ = deep_clone(self.cop)
	self.cop_civ.weapon = presets.weapon.normal
	self.cop_civ.detection = presets.detection.normal_undercover
	self.cop_civ.HEALTH_INIT = 0.9
	self.cop_civ.headshot_dmg_mul = 1.7
	self.cop_civ.surrender = nil
	self.cop_civ.silent_priority_shout = nil
	self.cop_civ.melee_weapon = nil
	self.cop_civ.move_speed = presets.move_speed.very_fast
end

function CharacterTweakData:_init_omnia_lpf(presets)
	self.omnia_lpf = deep_clone(presets.base)
	self.omnia_lpf.experience = {}
	self.omnia_lpf.weapon = deep_clone(presets.weapon.normal)
	self.omnia_lpf.detection = presets.detection.normal
	self.omnia_lpf.HEALTH_INIT = 15
	self.omnia_lpf.headshot_dmg_mul = 2.19
	self.omnia_lpf.move_speed = presets.move_speed.fast
	self.omnia_lpf.surrender_break_time = {6, 10}
	self.omnia_lpf.suppression = presets.suppression.no_supress
	self.omnia_lpf.surrender = nil
	self.omnia_lpf.ecm_vulnerability = 1
	self.omnia_lpf.ecm_hurts = {
		ears = {min_duration = 8, max_duration = 10}
	}
	self.omnia_lpf.weapon_voice = "2"
	self.omnia_lpf.experience.cable_tie = "tie_swat"
	self.omnia_lpf.speech_prefix_p1 = self._prefix_data_p1.swat()
	self.omnia_lpf.speech_prefix_p2 = "n"
	self.omnia_lpf.speech_prefix_count = 4
	self.omnia_lpf.access = "swat"
	self.omnia_lpf.dodge = presets.dodge.athletic
	self.omnia_lpf.no_arrest = true
	self.omnia_lpf.chatter = presets.enemy_chatter.swat
	self.omnia_lpf.melee_weapon = "baton"
	self.omnia_lpf.melee_weapon_dmg_multiplier = 1
	self.omnia_lpf.steal_loot = true
	self.omnia_lpf.rescue_hostages = false
	self.omnia_lpf.steal_loot = nil
	self.omnia_lpf.priority_shout = "f47"
	self.omnia_lpf.bot_priority_shout = "f47x_any"
	self.omnia_lpf.tags = {"custom", "special"}
	self.omnia_lpf.do_omnia = true
	self.omnia_lpf.use_factory = true
	self.omnia_lpf.factory_weapon_id = {"wpn_fps_smg_olympic_npc_omnia_lpf"}
	table.insert(self._enemy_list, "omnia_lpf")
end

function CharacterTweakData:_init_fbi(presets)
	self.fbi = deep_clone(presets.base)
 	self.fbi.experience = {}
	self.fbi.weapon = presets.weapon.normal
	self.fbi.detection = presets.detection.normal
	self.fbi.HEALTH_INIT = 6
	self.fbi.headshot_dmg_mul = 3.4
    	self.fbi.move_speed = presets.move_speed.very_fast
    	self.fbi.surrender_break_time = {7, 12}
    	self.fbi.suppression = presets.suppression.hard_def
    	self.fbi.surrender = presets.surrender.easy
    	self.fbi.ecm_vulnerability = 1
   	self.fbi.ecm_hurts = {
        	ears = {min_duration = 8, max_duration = 10}
    	}
    	self.fbi.weapon_voice = "2"
    	self.fbi.experience.cable_tie = "tie_swat"
    	self.fbi.speech_prefix_p1 = self._prefix_data_p1.cop()
    	self.fbi.speech_prefix_p2 = "n"
    	self.fbi.speech_prefix_count = 4
	self.fbi.silent_priority_shout = "f37"
    	self.fbi.access = "fbi"
    	self.fbi.dodge = presets.dodge.athletic
    	self.fbi.deathguard = true
    	self.fbi.chatter = presets.enemy_chatter.cop
    	self.fbi.steal_loot = true
	self.fbi.no_arrest = false
	table.insert(self._enemy_list, "fbi")
	self.fbi_female = deep_clone(self.fbi)
	self.fbi_female.speech_prefix_p1 = "fl"
	self.fbi_female.speech_prefix_p2 = self._speech_prefix_p2
	self.fbi_female.speech_prefix_count = 1
	table.insert(self._enemy_list, "fbi_female")
	self.fbi_vet = deep_clone(self.fbi)
	self.fbi_vet.tags = {"custom", "special"}
	self.fbi_vet.no_arrest = true
    	self.fbi_vet.surrender = nil
	self.fbi_vet.suppression = nil
    	self.fbi_vet.can_shoot_while_dodging = true
	self.fbi_vet.HEALTH_INIT = 15
	self.fbi_vet.headshot_dmg_mul = 2.19
	self.fbi_vet.damage.bullet_dodge_chance = 55
	self.fbi_vet.smoke_dodge_increase = 10
    	self.fbi_vet.dodge = presets.dodge.veteran
	self.fbi_vet.allowed_stances = {cbt = true}
    	self.fbi_vet.move_speed = presets.move_speed.lightning
	self.fbi_vet.use_animation_on_fire_damage = true
	self.fbi_vet.priority_shout = "g29"
	self.fbi_vet.bot_priority_shout = "g29"
	self.fbi_vet.silent_priority_shout = nil
	self.fbi_vet.custom_shout = true
	self.fbi_vet.priority_shout_max_dis = 3000
	self.fbi_vet.rescue_hostages = true
	if job == "chill_combat" then
		self.fbi_vet.steal_loot = nil
	else
		self.fbi_vet.steal_loot = true
	end
	self.fbi_vet.damage.hurt_severity = deep_clone(presets.hurt_severities.base)
	self.fbi_vet.damage.hurt_severity.bullet = {
		health_reference = 1,
		zones = {
			{none = 1}
		}
	}
	self.fbi_vet.damage.hurt_severity.melee = {
		health_reference = "current",
		zones = {
			{
				health_limit = 1,
				moderate = 1
			}
		}
	}
	self.fbi_vet.dodge_with_grenade = {
		smoke = {duration = {
			12,
			12
		}},
		check = function (t, nr_grenades_used)
			local delay_till_next_use = 30
			local chance = 0.1

			if math.random() < chance then
				return true, t + delay_till_next_use
			end

			return false, t + delay_till_next_use
		end
	}	
	self.fbi_vet.static_dodge_preset = true
	table.insert(self._enemy_list, "fbi_vet")
end

function CharacterTweakData:_init_medic(presets)
	self.medic = deep_clone(presets.base)
	self.medic.tags = {"medic", "special"}
	self.medic.experience = {}
	self.medic.weapon = deep_clone(presets.weapon.normal)
	self.medic.detection = presets.detection.normal
	self.medic.HEALTH_INIT = 30
	self.medic.headshot_dmg_mul = 2.2
	self.medic.suppression = presets.suppression.no_supress
	self.medic.surrender = presets.surrender.special
	self.medic.move_speed = presets.move_speed.very_fast
	self.medic.surrender_break_time = {7, 12}
	self.medic.ecm_vulnerability = 1
	self.medic.ecm_hurts = {
		ears = {min_duration = 8, max_duration = 10}
	}
	self.medic.weapon_voice = "2"
	self.medic.experience.cable_tie = "tie_swat"
	self.medic.speech_prefix_p1 = self._prefix_data_p1.medic()
	self.medic.speech_prefix_count = nil
	self.medic.spawn_sound_event = self._prefix_data_p1.medic() .. "_entrance"
	self.medic.access = "swat"
	self.medic.dodge = presets.dodge.athletic
	self.medic.deathguard = true
	self.medic.no_arrest = true
	self.medic.chatter = {
		aggressive = true,
		retreat = true,
		go_go = true,
		contact = true,
		entrance = true
	}
	self.medic.steal_loot = nil
	self.medic.rescue_hostages = false
	self.medic.priority_shout = "f47"
	self.medic.bot_priority_shout = "f47x_any"
	self.medic.priority_shout_max_dis = 3000
	table.insert(self._enemy_list, "medic")
	self.medic_summers = deep_clone(self.medic)
	self.medic_summers.HEALTH_INIT = 30
	self.medic_summers.headshot_dmg_mul = 1.25
	self.medic_summers.tags = {"medic_summers_special", "medic_summers", "custom", "special"}
	self.medic_summers.ignore_medic_revive_animation = false
	self.medic_summers.surrender = nil
	self.medic_summers.flammable = false
	self.medic_summers.use_animation_on_fire_damage = false
	self.medic_summers.damage.bullet_damage_mul = 0.65
	self.medic_summers.damage.explosion_damage_mul = 0.1
	self.medic_summers.damage.fire_damage_mul = 0.05
	self.medic_summers.damage.hurt_severity = presets.hurt_severities.no_hurts
	self.medic_summers.immune_to_concussion = true
	self.medic_summers.no_damage_mission = true
	self.medic_summers.no_retreat = true
	self.medic_summers.no_arrest = true
	self.medic_summers.rescue_hostages = false
	self.medic_summers.steal_loot = nil
	self.medic_summers.immune_to_knock_down = true
	self.medic_summers.priority_shout = "f45"
	self.medic_summers.bot_priority_shout = "f45x_any"
	self.medic_summers.speech_prefix_p1 = "rmdc"
	self.medic_summers.speech_prefix_p2 = nil
	self.medic_summers.spawn_sound_event = "rmdc_entrance"
	self.medic_summers.die_sound_event = "mga_death_scream"
	self.medic_summers.use_radio = "dsp_radio_russian"
	self.medic_summers.chatter = presets.enemy_chatter.summers
	self.medic_summers.use_factory = true
	self.medic_summers.factory_weapon_id = {"wpn_fps_smg_p90_npc_summers"}
	table.insert(self._enemy_list, "medic_summers")
end

function CharacterTweakData:_init_swat(presets)
	self.swat = deep_clone(presets.base)
	self.swat.experience = {}
	self.swat.weapon = presets.weapon.normal
	self.swat.detection = presets.detection.normal
	self.swat.HEALTH_INIT = 8
	self.swat.headshot_dmg_mul = 4.5
	self.swat.move_speed = presets.move_speed.fast
	self.swat.surrender_break_time = {6, 10}
	self.swat.suppression = presets.suppression.hard_agg
	self.swat.surrender = presets.surrender.hard
	self.swat.ecm_vulnerability = 1
	self.swat.ecm_hurts = {
		ears = {min_duration = 8, max_duration = 10}
	}
	self.swat.weapon_voice = "2"
	self.swat.experience.cable_tie = "tie_swat"
	self.swat.speech_prefix_p1 = self._prefix_data_p1.swat()
	self.swat.speech_prefix_p2 = self._speech_prefix_p2
	self.swat.speech_prefix_count = 4
	self.swat.access = "swat"
	self.swat.dodge = presets.dodge.athletic
	self.swat.no_arrest = false
	self.swat.chatter = presets.enemy_chatter.swat
	self.swat.melee_weapon = nil
	self.swat.melee_weapon_dmg_multiplier = 1
	if job == "chill_combat" then
		self.swat.steal_loot = true
	else
		self.swat.steal_loot = true
	end
	table.insert(self._enemy_list, "swat")
	
	self.hrt = deep_clone(self.swat)
	self.hrt.speech_prefix_p1 = self._prefix_data_p1.swat()
	self.hrt.speech_prefix_p2 = "n"
	self.hrt.speech_prefix_count = 4
	table.insert(self._enemy_list, "hrt")	
end

function CharacterTweakData:_init_heavy_swat(presets)
	self.heavy_swat = deep_clone(presets.base)
	self.heavy_swat.experience = {}
	self.heavy_swat.weapon = presets.weapon.normal
	self.heavy_swat.detection = presets.detection.normal
	self.heavy_swat.HEALTH_INIT = 13
	self.heavy_swat.headshot_dmg_mul = 3.25
	self.heavy_swat.move_speed = presets.move_speed.fast
	self.heavy_swat.surrender_break_time = {6, 8}
	self.heavy_swat.suppression = presets.suppression.hard_agg
	self.heavy_swat.surrender = presets.surrender.hard
	self.heavy_swat.ecm_vulnerability = 1
	self.heavy_swat.ecm_hurts = {
		ears = {min_duration = 8, max_duration = 10}
	}
	self.heavy_swat.weapon_voice = "2"
	self.heavy_swat.experience.cable_tie = "tie_swat"
	self.heavy_swat.speech_prefix_p1 = self._prefix_data_p1.heavy_swat()
	self.heavy_swat.speech_prefix_p2 = self._speech_prefix_p2
	self.heavy_swat.speech_prefix_count = 4
	self.heavy_swat.access = "swat"
	self.heavy_swat.dodge = presets.dodge.heavy
	self.heavy_swat.no_arrest = false
	self.heavy_swat.chatter = presets.enemy_chatter.swat
	if job == "chill_combat" then
		self.heavy_swat.steal_loot = nil
	else
		self.heavy_swat.steal_loot = true
	end
	self.heavy_swat.static_weapon_preset = true
	self.heavy_swat.static_dodge_preset = true
	self.heavy_swat.static_melee_preset = true
	table.insert(self._enemy_list, "heavy_swat")
	self.heavy_swat_sniper = deep_clone(self.heavy_swat)
	self.heavy_swat_sniper.tags = {"sniper", "special"}
	self.heavy_swat_sniper.damage.hurt_severity = presets.hurt_severities.elite
	self.heavy_swat_sniper.priority_shout = "f34"
	self.heavy_swat_sniper.bot_priority_shout = "f34x_any"
	self.heavy_swat_sniper.priority_shout_max_dis = 3000
	self.heavy_swat_sniper.weapon = presets.weapon.sniper
	self.heavy_swat_sniper.HEALTH_INIT = 13
	self.heavy_swat_sniper.headshot_dmg_mul = 2.6
	self.heavy_swat_sniper.move_speed = presets.move_speed.very_fast
	self.heavy_swat_sniper.surrender_break_time = {6, 10}
	self.heavy_swat_sniper.suppression = presets.suppression.no_supress
	self.heavy_swat_sniper.surrender = nil
	self.heavy_swat_sniper.no_arrest = true
	self.heavy_swat_sniper.ecm_vulnerability = 1
	self.heavy_swat_sniper.ecm_hurts = {
		ears = {min_duration = 8, max_duration = 10}
	}
	self.heavy_swat_sniper.experience.cable_tie = "tie_swat"
	self.heavy_swat_sniper.speech_prefix_p1 = self._prefix_data_p1.swat()
	self.heavy_swat_sniper.speech_prefix_p2 = self._speech_prefix_p2
	self.heavy_swat_sniper.speech_prefix_count = 4
	self.heavy_swat_sniper.access = "swat"
	self.heavy_swat_sniper.dodge = presets.dodge.athletic_overkill
	self.heavy_swat_sniper.chatter = presets.enemy_chatter.swat
	self.heavy_swat_sniper.melee_weapon = nil
	self.heavy_swat_sniper.melee_weapon_dmg_multiplier = 2.5
	if job == "chill_combat" then
		self.heavy_swat_sniper.steal_loot = nil
	else
		self.heavy_swat_sniper.steal_loot = true
	end
	self.heavy_swat_sniper.has_alarm_pager = false
	self.heavy_swat_sniper.calls_in = true
	self.heavy_swat_sniper.use_animation_on_fire_damage = false
	self.heavy_swat_sniper.static_weapon_preset = true
	self.heavy_swat_sniper.static_dodge_preset = true
	table.insert(self._enemy_list, "heavy_swat_sniper")
end

function CharacterTweakData:_init_fbi_swat(presets)
	self.fbi_swat = deep_clone(presets.base)
	self.fbi_swat.experience = {}
	self.fbi_swat.weapon = presets.weapon.good
	self.fbi_swat.detection = presets.detection.normal
	self.fbi_swat.HEALTH_INIT = 13
	self.fbi_swat.headshot_dmg_mul = 2.6
	self.fbi_swat.move_speed = presets.move_speed.very_fast
	self.fbi_swat.surrender_break_time = {6, 10}
	self.fbi_swat.suppression = presets.suppression.hard_def
	self.fbi_swat.surrender = presets.surrender.hard
	self.fbi_swat.ecm_vulnerability = 1
	self.fbi_swat.ecm_hurts = {
		ears = {min_duration = 8, max_duration = 10}
	}
	self.fbi_swat.weapon_voice = "2"
	self.fbi_swat.experience.cable_tie = "tie_swat"
	self.fbi_swat.speech_prefix_p1 = self._prefix_data_p1.swat()
	self.fbi_swat.speech_prefix_p2 = self._speech_prefix_p2
	self.fbi_swat.speech_prefix_count = 4
	self.fbi_swat.access = "swat"
	self.fbi_swat.dodge = presets.dodge.athletic_very_hard
	self.fbi_swat.no_arrest = false
	self.fbi_swat.chatter = presets.enemy_chatter.swat
	self.fbi_swat.melee_weapon = "knife_1"
	self.fbi_swat.melee_weapon_dmg_multiplier = 2
	if job == "chill_combat" then
		self.fbi_swat.steal_loot = nil
	else
		self.fbi_swat.steal_loot = true
	end
	self.fbi_swat.static_weapon_preset = true
	self.fbi_swat.static_dodge_preset = true
	self.fbi_swat.static_melee_preset = true
	table.insert(self._enemy_list, "fbi_swat")
	self.fbi_swat_vet = deep_clone(self.fbi_swat)
	self.fbi_swat_vet.melee_weapon_dmg_multiplier = 2
	table.insert(self._enemy_list, "fbi_swat_vet")
end

function CharacterTweakData:_init_fbi_heavy_swat(presets)
	self.fbi_heavy_swat = deep_clone(presets.base)
	self.fbi_heavy_swat.experience = {}
	self.fbi_heavy_swat.weapon = presets.weapon.normal
	self.fbi_heavy_swat.detection = presets.detection.normal
	self.fbi_heavy_swat.HEALTH_INIT = 20
	self.fbi_heavy_swat.headshot_dmg_mul = 2
	self.fbi_heavy_swat.move_speed = presets.move_speed.fast
	self.fbi_heavy_swat.surrender_break_time = {6, 8}
	self.fbi_heavy_swat.suppression = presets.suppression.hard_agg
	self.fbi_heavy_swat.surrender = presets.surrender.hard
	self.fbi_heavy_swat.ecm_vulnerability = 1
	self.fbi_heavy_swat.ecm_hurts = {
		ears = {min_duration = 8, max_duration = 10}
	}
	self.fbi_heavy_swat.weapon_voice = "2"
	self.fbi_heavy_swat.experience.cable_tie = "tie_swat"
	self.fbi_heavy_swat.speech_prefix_p1 = self._prefix_data_p1.swat()
	self.fbi_heavy_swat.speech_prefix_p2 = self._speech_prefix_p2
	self.fbi_heavy_swat.speech_prefix_count = 4
	self.fbi_heavy_swat.access = "swat"
	self.fbi_heavy_swat.dodge = presets.dodge.heavy_very_hard
	self.fbi_heavy_swat.no_arrest = false
	self.fbi_heavy_swat.melee_weapon = "knife_1"
	self.fbi_heavy_swat.melee_weapon_dmg_multiplier = 1
	self.fbi_heavy_swat.chatter = presets.enemy_chatter.swat
	if job == "chill_combat" then
		self.fbi_heavy_swat.steal_loot = nil
	else
		self.fbi_heavy_swat.steal_loot = true
	end
	self.fbi_heavy_swat.static_weapon_preset = true
	self.fbi_heavy_swat.static_dodge_preset = true
	self.fbi_heavy_swat.static_melee_preset = true		
 	table.insert(self._enemy_list, "fbi_heavy_swat")
end

function CharacterTweakData:_init_city_swat(presets)
	self.city_swat = deep_clone(presets.base)
	self.city_swat.experience = {}
	self.city_swat.weapon = deep_clone(presets.weapon.expert)
	self.city_swat.weapon.is_shotgun_pump = deep_clone(presets.weapon.expert.is_shotgun_mag)
	self.city_swat.weapon.is_shotgun_pump.RELOAD_SPEED = 0.25
	self.city_swat.detection = presets.detection.normal
	self.city_swat.HEALTH_INIT = 13
	self.city_swat.headshot_dmg_mul = 2.6
	self.city_swat.move_speed = presets.move_speed.very_fast
	self.city_swat.surrender_break_time = {6, 10}
	self.city_swat.suppression = presets.suppression.hard_def
	self.city_swat.surrender = presets.surrender.hard
	self.city_swat.no_arrest = false
	self.city_swat.ecm_vulnerability = 1
	self.city_swat.ecm_hurts = {
		ears = {min_duration = 8, max_duration = 10}
	}
	self.city_swat.weapon_voice = "2"
	self.city_swat.experience.cable_tie = "tie_swat"
	self.city_swat.silent_priority_shout = "f37"
	self.city_swat.speech_prefix_p1 = self._prefix_data_p1.swat()
	self.city_swat.speech_prefix_p2 = self._speech_prefix_p2
	self.city_swat.speech_prefix_count = 4
	self.city_swat.access = "swat"
	self.city_swat.dodge = presets.dodge.athletic_overkill
	self.city_swat.chatter = presets.enemy_chatter.swat
	self.city_swat.melee_weapon = nil
	self.city_swat.melee_weapon_dmg_multiplier = 2.5
	if job == "chill_combat" then
		self.city_swat.steal_loot = nil
	else
		self.city_swat.steal_loot = true
	end
	self.city_swat.has_alarm_pager = true
	self.city_swat.calls_in = true
	self.city_swat.static_weapon_preset = true
	self.city_swat.static_dodge_preset = true
	self.city_swat.static_melee_preset = true		
 	table.insert(self._enemy_list, "city_swat")
	self.city_swat_titan = deep_clone(self.city_swat)
	if job == "mad" then
		self.city_swat_titan.speech_prefix_p1 = self._prefix_data_p1.swat()
		self.city_swat_titan.speech_prefix_p2 = self._speech_prefix_p2
		self.city_swat_titan.speech_prefix_count = 4
	else
		self.city_swat_titan.speech_prefix_p1 = "l5d"
		self.city_swat_titan.speech_prefix_p2 = nil
		self.city_swat_titan.speech_prefix_count = nil
	end
	self.city_swat_titan.HEALTH_INIT = 15
	self.city_swat_titan.headshot_dmg_mul = 2.19
	self.city_swat_titan.damage.hurt_severity = presets.hurt_severities.elite
	self.city_swat_titan.use_animation_on_fire_damage = false
	self.city_swat_titan.move_speed = presets.move_speed.lightning
	self.city_swat_titan.dodge = presets.dodge.elite
	self.city_swat_titan.surrender = nil
	self.city_swat_titan.die_sound_event = "mga_death_scream"
	self.city_swat_titan.static_weapon_preset = true
	self.city_swat_titan.static_dodge_preset = true
	self.city_swat_titan.static_melee_preset = true	
	table.insert(self._enemy_list, "city_swat_titan")
	self.city_swat_titan_assault = deep_clone(self.city_swat_titan)
	self.city_swat_titan_assault.spawn_sound_event = "cloaker_spawn"
	self.city_swat_titan_assault.die_sound_event = "mga_death_scream"
 	table.insert(self._enemy_list, "city_swat_titan_assault")
end

function CharacterTweakData:_init_omnia(presets)
	self.omnia = deep_clone(presets.base)
	self.omnia.experience = {}
	self.omnia.damage.hurt_severity = presets.hurt_severities.elite
	self.omnia.weapon = deep_clone(presets.weapon.expert)
	self.omnia.weapon.is_shotgun_pump = deep_clone(presets.weapon.expert.is_shotgun_mag)
	self.omnia.weapon.is_shotgun_pump.RELOAD_SPEED = 0.25
	self.omnia.detection = presets.detection.normal
	self.omnia.HEALTH_INIT = 15
	self.omnia.headshot_dmg_mul = 1.46
	self.omnia.move_speed = presets.move_speed.very_fast
	self.omnia.surrender_break_time = {6, 10}
	self.omnia.suppression = presets.suppression.hard_def
	self.omnia.surrender = presets.surrender.hard
	self.omnia.no_arrest = false
	self.omnia.ecm_vulnerability = 1
	self.omnia.ecm_hurts = {
		ears = {min_duration = 8, max_duration = 10}
	}
	self.omnia.weapon_voice = "2"
	self.omnia.experience.cable_tie = "tie_swat"
	self.omnia.silent_priority_shout = "f37"
	self.omnia.speech_prefix_p1 = self._prefix_data_p1.swat()
	self.omnia.speech_prefix_p2 = self._speech_prefix_p2
	self.omnia.speech_prefix_count = 4
	self.omnia.access = "swat"
	self.omnia.dodge = presets.dodge.athletic_overkill
	self.omnia.chatter = presets.enemy_chatter.swat
	self.omnia.melee_weapon = nil
	self.omnia.melee_weapon_dmg_multiplier = 2.5
	if job == "chill_combat" then
		self.omnia.steal_loot = nil
	else
		self.omnia.steal_loot = true
	end
	self.omnia.has_alarm_pager = true
	self.omnia.calls_in = true
	self.omnia.use_animation_on_fire_damage = false
 	table.insert(self._enemy_list, "omnia")
end

function CharacterTweakData:_init_sniper(presets)
	self.sniper = deep_clone(presets.base)
	self.sniper.tags = {"sniper", "special"}
	self.sniper.experience = {}
	self.sniper.weapon = presets.weapon.sniper
	self.sniper.detection = presets.detection.sniper
	self.sniper.HEALTH_INIT = 6
	self.sniper.headshot_dmg_mul = 3.4
	self.sniper.move_speed = presets.move_speed.very_fast
	self.sniper.shooting_death = false
	self.sniper.no_move_and_shoot = true
	self.sniper.move_and_shoot_cooldown = 1
	self.sniper.suppression = presets.suppression.no_supress
	self.sniper.melee_weapon = nil
	self.sniper.ecm_vulnerability = 1
	self.sniper.ecm_hurts = {
		ears = {min_duration = 8, max_duration = 10}
	}
	self.sniper.weapon_voice = "1"
	self.sniper.experience.cable_tie = "tie_swat"
	self.sniper.speech_prefix_p1 = self._prefix_data_p1.swat()
	self.sniper.speech_prefix_p2 = "n"
	self.sniper.speech_prefix_count = 4
	self.sniper.priority_shout = "f34"
	self.sniper.bot_priority_shout = "f34x_any"
	self.sniper.priority_shout_max_dis = 3000
	self.sniper.access = "sniper"
	self.sniper.no_retreat = true
	self.sniper.no_arrest = true
	self.sniper.chatter = presets.enemy_chatter.no_chatter
	self.sniper.steal_loot = nil
	self.sniper.rescue_hostages = false
	self.sniper.static_weapon_preset = true
	self.sniper.static_dodge_preset = true
 	table.insert(self._enemy_list, "sniper")
end

function CharacterTweakData:_init_gangster(presets)
	self.gangster = deep_clone(presets.base)
	self.gangster.experience = {}
	self.gangster.weapon = presets.weapon.normal
	self.gangster.detection = presets.detection.normal
	self.gangster.HEALTH_INIT = 4
	self.gangster.headshot_dmg_mul = 2.3
	self.gangster.move_speed = presets.move_speed.fast
	self.gangster.suspicious = nil
	self.gangster.suppression = presets.suppression.easy
	self.gangster.surrender = nil
	self.gangster.ecm_vulnerability = 1
	self.gangster.ecm_hurts = {
		ears = {min_duration = 8, max_duration = 10}
	}
	self.gangster.no_arrest = true
	self.gangster.no_retreat = true
	self.gangster.weapon_voice = "3"
	self.gangster.experience.cable_tie = "tie_swat"
	if job == "nightclub" or job == "short2_stage1" or job == "jolly" then
		self.gangster.speech_prefix_p1 = "rt"
		self.gangster.speech_prefix_p2 = nil
		self.gangster.speech_prefix_count = 2
	elseif job == "alex_2" then
		self.gangster.speech_prefix_p1 = "ict"
		self.gangster.speech_prefix_p2 = nil
		self.gangster.speech_prefix_count = 2
	elseif job == "welcome_to_the_jungle_1" then
		self.gangster.speech_prefix_p1 = "bik"
		self.gangster.speech_prefix_p2 = nil
		self.gangster.speech_prefix_count = 2
	else
		self.gangster.speech_prefix_p1 = "lt"
		self.gangster.speech_prefix_p2 = nil
		self.gangster.speech_prefix_count = 2
	end
 	self.gangster.chatter = {
		aggressive = true,
		retreat = true,
		contact = true,
		go_go = true,
		suppress = true
 	}
	self.gangster.silent_priority_shout = "f37"
	self.gangster.access = "gangster"
	self.gangster.rescue_hostages = false
	self.gangster.use_radio = nil
	self.gangster.dodge = presets.dodge.average
	self.gangster.challenges = {type = "gangster"}
	self.gangster.melee_weapon = nil
	self.gangster.steal_loot = nil
	self.gangster.calls_in = true
	self.gangster.static_dodge_preset = true
 	table.insert(self._enemy_list, "gangster")
end

function CharacterTweakData:_init_biker(presets)
	self.biker = deep_clone(self.gangster)
	self.biker.calls_in = true
	if job == "born" or job == "chew" then
		self.biker.speech_prefix_p1 = "nl"
		self.biker.speech_prefix_p2 = nil
		self.biker.speech_prefix_count = 2
	else
		self.biker.speech_prefix_p1 = "bik"
		self.biker.speech_prefix_p2 = nil
		self.biker.speech_prefix_count = 2	
	end
 	self.biker.chatter = {
		aggressive = true,
		retreat = true,
		contact = true,
		go_go = true,
		suppress = true
 	}
	self.biker.static_dodge_preset = true
 	table.insert(self._enemy_list, "biker")
	self.biker_guard = deep_clone(self.biker)
	self.biker_guard.suppression = presets.suppression.hard_def
	self.biker_guard.has_alarm_pager = true
	self.biker_guard.radio_prefix = "fri_"
	self.biker_guard.surrender = presets.surrender.hard
	self.biker_guard.surrender_break_time = {20, 30}
	self.biker_guard.detection = presets.detection.guard
	self.biker_guard.HEALTH_INIT = 6
	self.biker_guard.headshot_dmg_mul = 3.4
	self.biker_guard.move_speed = presets.move_speed.very_fast
	self.biker_guard.ecm_vulnerability = 1
	self.biker_guard.no_arrest = false
	self.biker_guard.ecm_hurts = {
		ears = {min_duration = 8, max_duration = 10}
	}
	self.biker_guard.speech_prefix_p1 = "bik"
	self.biker_guard.speech_prefix_p2 = nil
	self.biker_guard.speech_prefix_count = 2
 	self.biker_guard.chatter = {
		aggressive = true,
		retreat = true,
		contact = true,
		go_go = true,
		suppress = true
 	}
	self.biker_guard.static_dodge_preset = false
end

function CharacterTweakData:_init_biker_escape(presets)
	self.biker_escape = deep_clone(self.gangster)
	self.biker_escape.melee_weapon = "knife_1"
	self.biker_escape.move_speed = presets.move_speed.very_fast
	self.biker_escape.HEALTH_INIT = 4
	self.biker_escape.suppression = presets.suppression.no_supress
 	table.insert(self._enemy_list, "biker_escape")
end

function CharacterTweakData:_init_mobster(presets)
	self.mobster = deep_clone(self.gangster)
	self.mobster.calls_in = true
	self.mobster.melee_weapon = "fists"
	self.mobster.HEALTH_INIT = 4
	self.mobster.headshot_dmg_mul = 2.3
	self.mobster.speech_prefix_p1 = "rt"
	self.mobster.speech_prefix_p2 = nil
	self.mobster.speech_prefix_count = 2
 	self.mobster.chatter = {
		aggressive = true,
		retreat = true,
		contact = true,
		go_go = true,
		suppress = true
 	}
	self.mobster.static_dodge_preset = true
 	table.insert(self._enemy_list, "mobster")
end

function CharacterTweakData:_init_mobster_boss(presets)
	self.mobster_boss = deep_clone(presets.base)
	self.mobster_boss.experience = {}
	self.mobster_boss.detection = presets.detection.normal
	self.mobster_boss.weapon = deep_clone(presets.weapon.normal)
	self.mobster_boss.HEALTH_INIT = 500
	self.mobster_boss.headshot_dmg_mul = 3.997125
	self.mobster_boss.damage.hurt_severity = presets.hurt_severities.no_hurts
	self.mobster_boss.damage.explosion_damage_mul = 1.25
	self.mobster_boss.move_speed = presets.move_speed.very_slow
	self.mobster_boss.allowed_poses = {stand = true}
	self.mobster_boss.crouch_move = false
	self.mobster_boss.no_run_start = true
	self.mobster_boss.no_run_stop = true
	self.mobster_boss.no_retreat = true
	self.mobster_boss.no_arrest = true
	self.mobster_boss.surrender = nil
	self.mobster_boss.ecm_vulnerability = 0.85
	self.mobster_boss.ecm_hurts = {
		ears = {min_duration = 1, max_duration = 3}
	}
	self.mobster_boss.weapon_voice = "3"
	self.mobster_boss.experience.cable_tie = "tie_swat"
	self.mobster_boss.access = "gangster"
	self.mobster_boss.speech_prefix_p1 = "l"
	self.mobster_boss.speech_prefix_p2 = "n"
	self.mobster_boss.speech_prefix_count = 4
	self.mobster_boss.rescue_hostages = false
	self.mobster_boss.melee_weapon = "fists_dozer"
	self.mobster_boss.steal_loot = nil
	self.mobster_boss.calls_in = nil
	self.mobster_boss.chatter = presets.enemy_chatter.no_chatter
	self.mobster_boss.use_radio = nil
	self.mobster_boss.can_be_tased = false
	self.mobster_boss.priority_shout = "g29"
	self.mobster_boss.bot_priority_shout = "g29"
	self.mobster_boss.silent_priority_shout = nil
	self.mobster_boss.custom_shout = true
	self.mobster_boss.priority_shout_max_dis = 3000
	self.mobster_boss.use_animation_on_fire_damage = false
	self.mobster_boss.flammable = true
	self.mobster_boss.immune_to_knock_down = true
	self.mobster_boss.immune_to_concussion = true
	self.mobster_boss.must_headshot = true
	self.mobster_boss.static_dodge_preset = true
 	table.insert(self._enemy_list, "mobster_boss")
end

function CharacterTweakData:_init_biker_boss(presets)
	self.biker_boss = deep_clone(presets.base)
	self.biker_boss.experience = {}
	self.biker_boss.weapon = deep_clone(presets.weapon.normal)
	self.biker_boss.detection = presets.detection.normal
	self.biker_boss.HEALTH_INIT = 500
	self.biker_boss.headshot_dmg_mul = 3.997125
	self.biker_boss.damage.explosion_damage_mul = 1.25
	self.biker_boss.damage.hurt_severity = self.presets.hurt_severities.no_hurts
	self.biker_boss.move_speed = presets.move_speed.very_slow
	self.biker_boss.allowed_poses = {stand = true}
	self.biker_boss.no_retreat = true
	self.biker_boss.no_run_start = true
	self.biker_boss.no_run_stop = true	
	self.biker_boss.no_arrest = true
	self.biker_boss.surrender = nil
	self.biker_boss.ecm_vulnerability = 0.85
	self.biker_boss.ecm_hurts = {
		ears = {min_duration = 1, max_duration = 3}
	}
	self.biker_boss.weapon_voice = "3"
	self.biker_boss.experience.cable_tie = "tie_swat"
	self.biker_boss.access = "gangster"
	self.biker_boss.speech_prefix_p1 = "bb"
	self.biker_boss.speech_prefix_p2 = "n"
	self.biker_boss.speech_prefix_count = 1
	self.biker_boss.rescue_hostages = false
	self.biker_boss.melee_weapon = "fists_dozer"
	self.biker_boss.melee_weapon_dmg_multiplier = 1
	self.biker_boss.steal_loot = nil
	self.biker_boss.calls_in = nil
	self.biker_boss.chatter = presets.enemy_chatter.no_chatter
	self.biker_boss.use_radio = nil
	self.biker_boss.use_animation_on_fire_damage = false
	self.biker_boss.flammable = true
	self.biker_boss.can_be_tased = false
	self.biker_boss.immune_to_knock_down = true
	self.biker_boss.priority_shout = "g29"
	self.biker_boss.bot_priority_shout = "g29"
	self.biker_boss.silent_priority_shout = nil
	self.biker_boss.custom_shout = true
	self.biker_boss.priority_shout_max_dis = 3000
	self.biker_boss.immune_to_concussion = true
	self.biker_boss.must_headshot = true
	self.biker_boss.static_dodge_preset = true
 	table.insert(self._enemy_list, "biker_boss")
end

function CharacterTweakData:_init_hector_boss(presets)
	self.hector_boss = deep_clone(self.mobster_boss)
	self.hector_boss.weapon = deep_clone(presets.weapon.normal)
	self.hector_boss.can_be_tased = false
	self.hector_boss.priority_shout = "g29"
	self.hector_boss.bot_priority_shout = "g29"
	self.hector_boss.silent_priority_shout = nil
	self.hector_boss.custom_shout = true
	self.hector_boss.priority_shout_max_dis = 3000
 	table.insert(self._enemy_list, "hector_boss")
end

function CharacterTweakData:_init_hector_boss_no_armor(presets)
	self.hector_boss_no_armor = deep_clone(self.fbi)
	self.hector_boss_no_armor.no_retreat = true
	self.hector_boss_no_armor.no_arrest = true
	self.hector_boss_no_armor.surrender = nil
	self.hector_boss_no_armor.access = "gangster"
	self.hector_boss_no_armor.rescue_hostages = false
	self.hector_boss_no_armor.steal_loot = nil
	self.hector_boss_no_armor.calls_in = nil
	self.hector_boss_no_armor.chatter = presets.enemy_chatter.no_chatter
	self.hector_boss_no_armor.use_radio = nil
	self.hector_boss_no_armor.can_be_tased = true
 	table.insert(self._enemy_list, "hector_boss_no_armor")
end

function CharacterTweakData:_init_chavez_boss(presets)
	self.chavez_boss = deep_clone(presets.base)
	self.chavez_boss.experience = {}
	self.chavez_boss.weapon = deep_clone(presets.weapon.normal)
	self.chavez_boss.detection = presets.detection.normal
	self.chavez_boss.priority_shout = "g29"
	self.chavez_boss.bot_priority_shout = "g29"
	self.chavez_boss.silent_priority_shout = nil
	self.chavez_boss.custom_shout = true
	self.chavez_boss.priority_shout_max_dis = 3000
	self.chavez_boss.damage.hurt_severity = presets.hurt_severities.no_hurts
	self.chavez_boss.HEALTH_INIT = 500
	self.chavez_boss.headshot_dmg_mul = 3.997125
	self.chavez_boss.damage.explosion_damage_mul = 1.25
	self.chavez_boss.move_speed = presets.move_speed.very_slow
	self.chavez_boss.allowed_poses = {stand = true}
	self.chavez_boss.no_retreat = true
	self.chavez_boss.no_arrest = true
	self.chavez_boss.no_run_start = true
	self.chavez_boss.no_run_stop = true		
	self.chavez_boss.surrender = nil
	self.chavez_boss.ecm_vulnerability = 0.85
	self.chavez_boss.ecm_hurts = {
		ears = {min_duration = 1, max_duration = 3}
	}
	self.chavez_boss.weapon_voice = "1"
	self.chavez_boss.experience.cable_tie = "tie_swat"
	self.chavez_boss.access = "gangster"
	self.chavez_boss.speech_prefix_p1 = "bb"
	self.chavez_boss.speech_prefix_p2 = "n"
	self.chavez_boss.speech_prefix_count = 1
	self.chavez_boss.rescue_hostages = false
	self.chavez_boss.melee_weapon = "fists_dozer"
	self.chavez_boss.melee_weapon_dmg_multiplier = 1
	self.chavez_boss.steal_loot = nil
	self.chavez_boss.calls_in = nil
	self.chavez_boss.chatter = presets.enemy_chatter.no_chatter
	self.chavez_boss.use_radio = nil
	self.chavez_boss.can_be_tased = false
	self.chavez_boss.use_animation_on_fire_damage = false
	self.chavez_boss.flammable = true
	self.chavez_boss.can_be_tased = false
	self.chavez_boss.immune_to_knock_down = true
	self.chavez_boss.immune_to_concussion = true
	self.chavez_boss.must_headshot = true
	self.chavez_boss.static_dodge_preset = true
	table.insert(self._enemy_list, "chavez_boss")
end

function CharacterTweakData:_init_bolivians(presets)
	self.bolivian = deep_clone(self.gangster)
	self.bolivian.detection = presets.detection.normal
	self.bolivian.access = "security"
	self.bolivian.radio_prefix = "fri_"
	self.bolivian.suspicious = true
	self.bolivian.crouch_move = nil
	self.bolivian.no_arrest = true
	self.bolivian.speech_prefix_p1 = "lt"
	self.bolivian.speech_prefix_p2 = nil
	self.bolivian.speech_prefix_count = 2
 	self.bolivian.chatter = {
		aggressive = true,
		retreat = true,
		contact = true,
		go_go = true,
		suppress = true
 	}
	self.bolivian.static_dodge_preset = true
	table.insert(self._enemy_list, "bolivian")
	self.bolivian_indoors = deep_clone(self.bolivian)
	self.bolivian_indoors.suppression = presets.suppression.hard
	self.bolivian_indoors.has_alarm_pager = true
	self.bolivian_indoors.surrender = presets.surrender.easy
	self.bolivian_indoors.surrender_break_time = {20, 30}
	self.bolivian_indoors.detection = presets.detection.guard
	self.bolivian_indoors.HEALTH_INIT = 6
	self.bolivian_indoors.headshot_dmg_mul = 3.4
	self.bolivian_indoors.move_speed = presets.move_speed.normal
	self.bolivian_indoors.ecm_vulnerability = 1
	self.bolivian_indoors.no_arrest = false
	self.bolivian_indoors.ecm_hurts = {
		ears = {min_duration = 8, max_duration = 10}
	}
	self.bolivian_indoors.speech_prefix_p1 = "lt"
	self.bolivian_indoors.speech_prefix_p2 = nil
	self.bolivian_indoors.speech_prefix_count = 2
 	self.bolivian_indoors.chatter = {
		aggressive = true,
		retreat = true,
		contact = true,
		go_go = true,
		suppress = true
 	}
	self.bolivian.static_dodge_preset = false
	table.insert(self._enemy_list, "bolivian_indoors")
end

function CharacterTweakData:_init_drug_lord_boss(presets)
	self.drug_lord_boss = deep_clone(presets.base)
	self.drug_lord_boss.experience = {}
	self.drug_lord_boss.weapon = deep_clone(presets.weapon.normal)
	self.drug_lord_boss.detection = presets.detection.normal
	self.drug_lord_boss.HEALTH_INIT = 500
	self.drug_lord_boss.headshot_dmg_mul = 3.997125
	self.drug_lord_boss.damage.explosion_damage_mul = 1.25
	self.drug_lord_boss.damage.hurt_severity = presets.hurt_severities.no_hurts
	self.drug_lord_boss.move_speed = presets.move_speed.very_slow
	self.drug_lord_boss.allowed_poses = {stand = true}
	self.drug_lord_boss.crouch_move = false
	self.drug_lord_boss.no_run_start = true
	self.drug_lord_boss.no_run_stop = true
	self.drug_lord_boss.no_retreat = true
	self.drug_lord_boss.no_arrest = true
	self.drug_lord_boss.surrender = nil
	self.drug_lord_boss.ecm_vulnerability = 0.85
	self.drug_lord_boss.ecm_hurts = {
		ears = {min_duration = 1, max_duration = 3}
	}
	self.drug_lord_boss.weapon_voice = "3"
	self.drug_lord_boss.experience.cable_tie = "tie_swat"
	self.drug_lord_boss.access = "gangster"
	self.drug_lord_boss.speech_prefix_p1 = "bb"
	self.drug_lord_boss.speech_prefix_p2 = "n"
	self.drug_lord_boss.speech_prefix_count = 1
	self.drug_lord_boss.rescue_hostages = false
	self.drug_lord_boss.silent_priority_shout = "f37"
	self.drug_lord_boss.melee_weapon = "fists_dozer"
	self.drug_lord_boss.melee_weapon_dmg_multiplier = 1
	self.drug_lord_boss.steal_loot = nil
	self.drug_lord_boss.calls_in = nil
	self.drug_lord_boss.chatter = presets.enemy_chatter.no_chatter
	self.drug_lord_boss.use_radio = nil
	self.drug_lord_boss.can_be_tased = false
	self.drug_lord_boss.use_animation_on_fire_damage = false
	self.drug_lord_boss.flammable = true
	self.drug_lord_boss.can_be_tased = false
	self.drug_lord_boss.immune_to_knock_down = true
	self.drug_lord_boss.immune_to_concussion = true
	self.drug_lord_boss.priority_shout = "g29"
	self.drug_lord_boss.bot_priority_shout = "g29"
	self.drug_lord_boss.custom_shout = true
	self.drug_lord_boss.priority_shout_max_dis = 3000
	self.drug_lord_boss.must_headshot = true
	self.drug_lord_boss.static_dodge_preset = true
	table.insert(self._enemy_list, "drug_lord_boss")
end

function CharacterTweakData:_init_drug_lord_boss_stealth(presets)
	self.drug_lord_boss_stealth = deep_clone(presets.base)
	self.drug_lord_boss_stealth.experience = {}
	self.drug_lord_boss_stealth.weapon = deep_clone(presets.weapon.normal)
	self.drug_lord_boss_stealth.detection = presets.detection.normal
	self.drug_lord_boss_stealth.HEALTH_INIT = 6
	self.drug_lord_boss_stealth.headshot_dmg_mul = 3.4
	self.drug_lord_boss_stealth.move_speed = presets.move_speed.very_fast
	self.drug_lord_boss_stealth.no_retreat = true
	self.drug_lord_boss_stealth.no_arrest = true
	self.drug_lord_boss_stealth.surrender = nil
	self.drug_lord_boss_stealth.ecm_vulnerability = 0
	self.drug_lord_boss_stealth.ecm_hurts = {
		ears = {min_duration = 0, max_duration = 0}
	}
	self.drug_lord_boss_stealth.weapon_voice = "3"
	self.drug_lord_boss_stealth.experience.cable_tie = "tie_swat"
	self.drug_lord_boss_stealth.access = "gangster"
	self.drug_lord_boss_stealth.speech_prefix_p1 = "bb"
	self.drug_lord_boss_stealth.speech_prefix_p2 = "n"
	self.drug_lord_boss_stealth.speech_prefix_count = 1
	self.drug_lord_boss_stealth.rescue_hostages = false
	self.drug_lord_boss_stealth.silent_priority_shout = "f37"
	self.drug_lord_boss_stealth.melee_weapon = "fists_dozer"
	self.drug_lord_boss_stealth.melee_weapon_dmg_multiplier = 1
	self.drug_lord_boss_stealth.steal_loot = nil
	self.drug_lord_boss_stealth.calls_in = nil
	self.drug_lord_boss_stealth.chatter = presets.enemy_chatter.no_chatter
	self.drug_lord_boss_stealth.use_radio = nil
	self.drug_lord_boss_stealth.use_animation_on_fire_damage = true
	self.drug_lord_boss_stealth.flammable = true
	self.drug_lord_boss_stealth.can_be_tased = true
	self.drug_lord_boss_stealth.immune_to_knock_down = false
	self.drug_lord_boss_stealth.immune_to_concussion = false
	table.insert(self._enemy_list, "drug_lord_boss_stealth")
end

function CharacterTweakData:_init_tank(presets)
	self.tank = deep_clone(presets.base)
	self.tank.tags = {"tank", "special"}
	self.tank.experience = {}
	self.tank.damage.tased_response = {
		light = {tased_time = 1, down_time = 0},
		heavy = {tased_time = 2, down_time = 0}
	}
	self.tank.damage.explosion_damage_mul = 2.5
	self.tank.weapon = deep_clone(presets.weapon.normal)
	self.tank.detection = presets.detection.normal
	self.tank.HEALTH_INIT = 500
	--Temp solution, unless someone manages to fix armor bits before release
	if job == "shoutout_raid" or job == "pbr" or job == "wetwork" then
		self.tank.headshot_dmg_mul = 8.9286
	else
		self.tank.headshot_dmg_mul = 12.5
	end
	self.tank.move_speed = presets.move_speed.slow
	self.tank.allowed_stances = {cbt = true}
	self.tank.allowed_poses = {stand = true}
	self.tank.crouch_move = false
	self.tank.no_run_start = true
	self.tank.no_run_stop = true
	self.tank.no_retreat = true
	self.tank.no_arrest = true
	self.tank.surrender = nil
	self.tank.ecm_vulnerability = 0.85
	self.tank.ecm_hurts = {
		ears = {min_duration = 1, max_duration = 3}
	}
	self.tank.weapon_voice = "3"
	self.tank.experience.cable_tie = "tie_swat"
	self.tank.access = "tank"
	self.tank.speech_prefix_p1 = self._prefix_data_p1.bulldozer()
	self.tank.speech_prefix_p2 = nil
	self.tank.speech_prefix_count = nil
	self.tank.spawn_sound_event = self._prefix_data_p1.bulldozer() .. "_entrance"
	self.tank.priority_shout = "f30"
	self.tank.bot_priority_shout = "f30x_any"
	self.tank.priority_shout_max_dis = 3000
	self.tank.rescue_hostages = false
	self.tank.deathguard = true
	self.tank.melee_weapon = "fists_dozer"
	self.tank.melee_weapon_dmg_multiplier = 1
	self.tank.melee_anims = {
		"cbt_std_melee"
	}
	self.tank.critical_hits = {
		damage_mul = 2
	}
	self.tank.damage.hurt_severity = presets.hurt_severities.no_hurts
 	self.tank.chatter = {
		aggressive = true,
		retreat = true,
		go_go = true,
		contact = true,
		entrance = true
 	}
	self.tank.announce_incomming = "incomming_tank"
	self.tank.steal_loot = nil
	self.tank.calls_in = nil
	self.tank.use_animation_on_fire_damage = false
	self.tank.flammable = true
	self.tank.can_be_tased = false
	self.tank.immune_to_knock_down = true
	self.tank.tank_concussion = true
	self.tank.must_headshot = true
	self.tank.static_dodge_preset = true
 	table.insert(self._enemy_list, "tank")
	
	self.tank_medic = deep_clone(self.tank)
	self.tank_medic.headshot_dmg_mul = 12.5
	self.tank_medic.custom_voicework = "medicdozer"
	table.insert(self.tank_medic.tags, "medic")
	table.insert(self._enemy_list, "tank_medic")
	
	self.tank_titan = deep_clone(self.tank)
	self.tank_titan.move_speed = presets.move_speed.very_slow
	self.tank_titan.headshot_dmg_mul = 3.997125
	self.tank_titan.immune_to_concussion = true
	self.tank_titan.immune_to_knock_down = true
	self.tank_titan.priority_shout = "f45"
	self.tank_titan.bot_priority_shout = "f45x_any"
	self.tank_titan.priority_shout_max_dis = 3000
	self.tank_titan.ecm_vulnerability = 0.85
	self.tank_titan.ecm_hurts = {
		ears = {min_duration = 1, max_duration = 3}
	}
	self.tank_titan.spawn_sound_event = "bdz_entrance_elite"
	self.tank_titan.die_sound_event = "mga_death_scream"
	self.tank_titan.damage.explosion_damage_mul = 1.25
 	table.insert(self._enemy_list, "tank_titan")
	
	self.tank_titan_assault = deep_clone(self.tank_titan)
	self.tank_titan_assault.spawn_sound_event = "cloaker_spawn"
	table.insert(self._enemy_list, "tank_titan_assault")
	
	self.tank_hw = deep_clone(self.tank_titan)
	self.tank_hw.priority_shout = "f30"
	self.tank_hw.bot_priority_shout = "f30x_any"	
	self.tank_hw.ignore_headshot = false
	self.tank_hw.melee_anims = nil
	self.tank_hw.spawn_sound_event = nil
	self.tank_hw.die_sound_event = nil
 	table.insert(self._enemy_list, "tank_hw")	
	
	self.tank_mini = deep_clone(self.tank)
	self.tank_mini.headshot_dmg_mul = 12.5
	self.tank_mini.move_speed = presets.move_speed.very_slow
	table.insert(self._enemy_list, "tank_mini")	
end

function CharacterTweakData:_init_tank_biker(presets)
	self.tank_biker = deep_clone(self.tank)
	self.tank_biker.access = "gangster"
	self.tank_biker.rescue_hostages = false
	self.tank_biker.use_radio = nil
	self.tank_biker.speech_prefix_p1 = "bik"
	self.tank_biker.speech_prefix_p2 = nil
	self.tank_biker.speech_prefix_count = 2	
	self.tank_biker.chatter = {
		aggressive = true,
		retreat = true,
		contact = true,
		go_go = true,
		suppress = true
 	}
end

function CharacterTweakData:_init_spooc(presets)
	self.spooc = deep_clone(presets.base)
	self.spooc.tags = {"spooc", "special"}
	self.spooc.experience = {}
	self.spooc.damage.hurt_severity = presets.hurt_severities.spooc
	self.spooc.weapon = deep_clone(presets.weapon.normal)
	self.spooc.detection = presets.detection.normal
	self.spooc.HEALTH_INIT = 60
	self.spooc.headshot_dmg_mul = 5.85
	self.spooc.move_speed = presets.move_speed.lightning
	self.spooc.no_retreat = true
	self.spooc.no_arrest = true
	self.spooc.surrender_break_time = {4, 6}
	self.spooc.suppression = nil
	self.spooc.surrender = nil
	self.spooc.priority_shout = "f33"
	self.spooc.bot_priority_shout = "f33x_any"
	self.spooc.priority_shout_max_dis = 3000
	self.spooc.rescue_hostages = false
	self.spooc.spooc_attack_timeout = {3, 3}
	self.spooc.spooc_attack_beating_time = {3, 3}
	self.spooc.spooc_attack_use_smoke_chance = 0
	self.spooc.weapon_voice = "3"
	self.spooc.experience.cable_tie = "tie_swat"
	self.spooc.speech_prefix_p1 = self._prefix_data_p1.cloaker()
	self.spooc.speech_prefix_count = nil
	self.spooc.access = "spooc"
	self.spooc.flammable = true
	self.spooc.dodge = presets.dodge.ninja
	self.spooc.chatter = presets.enemy_chatter.no_chatter
	self.spooc.steal_loot = nil
	self.spooc.melee_weapon = nil
	self.spooc.use_radio = nil
	self.spooc.can_be_tased = true
	self.spooc.static_dodge_preset = true
 	table.insert(self._enemy_list, "spooc")
	self.spooc_titan = deep_clone(self.spooc)
	self.spooc_titan.damage.hurt_severity = presets.hurt_severities.no_hurts
	self.spooc_titan.can_be_tased = false
	self.spooc_titan.priority_shout = "f45"
	self.spooc_titan.bot_priority_shout = "f45x_any"
	self.spooc_titan.priority_shout_max_dis = 1000
	self.spooc_titan.spawn_sound_event = "cloaker_presence_loop"
	self.spooc_titan.die_sound_event = "cloaker_presence_stop"
end

function CharacterTweakData:_init_shield(presets)
	self.shield = deep_clone(presets.base)
	self.shield.tags = {"shield", "special"}
	self.shield.experience = {}
	self.shield.weapon = deep_clone(presets.weapon.normal)
	self.shield.weapon.is_pistol.melee_speed = nil
	self.shield.weapon.is_pistol.melee_dmg = nil
	self.shield.weapon.is_pistol.melee_retry_delay = nil
	self.shield.detection = presets.detection.normal
	self.shield.HEALTH_INIT = 13
	self.shield.headshot_dmg_mul = 2.2
	self.shield.allowed_stances = {cbt = true}
	self.shield.allowed_poses = {crouch = true}
	self.shield.always_face_enemy = true
	self.shield.move_speed = presets.move_speed.fast
	self.shield.no_run_start = true
	self.shield.no_run_stop = true
	self.shield.no_retreat = true
	self.shield.no_arrest = true
	self.shield.surrender = nil
	self.shield.ecm_vulnerability = 0.9
	self.shield.suppression = presets.suppression.no_supress
	self.shield.ecm_hurts = {
		ears = {min_duration = 7, max_duration = 9}
	}
	self.shield.priority_shout = "f31"
	self.shield.bot_priority_shout = "f31x_any"
	self.shield.priority_shout_max_dis = 3000
	self.shield.rescue_hostages = false
	self.shield.deathguard = false
	self.shield.no_equip_anim = true
	self.shield.wall_fwd_offset = 100
	self.shield.calls_in = nil
	self.shield.ignore_medic_revive_animation = true
	self.shield.damage.hurt_severity = presets.hurt_severities.only_explosion_hurts
	self.shield.damage.shield_knocked = true
	self.shield.use_animation_on_fire_damage = false
	self.shield.flammable = true
	self.shield.weapon_voice = "3"
	self.shield.experience.cable_tie = "tie_swat"
	self.shield.speech_prefix_p1 = self._prefix_data_p1.swat()
	self.shield.speech_prefix_p2 = self._speech_prefix_p2
	self.shield.speech_prefix_count = 4
	self.shield.access = "shield"
	self.shield.chatter = presets.enemy_chatter.shield
	self.shield.announce_incomming = "incomming_shield"
	self.shield.steal_loot = nil
	self.shield.use_animation_on_fire_damage = false
	self.shield.immune_to_knock_down = true
	self.shield.static_dodge_preset = true
 	table.insert(self._enemy_list, "shield")
end

function CharacterTweakData:_init_phalanx_minion(presets)
	self.phalanx_minion = deep_clone(self.shield)
	self.phalanx_minion.tags = {"shield", "special"}
	self.phalanx_minion.experience = {}
	self.phalanx_minion.weapon = deep_clone(presets.weapon.normal)
	self.phalanx_minion.detection = presets.detection.normal
	self.phalanx_minion.headshot_dmg_mul = 2.2
	self.phalanx_minion.HEALTH_INIT = 13
	self.phalanx_minion.damage.explosion_damage_mul = 0.1
	self.phalanx_minion.damage.fire_damage_mul = 0.1
	self.phalanx_minion.damage.hurt_severity = presets.hurt_severities.no_hurts_no_tase
	self.phalanx_minion.flammable = false
	self.phalanx_minion.damage.shield_knocked = true
	self.phalanx_minion.priority_shout = "f45"
	self.phalanx_minion.bot_priority_shout = "f45x_any"
	self.phalanx_minion.priority_shout_max_dis = 3000
	self.phalanx_minion.weapon_voice = "3"
	self.phalanx_minion.experience.cable_tie = "tie_swat"
	self.phalanx_minion.speech_prefix_p1 = self._prefix_data_p1.swat()
	self.phalanx_minion.speech_prefix_p2 = self._speech_prefix_p2
	self.phalanx_minion.speech_prefix_count = 4
	self.phalanx_minion.access = "shield"
	self.phalanx_minion.chatter = presets.enemy_chatter.shield
	self.phalanx_minion.announce_incomming = "incomming_shield"
	self.phalanx_minion.steal_loot = nil
	self.phalanx_minion.ignore_medic_revive_animation = true
	self.phalanx_minion.ecm_vulnerability = 1
	self.phalanx_minion.ecm_hurts = {
		ears = {min_duration = 2, max_duration = 3}
	}
	self.phalanx_minion.use_animation_on_fire_damage = false
	self.phalanx_minion.can_be_tased = false
	self.phalanx_minion.immune_to_knock_down = true
	self.phalanx_minion.immune_to_concussion = true
	self.phalanx_minion.damage.immune_to_knockback = false
	self.phalanx_minion.spawn_sound_event = "l2d_prm"
	self.phalanx_minion.die_sound_event = "mga_death_scream"
	self.phalanx_minion.suppression = presets.suppression.no_supress
 	table.insert(self._enemy_list, "phalanx_minion")
	self.phalanx_minion_assault = deep_clone(self.phalanx_minion)
	self.phalanx_minion_assault.spawn_sound_event = "cloaker_spawn"
	self.phalanx_minion_assault.die_sound_event = "mga_death_scream"
	table.insert(self._enemy_list, "phalanx_minion_assault")
end

function CharacterTweakData:_init_phalanx_vip(presets)
	self.phalanx_vip = deep_clone(self.phalanx_minion)
	self.phalanx_vip.LOWER_HEALTH_PERCENTAGE_LIMIT = 0.0001
	self.phalanx_vip.FINAL_LOWER_HEALTH_PERCENTAGE_LIMIT = 0.0001
	self.phalanx_vip.damage.shield_knocked = false
	self.phalanx_vip.damage.immune_to_knockback = true
	self.phalanx_vip.immune_to_knock_down = true
	self.phalanx_vip.HEALTH_INIT = 26
	self.phalanx_vip.headshot_dmg_mul = 1.25
	self.phalanx_vip.damage.explosion_damage_mul = 0.05
	self.phalanx_vip.damage.fire_damage_mul = 0.05
	self.phalanx_vip.damage.bullet_damage_mul = 0.65
	self.phalanx_vip.spawn_sound_event = nil
	self.phalanx_vip.priority_shout = "f45"
	self.phalanx_vip.bot_priority_shout = "f45x_any"
	self.phalanx_vip.priority_shout_max_dis = 3000
	self.phalanx_vip.flammable = false
	self.phalanx_vip.can_be_tased = false
	self.phalanx_vip.ecm_vulnerability = nil
	self.phalanx_vip.must_headshot = true
	self.phalanx_vip.suppression = presets.suppression.no_supress
	self.phalanx_vip.ecm_hurts = {}
 	table.insert(self._enemy_list, "phalanx_vip")
end

function CharacterTweakData:_init_spring(presets)
	self.spring = deep_clone(self.tank)
	self.spring.tags = {"custom", "special"}
	self.spring.move_speed = presets.move_speed.very_slow
	self.spring.rage_move_speed = presets.move_speed.fast
	self.spring.no_run_start = true
	self.spring.no_run_stop = true
	self.spring.no_retreat = true
	self.spring.no_arrest = true
	self.spring.LOWER_HEALTH_PERCENTAGE_LIMIT = nil
	self.spring.FINAL_LOWER_HEALTH_PERCENTAGE_LIMIT = nil
	self.spring.ends_assault_on_death = true
	self.spring.no_damage_mission = true
	self.spring.immune_to_knock_down = true
	self.spring.HEALTH_INIT = 1000
	self.spring.EXTRA_HEALTH_BALANCE = 50
	self.spring.headshot_dmg_mul = 3.997125
	self.spring.damage.explosion_damage_mul = 1.25
	self.spring.damage.bullet_damage_mul = 0.65
	self.spring.damage.fire_damage_mul = 0.65
	self.spring.priority_shout = "f45"
	self.spring.bot_priority_shout = "f45x_any"
	self.spring.priority_shout_max_dis = 3000
	self.spring.flammable = true
	self.spring.rescue_hostages = false
	self.spring.can_be_tased = false
	self.spring.ecm_vulnerability = nil
	self.spring.immune_to_concussion = true
	self.spring.ecm_hurts = {}
	self.spring.damage.hurt_severity = presets.hurt_severities.no_hurts
	self.spring.melee_weapon = "fists_dozer"
	self.spring.melee_weapon_dmg_multiplier = 1
	self.spring.melee_anims = {
		"cbt_std_melee"
	}
	self.spring.speech_prefix_p1 = "cpsp"
	self.spring.speech_prefix_p2 = nil
	self.spring.speech_prefix_count = nil
 	self.spring.chatter = {
		aggressive = true,
		retreat = true,
		go_go = true,
		contact = true,
		entrance = true
 	}
	self.spring.announce_incomming = "incomming_captain"
	self.spring.spawn_sound_event = "cpa_a02_01"
	self.spring.die_sound_event = "mga_death_scream"
	self.spring.critical_hits = {
		damage_mul = 2
	}
	self.spring.static_dodge_preset = true
 	table.insert(self._enemy_list, "spring")
end

function CharacterTweakData:_init_summers(presets)
	self.summers = deep_clone(presets.base)
	self.summers.tags = {"custom", "special"}
	self.summers.experience = {}
	self.summers.weapon = deep_clone(presets.weapon.normal)
	self.summers.melee_weapon = "buzzer_summer"
	self.summers.melee_weapon_dmg_multiplier = 1
	self.summers.weapon_safety_range = 1
	self.summers.detection = presets.detection.normal
	self.summers.HEALTH_INIT = 72
	self.summers.HEALTH_SUICIDE_LIMIT = 0.25
	self.summers.flammable = false
	self.summers.allowed_stances = {cbt = true}
	self.summers.allowed_poses = {stand = true}	
	self.summers.use_animation_on_fire_damage = false
	self.summers.damage.bullet_damage_mul = 0.65
	self.summers.damage.explosion_damage_mul = 0.1
	self.summers.damage.fire_damage_mul = 0.05
	self.summers.damage.hurt_severity = presets.hurt_severities.no_hurts
	self.summers.headshot_dmg_mul = 1.25
	self.summers.bag_dmg_mul = 6
	self.summers.move_speed = presets.move_speed.very_slow
	self.summers.crouch_move = false
	self.summers.no_run_start = true
	self.summers.no_run_stop = true
	self.summers.no_retreat = true
	self.summers.no_arrest = true
	self.summers.ends_assault_on_death = true
	self.summers.no_damage_mission = true
	self.summers.immune_to_knock_down = true
	self.summers.priority_shout = "f45"
	self.summers.bot_priority_shout = "f45x_any"
	self.summers.priority_shout_max_dis = 3000
	self.summers.surrender = nil
	self.summers.ecm_vulnerability = 0
	self.summers.ecm_hurts = {}
	self.summers.surrender_break_time = {4, 6}
	self.summers.suppression = presets.suppression.no_supress
	self.summers.weapon_voice = "3"
	self.summers.experience.cable_tie = "tie_swat"
	self.summers.speech_prefix_p1 = "rtsr"
	self.summers.speech_prefix_p2 = nil
	self.summers.speech_prefix_count = nil
	self.summers.access = "taser"
	self.summers.dodge = presets.dodge.elite
	self.summers.use_gas = true
	self.summers.rescue_hostages = false
	self.summers.can_be_tased = false
	self.summers.immune_to_concussion = true
	self.summers.deathguard = true
	self.summers.chatter = presets.enemy_chatter.summers
	self.summers.announce_incomming = "incomming_captain"
	self.summers.spawn_sound_event = "cpa_a02_01"
	self.summers.die_sound_event = "mga_death_scream"
	self.summers.use_radio = "dsp_radio_russian"
	self.summers.use_factory = true
	self.summers.factory_weapon_id = {"wpn_fps_fla_mk2_npc_summers"}
	self.summers.steal_loot = nil
 	table.insert(self._enemy_list, "summers")
end

function CharacterTweakData:_init_taser(presets)
	self.taser = deep_clone(presets.base)
	self.taser.tags = {"taser", "special"}
	self.taser.experience = {}
	self.taser.weapon = deep_clone(presets.weapon.normal)
	self.taser.weapon.is_rifle.tase_distance = 1400
	self.taser.weapon.is_rifle.aim_delay_tase = {0, 0.5}
	self.taser.weapon.is_rifle.tase_sphere_cast_radius = 30
	self.taser.detection = presets.detection.normal
	self.taser.HEALTH_INIT = 36
	self.taser.headshot_dmg_mul = 1.8
	self.taser.move_speed = presets.move_speed.fast
	self.taser.no_retreat = true
	self.taser.no_arrest = true
	self.taser.surrender = presets.surrender.special
	self.taser.ecm_vulnerability = 0.9
	self.taser.ecm_hurts = {
		ears = {min_duration = 6, max_duration = 8}
	}
	self.taser.surrender_break_time = {4, 6}
	self.taser.suppression = presets.suppression.no_supress
	self.taser.weapon_voice = "3"
	self.taser.experience.cable_tie = "tie_swat"
	self.taser.speech_prefix_p1 = self._prefix_data_p1.taser()
	self.taser.speech_prefix_p2 = nil
	self.taser.speech_prefix_count = nil
	self.taser.spawn_sound_event = self._prefix_data_p1.taser() .. "_entrance"
	self.taser.access = "taser"
	self.taser.dodge = presets.dodge.athletic
	self.taser.priority_shout = "f32"
	self.taser.bot_priority_shout = "f32x_any"
	self.taser.priority_shout_max_dis = 3000
	self.taser.rescue_hostages = false
	self.taser.deathguard = true
 	self.taser.chatter = {
		aggressive = true,
		retreat = true,
		go_go = true,
		contact = true,
		entrance = true
 	}
	self.taser.announce_incomming = "incomming_taser"
	self.taser.steal_loot = nil
	self.taser.special_deaths = {}
	self.taser.special_deaths.bullet = {
		[("head"):id():key()] = {
			character_name = "bodhi",
			weapon_id = "model70",
			sequence = "kill_tazer_headshot",
			special_comment = "x01"
		}
	}
 	table.insert(self._enemy_list, "taser")
	self.taser_summers = deep_clone(self.taser)
	self.taser_summers.HEALTH_INIT = 36
	self.taser_summers.headshot_dmg_mul = 1.25
	self.taser_summers.tags = {"taser", "medic_summers", "custom", "special"}
	self.taser_summers.ignore_medic_revive_animation = false
	self.taser_summers.flammable = false
	self.taser_summers.use_animation_on_fire_damage = false
	self.taser_summers.damage.bullet_damage_mul = 0.65
	self.taser_summers.damage.explosion_damage_mul = 0.1
	self.taser_summers.damage.fire_damage_mul = 0.05
	self.taser_summers.damage.hurt_severity = presets.hurt_severities.no_hurts
	self.taser_summers.ecm_hurts = {}
	self.taser_summers.chatter = presets.enemy_chatter.summers
	self.taser_summers.no_retreat = true
	self.taser_summers.rescue_hostages = false
	self.taser_summers.steal_loot = nil
	self.taser_summers.immune_to_concussion = true
	self.taser_summers.no_damage_mission = true
	self.taser_summers.no_arrest = true
	self.taser_summers.immune_to_knock_down = true
	self.taser_summers.priority_shout = "f45"
	self.taser_summers.bot_priority_shout = "f45x_any"
	self.taser_summers.speech_prefix_p1 = "fl"
	self.taser_summers.speech_prefix_p2 = "n"
	self.taser_summers.speech_prefix_count = 1
	self.taser_summers.die_sound_event = "mga_death_scream"
	self.taser_summers.use_factory = true
	self.taser_summers.factory_weapon_id = {"wpn_fps_ass_m16_npc_summers"}
	self.taser_summers.use_radio = "dsp_radio_russian"
	self.taser_summers.spawn_sound_event = nil
 	table.insert(self._enemy_list, "taser_summers")
end

function CharacterTweakData:_init_boom(presets)
	self.boom = deep_clone(presets.base)
	self.boom.tags = {"custom", "special"}
	self.boom.experience = {}
	self.boom.weapon = deep_clone(presets.weapon.normal)
	self.boom.melee_weapon = "knife_1"
	self.boom.melee_weapon_dmg_multiplier = 1
	self.boom.weapon_safety_range = 1000
	self.boom.detection = presets.detection.normal
	self.boom.HEALTH_INIT = 36
	self.boom.HEALTH_SUICIDE_LIMIT = 0.25
	self.boom.flammable = true
	self.boom.use_animation_on_fire_damage = true
	self.boom.damage.explosion_damage_mul = 0.5
	self.boom.damage.fire_damage_mul = 1
	self.boom.damage.hurt_severity = presets.hurt_severities.boom
	self.boom.headshot_dmg_mul = 1.8
	self.boom.bag_dmg_mul = 6
	self.boom.move_speed = presets.move_speed.fast
	self.boom.no_retreat = true
	self.boom.no_arrest = true
	self.boom.surrender = nil
	self.boom.ecm_vulnerability = 0.9
	self.boom.ecm_hurts = {
		ears = {min_duration = 6, max_duration = 8}
	}
	self.boom.surrender_break_time = {4, 6}
	self.boom.suppression = presets.suppression.no_supress
	self.boom.weapon_voice = "3"
	self.boom.experience.cable_tie = "tie_swat"
	self.boom.speech_prefix_p1 = nil
	self.boom.speech_prefix_p2 = nil
	self.boom.speech_prefix_count = nil
	self.boom.access = "taser"
	self.boom.dodge = presets.dodge.athletic
	self.boom.use_gas = true
	self.boom.priority_shout = "g29"
	self.boom.bot_priority_shout = "g29"
	self.boom.priority_shout_max_dis = 3000
	self.boom.custom_shout = true
	self.boom.rescue_hostages = false
	self.boom.deathguard = true
	self.boom.chatter = {
		aggressive = true,
		retreat = true,
		go_go = true,
		contact = true,
		entrance = true
	}
	self.boom.announce_incomming = "incomming_gren"
	self.boom.spawn_sound_event = "clk_c01x_plu"
	self.boom.steal_loot = nil
	self.boom.custom_voicework = "grenadier"
 	table.insert(self._enemy_list, "boom")
	self.rboom = deep_clone(self.boom)
	self.rboom.spawn_sound_event = "clk_c01x_plu"
	self.rboom.die_sound_event = "mdc_x02a_any_3p"
	self.rboom.speech_prefix_p1 = self._prefix_data_p1.swat()
	self.rboom.speech_prefix_p2 = self._speech_prefix_p2
	self.rboom.speech_prefix_count = 1	
	self.rboom.custom_voicework = nil
 	table.insert(self._enemy_list, "rboom")
	self.boom_summers = deep_clone(self.boom)
	self.boom_summers.spawn_sound_event = "clk_c01x_plu"
	self.boom_summers.use_animation_on_fire_damage = false
	self.boom_summers.damage.explosion_damage_mul = 0.1
	self.boom_summers.damage.fire_damage_mul = 0.05
	self.boom_summers.damage.hurt_severity = presets.hurt_severities.no_hurts
	self.boom_summers.chatter = presets.enemy_chatter.summers
	self.boom_summers.speech_prefix_p1 = "fl"
	self.boom_summers.speech_prefix_p2 = "n"
	self.boom_summers.speech_prefix_count = 1
	self.boom_summers.custom_voicework = nil
	self.boom_summers.die_sound_event = "mga_death_scream"
	self.boom_summers.use_radio = "dsp_radio_russian"
	self.boom_summers.HEALTH_INIT = 36
	self.boom_summers.headshot_dmg_mul = 1.25
	self.boom_summers.tags = {"medic_summers", "custom", "special"}
	self.boom_summers.ignore_medic_revive_animation = false
	self.boom_summers.no_retreat = true
	self.boom_summers.no_arrest = true
	self.boom_summers.immune_to_knock_down = true
	self.boom_summers.immune_to_concussion = true
	self.boom_summers.no_damage_mission = true
	self.boom_summers.priority_shout = "f45"
	self.boom_summers.bot_priority_shout = "f45x_any"
	self.boom_summers.custom_shout = false
	self.boom_summers.use_factory = true
	self.boom_summers.rescue_hostages = false
	self.boom_summers.steal_loot = nil
	self.boom_summers.factory_weapon_id = {"wpn_fps_pis_peacemaker_npc_summers"}
 	table.insert(self._enemy_list, "boom_summers")
end

function CharacterTweakData:_init_inside_man(presets)
	self.inside_man = deep_clone(presets.base)
	self.inside_man.experience = {}
	self.inside_man.weapon = presets.weapon.normal
	self.inside_man.detection = presets.detection.blind
	self.inside_man.HEALTH_INIT = 4
	self.inside_man.headshot_dmg_mul = 2.5
	self.inside_man.move_speed = presets.move_speed.normal
	self.inside_man.surrender_break_time = {10, 15}
	self.inside_man.suppression = presets.suppression.no_supress
	self.inside_man.surrender = nil
	self.inside_man.ecm_vulnerability = nil
	self.inside_man.ecm_hurts = {
		ears = {min_duration = 0, max_duration = 0}
	}
	self.inside_man.weapon_voice = "1"
	self.inside_man.experience.cable_tie = "tie_swat"
	self.inside_man.speech_prefix_p1 = "l"
	self.inside_man.speech_prefix_p2 = "n"
	self.inside_man.speech_prefix_count = 4
	self.inside_man.access = "cop"
	self.inside_man.dodge = presets.dodge.average
	self.inside_man.chatter = presets.enemy_chatter.no_chatter
	self.inside_man.melee_weapon = "baton"
	self.inside_man.calls_in = nil
end

function CharacterTweakData:_init_civilian(presets)
	self.civilian = {
		experience = {}
	}
	self.civilian.tags = {"civilian"}
	self.civilian.detection = presets.detection.civilian
	self.civilian.HEALTH_INIT = 0.9
	self.civilian.headshot_dmg_mul = 999
	self.civilian.move_speed = presets.move_speed.civ_fast
	self.civilian.flee_type = "escape"
	self.civilian.scare_max = {10, 20}
	self.civilian.scare_shot = 1
	self.civilian.scare_intimidate = -5
	self.civilian.submission_max = {60, 120}
	self.civilian.submission_intimidate = 120
	self.civilian.run_away_delay = {5, 20}
	self.civilian.damage = presets.hurt_severities.no_hurts
	self.civilian.ecm_vulnerability = nil
	self.civilian.ecm_hurts = {
		ears = {min_duration = 0, max_duration = 0}
	}
	self.civilian.experience.cable_tie = "tie_civ"
	self.civilian.speech_prefix_p1 = "cm"
	self.civilian.speech_prefix_count = 2
	self.civilian.access = "civ_male"
	self.civilian.intimidateable = true
	self.civilian.challenges = {type = "civilians"}
	self.civilian.calls_in = true
	self.civilian.hostage_move_speed = 3
	self.civilian_female = deep_clone(self.civilian)
	self.civilian_female.speech_prefix_p1 = "cf"
	self.civilian_female.speech_prefix_count = 5
	self.civilian_female.female = true
	self.civilian_female.access = "civ_female"
	self.robbers_safehouse = deep_clone(self.civilian)
	self.robbers_safehouse.scare_shot = 0
	self.robbers_safehouse.scare_intimidate = 0
	self.robbers_safehouse.intimidateable = false
	self.robbers_safehouse.ignores_aggression = true
	self.robbers_safehouse.calls_in = nil
	self.robbers_safehouse.ignores_contours = true
	self.robbers_safehouse.HEALTH_INIT = 50
	self.robbers_safehouse.headshot_dmg_mul = 1
end

function CharacterTweakData:_init_bank_manager(presets)
	self.bank_manager = {
		experience = {},
		escort = {}
	}
	self.bank_manager.detection = presets.detection.civilian
	self.bank_manager.HEALTH_INIT = self.civilian.HEALTH_INIT
	self.bank_manager.headshot_dmg_mul = self.civilian.headshot_dmg_mul
	self.bank_manager.move_speed = presets.move_speed.normal
	self.bank_manager.flee_type = "hide"
	self.bank_manager.scare_max = {10, 20}
	self.bank_manager.scare_shot = 1
	self.bank_manager.scare_intimidate = -5
	self.bank_manager.submission_max = {60, 120}
	self.bank_manager.submission_intimidate = 120
	self.bank_manager.damage = presets.hurt_severities.no_hurts
	self.bank_manager.ecm_vulnerability = nil
	self.bank_manager.ecm_hurts = {
		ears = {min_duration = 0, max_duration = 0}
	}
	self.bank_manager.experience.cable_tie = "tie_civ"
	self.bank_manager.speech_prefix_p1 = "cm"
	self.bank_manager.speech_prefix_count = 2
	self.bank_manager.access = "civ_male"
	self.bank_manager.intimidateable = true
	self.bank_manager.hostage_move_speed = 3
	self.bank_manager.challenges = {type = "civilians"}
	self.bank_manager.calls_in = true
end

function CharacterTweakData:_init_drunk_pilot(presets)
	self.drunk_pilot = deep_clone(self.civilian)
	self.drunk_pilot.move_speed = presets.move_speed.civ_fast
	self.drunk_pilot.flee_type = "hide"
	self.drunk_pilot.access = "civ_male"
	self.drunk_pilot.intimidateable = nil
	self.drunk_pilot.challenges = {type = "civilians"}
	self.drunk_pilot.calls_in = nil
	self.drunk_pilot.ignores_aggression = true
end

function CharacterTweakData:_init_boris(presets)
	self.boris = deep_clone(self.civilian)
	self.boris.flee_type = "hide"
	self.boris.access = "civ_male"
	self.boris.intimidateable = nil
	self.boris.challenges = {type = "civilians"}
	self.boris.calls_in = nil
	self.boris.ignores_aggression = true
end

function CharacterTweakData:_init_old_hoxton_mission(presets)
	self.old_hoxton_mission = deep_clone(presets.base)
	self.old_hoxton_mission.experience = {}
	self.old_hoxton_mission.no_run_start = true
	self.old_hoxton_mission.no_run_stop = true
	self.old_hoxton_mission.weapon = presets.weapon.gang_member
	self.old_hoxton_mission.detection = presets.detection.gang_member
	self.old_hoxton_mission.damage = presets.gang_member_damage
	self.old_hoxton_mission.damage.explosion_damage_mul = 0
	self.old_hoxton_mission.HEALTH_INIT = 100
	self.old_hoxton_mission.headshot_dmg_mul = 1
	self.old_hoxton_mission.move_speed = presets.move_speed.gang_member
	self.old_hoxton_mission.surrender_break_time = {6, 10}
	self.old_hoxton_mission.suppression = presets.suppression.no_supress
	self.old_hoxton_mission.surrender = false
	self.old_hoxton_mission.weapon_voice = "1"
	self.old_hoxton_mission.experience.cable_tie = "tie_swat"
	self.old_hoxton_mission.speech_prefix_p1 = "rb2"
	self.old_hoxton_mission.access = "teamAI4"
	self.old_hoxton_mission.dodge = presets.dodge.athletic
	self.old_hoxton_mission.no_arrest = true
	self.old_hoxton_mission.chatter = presets.enemy_chatter.no_chatter
	self.old_hoxton_mission.use_radio = nil
	self.old_hoxton_mission.melee_weapon = "fists"
	self.old_hoxton_mission.melee_weapon_dmg_multiplier = 1
	self.old_hoxton_mission.steal_loot = false
	self.old_hoxton_mission.rescue_hostages = false
	self.old_hoxton_mission.crouch_move = false
	self.old_hoxton_mission.static_dodge_preset = true
end

function CharacterTweakData:_init_russian(presets)
	self.russian = {}
	self.russian.always_face_enemy = true
	self.russian.no_run_start = true
	self.russian.no_run_stop = true
	self.russian.flammable = false
	self.russian.damage = presets.gang_member_damage
	self.russian.weapon = deep_clone(presets.weapon.gang_member)
	self.russian.weapon.weapons_of_choice = {
		primary = "wpn_fps_ass_74_npc",
		secondary = Idstring("units/payday2/weapons/wpn_npc_beretta92/wpn_npc_beretta92")
	}
	self.russian.detection = presets.detection.gang_member
	self.russian.move_speed = presets.move_speed.gang_member
	self.russian.crouch_move = false
	self.russian.speech_prefix = "rb2"
	self.russian.weapon_voice = "1"
	self.russian.access = "teamAI1"
	self.russian.dodge = presets.dodge.athletic
	self.russian.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_german(presets)
	self.german = {}
	self.german.always_face_enemy = true
	self.german.no_run_start = true
	self.german.no_run_stop = true
	self.german.flammable = false
	self.german.damage = presets.gang_member_damage
	self.german.weapon = deep_clone(presets.weapon.gang_member)
	self.german.weapon.weapons_of_choice = {
		primary = "wpn_fps_shot_r870_npc",
		secondary = Idstring("units/payday2/weapons/wpn_npc_beretta92/wpn_npc_beretta92")
	}
	self.german.detection = presets.detection.gang_member
	self.german.move_speed = presets.move_speed.gang_member
	self.german.crouch_move = false
	self.german.speech_prefix = "rb2"
	self.german.weapon_voice = "2"
	self.german.access = "teamAI1"
	self.german.dodge = presets.dodge.athletic
	self.german.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_spanish(presets)
	self.spanish = {}
	self.spanish.always_face_enemy = true
	self.spanish.no_run_start = true
	self.spanish.no_run_stop = true
	self.spanish.flammable = false
	self.spanish.damage = presets.gang_member_damage
	self.spanish.weapon = deep_clone(presets.weapon.gang_member)
	self.spanish.weapon.weapons_of_choice = {
		primary = "wpn_fps_lmg_m249_npc",
		secondary = Idstring("units/payday2/weapons/wpn_npc_beretta92/wpn_npc_beretta92")
	}
	self.spanish.detection = presets.detection.gang_member
	self.spanish.move_speed = presets.move_speed.gang_member
	self.spanish.crouch_move = false
	self.spanish.speech_prefix = "rb2"
	self.spanish.weapon_voice = "3"
	self.spanish.access = "teamAI1"
	self.spanish.dodge = presets.dodge.athletic
	self.spanish.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_american(presets)
	self.american = {}
	self.american.always_face_enemy = true
	self.american.no_run_start = true
	self.american.no_run_stop = true
	self.american.flammable = false
	self.american.damage = presets.gang_member_damage
	self.american.weapon = deep_clone(presets.weapon.gang_member)
	self.american.weapon.weapons_of_choice = {
		primary = "wpn_fps_ass_m14_npc",
		secondary = Idstring("units/payday2/weapons/wpn_npc_beretta92/wpn_npc_beretta92")
	}
	self.american.detection = presets.detection.gang_member
	self.american.move_speed = presets.move_speed.gang_member
	self.american.crouch_move = false
	self.american.speech_prefix = "rb2"
	self.american.weapon_voice = "3"
	self.american.access = "teamAI1"
	self.american.dodge = presets.dodge.athletic
	self.american.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_jowi(presets)
	self.jowi = {}
	self.jowi.always_face_enemy = true
	self.jowi.no_run_start = true
	self.jowi.no_run_stop = true
	self.jowi.damage = presets.gang_member_damage
	self.jowi.weapon = deep_clone(presets.weapon.gang_member)
	self.jowi.weapon.weapons_of_choice = {
		primary = "wpn_fps_snp_tti_npc",
		secondary = Idstring("units/payday2/weapons/wpn_npc_beretta92/wpn_npc_beretta92")
	}
	self.jowi.detection = presets.detection.gang_member
	self.jowi.move_speed = presets.move_speed.gang_member
	self.jowi.crouch_move = false
	self.jowi.speech_prefix = "rb2"
	self.jowi.weapon_voice = "3"
	self.jowi.access = "teamAI1"
	self.jowi.dodge = presets.dodge.athletic
	self.jowi.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_old_hoxton(presets)
	self.old_hoxton = {}
	self.old_hoxton.always_face_enemy = true
	self.old_hoxton.no_run_start = true
	self.old_hoxton.no_run_stop = true
	self.old_hoxton.damage = presets.gang_member_damage
	self.old_hoxton.weapon = deep_clone(presets.weapon.gang_member)
	self.old_hoxton.weapon.weapons_of_choice = {
		primary = "wpn_fps_sho_spas12_npc",
		secondary = Idstring("units/payday2/weapons/wpn_npc_beretta92/wpn_npc_beretta92")
	}
	self.old_hoxton.detection = presets.detection.gang_member
	self.old_hoxton.move_speed = presets.move_speed.gang_member
	self.old_hoxton.crouch_move = false
	self.old_hoxton.speech_prefix = "rb2"
	self.old_hoxton.weapon_voice = "3"
	self.old_hoxton.access = "teamAI1"
	self.old_hoxton.dodge = presets.dodge.athletic
	self.old_hoxton.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_clover(presets)
	self.female_1 = {}
	self.female_1.always_face_enemy = true
	self.female_1.no_run_start = true
	self.female_1.no_run_stop = true
	self.female_1.damage = presets.gang_member_damage
	self.female_1.weapon = deep_clone(presets.weapon.gang_member)
	self.female_1.weapon.weapons_of_choice = {
		primary = "wpn_fps_ass_l85a2_npc",
		secondary = Idstring("units/payday2/weapons/wpn_npc_beretta92/wpn_npc_beretta92")
	}
	self.female_1.detection = presets.detection.gang_member
	self.female_1.move_speed = presets.move_speed.gang_member
	self.female_1.crouch_move = false
	self.female_1.speech_prefix = "rb7"
	self.female_1.weapon_voice = "3"
	self.female_1.access = "teamAI1"
	self.female_1.dodge = presets.dodge.athletic
	self.female_1.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_dragan(presets)
	self.dragan = {}
	self.dragan.always_face_enemy = true
	self.dragan.no_run_start = true
	self.dragan.no_run_stop = true
	self.dragan.damage = presets.gang_member_damage
	self.dragan.weapon = deep_clone(presets.weapon.gang_member)
	self.dragan.weapon.weapons_of_choice = {
		primary = "wpn_fps_ass_vhs_npc",
		secondary = Idstring("units/payday2/weapons/wpn_npc_beretta92/wpn_npc_beretta92")
	}
	self.dragan.detection = presets.detection.gang_member
	self.dragan.move_speed = presets.move_speed.gang_member
	self.dragan.crouch_move = false
	self.dragan.speech_prefix = "rb8"
	self.dragan.weapon_voice = "3"
	self.dragan.access = "teamAI1"
	self.dragan.dodge = presets.dodge.athletic
	self.dragan.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_jacket(presets)
	self.jacket = {}
	self.jacket.always_face_enemy = true
	self.jacket.no_run_start = true
	self.jacket.no_run_stop = true
	self.jacket.damage = presets.gang_member_damage
	self.jacket.weapon = deep_clone(presets.weapon.gang_member)
	self.jacket.weapon.weapons_of_choice = {
		primary = "wpn_fps_ass_74_npc",
		secondary = Idstring("units/payday2/weapons/wpn_npc_beretta92/wpn_npc_beretta92")
	}
	self.jacket.detection = presets.detection.gang_member
	self.jacket.move_speed = presets.move_speed.gang_member
	self.jacket.crouch_move = false
	self.jacket.speech_prefix = "rb9"
	self.jacket.weapon_voice = "3"
	self.jacket.access = "teamAI1"
	self.jacket.dodge = presets.dodge.athletic
	self.jacket.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_bonnie(presets)
	self.bonnie = {}
	self.bonnie.always_face_enemy = true
	self.bonnie.no_run_start = true
	self.bonnie.no_run_stop = true
	self.bonnie.damage = presets.gang_member_damage
	self.bonnie.weapon = deep_clone(presets.weapon.gang_member)
	self.bonnie.weapon.weapons_of_choice = {
		primary = "wpn_fps_shot_b682_npc",
		secondary = Idstring("units/payday2/weapons/wpn_npc_beretta92/wpn_npc_beretta92")
	}
	self.bonnie.detection = presets.detection.gang_member
	self.bonnie.move_speed = presets.move_speed.gang_member
	self.bonnie.dodge = presets.dodge.athletic
	self.bonnie.crouch_move = false
	self.bonnie.speech_prefix = "rb10"
	self.bonnie.weapon_voice = "3"
	self.bonnie.access = "teamAI1"
	self.bonnie.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_sokol(presets)
	self.sokol = {}
	self.sokol.always_face_enemy = true
	self.sokol.no_run_start = true
	self.sokol.no_run_stop = true
	self.sokol.damage = presets.gang_member_damage
	self.sokol.weapon = deep_clone(presets.weapon.gang_member)
	self.sokol.weapon.weapons_of_choice = {
		primary = "wpn_fps_ass_asval_npc",
		secondary = Idstring("units/payday2/weapons/wpn_npc_beretta92/wpn_npc_beretta92")
	}
	self.sokol.detection = presets.detection.gang_member
	self.sokol.move_speed = presets.move_speed.gang_member
	self.sokol.crouch_move = false
	self.sokol.speech_prefix = "rb11"
	self.sokol.weapon_voice = "3"
	self.sokol.access = "teamAI1"
	self.sokol.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_dragon(presets)
	self.dragon = {}
	self.dragon.always_face_enemy = true
	self.dragon.no_run_start = true
	self.dragon.no_run_stop = true
	self.dragon.damage = presets.gang_member_damage
	self.dragon.weapon = deep_clone(presets.weapon.gang_member)
	self.dragon.weapon.weapons_of_choice = {
		primary = "wpn_fps_snp_wa2000_npc",
		secondary = Idstring("units/payday2/weapons/wpn_npc_beretta92/wpn_npc_beretta92")
	}
	self.dragon.detection = presets.detection.gang_member
	self.dragon.move_speed = presets.move_speed.gang_member
	self.dragon.crouch_move = false
	self.dragon.speech_prefix = "rb12"
	self.dragon.weapon_voice = "3"
	self.dragon.access = "teamAI1"
	self.dragon.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_bodhi(presets)
	self.bodhi = {}
	self.bodhi.always_face_enemy = true
	self.bodhi.no_run_start = true
	self.bodhi.no_run_stop = true
	self.bodhi.damage = presets.gang_member_damage
	self.bodhi.weapon = deep_clone(presets.weapon.gang_member)
	self.bodhi.weapon.weapons_of_choice = {
		primary = "wpn_fps_snp_model70_npc",
		secondary = Idstring("units/payday2/weapons/wpn_npc_beretta92/wpn_npc_beretta92")
	}
	self.bodhi.detection = presets.detection.gang_member
	self.bodhi.move_speed = presets.move_speed.gang_member
	self.bodhi.crouch_move = false
	self.bodhi.speech_prefix = "rb13"
	self.bodhi.weapon_voice = "3"
	self.bodhi.access = "teamAI1"
	self.bodhi.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_jimmy(presets)
	self.jimmy = {}
	self.jimmy.always_face_enemy = true
	self.jimmy.no_run_start = true
	self.jimmy.no_run_stop = true
	self.jimmy.damage = presets.gang_member_damage
	self.jimmy.weapon = deep_clone(presets.weapon.gang_member)
	self.jimmy.weapon.weapons_of_choice = {
		primary = "wpn_fps_sho_ben_npc",
		secondary = Idstring("units/payday2/weapons/wpn_npc_beretta92/wpn_npc_beretta92")
	}
	self.jimmy.detection = presets.detection.gang_member
	self.jimmy.move_speed = presets.move_speed.gang_member
	self.jimmy.crouch_move = false
	self.jimmy.speech_prefix = "rb14"
	self.jimmy.weapon_voice = "3"
	self.jimmy.access = "teamAI1"
	self.jimmy.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_sydney(presets)
	self.sydney = {}
	self.sydney.always_face_enemy = true
	self.sydney.no_run_start = true
	self.sydney.no_run_stop = true
	self.sydney.damage = presets.gang_member_damage
	self.sydney.weapon = deep_clone(presets.weapon.gang_member)
	self.sydney.weapon.weapons_of_choice = {
		primary = "wpn_fps_ass_tecci_npc",
		secondary = Idstring("units/payday2/weapons/wpn_npc_beretta92/wpn_npc_beretta92")
	}
	self.sydney.detection = presets.detection.gang_member
	self.sydney.move_speed = presets.move_speed.gang_member
	self.sydney.crouch_move = false
	self.sydney.speech_prefix = "rb15"
	self.sydney.weapon_voice = "3"
	self.sydney.access = "teamAI1"
	self.sydney.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_wild(presets)
	self.wild = {}
	self.wild.always_face_enemy = true
	self.wild.no_run_start = true
	self.wild.no_run_stop = true
	self.wild.damage = presets.gang_member_damage
	self.wild.weapon = deep_clone(presets.weapon.gang_member)
	self.wild.weapon.weapons_of_choice = {
		primary = "wpn_fps_sho_boot_npc",
		secondary = Idstring("units/payday2/weapons/wpn_npc_beretta92/wpn_npc_beretta92")
	}
	self.wild.detection = presets.detection.gang_member
	self.wild.move_speed = presets.move_speed.gang_member
	self.wild.crouch_move = false
	self.wild.speech_prefix = "rb16"
	self.wild.weapon_voice = "3"
	self.wild.access = "teamAI1"
	self.wild.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_chico(presets)
	self.chico = {}
	self.chico.always_face_enemy = true
	self.chico.no_run_start = true
	self.chico.no_run_stop = true
	self.chico.damage = presets.gang_member_damage
	self.chico.weapon = deep_clone(presets.weapon.gang_member)
	self.chico.weapon.weapons_of_choice = {
		primary = "wpn_fps_ass_contraband_npc",
		secondary = Idstring("units/payday2/weapons/wpn_npc_beretta92/wpn_npc_beretta92")
	}
	self.chico.detection = presets.detection.gang_member
	self.chico.move_speed = presets.move_speed.gang_member
	self.chico.crouch_move = false
	self.chico.speech_prefix = "rb17"
	self.chico.weapon_voice = "3"
	self.chico.access = "teamAI1"
	self.chico.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_max(presets)
	self.max = {}
	self.max.always_face_enemy = true
	self.max.no_run_start = true
	self.max.no_run_stop = true
	self.max.damage = presets.gang_member_damage
	self.max.weapon = deep_clone(presets.weapon.gang_member)
	self.max.weapon.weapons_of_choice = {
		primary = "wpn_fps_ass_akm_gold_npc",
		secondary = Idstring("units/payday2/weapons/wpn_npc_beretta92/wpn_npc_beretta92")
	}
	self.max.detection = presets.detection.gang_member
	self.max.move_speed = presets.move_speed.gang_member
	self.max.crouch_move = false
	self.max.speech_prefix = "rb18"
	self.max.weapon_voice = "3"
	self.max.access = "teamAI1"
	self.max.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_myh(presets)
	self.myh = {}
	self.myh.always_face_enemy = true
	self.myh.no_run_start = true
	self.myh.no_run_stop = true
	self.myh.flammable = false
	self.myh.damage = presets.gang_member_damage
	self.myh.weapon = deep_clone(presets.weapon.gang_member)
	self.myh.weapon.weapons_of_choice = {
		primary = "wpn_fps_ass_74_npc",
		secondary = Idstring("units/payday2/weapons/wpn_npc_beretta92/wpn_npc_beretta92")
	}
	self.myh.detection = presets.detection.gang_member
	self.myh.move_speed = presets.move_speed.gang_member
	self.myh.crouch_move = false
	self.myh.speech_prefix = "rb2"
	self.myh.weapon_voice = "1"
	self.myh.access = "teamAI1"
	self.myh.dodge = presets.dodge.athletic
	self.myh.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_ecp(presets)
	self.ecp_female = {
		damage = presets.gang_member_damage,
		weapon = deep_clone(presets.weapon.gang_member)
	}
	self.ecp_female.weapon.weapons_of_choice = {
		primary = "wpn_fps_ass_m4_npc",
		secondary = Idstring("units/payday2/weapons/wpn_npc_mac11/wpn_npc_mac11")
	}
	self.ecp_female.always_face_enemy = true
	self.ecp_female.no_run_start = true
	self.ecp_female.no_run_stop = true
	self.ecp_female.flammable = false	
	self.ecp_female.detection = presets.detection.gang_member
	self.ecp_female.move_speed = presets.move_speed.gang_member
	self.ecp_female.crouch_move = false
	self.ecp_female.speech_prefix = "rb21"
	self.ecp_female.weapon_voice = "3"
	self.ecp_female.access = "teamAI1"
	self.ecp_female.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
	self.ecp_male = {
		damage = presets.gang_member_damage,
		weapon = deep_clone(presets.weapon.gang_member)
	}
	self.ecp_male.weapon.weapons_of_choice = {
		primary = "wpn_fps_ass_m4_npc",
		secondary = Idstring("units/payday2/weapons/wpn_npc_mac11/wpn_npc_mac11")
	}
	self.ecp_male.always_face_enemy = true
	self.ecp_male.no_run_start = true
	self.ecp_male.no_run_stop = true
	self.ecp_male.flammable = false		
	self.ecp_male.detection = presets.detection.gang_member
	self.ecp_male.move_speed = presets.move_speed.gang_member
	self.ecp_male.crouch_move = false
	self.ecp_male.speech_prefix = "rb20"
	self.ecp_male.weapon_voice = "3"
	self.ecp_male.access = "teamAI1"
	self.ecp_male.arrest = {
		timeout = 240,
		aggression_timeout = 6,
		arrest_timeout = 240
	}
end

function CharacterTweakData:_init_deathvox(presets)
	self.deathvox_guard = deep_clone(self.security)
	self.deathvox_guard.detection = presets.detection.guard
	self.deathvox_guard.suppression = nil -- presets.suppression.no_supress
	self.deathvox_guard.surrender = presets.surrender.easy
	self.deathvox_guard.move_speed = presets.move_speed.very_fast -- tentative.
	self.deathvox_guard.ecm_vulnerability = 0 -- DV guards ignore feedback. Removing safety net in stealth.
	
	self.deathvox_guard.dodge = presets.dodge.deathvox_guard
	self.deathvox_guard.deathguard = true -- unlikely to be relevant usually, but adds slight safety window during pathing step.
	self.deathvox_guard.no_arrest = true -- removing the arrest loophole.
	self.deathvox_guard.factory_weapon_id = {"wpn_deathvox_guard_pistol"}
	self.deathvox_guard.use_factory = true
	self.deathvox_guard.HEALTH_INIT = 7
	self.deathvox_guard.headshot_dmg_mul = 3
	self.deathvox_guard.weapon = deep_clone(presets.weapon.deathvox)
	self.deathvox_guard.access = "any"
	table.insert(self._enemy_list, "deathvox_guard")
	
	self.deathvox_lightar = deep_clone(self.city_swat)
	self.deathvox_lightar.detection = presets.detection.normal
	self.deathvox_lightar.suppression = presets.suppression.hard_agg
	self.deathvox_lightar.surrender = presets.surrender.normal -- hard for heavy, normal for light.
	self.deathvox_lightar.move_speed = presets.move_speed.very_fast
	self.deathvox_lightar.surrender_break_time = {6, 8}
	self.deathvox_lightar.ecm_vulnerability = 1
	self.deathvox_lightar.ecm_hurts = {
		ears = {min_duration = 6, max_duration = 8}
	}
	self.deathvox_lightar.dodge = presets.dodge.deathvoxninja
	self.deathvox_lightar.deathguard = true
	self.deathvox_lightar.no_arrest = true
	self.deathvox_lightar.steal_loot = true
	self.deathvox_lightar.rescue_hostages = true
	self.deathvox_lightar.weapon = deep_clone(presets.weapon.deathvox)
	self.deathvox_lightar.factory_weapon_id = {"wpn_deathvox_light_ar"}
	self.deathvox_lightar.use_factory = true
	self.deathvox_lightar.HEALTH_INIT = 22
	self.deathvox_lightar.headshot_dmg_mul = 3
	self.deathvox_lightar.access = "any"
	table.insert(self._enemy_list, "deathvox_lightar")
	
	self.deathvox_heavyar = deep_clone(self.city_swat)
	self.deathvox_heavyar.detection = presets.detection.normal
	self.deathvox_heavyar.damage.hurt_severity = presets.hurt_severities.light_hurt_fire_poison -- revised per feedback.
	self.deathvox_heavyar.suppression = presets.suppression.hard_agg -- tentative.
	self.deathvox_heavyar.surrender = presets.surrender.hard --tentative.
	self.deathvox_heavyar.move_speed = presets.move_speed.very_fast
	self.deathvox_heavyar.surrender_break_time = {6, 8}
	self.deathvox_heavyar.ecm_vulnerability = 1
	self.deathvox_heavyar.ecm_hurts = {
		ears = {min_duration = 6, max_duration = 8}
	}
	self.deathvox_heavyar.dodge = presets.dodge.deathvox
	self.deathvox_heavyar.deathguard = true
	self.deathvox_heavyar.no_arrest = true
	self.deathvox_heavyar.steal_loot = true
	self.deathvox_heavyar.rescue_hostages = true
	self.deathvox_heavyar.weapon = deep_clone(presets.weapon.deathvox)
	self.deathvox_heavyar.factory_weapon_id = {"wpn_deathvox_heavy_ar"}
	self.deathvox_heavyar.use_factory = true
	self.deathvox_heavyar.HEALTH_INIT = 35 -- new with final 2017 pass.
	self.deathvox_heavyar.headshot_dmg_mul = 3
	self.deathvox_heavyar.damage.explosion_damage_mul = 0.7
	self.deathvox_heavyar.access = "any"
	table.insert(self._enemy_list, "deathvox_heavyar")
	
	self.deathvox_lightshot = deep_clone(self.city_swat)
	self.deathvox_lightshot.detection = presets.detection.normal
	self.deathvox_lightshot.suppression = presets.suppression.hard_agg -- tentative.
	self.deathvox_lightshot.surrender = presets.surrender.normal -- tentative.
	self.deathvox_lightshot.move_speed = presets.move_speed.very_fast
	self.deathvox_lightshot.surrender_break_time = {6, 8} 
	self.deathvox_lightshot.ecm_vulnerability = 1
	self.deathvox_lightshot.ecm_hurts = {
		ears = {min_duration = 6, max_duration = 8}
	}
	self.deathvox_lightshot.dodge = presets.dodge.deathvoxninja
	self.deathvox_lightshot.deathguard = true
	self.deathvox_lightshot.no_arrest = true
	self.deathvox_lightshot.steal_loot = true
	self.deathvox_lightshot.rescue_hostages = true
	self.deathvox_lightshot.weapon = deep_clone(presets.weapon.deathvox)
	self.deathvox_lightshot.factory_weapon_id = {"wpn_deathvox_shotgun_light"}
	self.deathvox_lightshot.use_factory = true
	self.deathvox_lightshot.HEALTH_INIT = 22
	self.deathvox_lightshot.headshot_dmg_mul = 3
	self.deathvox_lightshot.access = "any"
	table.insert(self._enemy_list, "deathvox_lightshot")
	
	self.deathvox_heavyshot = deep_clone(self.city_swat)
	self.deathvox_heavyshot.detection = presets.detection.normal
	self.deathvox_heavyshot.damage.hurt_severity = presets.hurt_severities.light_hurt_fire_poison -- revised per feedback.
	self.deathvox_heavyshot.suppression = presets.suppression.hard_agg -- tentative.
	self.deathvox_heavyshot.surrender = presets.surrender.hard -- tentative.
	self.deathvox_heavyshot.move_speed = presets.move_speed.very_fast
	self.deathvox_heavyshot.surrender_break_time = {6, 8} 
	self.deathvox_heavyshot.ecm_vulnerability = 1
	self.deathvox_heavyshot.ecm_hurts = {
		ears = {min_duration = 6, max_duration = 8}
	}
	self.deathvox_heavyshot.dodge = presets.dodge.deathvox
	self.deathvox_heavyshot.deathguard = true
	self.deathvox_heavyshot.no_arrest = true
	self.deathvox_heavyshot.steal_loot = true
	self.deathvox_heavyshot.rescue_hostages = true
	self.deathvox_heavyshot.weapon = deep_clone(presets.weapon.deathvox)
	self.deathvox_heavyshot.factory_weapon_id = {"wpn_deathvox_shotgun_heavy"}
	self.deathvox_heavyshot.use_factory = true
	self.deathvox_heavyshot.HEALTH_INIT = 35 -- new with final 2017 pass.
	self.deathvox_heavyshot.headshot_dmg_mul = 3
	self.deathvox_heavyshot.damage.explosion_damage_mul = 0.7
	self.deathvox_heavyshot.access = "any"
	table.insert(self._enemy_list, "deathvox_heavyshot")
	
	self.deathvox_shield = deep_clone(self.shield)
	self.deathvox_shield.tags = {"shield"} -- just to be sure it's being applied.
	self.deathvox_shield.detection = presets.detection.normal
	self.deathvox_shield.damage.hurt_severity = presets.hurt_severities.only_explosion_hurts
	self.deathvox_shield.suppression = presets.suppression.no_supress -- I think this is in resto, if not it now is.
	self.deathvox_shield.surrender = nil
	self.deathvox_shield.move_speed = presets.move_speed.very_fast -- same as base.
	self.deathvox_shield.ecm_vulnerability = .9 -- same as base.
	self.deathvox_shield.ecm_hurts = {
		ears = {min_duration = 6, max_duration = 8} -- same as general enemies, less than vanilla.
	}
	self.deathvox_shield.deathguard = false
	self.deathvox_shield.no_arrest = true
	self.deathvox_shield.steal_loot = true -- this is new.
	self.deathvox_shield.rescue_hostages = false
	self.deathvox_shield.weapon = deep_clone(presets.weapon.deathvox)
	self.deathvox_shield.HEALTH_INIT = 22
	self.deathvox_shield.headshot_dmg_mul = 3
	self.deathvox_shield.is_special_unit = "shield"	
	self.deathvox_shield.access = "any"
	table.insert(self._enemy_list, "deathvox_shield")
	
	self.deathvox_medic = deep_clone(self.medic)
	self.deathvox_medic.tags = {"medic"} --just making sure tag applies.
	self.deathvox_medic.detection = presets.detection.normal
	self.deathvox_medic.damage.hurt_severity = presets.hurt_severities.only_fire_and_poison_hurts -- added to make code consistent.
	self.deathvox_medic.suppression = presets.suppression.no_supress -- in base.
	self.deathvox_medic.surrender = nil -- correcting surrender bug.
	self.deathvox_medic.move_speed = presets.move_speed.very_fast
	self.deathvox_medic.surrender_break_time = {7, 12} 
	self.deathvox_medic.ecm_vulnerability = 1
	self.deathvox_medic.ecm_hurts = {
		ears = {min_duration = 8, max_duration = 10}
	}
	self.deathvox_medic.dodge = presets.dodge.deathvox
	self.deathvox_medic.deathguard = false
	self.deathvox_medic.no_arrest = true 
	self.deathvox_medic.steal_loot = nil
	self.deathvox_medic.rescue_hostages = false
	self.deathvox_medic.weapon = deep_clone(presets.weapon.deathvox)
	self.deathvox_medic.use_factory = true
	self.deathvox_medic.dv_medic_heal = true -- dont touch, makes him use the death vox healing
	self.deathvox_medic.factory_weapon_id = {"wpn_deathvox_medic_pistol"}
	self.deathvox_medic.HEALTH_INIT = 52
	self.deathvox_medic.headshot_dmg_mul = 3
	self.deathvox_medic.is_special_unit = "medic"
	self.deathvox_medic.access = "any"
	table.insert(self._enemy_list, "deathvox_medic") 

	self.deathvox_taser = deep_clone(self.taser)
	self.deathvox_taser.tags = {"taser"} -- just making sure tag applies.
	self.deathvox_taser.detection = presets.detection.normal
	self.deathvox_taser.damage.hurt_severity = presets.hurt_severities.only_light_hurt_and_fire
	self.deathvox_taser.damage.hurt_severity.tase = false -- if this works, great, horrible things will arise.
	self.deathvox_taser.suppression = presets.suppression.no_supress -- consistent form added.
	self.deathvox_taser.surrender = nil -- correcting surrender bug.
	self.deathvox_taser.move_speed = presets.move_speed.fast
	self.deathvox_taser.surrender_break_time = {7, 12} 
	self.deathvox_taser.ecm_vulnerability = 0.9 -- in base
	self.deathvox_taser.ecm_hurts = {
		ears = {min_duration = 6, max_duration = 8} -- in base
	}
	self.deathvox_taser.dodge = presets.dodge.deathvox
	self.deathvox_taser.deathguard = true 
	self.deathvox_taser.no_arrest = true
	self.deathvox_taser.steal_loot = nil
	self.deathvox_taser.rescue_hostages = false
	self.deathvox_taser.HEALTH_INIT = 63 -- new with final 2017 pass.
	self.deathvox_taser.headshot_dmg_mul = 3
	self.deathvox_taser.is_special_unit = "taser"
	self.deathvox_taser.access = "any"
	table.insert(self._enemy_list, "deathvox_taser") 

	self.deathvox_cloaker = deep_clone(self.spooc)
	self.deathvox_cloaker.tags = {"spooc"} -- just making sure tag applies.
	self.deathvox_cloaker.detection = presets.detection.normal
	self.deathvox_cloaker.suppression = nil
	self.deathvox_cloaker.surrender = nil
	self.deathvox_cloaker.move_speed = presets.move_speed.lightning
	self.deathvox_cloaker.HEALTH_INIT = 105
	self.deathvox_cloaker.headshot_dmg_mul = 3
	self.deathvox_cloaker.surrender_break_time = {4, 6} 
	self.deathvox_cloaker.ecm_vulnerability = 0
	self.deathvox_cloaker.dodge = presets.dodge.deathvoxninja
	self.deathvox_cloaker.deathguard = true 
	self.deathvox_cloaker.no_arrest = true
	self.deathvox_cloaker.steal_loot = nil
	self.deathvox_cloaker.rescue_hostages = false
	self.deathvox_cloaker.factory_weapon_id = {"wpn_deathvox_cloaker"}
	self.deathvox_cloaker.use_factory = true
	self.deathvox_cloaker.is_special_unit = "spooc"
	self.deathvox_cloaker.access = "any"
	self.deathvox_cloaker.use_pdth_shit = true

	table.insert(self._enemy_list, "deathvox_cloaker") 

	self.deathvox_sniper = deep_clone(self.sniper)
	self.deathvox_sniper.tags = {"sniper"} -- just making sure tag applies.
	self.deathvox_sniper.detection = presets.detection.normal
	self.deathvox_sniper.suppression = presets.suppression.no_supress -- this actually makes snipers way less annoying!
	self.deathvox_sniper.surrender = nil -- correcting surrender bug.
	self.deathvox_sniper.move_speed = presets.move_speed.normal -- same as base.
	self.deathvox_sniper.surrender_break_time = {4, 6} 
	self.deathvox_sniper.ecm_vulnerability = 0
	self.deathvox_sniper.no_arrest = true
	self.deathvox_sniper.steal_loot = nil
	self.deathvox_sniper.rescue_hostages = false

	self.deathvox_sniper.use_factory = true -- Use a factory weapon
	self.deathvox_sniper.factory_weapon_id = {"wpn_deathvox_sniper"}
	self.deathvox_sniper.HEALTH_INIT = 9 -- note does not match assault, consider revise.
	self.deathvox_sniper.headshot_dmg_mul = 3
	self.deathvox_sniper.is_special_unit = "sniper"
	self.deathvox_sniper.access = "any"

	self.deathvox_sniper_assault = deep_clone(self.deathvox_sniper)
	self.deathvox_sniper_assault.move_speed = presets.move_speed.very_fast
	self.deathvox_sniper_assault.deathguard = true
	self.deathvox_sniper_assault.HEALTH_INIT = 22
	self.deathvox_sniper_assault.headshot_dmg_mul = 3
	self.deathvox_sniper_assault.is_special_unit = "ass_sniper"
	self.deathvox_sniper_assault.access = "any"
	table.insert(self._enemy_list, "deathvox_sniper_assault")

	self.deathvox_tank = deep_clone(self.tank)
	self.deathvox_tank.tags = {"tank"} -- just making sure tag applies.
	self.deathvox_tank.detection = presets.detection.normal
	self.deathvox_tank.damage.hurt_severity = presets.hurt_severities.no_hurts_no_tase -- new with final 2017 pass. Probably not a change, needs to stay.
	self.deathvox_tank.suppression = presets.suppression.no_supress
	self.deathvox_tank.surrender = nil
	self.deathvox_tank.surrender_break_time = {4, 6}
	self.deathvox_tank.ecm_vulnerability = 0.85
	self.deathvox_tank.ecm_hurts = {
        ears = {min_duration = 1, max_duration = 3} -- tentative, in base
    }
	self.deathvox_tank.deathguard = true
	self.deathvox_tank.no_arrest = true
	self.deathvox_tank.steal_loot = nil
	self.deathvox_tank.rescue_hostages = false
	self.deathvox_tank.HEALTH_INIT = 875
	self.deathvox_tank.damage.explosion_damage_mul = 0.5  -- new with final 2017 pass. Requires scrutiny.
	self.deathvox_tank.is_special_unit = "tank"
	self.deathvox_tank.access = "walk"

    self.deathvox_greendozer = deep_clone(self.deathvox_tank)
	self.deathvox_greendozer.use_factory = true -- Use a factory weapon
	self.deathvox_greendozer.factory_weapon_id = {"wpn_deathvox_greendozer"} 
	self.deathvox_greendozer.access = "tank"
	table.insert(self._enemy_list, "deathvox_greendozer")

    self.deathvox_blackdozer = deep_clone(self.deathvox_tank)
	self.deathvox_blackdozer.use_factory = true -- Use a factory weapon
	self.deathvox_blackdozer.factory_weapon_id = {"wpn_deathvox_blackdozer"} 
	self.deathvox_blackdozer.access = "walk"
	table.insert(self._enemy_list, "deathvox_blackdozer")

    self.deathvox_lmgdozer = deep_clone(self.deathvox_tank)
	self.deathvox_lmgdozer.use_factory = true -- Use a factory weapon
	self.deathvox_lmgdozer.factory_weapon_id = {"wpn_deathvox_lmgdozer"} 
	self.deathvox_lmgdozer.access = "walk"
	table.insert(self._enemy_list, "deathvox_lmgdozer")
	
    self.deathvox_medicdozer = deep_clone(self.deathvox_tank)
	self.deathvox_medicdozer.tags = {"tank", "medic"}
	self.deathvox_medicdozer.use_factory = true -- Use a factory weapon
	self.deathvox_medicdozer.factory_weapon_id = {"wpn_deathvox_medicdozer_smg"} 
	self.deathvox_medicdozer.dv_medic_heal = true -- dont touch, makes him use the death vox healing
	self.deathvox_medicdozer.custom_voicework = "medicdozer"
	self.deathvox_medicdozer.access = "walk"
	self.deathvox_medicdozer.disable_medic_heal_voice = true
	table.insert(self._enemy_list, "deathvox_medicdozer")

	self.deathvox_grenadier = deep_clone(self.boom)
	self.deathvox_grenadier.tags = {"custom"}
	self.deathvox_grenadier.experience = {}
	self.deathvox_grenadier.weapon = deep_clone(presets.weapon.normal)
	self.deathvox_grenadier.melee_weapon = "knife_1"
	self.deathvox_grenadier.melee_weapon_dmg_multiplier = 1
	self.deathvox_grenadier.weapon_safety_range = 1000
	self.deathvox_grenadier.detection = presets.detection.normal
	self.deathvox_grenadier.damage.hurt_severity = presets.hurt_severities.only_light_hurt_and_fire -- immune to poison. new with final 2017 pass.
	self.deathvox_grenadier.HEALTH_INIT = 63
	self.deathvox_grenadier.HEALTH_SUICIDE_LIMIT = 0.25
	self.deathvox_grenadier.flammable = true
	self.deathvox_grenadier.use_animation_on_fire_damage = true
	self.deathvox_grenadier.damage.fire_damage_mul = 1
	self.deathvox_grenadier.headshot_dmg_mul = 3
	self.deathvox_grenadier.bag_dmg_mul = 6
	self.deathvox_grenadier.move_speed = presets.move_speed.fast
	self.deathvox_grenadier.no_retreat = true
	self.deathvox_grenadier.no_arrest = true
	self.deathvox_grenadier.surrender = nil
	self.deathvox_grenadier.ecm_vulnerability = 0.9
	self.deathvox_grenadier.ecm_hurts = {
		ears = {min_duration = 6, max_duration = 8}
	}
	self.deathvox_grenadier.surrender_break_time = {4, 6}
	self.deathvox_grenadier.suppression = nil
	self.deathvox_grenadier.weapon_voice = "3"
	self.deathvox_grenadier.experience.cable_tie = "tie_swat"
	self.deathvox_grenadier.access = "any"
	self.deathvox_grenadier.dodge = presets.dodge.athletic
	self.deathvox_grenadier.use_gas = true
	self.deathvox_grenadier.priority_shout = "g29"
	self.deathvox_grenadier.bot_priority_shout = "g29"
	self.deathvox_grenadier.priority_shout_max_dis = 3000
	self.deathvox_grenadier.custom_shout = true
	self.deathvox_grenadier.rescue_hostages = false
	self.deathvox_grenadier.deathguard = true
	self.deathvox_grenadier.chatter = {
		aggressive = true,
		retreat = true,
		go_go = true,
		contact = true,
		entrance = true
	}
	self.deathvox_grenadier.announce_incomming = "incomming_gren"
	self.deathvox_grenadier.spawn_sound_event = "clk_c01x_plu"
	self.deathvox_grenadier.die_sound_event = "rmdc_x02a_any_3p"
	self.deathvox_grenadier.steal_loot = nil
	self.deathvox_grenadier.use_factory = true -- Use a factory weapon
	self.deathvox_grenadier.factory_weapon_id = {"wpn_deathvox_grenadier"} 
	self.deathvox_grenadier.is_special_unit = "boom"
	self.deathvox_grenadier.custom_voicework = "grenadier"
 	table.insert(self._enemy_list, "deathvox_grenadier")
	
end



function CharacterTweakData:_presets(tweak_data)
	local presets = {}
	presets.hurt_severities = {}
	presets.hurt_severities.no_hurts = {
		bullet = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		explosion = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		melee = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		fire = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		poison = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		tase = false
	}
	presets.hurt_severities.titan = deep_clone(presets.hurt_severities.no_hurts)
	presets.hurt_severities.titan.bullet = {
			health_reference = "current",
			zones = {
				{
					health_limit = 0.3,
					none = 0.2,
					light = 0.75,
					explode = 0.05,
					heavy = 0
				},
				{
					health_limit = 0.6,
					light = 0.7,
					explode = 0.15,
					heavy = 0
				},
				{
					health_limit = 0.9,
					light = 0.6,
					explode = 0.2,
					heavy = 0
				},
				{
					light = 0.5,
					explode = 0.25,
					heavy = 0
				}
			}
	}
	presets.hurt_severities.titan.fire = {
			health_reference = "current",
			zones = {
				{fire = 1}
			}
	}
	presets.hurt_severities.titan.explosion = {
			health_reference = "current",
			zones = {
				{
					health_limit = 0.3,
					none = 0.2,
					light = 0.75,
					explode = 0.05,
					heavy = 0
				},
				{
					health_limit = 0.6,
					light = 0.7,
					explode = 0.3,
					heavy = 0
				},
				{
					health_limit = 0.9,
					light = 0.6,
					explode = 0.4,
					heavy = 0
				},
				{
					light = 0.5,
					explode = 0.5,
					heavy = 0
				}
			}
	}
	presets.hurt_severities.captain = deep_clone(presets.hurt_severities.titan)
	presets.hurt_severities.no_hurts_no_tase = deep_clone(presets.hurt_severities.no_hurts)
	presets.hurt_severities.no_hurts_no_tase.tase = false
	presets.hurt_severities.only_light_hurt = {
		bullet = {
			health_reference = 1,
			zones = {
				{light = 1}
			}
		},
		explosion = {
			health_reference = 1,
			zones = {
				{explode = 1}
			}
		},
		melee = {
			health_reference = 1,
			zones = {
				{light = 1}
			}
		},
		fire = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		poison = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		tase = true
	}
	presets.hurt_severities.only_light_hurt_and_fire = {
		bullet = {
			health_reference = 1,
			zones = {
				{light = 1}
			}
		},
		explosion = {
			health_reference = 1,
			zones = {
				{explode = 1}
			}
		},
		melee = {
			health_reference = 1,
			zones = {
				{light = 1}
			}
		},
		fire = {
			health_reference = 1,
			zones = {
				{fire = 1}
			}
		},
		poison = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		tase = true
	}
	presets.hurt_severities.light_hurt_fire_poison = deep_clone(presets.hurt_severities.only_light_hurt_and_fire)
	presets.hurt_severities.light_hurt_fire_poison.poison = {
		health_reference = 1,
		zones = {
			{poison = 1}
		}
	}
	presets.hurt_severities.elite = deep_clone(presets.hurt_severities.light_hurt_fire_poison)
	presets.hurt_severities.elite.fire = {
		health_reference = 1,
		zones = {
			{none = 1}
		}
	}
	presets.hurt_severities.elite.melee = {
		health_reference = "current",
		zones = {
			{
				health_limit = 0.3,
				none = 0.3,
				light = 0.7,
				moderate = 0,
				heavy = 0
			},
			{
				health_limit = 0.8,
				light = 1,
				moderate = 0,
				heavy = 0
			},
			{
				health_limit = 0.9,
				light = 0.8,
				moderate = 0.2,
				heavy = 0
			},
			{
				light = 0,
				moderate = 9,
				heavy = 0
			}
		}
	}
	presets.hurt_severities.only_explosion_hurts = {
		bullet = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		explosion = {
			health_reference = 1,
			zones = {
				{explode = 1}
			}
		},
		melee = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		fire = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		poison = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		tase = true
	}
	presets.hurt_severities.only_fire_and_poison_hurts = {
		bullet = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		explosion = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		melee = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		fire = {
			health_reference = 1,
			zones = {
				{none = 1}
			}
		},
		poison = {
			health_reference = 1,
			zones = {
				{poison = 1}
			}
		},
		tase = true
	}
	presets.hurt_severities.base = {
		bullet = {
			health_reference = "current",
			zones = {
				{
					health_limit = 0.3,
					none = 0.2,
					light = 0.7,
					moderate = 0.05,
					heavy = 0.05
				},
				{
					health_limit = 0.6,
					light = 0.4,
					moderate = 0.4,
					heavy = 0.2
				},
				{
					health_limit = 0.9,
					light = 0.2,
					moderate = 0.2,
					heavy = 0.6
				},
				{
					light = 0,
					moderate = 0,
					heavy = 1
				}
			}
		},
		explosion = {
			health_reference = "current",
			zones = {
				{
					health_limit = 0.2,
					none = 0.6,
					heavy = 0.4
				},
				{
					health_limit = 0.5,
					heavy = 0.6,
					explode = 0.4
				},
				{heavy = 0.2, explode = 0.8}
			}
		},
		melee = {
			health_reference = "current",
			zones = {
				{
					health_limit = 0.3,
					none = 0.3,
					light = 0.7,
					moderate = 0,
					heavy = 0
				},
				{
					health_limit = 0.8,
					light = 1,
					moderate = 0,
					heavy = 0
				},
				{
					health_limit = 0.9,
					light = 0.6,
					moderate = 0.2,
					heavy = 0.2
				},
				{
					light = 0,
					moderate = 0,
					heavy = 9
				}
			}
		},
		fire = {
			health_reference = "current",
			zones = {
				{fire = 1}
			}
		},
		poison = {
			health_reference = "current",
			zones = {
				{none = 0, poison = 1}
			}
		}
	}
	presets.hurt_severities.spooc = deep_clone(presets.hurt_severities.base)
	presets.hurt_severities.boom = deep_clone(presets.hurt_severities.base)
	presets.hurt_severities.boom.explosion = {
		health_reference = 1,
		zones = {
			{none = 1}
		}
	}
	presets.hurt_severities.base_no_poison = deep_clone(presets.hurt_severities.base)
	presets.hurt_severities.base_no_poison.poison = {
		health_reference = 1,
		zones = {
			{none = 1}
		}
	}
	presets.base = {}
	presets.base.HEALTH_INIT = 2.5
	presets.base.headshot_dmg_mul = 2
	presets.base.use_animation_on_fire_damage = true
	presets.base.SPEED_WALK = {
		ntl = 120,
		hos = 180,
		cbt = 160,
		pnc = 160
	}
	presets.base.SPEED_RUN = 370
	presets.base.crouch_move = true
	presets.base.shooting_death = true
	presets.base.suspicious = true
	presets.base.surrender_break_time = {20, 30}
	presets.base.submission_max = {45, 60}
	presets.base.submission_intimidate = 15
	presets.base.speech_prefix = "po"
	presets.base.speech_prefix_count = 1
	presets.base.rescue_hostages = true
	presets.base.use_radio = self._default_chatter
	presets.base.dodge = nil
	presets.base.challenges = {type = "law"}
	presets.base.calls_in = true
	presets.base.ignore_medic_revive_animation = false
	presets.base.spotlight_important = false
	presets.base.follower = true
	presets.base.experience = {}
	presets.base.experience.cable_tie = "tie_swat"
	presets.base.damage = {}
	presets.base.damage.hurt_severity = presets.hurt_severities.base
	presets.base.damage.death_severity = 0.5
	presets.base.damage.explosion_damage_mul = 1
	presets.base.critical_hits = {
		damage_mul = 2
	}
	presets.base.damage.tased_response = {
		light = {tased_time = 5, down_time = 5},
		heavy = {tased_time = 5, down_time = 10}
	}
	presets.base.static_weapon_preset = false
	presets.base.static_dodge_preset = false
	presets.base.static_melee_preset = false
	presets.gang_member_damage = {}
	presets.gang_member_damage.HEALTH_INIT = 25
	presets.gang_member_damage.no_run_start = true
	presets.gang_member_damage.no_run_stop = true
	presets.gang_member_damage.headshot_dmg_mul = 1
	presets.gang_member_damage.LIVES_INIT = 4
	presets.gang_member_damage.explosion_damage_mul = 0
	presets.gang_member_damage.REGENERATE_TIME = 2
	presets.gang_member_damage.REGENERATE_TIME_AWAY = 0.25
	presets.gang_member_damage.DOWNED_TIME = tweak_data.player.damage.DOWNED_TIME
	presets.gang_member_damage.TASED_TIME = tweak_data.player.damage.TASED_TIME
	presets.gang_member_damage.BLEED_OUT_HEALTH_INIT = 25
	presets.gang_member_damage.ARRESTED_TIME = tweak_data.player.damage.ARRESTED_TIME
	presets.gang_member_damage.INCAPACITATED_TIME = tweak_data.player.damage.INCAPACITATED_TIME
	presets.gang_member_damage.hurt_severity = deep_clone(presets.hurt_severities.no_hurts)
	presets.gang_member_damage.MIN_DAMAGE_INTERVAL = 0.6
	presets.gang_member_damage.respawn_time_penalty = 0
	presets.gang_member_damage.base_respawn_time_penalty = 5
	presets.weapon = {}
	presets.weapon.normal = {
		is_pistol = {},
		is_revolver = {},
		is_rifle = {},
		is_lmg = {},
		is_shotgun_pump = {},
		is_shotgun_mag = {},
		mossberg = {},
		is_smg = {},
		mp9 = {},
		mac11 = {},
		is_revolver = {},
		akimbo_pistol = {},
		mini = {},
		flamethrower = {}
	}
	presets.weapon.normal.is_pistol.aim_delay = {0.1, 0.1}
	presets.weapon.normal.is_pistol.focus_delay = 10
	presets.weapon.normal.is_pistol.focus_dis = 200
	presets.weapon.normal.is_pistol.spread = 20
	presets.weapon.normal.is_pistol.miss_dis = 50
	presets.weapon.normal.is_pistol.RELOAD_SPEED = 1
	presets.weapon.normal.is_pistol.melee_speed = 1
	presets.weapon.normal.is_pistol.melee_dmg = 5
	presets.weapon.normal.is_pistol.melee_retry_delay = {0.68, 0.68}
	presets.weapon.normal.is_pistol.range = {
		close = 1000,
		optimal = 2000,
		far = 5000
	}
	presets.weapon.normal.is_pistol.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 1,
			recoil = {0.15, 0.25},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 500,
			acc = {0.4, 0.85},
			dmg_mul = 1,
			recoil = {0.15, 0.25},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1000,
			acc = {0.375, 0.55},
			dmg_mul = 1,
			recoil = {0.15, 0.3},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2000,
			acc = {0.25, 0.45},
			dmg_mul = 1,
			recoil = {0.3, 0.7},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 3000,
			acc = {0.01, 0.35},
			dmg_mul = 1,
			recoil = {0.4, 1},
			mode = {
				1,
				0,
				0,
				0
			}
		}
	}
	presets.weapon.normal.akimbo_pistol = presets.weapon.normal.is_pistol
	presets.weapon.normal.is_rifle.aim_delay = {0.1, 0.1}
	presets.weapon.normal.is_rifle.focus_delay = 10
	presets.weapon.normal.is_rifle.focus_dis = 200
	presets.weapon.normal.is_rifle.spread = 20
	presets.weapon.normal.is_rifle.miss_dis = 40
	presets.weapon.normal.is_rifle.RELOAD_SPEED = 1
	presets.weapon.normal.is_rifle.melee_speed = 1
	presets.weapon.normal.is_rifle.melee_dmg = 5
	presets.weapon.normal.is_rifle.tase_distance = 1400
	presets.weapon.normal.is_rifle.aim_delay_tase = {0, 0.5}
	presets.weapon.normal.is_rifle.tase_sphere_cast_radius = 30
	presets.weapon.normal.is_rifle.melee_retry_delay = {0.68, 0.68}
	presets.weapon.normal.is_rifle.range = {
		close = 1000,
		optimal = 2000,
		far = 5000
	}
	presets.weapon.normal.is_rifle.autofire_rounds = {6, 11}
	presets.weapon.normal.is_rifle.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 1,
			recoil = {0.4, 0.8},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 500,
			acc = {0.4, 0.9},
			dmg_mul = 1,
			recoil = {0.45, 0.8},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 1000,
			acc = {0.2, 0.8},
			dmg_mul = 1,
			recoil = {0.35, 0.75},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 2000,
			acc = {0.2, 0.5},
			dmg_mul = 1,
			recoil = {0.4, 1.2},
			mode = {
				3,
				2,
				2,
				0
			}
		},
		{
			r = 3000,
			acc = {0.01, 0.35},
			dmg_mul = 1,
			recoil = {1.5, 3},
			mode = {
				3,
				1,
				1,
				0
			}
		}
	}
	presets.weapon.normal.is_bullpup = presets.weapon.normal.is_rifle
	presets.weapon.normal.is_shotgun_pump.aim_delay = {0.1, 0.1}
	presets.weapon.normal.is_shotgun_pump.focus_delay = 10
	presets.weapon.normal.is_shotgun_pump.focus_dis = 200
	presets.weapon.normal.is_shotgun_pump.spread = 15
	presets.weapon.normal.is_shotgun_pump.miss_dis = 20
	presets.weapon.normal.is_shotgun_pump.RELOAD_SPEED = 0.25
	presets.weapon.normal.is_shotgun_pump.melee_speed = 1
	presets.weapon.normal.is_shotgun_pump.melee_dmg = 5
	presets.weapon.normal.is_shotgun_pump.melee_retry_delay = {0.68, 0.68}
	presets.weapon.normal.is_shotgun_pump.range = {
		close = 1000,
		optimal = 2000,
		far = 5000
	}
	presets.weapon.normal.is_shotgun_pump.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 1,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 500,
			acc = {0.4, 0.9},
			dmg_mul = 0.95,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 600,
			acc = {0.4, 0.9},
			dmg_mul = 0.9,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 700,
			acc = {0.4, 0.9},
			dmg_mul = 0.85,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 800,
			acc = {0.4, 0.9},
			dmg_mul = 0.8,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 900,
			acc = {0.4, 0.9},
			dmg_mul = 0.75,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1000,
			acc = {0.4, 0.75},
			dmg_mul = 0.7,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1100,
			acc = {0.4, 0.75},
			dmg_mul = 0.65,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1200,
			acc = {0.4, 0.75},
			dmg_mul = 0.6,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1300,
			acc = {0.4, 0.75},
			dmg_mul = 0.55,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1400,
			acc = {0.4, 0.75},
			dmg_mul = 0.5,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1500,
			acc = {0.4, 0.75},
			dmg_mul = 0.45,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1600,
			acc = {0.1, 0.55},
			dmg_mul = 0.4,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1700,
			acc = {0.1, 0.55},
			dmg_mul = 0.35,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1800,
			acc = {0.1, 0.55},
			dmg_mul = 0.3,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1900,
			acc = {0.1, 0.55},
			dmg_mul = 0.25,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2000,
			acc = {0.1, 0.55},
			dmg_mul = 0.2,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2100,
			acc = {0.1, 0.55},
			dmg_mul = 0.15,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2200,
			acc = {0.1, 0.55},
			dmg_mul = 0.1,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2300,
			acc = {0.1, 0.55},
			dmg_mul = 0.05,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2400,
			acc = {0, 0},
			dmg_mul = 0,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		}
	}
	presets.weapon.normal.is_smg.aim_delay = {0.1, 0.1}
	presets.weapon.normal.is_smg.focus_delay = 10
	presets.weapon.normal.is_smg.focus_dis = 200
	presets.weapon.normal.is_smg.spread = 15
	presets.weapon.normal.is_smg.miss_dis = 20
	presets.weapon.normal.is_smg.RELOAD_SPEED = 1
	presets.weapon.normal.is_smg.melee_speed = 1
	presets.weapon.normal.is_smg.melee_dmg = 5
	presets.weapon.normal.is_smg.melee_retry_delay = {0.68, 0.68}
	presets.weapon.normal.is_smg.range = {
		close = 1000,
		optimal = 2000,
		far = 5000
	}
	presets.weapon.normal.is_smg.autofire_rounds = {6, 11}
	presets.weapon.normal.is_smg.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 1,
			recoil = {0.1, 0.3},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 500,
			acc = {0.4, 0.9},
			dmg_mul = 1,
			recoil = {0.1, 0.3},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 1000,
			acc = {0.2, 0.8},
			dmg_mul = 1,
			recoil = {0.3, 0.4},
			mode = {
				0,
				3,
				3,
				0
			}
		},
		{
			r = 2000,
			acc = {0.1, 0.45},
			dmg_mul = 1,
			recoil = {0.3, 0.4},
			mode = {
				0,
				3,
				3,
				0
			}
		},
		{
			r = 3000,
			acc = {0.1, 0.35},
			dmg_mul = 1,
			recoil = {0.5, 0.6},
			mode = {
				1,
				3,
				2,
				0
			}
		}
	}
	presets.weapon.normal.mp9.aim_delay = {0.1, 0.1}
	presets.weapon.normal.mp9.focus_delay = 20
	presets.weapon.normal.mp9.focus_dis = 200
	presets.weapon.normal.mp9.spread = 30
	presets.weapon.normal.mp9.miss_dis = 15
	presets.weapon.normal.mp9.RELOAD_SPEED = 1
	presets.weapon.normal.mp9.melee_speed = nil
	presets.weapon.normal.mp9.melee_dmg = nil
	presets.weapon.normal.mp9.melee_retry_delay = nil
	presets.weapon.normal.mp9.range = {
		close = 500,
		optimal = 1200,
		far = 3000
	}
	presets.weapon.normal.mp9.autofire_rounds = {6, 11}
	presets.weapon.normal.mp9.FALLOFF = {
		{
			r = 0,
			acc = {0.7, 0.95},
			dmg_mul = 1,
			recoil = {0.35, 0.55},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 700,
			acc = {0.5, 0.75},
			dmg_mul = 1,
			recoil = {0.35, 0.55},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 1000,
			acc = {0.45, 0.65},
			dmg_mul = 1,
			recoil = {1, 1.2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2000,
			acc = {0.3, 0.5},
			dmg_mul = 1,
			recoil = {1.2, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 3000,
			acc = {0.1, 0.25},
			dmg_mul = 1,
			recoil = {1.2, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		}
	}
	presets.weapon.normal.mac11.aim_delay = {0.1, 0.1}
	presets.weapon.normal.mac11.focus_delay = 10
	presets.weapon.normal.mac11.focus_dis = 200
	presets.weapon.normal.mac11.spread = 20
	presets.weapon.normal.mac11.miss_dis = 25
	presets.weapon.normal.mac11.RELOAD_SPEED = 1
	presets.weapon.normal.mac11.melee_speed = 1
	presets.weapon.normal.mac11.melee_dmg = 5
	presets.weapon.normal.mac11.melee_retry_delay = {0.68, 0.68}
	presets.weapon.normal.mac11.range = {
		close = 1000,
		optimal = 2000,
		far = 5000
	}
	presets.weapon.normal.mac11.autofire_rounds = {6, 11}
	presets.weapon.normal.mac11.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 1,
			recoil = {0.5, 0.65},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 500,
			acc = {0.1, 0.85},
			dmg_mul = 1,
			recoil = {0.5, 0.65},
			mode = {
				0,
				1,
				3,
				1
			}
		},
		{
			r = 1000,
			acc = {0.2, 0.5},
			dmg_mul = 1,
			recoil = {0.55, 0.85},
			mode = {
				2,
				1,
				3,
				0
			}
		},
		{
			r = 2000,
			acc = {0.05, 0.4},
			dmg_mul = 1,
			recoil = {0.65, 1},
			mode = {
				2,
				1,
				3,
				0
			}
		},
		{
			r = 3000,
			acc = {0, 0.2},
			dmg_mul = 1,
			recoil = {0.65, 1},
			mode = {
				2,
				1,
				3,
				0
			}
		}
	}
	presets.weapon.normal.is_revolver.aim_delay = {0.1, 0.1}
	presets.weapon.normal.is_revolver.focus_delay = 10
	presets.weapon.normal.is_revolver.focus_dis = 200
	presets.weapon.normal.is_revolver.spread = 20
	presets.weapon.normal.is_revolver.miss_dis = 50
	presets.weapon.normal.is_revolver.RELOAD_SPEED = 1
	presets.weapon.normal.is_revolver.melee_speed = 1
	presets.weapon.normal.is_revolver.melee_dmg = 5
	presets.weapon.normal.is_revolver.melee_retry_delay = {0.68, 0.68}
	presets.weapon.normal.is_revolver.range = {
		close = 1000,
		optimal = 2000,
		far = 5000
	}
	presets.weapon.normal.is_revolver.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 1,
			recoil = {0.8, 1},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 500,
			acc = {0.5, 0.85},
			dmg_mul = 1,
			recoil = {0.8, 1.1},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1000,
			acc = {0.375, 0.55},
			dmg_mul = 1,
			recoil = {0.8, 1.1},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2000,
			acc = {0.25, 0.45},
			dmg_mul = 1,
			recoil = {1, 1.3},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 3000,
			acc = {0.01, 0.35},
			dmg_mul = 1,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		}
	}
	presets.weapon.normal.is_lmg = deep_clone(presets.weapon.normal.is_rifle)
	presets.weapon.normal.is_lmg.RELOAD_SPEED = 0.5
	presets.weapon.normal.is_lmg.autofire_rounds = {20, 40}
	presets.weapon.normal.is_lmg.FALLOFF = {
		{
			r = 100,
			acc = {0.7, 0.9},
			dmg_mul = 1,
			recoil = {0.4, 0.7},
			mode = {
				0,
				0,
				0,
				1
			}
		},
		{
			r = 500,
			acc = {0.5, 0.75},
			dmg_mul = 1,
			recoil = {0.5, 0.8},
			mode = {
				0,
				0,
				0,
				6
			}
		},
		{
			r = 1000,
			acc = {0.3, 0.6},
			dmg_mul = 1,
			recoil = {1, 1},
			mode = {
				0,
				0,
				2,
				6
			}
		},
		{
			r = 2000,
			acc = {0.25, 0.55},
			dmg_mul = 1,
			recoil = {1, 1},
			mode = {
				0,
				0,
				2,
				6
			}
		},
		{
			r = 3000,
			acc = {0.15, 0.5},
			dmg_mul = 1,
			recoil = {1, 2},
			mode = {
				0,
				0,
				2,
				6
			}
		}
	}
	presets.weapon.normal.mossberg = deep_clone(presets.weapon.normal.is_shotgun_pump)
	presets.weapon.normal.mossberg.RELOAD_SPEED = 1.5
	presets.weapon.normal.is_shotgun_mag = deep_clone(presets.weapon.normal.is_shotgun_pump)
	presets.weapon.normal.is_shotgun_mag.RELOAD_SPEED = 0.25
	presets.weapon.normal.is_shotgun_mag.autofire_rounds = {4, 9}
	presets.weapon.normal.is_shotgun_mag.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 1,
			recoil = {0.4, 0.7},
			mode = {
				0,
				1,
				2,
				1
			}
		},
		{
			r = 500,
			acc = {0.4, 0.9},
			dmg_mul = 0.95,
			recoil = {0.4, 0.7},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 600,
			acc = {0.4, 0.9},
			dmg_mul = 0.9,
			recoil = {0.4, 0.7},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 700,
			acc = {0.4, 0.9},
			dmg_mul = 0.85,
			recoil = {0.4, 0.7},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 800,
			acc = {0.4, 0.9},
			dmg_mul = 0.8,
			recoil = {0.4, 0.7},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 900,
			acc = {0.4, 0.9},
			dmg_mul = 0.75,
			recoil = {0.4, 0.7},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 1000,
			acc = {0.4, 0.75},
			dmg_mul = 0.7,
			recoil = {0.4, 0.7},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 1100,
			acc = {0.4, 0.75},
			dmg_mul = 0.65,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1200,
			acc = {0.4, 0.75},
			dmg_mul = 0.6,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1300,
			acc = {0.4, 0.75},
			dmg_mul = 0.55,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1400,
			acc = {0.4, 0.75},
			dmg_mul = 0.5,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1500,
			acc = {0.4, 0.75},
			dmg_mul = 0.45,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1600,
			acc = {0.1, 0.55},
			dmg_mul = 0.4,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1700,
			acc = {0.1, 0.55},
			dmg_mul = 0.35,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1800,
			acc = {0.1, 0.55},
			dmg_mul = 0.3,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1900,
			acc = {0.1, 0.55},
			dmg_mul = 0.25,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 2000,
			acc = {0.1, 0.55},
			dmg_mul = 0.2,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 2100,
			acc = {0.1, 0.55},
			dmg_mul = 0.15,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 2200,
			acc = {0.1, 0.55},
			dmg_mul = 0.1,
			recoil = {0.45, 0.8},
			mode = {
				3,
				2,
				2,
				0
			}
		},
		{
			r = 2300,
			acc = {0.1, 0.55},
			dmg_mul = 0.05,
			recoil = {0.45, 0.8},
			mode = {
				3,
				2,
				2,
				0
			}
		},
		{
			r = 2400,
			acc = {0, 0},
			dmg_mul = 0,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		}
	}
	presets.weapon.normal.flamethrower = deep_clone(presets.weapon.normal.is_shotgun_pump)
	presets.weapon.normal.flamethrower.autofire_rounds = {25, 50}
	presets.weapon.normal.flamethrower.RELOAD_SPEED = 0.5
	presets.weapon.normal.flamethrower.range = {
		close = 250,
		optimal = 750,
		far = 1400
	}
	presets.weapon.normal.flamethrower.FALLOFF = {
		{
			r = 250,
			acc = {1, 1},
			dmg_mul = 1,
			recoil = {0, 0},
			mode = {
				0,
				0,
				0,
				1
			},
			autofire_rounds = {25, 50}
		},
		{
			r = 500,
			acc = {0.5, 0.5},
			dmg_mul = 1,
			recoil = {0, 0},
			mode = {
				0,
				0,
				0,
				1
			},
			autofire_rounds = {25, 50}
		},
		{
			r = 1400,
			acc = {0.25, 0.25},
			dmg_mul = 1,
			recoil = {0, 0},
			mode = {
				0,
				0,
				0,
				1
			},
			autofire_rounds = {25, 50}
		},
		{
			r = 1401,
			acc = {0, 0},
			dmg_mul = 0,
			recoil = {0, 0},
			mode = {
				0,
				0,
				0,
				1
			},
			autofire_rounds = {25, 50}
		}
	}
	presets.weapon.normal.mini = {}
	presets.weapon.normal.mini.aim_delay = {0.1, 0.1}
	presets.weapon.normal.mini.focus_delay = 10
	presets.weapon.normal.mini.focus_dis = 200
	presets.weapon.normal.mini.spread = 20
	presets.weapon.normal.mini.miss_dis = 40
	presets.weapon.normal.mini.RELOAD_SPEED = 0.25
	presets.weapon.normal.mini.melee_speed = 1
	presets.weapon.normal.mini.melee_dmg = 5
	presets.weapon.normal.mini.melee_retry_delay = {0.68, 0.68}
	presets.weapon.normal.mini.range = {
		close = 1000,
		optimal = 2500,
		far = 5000
	}
	presets.weapon.normal.mini.autofire_rounds = {20, 40}
	presets.weapon.normal.mini.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 1,
			recoil = {0.4, 0.7},
			mode = {
				0,
				0,
				0,
				1
			},
			autofire_rounds = {500, 700}
		},
		{
			r = 500,
			acc = {0.5, 0.7},
			dmg_mul = 1,
			recoil = {0.4, 0.7},
			mode = {
				0,
				0,
				0,
				1
			},
			autofire_rounds = {500, 500}
		},
		{
			r = 1000,
			acc = {0.4, 0.6},
			dmg_mul = 1,
			recoil = {0.45, 0.8},
			mode = {
				0,
				0,
				0,
				1
			},
			autofire_rounds = {300, 500}
		},
		{
			r = 2000,
			acc = {0.2, 0.5},
			dmg_mul = 1,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				1
			}
		},
		{
			r = 3000,
			acc = {0.1, 0.35},
			dmg_mul = 1,
			recoil = {1, 1.2},
			mode = {
				4,
				2,
				1,
				0
			}
		}
	}
	presets.weapon.good = deep_clone(presets.weapon.normal)
	presets.weapon.good.is_pistol.aim_delay = {0.1, 0.1}
	presets.weapon.good.is_pistol.focus_delay = 2
	presets.weapon.good.is_pistol.focus_dis = 200
	presets.weapon.good.is_pistol.spread = 20
	presets.weapon.good.is_pistol.miss_dis = 50
	presets.weapon.good.is_pistol.RELOAD_SPEED = 1
	presets.weapon.good.is_pistol.melee_speed = presets.weapon.normal.is_pistol.melee_speed
	presets.weapon.good.is_pistol.melee_dmg = 10
	presets.weapon.good.is_pistol.melee_retry_delay = presets.weapon.normal.is_pistol.melee_retry_delay
	presets.weapon.good.is_pistol.range = presets.weapon.normal.is_pistol.range
	presets.weapon.good.is_pistol.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 2,
			recoil = {0.15, 0.25},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 500,
			acc = {0.5, 0.85},
			dmg_mul = 2,
			recoil = {0.15, 0.25},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1000,
			acc = {0.375, 0.55},
			dmg_mul = 2,
			recoil = {0.15, 0.4},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2000,
			acc = {0.25, 0.45},
			dmg_mul = 1,
			recoil = {0.4, 0.9},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 3000,
			acc = {0.01, 0.35},
			dmg_mul = 1,
			recoil = {0.4, 1},
			mode = {
				1,
				0,
				0,
				0
			}
		}
	}
	presets.weapon.good.akimbo_pistol = presets.weapon.good.is_pistol
	presets.weapon.good.is_rifle.aim_delay = {0.1, 0.1}
	presets.weapon.good.is_rifle.focus_delay = 3
	presets.weapon.good.is_rifle.focus_dis = 200
	presets.weapon.good.is_rifle.spread = 20
	presets.weapon.good.is_rifle.miss_dis = 40
	presets.weapon.good.is_rifle.RELOAD_SPEED = 1
	presets.weapon.good.is_rifle.melee_speed = 1
	presets.weapon.good.is_rifle.melee_dmg = 10
	presets.weapon.good.is_rifle.tase_distance = 1400
	presets.weapon.good.is_rifle.aim_delay_tase = {0, 0.5}
	presets.weapon.good.is_rifle.tase_sphere_cast_radius = 30
	presets.weapon.good.is_rifle.melee_retry_delay = presets.weapon.normal.is_rifle.melee_retry_delay
	presets.weapon.good.is_rifle.range = {
		close = 1000,
		optimal = 2000,
		far = 5000
	}
	presets.weapon.good.is_rifle.autofire_rounds = presets.weapon.normal.is_rifle.autofire_rounds
	presets.weapon.good.is_rifle.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 2,
			recoil = {0.4, 0.8},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 500,
			acc = {0.4, 0.9},
			dmg_mul = 2,
			recoil = {0.45, 0.8},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 1000,
			acc = {0.2, 0.8},
			dmg_mul = 2,
			recoil = {0.35, 0.75},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 2000,
			acc = {0.2, 0.5},
			dmg_mul = 1,
			recoil = {0.4, 1.2},
			mode = {
				3,
				2,
				2,
				0
			}
		},
		{
			r = 3000,
			acc = {0.01, 0.35},
			dmg_mul = 1,
			recoil = {1.5, 3},
			mode = {
				3,
				1,
				1,
				0
			}
		}
	}
	presets.weapon.good.is_bullpup = presets.weapon.good.is_rifle
	presets.weapon.good.is_shotgun_pump.aim_delay = {0.1, 0.1}
	presets.weapon.good.is_shotgun_pump.focus_delay = 5
	presets.weapon.good.is_shotgun_pump.focus_dis = 200
	presets.weapon.good.is_shotgun_pump.spread = 15
	presets.weapon.good.is_shotgun_pump.miss_dis = 20
	presets.weapon.good.is_shotgun_pump.RELOAD_SPEED = 0.25
	presets.weapon.good.is_shotgun_pump.melee_speed = 1
	presets.weapon.good.is_shotgun_pump.melee_dmg = 10
	presets.weapon.good.is_shotgun_pump.melee_retry_delay = presets.weapon.normal.is_shotgun_pump.melee_retry_delay
	presets.weapon.good.is_shotgun_pump.range = {
		close = 1000,
		optimal = 2000,
		far = 5000
	}
	presets.weapon.good.is_shotgun_pump.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 2,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 500,
			acc = {0.4, 0.9},
			dmg_mul = 1.9,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 600,
			acc = {0.4, 0.9},
			dmg_mul = 1.8,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 700,
			acc = {0.4, 0.9},
			dmg_mul = 1.7,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 800,
			acc = {0.4, 0.9},
			dmg_mul = 1.6,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 900,
			acc = {0.4, 0.9},
			dmg_mul = 1.5,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1000,
			acc = {0.4, 0.9},
			dmg_mul = 1.4,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1100,
			acc = {0.4, 0.75},
			dmg_mul = 1.3,
         		recoil = {1.5, 2},
            		mode = {
                		1,
                		0,
                		0,
               			0
            		}
		},
		{
			r = 1200,
			acc = {0.4, 0.75},
			dmg_mul = 1.2,
         		recoil = {1.5, 2},
            		mode = {
                		1,
                		0,
                		0,
               			0
            		}
		},
		{
			r = 1300,
			acc = {0.4, 0.75},
			dmg_mul = 1.1,
         		recoil = {1.5, 2},
            		mode = {
                		1,
                		0,
                		0,
               			0
            		}
		},
		{
			r = 1400,
			acc = {0.4, 0.75},
			dmg_mul = 1,
         		recoil = {1.5, 2},
            		mode = {
                		1,
                		0,
                		0,
               			0
            		}
		},
		{
			r = 1500,
			acc = {0.4, 0.75},
			dmg_mul = 0.9,
         		recoil = {1.5, 2},
            		mode = {
                		1,
                		0,
                		0,
               			0
            		}
		},
		{
			r = 1600,
			acc = {0.1, 0.55},
			dmg_mul = 0.8,
         		recoil = {1.5, 2},
            		mode = {
                		1,
                		0,
                		0,
               			0
            		}
		},
		{
			r = 1700,
			acc = {0.1, 0.55},
			dmg_mul = 0.7,
         		recoil = {1.5, 2},
            		mode = {
                		1,
                		0,
                		0,
               			0
            		}
		},
		{
			r = 1800,
			acc = {0.1, 0.55},
			dmg_mul = 0.6,
         		recoil = {1.5, 2},
            		mode = {
                		1,
                		0,
                		0,
               			0
            		}
		},
		{
			r = 1900,
			acc = {0.1, 0.55},
			dmg_mul = 0.5,
         		recoil = {1.5, 2},
            		mode = {
                		1,
                		0,
                		0,
               			0
            		}
		},
		{
			r = 2000,
			acc = {0.1, 0.55},
			dmg_mul = 0.25,
         		recoil = {1.5, 2},
            		mode = {
                		1,
                		0,
                		0,
               			0
            		}
		},
		{
			r = 2100,
			acc = {0.1, 0.55},
			dmg_mul = 0.2,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2200,
			acc = {0.1, 0.55},
			dmg_mul = 0.15,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2300,
			acc = {0.1, 0.55},
			dmg_mul = 0.1,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2400,
			acc = {0.1, 0.55},
			dmg_mul = 0.05,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2500,
			acc = {0, 0},
			dmg_mul = 0,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		}
	}
	presets.weapon.good.is_shotgun_mag.aim_delay = {0.1, 0.1}
	presets.weapon.good.is_shotgun_mag.focus_delay = 5
	presets.weapon.good.is_shotgun_mag.focus_dis = 200
	presets.weapon.good.is_shotgun_mag.spread = 15
	presets.weapon.good.is_shotgun_mag.miss_dis = 20
	presets.weapon.good.is_shotgun_mag.RELOAD_SPEED = 0.25
	presets.weapon.good.is_shotgun_mag.melee_speed = 1
	presets.weapon.good.is_shotgun_mag.melee_dmg = 10
	presets.weapon.good.is_shotgun_mag.melee_retry_delay = presets.weapon.normal.is_shotgun_pump.melee_retry_delay
	presets.weapon.good.is_shotgun_mag.autofire_rounds = {4, 9}
	presets.weapon.good.is_shotgun_mag.range = {
		close = 1000,
		optimal = 2000,
		far = 5000
	}
	presets.weapon.good.is_shotgun_mag.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 2,
			recoil = {0.4, 0.7},
			mode = {
				0,
				1,
				2,
				1
			}
		},
		{
			r = 500,
			acc = {0.4, 0.9},
			dmg_mul = 1.9,
			recoil = {0.4, 0.7},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 600,
			acc = {0.4, 0.9},
			dmg_mul = 1.8,
			recoil = {0.4, 0.7},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 700,
			acc = {0.4, 0.9},
			dmg_mul = 1.7,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 800,
			acc = {0.4, 0.9},
			dmg_mul = 1.6,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 900,
			acc = {0.4, 0.9},
			dmg_mul = 1.5,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1000,
			acc = {0.4, 0.75},
			dmg_mul = 1.4,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1100,
			acc = {0.4, 0.75},
			dmg_mul = 1.3,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1200,
			acc = {0.4, 0.75},
			dmg_mul = 1.2,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1300,
			acc = {0.4, 0.75},
			dmg_mul = 1.1,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1400,
			acc = {0.4, 0.75},
			dmg_mul = 1,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1500,
			acc = {0.4, 0.75},
			dmg_mul = 0.9,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1600,
			acc = {0.4, 0.75},
			dmg_mul = 0.8,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1700,
			acc = {0.4, 0.75},
			dmg_mul = 0.7,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1800,
			acc = {0.1, 0.55},
			dmg_mul = 0.6,
			recoil = {0.45, 0.8},
			mode = {
				3,
				2,
				2,
				0
			}
		},
		{
			r = 1900,
			acc = {0.1, 0.55},
			dmg_mul = 0.5,
			recoil = {0.45, 0.8},
			mode = {
				3,
				2,
				2,
				0
			}
		},
		{
			r = 2000,
			acc = {0.1, 0.55},
			dmg_mul = 0.25,
			recoil = {0.45, 0.8},
			mode = {
				3,
				2,
				2,
				0
			}
		},
		{
			r = 2100,
			acc = {0.1, 0.55},
			dmg_mul = 0.2,
			recoil = {0.45, 0.8},
			mode = {
				3,
				2,
				2,
				0
			}
		},
		{
			r = 2200,
			acc = {0.1, 0.55},
			dmg_mul = 0.15,
			recoil = {0.45, 0.8},
			mode = {
				3,
				2,
				2,
				0
			}
		},
		{
			r = 2300,
			acc = {0.1, 0.55},
			dmg_mul = 0.1,
			recoil = {0.45, 0.8},
			mode = {
				3,
				2,
				2,
				0
			}
		},
		{
			r = 2400,
			acc = {0.1, 0.55},
			dmg_mul = 0.05,
			recoil = {0.45, 0.8},
			mode = {
				3,
				2,
				2,
				0
			}
		},
		{
			r = 2500,
			acc = {0, 0},
			dmg_mul = 0,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		}
	}
	presets.weapon.good.flamethrower = deep_clone(presets.weapon.good.is_shotgun_pump)
	presets.weapon.good.flamethrower.autofire_rounds = {25, 50}
	presets.weapon.good.flamethrower.RELOAD_SPEED = 0.5
	presets.weapon.good.flamethrower.range = {
		close = 250,
		optimal = 750,
		far = 1400
	}
	presets.weapon.good.flamethrower.FALLOFF = {
		{
			r = 250,
			acc = {1, 1},
			dmg_mul = 2,
			recoil = {0, 0},
			mode = {
				0,
				0,
				0,
				1
			},
			autofire_rounds = {25, 50}
		},
		{
			r = 500,
			acc = {0.5, 0.5},
			dmg_mul = 2,
			recoil = {0, 0},
			mode = {
				0,
				0,
				0,
				1
			},
			autofire_rounds = {25, 50}
		},
		{
			r = 1400,
			acc = {0.25, 0.25},
			dmg_mul = 2,
			recoil = {0, 0},
			mode = {
				0,
				0,
				0,
				1
			},
			autofire_rounds = {25, 50}
		},
		{
			r = 1401,
			acc = {0, 0},
			dmg_mul = 0,
			recoil = {0, 0},
			mode = {
				0,
				0,
				0,
				1
			},
			autofire_rounds = {25, 50}
		}
	}
	presets.weapon.good.is_smg.aim_delay = {0.1, 0.1}
	presets.weapon.good.is_smg.focus_delay = 3
	presets.weapon.good.is_smg.focus_dis = 200
	presets.weapon.good.is_smg.spread = 20
	presets.weapon.good.is_smg.miss_dis = 40
	presets.weapon.good.is_smg.RELOAD_SPEED = 1
	presets.weapon.good.is_smg.melee_speed = presets.weapon.normal.is_smg.melee_speed
	presets.weapon.good.is_smg.melee_dmg = 10
	presets.weapon.good.is_smg.melee_retry_delay = presets.weapon.normal.is_smg.melee_retry_delay
	presets.weapon.good.is_smg.range = presets.weapon.normal.is_smg.range
	presets.weapon.good.is_smg.autofire_rounds = presets.weapon.normal.is_smg.autofire_rounds
	presets.weapon.good.is_smg.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 2,
			recoil = {0.1, 0.25},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 500,
			acc = {0.4, 0.95},
			dmg_mul = 2,
			recoil = {0.1, 0.3},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 1000,
			acc = {0.2, 0.75},
			dmg_mul = 2,
			recoil = {0.35, 0.5},
			mode = {
				0,
				3,
				3,
				0
			}
		},
		{
			r = 2000,
			acc = {0.1, 0.45},
			dmg_mul = 1,
			recoil = {0.35, 0.6},
			mode = {
				0,
				3,
				3,
				0
			}
		},
		{
			r = 3000,
			acc = {0.1, 0.35},
			dmg_mul = 1,
			recoil = {0.5, 0.6},
			mode = {
				1,
				3,
				2,
				0
			}
		}
	}
	presets.weapon.good.mp9.aim_delay = {0.1, 0.1}
	presets.weapon.good.mp9.focus_delay = 20
	presets.weapon.good.mp9.focus_dis = 200
	presets.weapon.good.mp9.spread = 30
	presets.weapon.good.mp9.miss_dis = 15
	presets.weapon.good.mp9.RELOAD_SPEED = 1
	presets.weapon.good.mp9.melee_speed = nil
	presets.weapon.good.mp9.melee_dmg = nil
	presets.weapon.good.mp9.melee_retry_delay = nil
	presets.weapon.good.mp9.range = {
		close = 500,
		optimal = 1200,
		far = 3000
	}
	presets.weapon.good.mp9.autofire_rounds = {6, 11}
	presets.weapon.good.mp9.FALLOFF = {
		{
			r = 0,
			acc = {0.7, 0.95},
			dmg_mul = 2,
			recoil = {0.35, 0.55},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 700,
			acc = {0.5, 0.75},
			dmg_mul = 2,
			recoil = {0.35, 0.55},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 1000,
			acc = {0.45, 0.65},
			dmg_mul = 2,
			recoil = {1, 1.2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2000,
			acc = {0.3, 0.5},
			dmg_mul = 1,
			recoil = {1.2, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 3000,
			acc = {0.1, 0.25},
			dmg_mul = 1,
			recoil = {1.2, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		}
	}
	presets.weapon.good.mac11.aim_delay = {0.1, 0.1}
	presets.weapon.good.mac11.focus_delay = 3
	presets.weapon.good.mac11.focus_dis = 200
	presets.weapon.good.mac11.spread = 15
	presets.weapon.good.mac11.miss_dis = 10
	presets.weapon.good.mac11.RELOAD_SPEED = 1
	presets.weapon.good.mac11.melee_speed = presets.weapon.normal.mac11.melee_speed
	presets.weapon.good.mac11.melee_dmg = 10
	presets.weapon.good.mac11.melee_retry_delay = presets.weapon.normal.mac11.melee_retry_delay
	presets.weapon.good.mac11.range = presets.weapon.normal.mac11.range
	presets.weapon.good.mac11.autofire_rounds = presets.weapon.normal.mac11.autofire_rounds
	presets.weapon.good.mac11.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 2,
			recoil = {0.3, 0.35},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 500,
			acc = {0.1, 0.7},
			dmg_mul = 2,
			recoil = {0.5, 0.65},
			mode = {
				0,
				1,
				3,
				1
			}
		},
		{
			r = 1000,
			acc = {0.2, 0.55},
			dmg_mul = 2,
			recoil = {0.55, 0.85},
			mode = {
				2,
				1,
				3,
				0
			}
		},
		{
			r = 2000,
			acc = {0.05, 0.4},
			dmg_mul = 1,
			recoil = {0.65, 1},
			mode = {
				2,
				1,
				3,
				0
			}
		},
		{
			r = 3000,
			acc = {0, 0.2},
			dmg_mul = 1,
			recoil = {0.65, 1.2},
			mode = {
				4,
				1,
				0,
				0
			}
		}
	}
	presets.weapon.good.is_revolver.aim_delay = {0.1, 0.1}
	presets.weapon.good.is_revolver.focus_delay = 10
	presets.weapon.good.is_revolver.focus_dis = 200
	presets.weapon.good.is_revolver.spread = 20
	presets.weapon.good.is_revolver.miss_dis = 50
	presets.weapon.good.is_revolver.RELOAD_SPEED = 1
	presets.weapon.good.is_revolver.melee_speed = 1
	presets.weapon.good.is_revolver.melee_dmg = 10
	presets.weapon.good.is_revolver.melee_retry_delay = {0.68, 0.68}
	presets.weapon.good.is_revolver.range = {
		close = 1000,
		optimal = 2000,
		far = 5000
	}
	presets.weapon.good.is_revolver.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 2,
			recoil = {0.8, 1},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 500,
			acc = {0.5, 0.85},
			dmg_mul = 2,
			recoil = {0.8, 1.1},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1000,
			acc = {0.375, 0.55},
			dmg_mul = 2,
			recoil = {0.8, 1.1},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2000,
			acc = {0.25, 0.45},
			dmg_mul = 1,
			recoil = {1, 1.3},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 3000,
			acc = {0.01, 0.35},
			dmg_mul = 1,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		}
	}
	presets.weapon.good.is_lmg = deep_clone(presets.weapon.good.is_rifle)
	presets.weapon.good.is_lmg.RELOAD_SPEED = 0.5
	presets.weapon.good.is_lmg.autofire_rounds = {20, 40}
	presets.weapon.good.is_lmg.FALLOFF = {
		{
			r = 100,
			acc = {0.7, 0.9},
			dmg_mul = 2,
			recoil = {0.4, 0.7},
			mode = {
				0,
				0,
				0,
				1
			}
		},
		{
			r = 500,
			acc = {0.5, 0.75},
			dmg_mul = 2,
			recoil = {0.5, 0.8},
			mode = {
				0,
				0,
				0,
				6
			}
		},
		{
			r = 1000,
			acc = {0.3, 0.6},
			dmg_mul = 2,
			recoil = {1, 1},
			mode = {
				0,
				0,
				2,
				6
			}
		},
		{
			r = 2000,
			acc = {0.25, 0.55},
			dmg_mul = 1,
			recoil = {1, 1},
			mode = {
				0,
				0,
				2,
				6
			}
		},
		{
			r = 3000,
			acc = {0.15, 0.5},
			dmg_mul = 1,
			recoil = {1, 2},
			mode = {
				0,
				0,
				2,
				6
			}
		}
	}
	presets.weapon.good.mossberg = deep_clone(presets.weapon.good.is_shotgun_pump)
	presets.weapon.good.mossberg.RELOAD_SPEED = 1.5
	presets.weapon.good.mini = {}
	presets.weapon.good.mini.aim_delay = {0.1, 0.1}
	presets.weapon.good.mini.focus_delay = 3
	presets.weapon.good.mini.focus_dis = 200
	presets.weapon.good.mini.spread = 20
	presets.weapon.good.mini.miss_dis = 40
	presets.weapon.good.mini.RELOAD_SPEED = 0.25
	presets.weapon.good.mini.melee_speed = 1
	presets.weapon.good.mini.melee_dmg = 10
	presets.weapon.good.mini.melee_retry_delay = {0.68, 0.68}
	presets.weapon.good.mini.range = {
		close = 1000,
		optimal = 2500,
		far = 5000
	}
	presets.weapon.good.mini.autofire_rounds = {20, 40}
	presets.weapon.good.mini.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 2,
			recoil = {0.4, 0.7},
			mode = {
				0,
				0,
				0,
				1
			},
			autofire_rounds = {500, 700}
		},
		{
			r = 500,
			acc = {0.5, 0.7},
			dmg_mul = 2,
			recoil = {0.4, 0.7},
			mode = {
				0,
				0,
				0,
				1
			},
			autofire_rounds = {500, 500}
		},
		{
			r = 1000,
			acc = {0.4, 0.6},
			dmg_mul = 2,
			recoil = {0.45, 0.8},
			mode = {
				0,
				0,
				0,
				1
			},
			autofire_rounds = {300, 500}
		},
		{
			r = 2000,
			acc = {0.2, 0.5},
			dmg_mul = 1,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				1
			}
		},
		{
			r = 3000,
			acc = {0.1, 0.35},
			dmg_mul = 1,
			recoil = {1, 1.2},
			mode = {
				4,
				2,
				1,
				0
			}
		}
	}
	presets.weapon.expert = deep_clone(presets.weapon.good)
	presets.weapon.expert.is_pistol.aim_delay = {0, 0.1}
	presets.weapon.expert.is_pistol.focus_delay = 1
	presets.weapon.expert.is_pistol.focus_dis = 300
	presets.weapon.expert.is_pistol.spread = 20
	presets.weapon.expert.is_pistol.miss_dis = 50
	presets.weapon.expert.is_pistol.RELOAD_SPEED = 1
	presets.weapon.expert.is_pistol.melee_speed = presets.weapon.normal.is_pistol.melee_speed
	presets.weapon.expert.is_pistol.melee_dmg = 12
	presets.weapon.expert.is_pistol.melee_retry_delay = presets.weapon.normal.is_pistol.melee_retry_delay
	presets.weapon.expert.is_pistol.range = presets.weapon.normal.is_pistol.range
	presets.weapon.expert.is_pistol.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 2.3,
			recoil = {0.15, 0.25},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 500,
			acc = {0.5, 0.9},
			dmg_mul = 2.3,
			recoil = {0.15, 0.3},
			mode = {
				1,
				0,
				1,
				0
			}
		},
		{
			r = 1000,
			acc = {0.4, 0.65},
			dmg_mul = 2.3,
			recoil = {0.15, 0.3},
			mode = {
				1,
				0,
				1,
				0
			}
		},
		{
			r = 1800,
			acc = {0.4, 0.65},
			dmg_mul = 2.1,
			recoil = {0.15, 0.3},
			mode = {
				1,
				0,
				1,
				0
			}
		},		
		{
			r = 2000,
			acc = {0.3, 0.5},
			dmg_mul = 2.1,
			recoil = {0.4, 0.9},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 3000,
			acc = {0.1, 0.25},
			dmg_mul = 1.05,
			recoil = {0.4, 1.4},
			mode = {
				1,
				0,
				0,
				0
			}
		}
	}
	presets.weapon.expert.akimbo_pistol = presets.weapon.expert.is_pistol
	presets.weapon.expert.is_rifle.aim_delay = {0, 0.1}
	presets.weapon.expert.is_rifle.focus_delay = 2
	presets.weapon.expert.is_rifle.focus_dis = 300
	presets.weapon.expert.is_rifle.spread = 20
	presets.weapon.expert.is_rifle.miss_dis = 40
	presets.weapon.expert.is_rifle.RELOAD_SPEED = 1
	presets.weapon.expert.is_rifle.melee_speed = 1
	presets.weapon.expert.is_rifle.melee_dmg = 12
	presets.weapon.expert.is_rifle.tase_distance = 1400
	presets.weapon.expert.is_rifle.aim_delay_tase = {0, 0.5}
	presets.weapon.expert.is_rifle.tase_sphere_cast_radius = 30
	presets.weapon.expert.is_rifle.melee_retry_delay = presets.weapon.normal.is_rifle.melee_retry_delay
	presets.weapon.expert.is_rifle.range = {
		close = 1000,
		optimal = 2000,
		far = 5000
	}
	presets.weapon.expert.is_rifle.autofire_rounds = presets.weapon.normal.is_rifle.autofire_rounds
	presets.weapon.expert.is_rifle.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 2.3,
			recoil = {0.4, 0.8},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 500,
			acc = {0.55, 0.95},
			dmg_mul = 2.3,
			recoil = {0.45, 0.8},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 1000,
			acc = {0.525, 0.8},
			dmg_mul = 2.3,
			recoil = {0.35, 0.75},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1800,
			acc = {0.525, 0.8},
			dmg_mul = 2.1,
			recoil = {0.35, 0.75},
			mode = {
				1,
				2,
				2,
				0
			}
		},		
		{
			r = 2000,
			acc = {0.5, 0.7},
			dmg_mul = 2.1,
			recoil = {0.4, 1.2},
			mode = {
				3,
				2,
				2,
				0
			}
		},
		{
			r = 3000,
			acc = {0.2, 0.4},
			dmg_mul = 1.05,
			recoil = {1.5, 3},
			mode = {
				3,
				1,
				1,
				0
			}
		}
	}
	presets.weapon.expert.is_bullpup = presets.weapon.expert.is_rifle
	presets.weapon.expert.is_shotgun_pump.aim_delay = {0, 0.1}
	presets.weapon.expert.is_shotgun_pump.focus_delay = 2
	presets.weapon.expert.is_shotgun_pump.focus_dis = 200
	presets.weapon.expert.is_shotgun_pump.spread = 15
	presets.weapon.expert.is_shotgun_pump.miss_dis = 20
	presets.weapon.expert.is_shotgun_pump.RELOAD_SPEED = 0.25
	presets.weapon.expert.is_shotgun_pump.melee_speed = 1
	presets.weapon.expert.is_shotgun_pump.melee_dmg = 12
	presets.weapon.expert.is_shotgun_pump.melee_retry_delay = presets.weapon.normal.is_shotgun_pump.melee_retry_delay
	presets.weapon.expert.is_shotgun_pump.range = {
		close = 1000,
		optimal = 2000,
		far = 5000
	}
	presets.weapon.expert.is_shotgun_pump.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 2.3,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 500,
			acc = {0.4, 0.9},
			dmg_mul = 2.185,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 600,
			acc = {0.4, 0.9},
			dmg_mul = 2.07,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 700,
			acc = {0.4, 0.9},
			dmg_mul = 1.955,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 800,
			acc = {0.4, 0.9},
			dmg_mul = 1.84,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 900,
			acc = {0.4, 0.9},
			dmg_mul = 1.725,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1000,
			acc = {0.4, 0.75},
			dmg_mul = 1.61,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1100,
			acc = {0.4, 0.75},
			dmg_mul = 1.495,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1200,
			acc = {0.4, 0.75},
			dmg_mul = 1.38,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1300,
			acc = {0.4, 0.75},
			dmg_mul = 1.265,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1400,
			acc = {0.4, 0.75},
			dmg_mul = 1.15,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1500,
			acc = {0.4, 0.75},
			dmg_mul = 1.035,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1600,
			acc = {0.1, 0.55},
			dmg_mul = 0.92,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1700,
			acc = {0.1, 0.55},
			dmg_mul = 0.805,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1800,
			acc = {0.1, 0.55},
			dmg_mul = 0.63,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1900,
			acc = {0.1, 0.55},
			dmg_mul = 0.525,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2000,
			acc = {0.1, 0.55},
			dmg_mul = 0.2,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2100,
			acc = {0.1, 0.55},
			dmg_mul = 0.15,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2200,
			acc = {0.1, 0.55},
			dmg_mul = 0.1,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2300,
			acc = {0.1, 0.55},
			dmg_mul = 0.05,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2400,
			acc = {0, 0},
			dmg_mul = 0,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		}
	}
	presets.weapon.expert.is_shotgun_mag.aim_delay = {0, 0.1}
	presets.weapon.expert.is_shotgun_mag.focus_delay = 2
	presets.weapon.expert.is_shotgun_mag.focus_dis = 200
	presets.weapon.expert.is_shotgun_mag.spread = 15
	presets.weapon.expert.is_shotgun_mag.miss_dis = 20
	presets.weapon.expert.is_shotgun_mag.RELOAD_SPEED = 0.25
	presets.weapon.expert.is_shotgun_mag.melee_speed = 1
	presets.weapon.expert.is_shotgun_mag.melee_dmg = 12
	presets.weapon.expert.is_shotgun_mag.melee_retry_delay = presets.weapon.normal.is_shotgun_pump.melee_retry_delay
	presets.weapon.expert.is_shotgun_mag.range = {
		close = 1000,
		optimal = 2000,
		far = 5000
	}
	presets.weapon.expert.is_shotgun_mag.autofire_rounds = {4, 9}
	presets.weapon.expert.is_shotgun_mag.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 2.3,
			recoil = {0.4, 0.7},
			mode = {
				0,
				1,
				2,
				1
			}
		},
		{
			r = 500,
			acc = {0.4, 0.9},
			dmg_mul = 2.185,
			recoil = {0.4, 0.7},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 600,
			acc = {0.4, 0.9},
			dmg_mul = 2.07,
			recoil = {0.4, 0.7},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 700,
			acc = {0.4, 0.9},
			dmg_mul = 1.955,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 800,
			acc = {0.4, 0.9},
			dmg_mul = 1.84,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 900,
			acc = {0.4, 0.9},
			dmg_mul = 1.725,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1000,
			acc = {0.4, 0.75},
			dmg_mul = 1.61,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1100,
			acc = {0.4, 0.75},
			dmg_mul = 1.495,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1200,
			acc = {0.4, 0.75},
			dmg_mul = 1.38,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1300,
			acc = {0.4, 0.75},
			dmg_mul = 1.265,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1400,
			acc = {0.4, 0.75},
			dmg_mul = 1.15,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1500,
			acc = {0.4, 0.75},
			dmg_mul = 1.035,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1600,
			acc = {0.1, 0.55},
			dmg_mul = 0.92,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1700,
			acc = {0.1, 0.55},
			dmg_mul = 0.805,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1800,
			acc = {0.1, 0.55},
			dmg_mul = 0.63,
			recoil = {0.45, 0.8},
			mode = {
				3,
				2,
				2,
				0
			}
		},
		{
			r = 1900,
			acc = {0.1, 0.55},
			dmg_mul = 0.525,
			recoil = {0.45, 0.8},
			mode = {
				3,
				2,
				2,
				0
			}
		},
		{
			r = 2000,
			acc = {0.1, 0.55},
			dmg_mul = 0.2,
			recoil = {0.45, 0.8},
			mode = {
				3,
				2,
				2,
				0
			}
		},
		{
			r = 2100,
			acc = {0.1, 0.55},
			dmg_mul = 0.15,
			recoil = {0.45, 0.8},
			mode = {
				3,
				2,
				2,
				0
			}
		},
		{
			r = 2200,
			acc = {0.1, 0.55},
			dmg_mul = 0.1,
			recoil = {0.45, 0.8},
			mode = {
				3,
				2,
				2,
				0
			}
		},
		{
			r = 2300,
			acc = {0.1, 0.55},
			dmg_mul = 0.05,
			recoil = {0.45, 0.8},
			mode = {
				3,
				2,
				2,
				0
			}
		},
		{
			r = 2400,
			acc = {0, 0},
			dmg_mul = 0,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		}
	}
	presets.weapon.expert.flamethrower = deep_clone(presets.weapon.expert.is_shotgun_pump)
	presets.weapon.expert.flamethrower.autofire_rounds = {25, 50}
	presets.weapon.expert.flamethrower.RELOAD_SPEED = 0.5
	presets.weapon.expert.flamethrower.range = {
		close = 250,
		optimal = 750,
		far = 1400
	}
	presets.weapon.expert.flamethrower.FALLOFF = {
		{
			r = 250,
			acc = {1, 1},
			dmg_mul = 2.3,
			recoil = {0, 0},
			mode = {
				0,
				0,
				0,
				1
			},
			autofire_rounds = {25, 50}
		},
		{
			r = 500,
			acc = {0.5, 0.5},
			dmg_mul = 2.3,
			recoil = {0, 0},
			mode = {
				0,
				0,
				0,
				1
			},
			autofire_rounds = {25, 50}
		},
		{
			r = 1400,
			acc = {0.25, 0.25},
			dmg_mul = 2.3,
			recoil = {0, 0},
			mode = {
				0,
				0,
				0,
				1
			},
			autofire_rounds = {25, 50}
		},
		{
			r = 1401,
			acc = {0, 0},
			dmg_mul = 0,
			recoil = {0, 0},
			mode = {
				0,
				0,
				0,
				1
			},
			autofire_rounds = {25, 50}
		}
	}
	presets.weapon.expert.is_smg.aim_delay = {0, 0.1}
	presets.weapon.expert.is_smg.focus_delay = 1
	presets.weapon.expert.is_smg.focus_dis = 200
	presets.weapon.expert.is_smg.spread = 15
	presets.weapon.expert.is_smg.miss_dis = 10
	presets.weapon.expert.is_smg.RELOAD_SPEED = 1
	presets.weapon.expert.is_smg.melee_speed = presets.weapon.normal.is_smg.melee_speed
	presets.weapon.expert.is_smg.melee_dmg = 12
	presets.weapon.expert.is_smg.melee_retry_delay = presets.weapon.normal.is_smg.melee_retry_delay
	presets.weapon.expert.is_smg.range = presets.weapon.normal.is_smg.range
	presets.weapon.expert.is_smg.autofire_rounds = presets.weapon.normal.is_smg.autofire_rounds
	presets.weapon.expert.is_smg.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.95},
			dmg_mul = 2.3,
			recoil = {0.1, 0.25},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 500,
			acc = {0.6, 0.9},
			dmg_mul = 2.3,
			recoil = {0.1, 0.3},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 1000,
			acc = {0.4, 0.65},
			dmg_mul = 2.3,
			recoil = {0.35, 0.5},
			mode = {
				0,
				3,
				3,
				0
			}
		},
		{
			r = 1800,
			acc = {0.4, 0.65},
			dmg_mul = 2.1,
			recoil = {0.35, 0.5},
			mode = {
				0,
				3,
				3,
				0
			}
		},		
		{
			r = 2000,
			acc = {0.4, 0.6},
			dmg_mul = 2.1,
			recoil = {0.35, 0.7},
			mode = {
				0,
				3,
				3,
				0
			}
		},
		{
			r = 3000,
			acc = {0.2, 0.35},
			dmg_mul = 1.05,
			recoil = {0.5, 1.5},
			mode = {
				1,
				3,
				2,
				0
			}
		}
	}
	presets.weapon.expert.mp9.aim_delay = {0, 0.1}
	presets.weapon.expert.mp9.focus_delay = 20
	presets.weapon.expert.mp9.focus_dis = 200
	presets.weapon.expert.mp9.spread = 30
	presets.weapon.expert.mp9.miss_dis = 15
	presets.weapon.expert.mp9.RELOAD_SPEED = 1
	presets.weapon.expert.mp9.melee_speed = nil
	presets.weapon.expert.mp9.melee_dmg = nil
	presets.weapon.expert.mp9.melee_retry_delay = nil
	presets.weapon.expert.mp9.range = {
		close = 500,
		optimal = 1200,
		far = 3000
	}
	presets.weapon.expert.mp9.autofire_rounds = {6, 11}
	presets.weapon.expert.mp9.FALLOFF = {
		{
			r = 0,
			acc = {0.7, 0.95},
			dmg_mul = 2.3,
			recoil = {0.35, 0.55},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 700,
			acc = {0.5, 0.75},
			dmg_mul = 2.3,
			recoil = {0.35, 0.55},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 1000,
			acc = {0.45, 0.65},
			dmg_mul = 2.3,
			recoil = {1, 1.2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1800,
			acc = {0.45, 0.65},
			dmg_mul = 2.1,
			recoil = {1, 1.2},
			mode = {
				1,
				0,
				0,
				0
			}
		},		
		{
			r = 2000,
			acc = {0.3, 0.5},
			dmg_mul = 2.1,
			recoil = {1.2, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 3000,
			acc = {0.1, 0.25},
			dmg_mul = 1.05,
			recoil = {1.2, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		}
	}
	presets.weapon.expert.mac11.aim_delay = {0, 0.1}
	presets.weapon.expert.mac11.focus_delay = 1
	presets.weapon.expert.mac11.focus_dis = 200
	presets.weapon.expert.mac11.spread = 15
	presets.weapon.expert.mac11.miss_dis = 10
	presets.weapon.expert.mac11.RELOAD_SPEED = 1
	presets.weapon.expert.mac11.melee_speed = presets.weapon.normal.mac11.melee_speed
	presets.weapon.expert.mac11.melee_dmg = 12
	presets.weapon.expert.mac11.melee_retry_delay = presets.weapon.normal.mac11.melee_retry_delay
	presets.weapon.expert.mac11.range = presets.weapon.normal.mac11.range
	presets.weapon.expert.mac11.autofire_rounds = presets.weapon.normal.mac11.autofire_rounds
	presets.weapon.expert.mac11.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 2.3,
			recoil = {0.5, 0.6},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 500,
			acc = {0.5, 0.85},
			dmg_mul = 2.3,
			recoil = {0.5, 0.65},
			mode = {
				0,
				1,
				3,
				1
			}
		},
		{
			r = 1000,
			acc = {0.3, 0.65},
			dmg_mul = 2.3,
			recoil = {0.55, 0.85},
			mode = {
				2,
				1,
				3,
				0
			}
		},
		{
			r = 1800,
			acc = {0.3, 0.65},
			dmg_mul = 2.1,
			recoil = {0.55, 0.85},
			mode = {
				2,
				1,
				3,
				0
			}
		},		
		{
			r = 2000,
			acc = {0.35, 0.55},
			dmg_mul = 2.1,
			recoil = {0.65, 1},
			mode = {
				2,
				1,
				3,
				0
			}
		},
		{
			r = 3000,
			acc = {0.2, 0.35},
			dmg_mul = 1.05,
			recoil = {0.65, 1.2},
			mode = {
				4,
				1,
				0,
				0
			}
		}
	}
	presets.weapon.expert.is_revolver.aim_delay = {0, 0.1}
	presets.weapon.expert.is_revolver.focus_delay = 10
	presets.weapon.expert.is_revolver.focus_dis = 200
	presets.weapon.expert.is_revolver.spread = 20
	presets.weapon.expert.is_revolver.miss_dis = 50
	presets.weapon.expert.is_revolver.RELOAD_SPEED = 1
	presets.weapon.expert.is_revolver.melee_speed = 1
	presets.weapon.expert.is_revolver.melee_dmg = 12
	presets.weapon.expert.is_revolver.melee_retry_delay = {0.68, 0.68}
	presets.weapon.expert.is_revolver.range = {
		close = 1000,
		optimal = 2000,
		far = 5000
	}
	presets.weapon.expert.is_revolver.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 2.3,
			recoil = {0.8, 1},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 500,
			acc = {0.5, 0.85},
			dmg_mul = 2.3,
			recoil = {0.8, 1.1},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1000,
			acc = {0.375, 0.55},
			dmg_mul = 2.3,
			recoil = {0.8, 1.1},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1800,
			acc = {0.375, 0.55},
			dmg_mul = 2.1,
			recoil = {0.8, 1.1},
			mode = {
				1,
				0,
				0,
				0
			}
		},		
		{
			r = 2000,
			acc = {0.25, 0.45},
			dmg_mul = 2.1,
			recoil = {1, 1.3},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 3000,
			acc = {0.01, 0.35},
			dmg_mul = 1.05,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		}
	}
	presets.weapon.expert.is_lmg = deep_clone(presets.weapon.expert.is_rifle)
	presets.weapon.expert.is_lmg.RELOAD_SPEED = 0.5
	presets.weapon.expert.is_lmg.autofire_rounds = {20, 40}
	presets.weapon.expert.is_lmg.FALLOFF = {
		{
			r = 100,
			acc = {0.7, 0.9},
			dmg_mul = 2.3,
			recoil = {0.4, 0.7},
			mode = {
				0,
				0,
				0,
				1
			}
		},
		{
			r = 500,
			acc = {0.5, 0.75},
			dmg_mul = 2.3,
			recoil = {0.5, 0.8},
			mode = {
				0,
				0,
				0,
				6
			}
		},
		{
			r = 1000,
			acc = {0.3, 0.6},
			dmg_mul = 2.3,
			recoil = {1, 1},
			mode = {
				0,
				0,
				2,
				6
			}
		},
		{
			r = 1800,
			acc = {0.3, 0.6},
			dmg_mul = 2.1,
			recoil = {1, 1},
			mode = {
				0,
				0,
				2,
				6
			}
		},		
		{
			r = 2000,
			acc = {0.25, 0.55},
			dmg_mul = 2.1,
			recoil = {1, 1},
			mode = {
				0,
				0,
				2,
				6
			}
		},
		{
			r = 3000,
			acc = {0.15, 0.5},
			dmg_mul = 1.05,
			recoil = {1, 2},
			mode = {
				0,
				0,
				2,
				6
			}
		}
	}
	presets.weapon.expert.mossberg = deep_clone(presets.weapon.expert.is_shotgun_pump)
	presets.weapon.expert.mossberg.RELOAD_SPEED = 1.5
	presets.weapon.expert.mini = {}
	presets.weapon.expert.mini.aim_delay = {0, 0.1}
	presets.weapon.expert.mini.focus_delay = 2
	presets.weapon.expert.mini.focus_dis = 300
	presets.weapon.expert.mini.spread = 20
	presets.weapon.expert.mini.miss_dis = 40
	presets.weapon.expert.mini.RELOAD_SPEED = 0.25
	presets.weapon.expert.mini.melee_speed = 1
	presets.weapon.expert.mini.melee_dmg = 12
	presets.weapon.expert.mini.melee_retry_delay = {0.68, 0.68}
	presets.weapon.expert.mini.range = {
		close = 1000,
		optimal = 2500,
		far = 5000
	}
	presets.weapon.expert.mini.autofire_rounds = {20, 40}
	presets.weapon.expert.mini.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 2.3,
			recoil = {0.4, 0.7},
			mode = {
				0,
				0,
				0,
				1
			},
			autofire_rounds = {500, 700}
		},
		{
			r = 500,
			acc = {0.5, 0.7},
			dmg_mul = 2.3,
			recoil = {0.4, 0.7},
			mode = {
				0,
				0,
				0,
				1
			},
			autofire_rounds = {500, 500}
		},
		{
			r = 1000,
			acc = {0.4, 0.6},
			dmg_mul = 2.3,
			recoil = {0.45, 0.8},
			mode = {
				0,
				0,
				0,
				1
			},
			autofire_rounds = {300, 500}
		},
		{
			r = 1800,
			acc = {0.4, 0.6},
			dmg_mul = 2.1,
			recoil = {0.45, 0.8},
			mode = {
				0,
				0,
				0,
				1
			},
			autofire_rounds = {300, 500}
		},		
		{
			r = 2000,
			acc = {0.2, 0.5},
			dmg_mul = 2.1,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				1
			}
		},
		{
			r = 3000,
			acc = {0.1, 0.35},
			dmg_mul = 1.05,
			recoil = {1, 1.2},
			mode = {
				4,
				2,
				1,
				0
			}
		}
	}
	presets.weapon.deathwish = deep_clone(presets.weapon.expert)
	presets.weapon.deathwish.is_shotgun_pump.melee_dmg = 12
	presets.weapon.deathwish.is_shotgun_pump.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 2.875,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 500,
			acc = {0.4, 0.9},
			dmg_mul = 2.73125,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 600,
			acc = {0.4, 0.9},
			dmg_mul = 2.5875,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 700,
			acc = {0.4, 0.9},
			dmg_mul = 2.44375,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 800,
			acc = {0.4, 0.9},
			dmg_mul = 2.3,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 900,
			acc = {0.4, 0.75},
			dmg_mul = 2.15625,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1000,
			acc = {0.4, 0.75},
			dmg_mul = 2.0125,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1100,
			acc = {0.4, 0.75},
			dmg_mul = 1.86875,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1200,
			acc = {0.4, 0.75},
			dmg_mul = 1.725,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1300,
			acc = {0.4, 0.75},
			dmg_mul = 1.58125,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1400,
			acc = {0.4, 0.75},
			dmg_mul = 1.3125,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1500,
			acc = {0.1, 0.55},
			dmg_mul = 1.18125,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1600,
			acc = {0.1, 0.55},
			dmg_mul = 1.05,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1700,
			acc = {0.1, 0.55},
			dmg_mul = 0.91875,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1800,
			acc = {0.1, 0.55},
			dmg_mul = 0.75,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1900,
			acc = {0.1, 0.55},
			dmg_mul = 0.625,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2000,
			acc = {0.1, 0.55},
			dmg_mul = 0.5,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2100,
			acc = {0.1, 0.55},
			dmg_mul = 0.375,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2200,
			acc = {0.1, 0.55},
			dmg_mul = 0.25,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2300,
			acc = {0.1, 0.55},
			dmg_mul = 0.125,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2400,
			acc = {0, 0},
			dmg_mul = 0,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		}
	}
	presets.weapon.deathwish.flamethrower = deep_clone(presets.weapon.deathwish.is_shotgun_pump)
	presets.weapon.deathwish.flamethrower.autofire_rounds = {25, 50}
	presets.weapon.deathwish.flamethrower.RELOAD_SPEED = 0.5
	presets.weapon.deathwish.flamethrower.range = {
		close = 250,
		optimal = 750,
		far = 1400
	}
	presets.weapon.deathwish.flamethrower.FALLOFF = {
		{
			r = 250,
			acc = {1, 1},
			dmg_mul = 2.875,
			recoil = {0, 0},
			mode = {
				0,
				0,
				0,
				1
			},
			autofire_rounds = {25, 50}
		},
		{
			r = 500,
			acc = {0.5, 0.5},
			dmg_mul = 2.875,
			recoil = {0, 0},
			mode = {
				0,
				0,
				0,
				1
			},
			autofire_rounds = {25, 50}
		},
		{
			r = 1400,
			acc = {0.25, 0.25},
			dmg_mul = 2.875,
			recoil = {0, 0},
			mode = {
				0,
				0,
				0,
				1
			},
			autofire_rounds = {25, 50}
		},
		{
			r = 1401,
			acc = {0, 0},
			dmg_mul = 0,
			recoil = {0, 0},
			mode = {
				0,
				0,
				0,
				1
			},
			autofire_rounds = {25, 50}
		}
	}
	presets.weapon.deathwish.is_shotgun_mag.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 2.875,
			recoil = {0.4, 0.7},
			mode = {
				0,
				1,
				2,
				1
			}
		},
		{
			r = 500,
			acc = {0.4, 0.9},
			dmg_mul = 2.73125,
			recoil = {0.4, 0.7},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 600,
			acc = {0.4, 0.9},
			dmg_mul = 2.5875,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 700,
			acc = {0.4, 0.9},
			dmg_mul = 2.44375,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 800,
			acc = {0.4, 0.9},
			dmg_mul = 2.3,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 900,
			acc = {0.4, 0.75},
			dmg_mul = 2.15625,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1000,
			acc = {0.4, 0.75},
			dmg_mul = 2.0125,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1100,
			acc = {0.4, 0.75},
			dmg_mul = 1.86875,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1200,
			acc = {0.4, 0.75},
			dmg_mul = 1.725,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1300,
			acc = {0.4, 0.75},
			dmg_mul = 1.58125,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1400,
			acc = {0.4, 0.75},
			dmg_mul = 1.3125,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1500,
			acc = {0.4, 0.75},
			dmg_mul = 1.18125,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1600,
			acc = {0.4, 0.75},
			dmg_mul = 1.05,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1700,
			acc = {0.1, 0.55},
			dmg_mul = 0.91875,
			recoil = {0.45, 0.8},
			mode = {
				3,
				2,
				2,
				0
			}
		},
		{
			r = 1800,
			acc = {0.1, 0.55},
			dmg_mul = 0.75,
			recoil = {0.45, 0.8},
			mode = {
				3,
				2,
				2,
				0
			}
		},
		{
			r = 1900,
			acc = {0.1, 0.55},
			dmg_mul = 0.625,
			recoil = {0.45, 0.8},
			mode = {
				3,
				2,
				2,
				0
			}
		},
		{
			r = 2000,
			acc = {0.1, 0.55},
			dmg_mul = 0.5,
			recoil = {0.45, 0.8},
			mode = {
				3,
				2,
				2,
				0
			}
		},
		{
			r = 2100,
			acc = {0.1, 0.55},
			dmg_mul = 0.375,
			recoil = {0.45, 0.8},
			mode = {
				3,
				2,
				2,
				0
			}
		},
		{
			r = 2200,
			acc = {0.1, 0.55},
			dmg_mul = 0.25,
			recoil = {0.45, 0.8},
			mode = {
				3,
				2,
				2,
				0
			}
		},
		{
			r = 2300,
			acc = {0.1, 0.55},
			dmg_mul = 0.125,
			recoil = {0.45, 0.8},
			mode = {
				3,
				2,
				2,
				0
			}
		},
		{
			r = 2400,
			acc = {0.1, 0.55},
			dmg_mul = 0,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		}
	}
	presets.weapon.deathwish.is_pistol.melee_dmg = 12
	presets.weapon.deathwish.is_pistol.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 2.875,
			recoil = {0.15, 0.25},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 500,
			acc = {0.5, 0.9},
			dmg_mul = 2.875,
			recoil = {0.15, 0.3},
			mode = {
				1,
				0,
				1,
				0
			}
		},
		{
			r = 1000,
			acc = {0.4, 0.65},
			dmg_mul = 2.875,
			recoil = {0.15, 0.3},
			mode = {
				1,
				0,
				1,
				0
			}
		},
		{
			r = 1800,
			acc = {0.4, 0.65},
			dmg_mul = 2.625,
			recoil = {0.15, 0.3},
			mode = {
				1,
				0,
				1,
				0
			}
		},
		{
			r = 2000,
			acc = {0.3, 0.5},
			dmg_mul = 2.625,
			recoil = {0.4, 0.9},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 3000,
			acc = {0.1, 0.25},
			dmg_mul = 1.05,
			recoil = {0.4, 1.4},
			mode = {
				1,
				0,
				0,
				0
			}
		}
	}
	presets.weapon.deathwish.akimbo_pistol.melee_dmg = 12
	presets.weapon.deathwish.akimbo_pistol.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 2.875,
			recoil = {0.15, 0.25},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 500,
			acc = {0.5, 0.9},
			dmg_mul = 2.875,
			recoil = {0.15, 0.3},
			mode = {
				1,
				0,
				1,
				0
			}
		},
		{
			r = 1000,
			acc = {0.4, 0.65},
			dmg_mul = 2.875,
			recoil = {0.15, 0.3},
			mode = {
				1,
				0,
				1,
				0
			}
		},
		{
			r = 1800,
			acc = {0.4, 0.65},
			dmg_mul = 2.625,
			recoil = {0.15, 0.3},
			mode = {
				1,
				0,
				1,
				0
			}
		},
		{
			r = 2000,
			acc = {0.3, 0.5},
			dmg_mul = 2.625,
			recoil = {0.4, 0.9},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 3000,
			acc = {0.1, 0.25},
			dmg_mul = 1.05,
			recoil = {0.4, 1.4},
			mode = {
				1,
				0,
				0,
				0
			}
		}
	}
	presets.weapon.deathwish.mac11.melee_dmg = 12
	presets.weapon.deathwish.mac11.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 2.875,
			recoil = {0.5, 0.6},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 500,
			acc = {0.5, 0.85},
			dmg_mul = 2.875,
			recoil = {0.5, 0.65},
			mode = {
				0,
				1,
				3,
				1
			}
		},
		{
			r = 1000,
			acc = {0.3, 0.65},
			dmg_mul = 2.875,
			recoil = {0.55, 0.85},
			mode = {
				2,
				1,
				3,
				0
			}
		},
		{
			r = 1800,
			acc = {0.3, 0.65},
			dmg_mul = 2.625,
			recoil = {0.55, 0.85},
			mode = {
				2,
				1,
				3,
				0
			}
		},
		{
			r = 2000,
			acc = {0.35, 0.55},
			dmg_mul = 2.625,
			recoil = {0.65, 1},
			mode = {
				2,
				1,
				3,
				0
			}
		},
		{
			r = 3000,
			acc = {0.2, 0.35},
			dmg_mul = 1.05,
			recoil = {0.65, 1.2},
			mode = {
				4,
				1,
				0,
				0
			}
		}
	}
	presets.weapon.deathwish.is_revolver.melee_dmg = 12
	presets.weapon.deathwish.is_revolver.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 2.875,
			recoil = {0.8, 1},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 500,
			acc = {0.5, 0.85},
			dmg_mul = 2.875,
			recoil = {0.8, 1.1},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1000,
			acc = {0.375, 0.55},
			dmg_mul = 2.875,
			recoil = {0.8, 1.1},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1800,
			acc = {0.375, 0.55},
			dmg_mul = 2.625,
			recoil = {0.8, 1.1},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2000,
			acc = {0.25, 0.45},
			dmg_mul = 2.625,
			recoil = {1, 1.3},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 3000,
			acc = {0.01, 0.35},
			dmg_mul = 1.05,
			recoil = {1, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		}
	}
	presets.weapon.deathwish.is_rifle.melee_dmg = 12
	presets.weapon.deathwish.is_rifle.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 2.875,
			recoil = {0.4, 0.8},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 500,
			acc = {0.55, 0.95},
			dmg_mul = 2.875,
			recoil = {0.45, 0.8},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 1000,
			acc = {0.525, 0.8},
			dmg_mul = 2.875,
			recoil = {0.35, 0.75},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 1800,
			acc = {0.525, 0.8},
			dmg_mul = 2.625,
			recoil = {0.35, 0.75},
			mode = {
				1,
				2,
				2,
				0
			}
		},
		{
			r = 2000,
			acc = {0.5, 0.7},
			dmg_mul = 2.625,
			recoil = {0.4, 1.2},
			mode = {
				3,
				2,
				2,
				0
			}
		},
		{
			r = 3000,
			acc = {0.2, 0.4},
			dmg_mul = 1.05,
			recoil = {1.5, 3},
			mode = {
				3,
				1,
				1,
				0
			}
		}
	}
	presets.weapon.deathwish.is_bullpup = presets.weapon.deathwish.is_rifle
	presets.weapon.deathwish.is_smg.melee_dmg = 12
	presets.weapon.deathwish.is_smg.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.95},
			dmg_mul = 2.875,
			recoil = {0.1, 0.25},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 500,
			acc = {0.6, 0.9},
			dmg_mul = 2.875,
			recoil = {0.1, 0.3},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 1000,
			acc = {0.4, 0.65},
			dmg_mul = 2.875,
			recoil = {0.35, 0.5},
			mode = {
				0,
				3,
				3,
				0
			}
		},
		{
			r = 1800,
			acc = {0.4, 0.65},
			dmg_mul = 2.625,
			recoil = {0.35, 0.5},
			mode = {
				0,
				3,
				3,
				0
			}
		},
		{
			r = 2000,
			acc = {0.4, 0.6},
			dmg_mul = 2.625,
			recoil = {0.35, 0.7},
			mode = {
				0,
				3,
				3,
				0
			}
		},
		{
			r = 3000,
			acc = {0.2, 0.35},
			dmg_mul = 1.05,
			recoil = {0.5, 1.5},
			mode = {
				1,
				3,
				2,
				0
			}
		}
	}
	presets.weapon.deathwish.mp9.FALLOFF = {
		{
			r = 0,
			acc = {0.7, 0.95},
			dmg_mul = 2.875,
			recoil = {0.35, 0.55},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 700,
			acc = {0.5, 0.75},
			dmg_mul = 2.875,
			recoil = {0.35, 0.55},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 1000,
			acc = {0.45, 0.65},
			dmg_mul = 2.875,
			recoil = {1, 1.2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1800,
			acc = {0.45, 0.65},
			dmg_mul = 2.625,
			recoil = {1, 1.2},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2000,
			acc = {0.3, 0.5},
			dmg_mul = 2.625,
			recoil = {1.2, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 3000,
			acc = {0.1, 0.25},
			dmg_mul = 1.05,
			recoil = {1.2, 1.5},
			mode = {
				1,
				0,
				0,
				0
			}
		}
	}
	presets.weapon.deathwish.is_lmg.melee_dmg = 12
	presets.weapon.deathwish.is_lmg.FALLOFF = {
		{
			r = 100,
			acc = {0.7, 0.9},
			dmg_mul = 2.875,
			recoil = {0.4, 0.7},
			mode = {
				0,
				0,
				0,
				1
			}
		},
		{
			r = 500,
			acc = {0.5, 0.75},
			dmg_mul = 2.875,
			recoil = {0.5, 0.8},
			mode = {
				0,
				0,
				0,
				6
			}
		},
		{
			r = 1000,
			acc = {0.3, 0.6},
			dmg_mul = 2.875,
			recoil = {1, 1},
			mode = {
				0,
				0,
				2,
				6
			}
		},
		{
			r = 1800,
			acc = {0.3, 0.6},
			dmg_mul = 2.625,
			recoil = {1, 1},
			mode = {
				0,
				0,
				2,
				6
			}
		},
		{
			r = 2000,
			acc = {0.25, 0.55},
			dmg_mul = 2.625,
			recoil = {1, 1},
			mode = {
				0,
				0,
				2,
				6
			}
		},
		{
			r = 3000,
			acc = {0.15, 0.5},
			dmg_mul = 1.05,
			recoil = {1, 2},
			mode = {
				0,
				0,
				2,
				6
			}
		}
	}
	presets.weapon.deathwish.mini.melee_dmg = 12
	presets.weapon.deathwish.mini.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 2.875,
			recoil = {0.4, 0.7},
			mode = {
				0,
				0,
				0,
				1
			},
			autofire_rounds = {500, 700}
		},
		{
			r = 500,
			acc = {0.5, 0.7},
			dmg_mul = 2.875,
			recoil = {0.4, 0.7},
			mode = {
				0,
				0,
				0,
				1
			},
			autofire_rounds = {500, 500}
		},
		{
			r = 1000,
			acc = {0.4, 0.6},
			dmg_mul = 2.875,
			recoil = {0.45, 0.8},
			mode = {
				0,
				0,
				0,
				1
			},
			autofire_rounds = {300, 500}
		},
		{
			r = 1800,
			acc = {0.4, 0.6},
			dmg_mul = 2.625,
			recoil = {0.45, 0.8},
			mode = {
				1,
				3,
				6,
				6
			}
		},
		{
			r = 2000,
			acc = {0.2, 0.5},
			dmg_mul = 2.625,
			recoil = {0.45, 0.8},
			mode = {
				1,
				2,
				2,
				1
			}
		},
		{
			r = 3000,
			acc = {0.1, 0.35},
			dmg_mul = 1.05,
			recoil = {1, 1.2},
			mode = {
				4,
				2,
				1,
				0
			}
		}
	}
	presets.weapon.gang_member = deep_clone(presets.weapon.deathwish)
	presets.weapon.gang_member.is_pistol.aim_delay = {0, 0}
	presets.weapon.gang_member.is_pistol.focus_delay = 0
	presets.weapon.gang_member.is_pistol.focus_dis = 200
	presets.weapon.gang_member.is_pistol.spread = 25
	presets.weapon.gang_member.is_pistol.miss_dis = 20
	presets.weapon.gang_member.is_pistol.RELOAD_SPEED = 1.5
	presets.weapon.gang_member.is_pistol.melee_speed = 3
	presets.weapon.gang_member.is_pistol.melee_dmg = 5
	presets.weapon.gang_member.is_pistol.melee_retry_delay = presets.weapon.normal.is_pistol.melee_retry_delay
	presets.weapon.gang_member.is_pistol.range = presets.weapon.normal.is_pistol.range
	presets.weapon.gang_member.is_pistol.FALLOFF = {
		{
			r = 300,
			acc = {1, 1},
			dmg_mul = 1.25,
			recoil = {0.25, 0.45},
			mode = {
				0.1,
				0.3,
				4,
				7
			}
		},
		{
			r = 10000,
			acc = {1, 1},
			dmg_mul = 1.25,
			recoil = {2, 3},
			mode = {
				0.1,
				0.3,
				4,
				7
			}
		}
	}
	presets.weapon.gang_member.is_rifle.aim_delay = {0, 0}
	presets.weapon.gang_member.is_rifle.focus_delay = 0
	presets.weapon.gang_member.is_rifle.focus_dis = 200
	presets.weapon.gang_member.is_rifle.spread = 20
	presets.weapon.gang_member.is_rifle.miss_dis = 40
	presets.weapon.gang_member.is_rifle.RELOAD_SPEED = 1
	presets.weapon.gang_member.is_rifle.melee_speed = 1
	presets.weapon.gang_member.is_rifle.melee_dmg = 5
	presets.weapon.gang_member.is_rifle.melee_retry_delay = presets.weapon.normal.is_rifle.melee_retry_delay
	presets.weapon.gang_member.is_rifle.range = {
		close = 1500,
		optimal = 2500,
		far = 6000
	}
	presets.weapon.gang_member.is_rifle.autofire_rounds = presets.weapon.normal.is_rifle.autofire_rounds
	presets.weapon.gang_member.is_rifle.FALLOFF = {
		{
			r = 300,
			acc = {0.9, 0.975},
			dmg_mul = 1.25,
			recoil = {0.25, 0.3},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 2000,
			acc = {0.875, 0.95},
			dmg_mul = 1.25,
			recoil = {0.25, 0.3},
			mode = {
				0,
				3,
				8,
				1
			}
		},
		{
			r = 10000,
			acc = {0.7, 0.9},
			dmg_mul = 1.25,
			recoil = {0.35, 0.55},
			mode = {
				0,
				2,
				5,
				1
			}
		}
	}
	presets.weapon.gang_member.is_bullpup = presets.weapon.gang_member.is_rifle
	presets.weapon.gang_member.is_shotgun_pump.aim_delay = {0, 0}
	presets.weapon.gang_member.is_shotgun_pump.focus_delay = 0
	presets.weapon.gang_member.is_shotgun_pump.focus_dis = 200
	presets.weapon.gang_member.is_shotgun_pump.spread = 15
	presets.weapon.gang_member.is_shotgun_pump.miss_dis = 20
	presets.weapon.gang_member.is_shotgun_pump.RELOAD_SPEED = 1
	presets.weapon.gang_member.is_shotgun_pump.melee_speed = 1
	presets.weapon.gang_member.is_shotgun_pump.melee_dmg = 5
	presets.weapon.gang_member.is_shotgun_pump.melee_retry_delay = presets.weapon.normal.is_shotgun_pump.melee_retry_delay
	presets.weapon.gang_member.is_shotgun_pump.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 1,
			recoil = {0.75, 0.75},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 900,
			acc = {0.6, 0.9},
			dmg_mul = 1,
			recoil = {0.75, 0.75},
			mode = {
				1,
				0,
				0,
				0
			}
		},		
		{
			r = 1000,
			acc = {0.4, 0.9},
			dmg_mul = 0.95,
			recoil = {0.75, 0.75},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1100,
			acc = {0.4, 0.9},
			dmg_mul = 0.9,
			recoil = {0.75, 0.75},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1200,
			acc = {0.4, 0.9},
			dmg_mul = 0.85,
			recoil = {0.75, 0.75},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1300,
			acc = {0.4, 0.9},
			dmg_mul = 0.8,
			recoil = {0.75, 0.75},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1400,
			acc = {0.4, 0.9},
			dmg_mul = 0.75,
			recoil = {0.75, 0.75},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1500,
			acc = {0.4, 0.75},
			dmg_mul = 0.7,
			recoil = {0.75, 0.75},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1600,
			acc = {0.4, 0.75},
			dmg_mul = 0.65,
			recoil = {0.75, 0.75},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1700,
			acc = {0.4, 0.75},
			dmg_mul = 0.6,
			recoil = {0.75, 0.75},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1800,
			acc = {0.4, 0.75},
			dmg_mul = 0.55,
			recoil = {0.75, 0.75},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1900,
			acc = {0.4, 0.75},
			dmg_mul = 0.5,
			recoil = {0.75, 0.75},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2000,
			acc = {0.4, 0.75},
			dmg_mul = 0.45,
			recoil = {0.75, 0.75},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2100,
			acc = {0.1, 0.55},
			dmg_mul = 0.4,
			recoil = {0.75, 0.75},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2200,
			acc = {0.1, 0.55},
			dmg_mul = 0.35,
			recoil = {0.75, 0.75},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2300,
			acc = {0.1, 0.55},
			dmg_mul = 0.3,
			recoil = {0.75, 0.75},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2400,
			acc = {0.1, 0.55},
			dmg_mul = 0.25,
			recoil = {0.75, 0.75},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2500,
			acc = {0.1, 0.55},
			dmg_mul = 0.2,
			recoil = {0.75, 0.75},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2600,
			acc = {0.1, 0.55},
			dmg_mul = 0.15,
			recoil = {0.75, 0.75},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2700,
			acc = {0.1, 0.55},
			dmg_mul = 0.1,
			recoil = {0.75, 0.75},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2800,
			acc = {0.1, 0.55},
			dmg_mul = 0.05,
			recoil = {0.75, 0.75},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2900,
			acc = {0, 0},
			dmg_mul = 0,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		}
	}	
	presets.weapon.gang_member.mossberg = deep_clone(presets.weapon.gang_member.is_shotgun_pump)
	presets.weapon.gang_member.mossberg.RELOAD_SPEED = 1.5
	presets.weapon.gang_member.is_smg = deep_clone(presets.weapon.gang_member.is_rifle)
	presets.weapon.gang_member.is_smg.FALLOFF = {
		{
			r = 300,
			acc = {0.9, 0.975},
			dmg_mul = 1.25,
			recoil = {0.25, 0.3},
			mode = {
				0,
				3,
				3,
				1
			}
		},
		{
			r = 2000,
			acc = {0.875, 0.95},
			dmg_mul = 1.25,
			recoil = {0.25, 0.3},
			mode = {
				0,
				3,
				8,
				1
			}
		},
		{
			r = 10000,
			acc = {0.7, 0.9},
			dmg_mul = 1.25,
			recoil = {0.35, 0.55},
			mode = {
				0,
				2,
				5,
				1
			}
		}
	}
	presets.weapon.gang_member.is_revolver = presets.weapon.gang_member.is_pistol
	presets.weapon.gang_member.is_lmg = deep_clone(presets.weapon.gang_member.is_rifle)
	presets.weapon.gang_member.is_lmg.FALLOFF = {
		{
			r = 300,
			acc = {0.7, 0.9},
			dmg_mul = 1.25,
			recoil = {0, 0.1},
			mode = {
				0,
				0,
				0,
				1
			}
		},
		{
			r = 2000,
			acc = {0.5, 0.75},
			dmg_mul = 1.25,
			recoil = {0.1, 0.2},
			mode = {
				0,
				0,
				0,
				1
			}
		},
		{
			r = 10000,
			acc = {0.3, 0.6},
			dmg_mul = 1.25,
			recoil = {0.4, 0.6},
			mode = {
				1,
				3,
				6,
				6
			}
		}
	}
	presets.weapon.gang_member.mossberg = deep_clone(presets.weapon.gang_member.is_shotgun_pump)
	presets.weapon.gang_member.mossberg.RELOAD_SPEED = 3
	presets.weapon.gang_member.mac11 = presets.weapon.gang_member.is_smg
	presets.weapon.gang_member.rifle = deep_clone(presets.weapon.gang_member.is_rifle)
	presets.weapon.gang_member.rifle.spread = 5
	presets.weapon.gang_member.rifle.autofire_rounds = nil
	presets.weapon.gang_member.rifle.FALLOFF = {
		{
			r = 100,
			acc = {1, 1},
			dmg_mul = 1.25,
			recoil = {1, 1},
			mode = {
				1,
				1,
				1,
				1
			}
		},
		{
			r = 3000,
			acc = {0.95, 1},
			dmg_mul = 1.25,
			recoil = {1, 1},
			mode = {
				1,
				1,
				1,
				1
			}
		},
		{
			r = 10000,
			acc = {0.9, 0.95},
			dmg_mul = 1.25,
			recoil = {1, 1},
			mode = {
				1,
				1,
				1,
				1
			}
		}
	}
	presets.weapon.gang_member.akimbo_pistol = presets.weapon.gang_member.is_pistol
	presets.weapon.gang_member.is_shotgun_mag.aim_delay = {0, 0}
	presets.weapon.gang_member.is_shotgun_mag.focus_delay = 0
	presets.weapon.gang_member.is_shotgun_mag.focus_dis = 200
	presets.weapon.gang_member.is_shotgun_mag.spread = 15
	presets.weapon.gang_member.is_shotgun_mag.miss_dis = 20
	presets.weapon.gang_member.is_shotgun_mag.melee_speed = 1
	presets.weapon.gang_member.is_shotgun_mag.melee_dmg = 5
	presets.weapon.gang_member.is_shotgun_mag.melee_retry_delay = presets.weapon.normal.is_shotgun_pump.melee_retry_delay
	presets.weapon.gang_member.is_shotgun_mag.RELOAD_SPEED = 1
	presets.weapon.gang_member.is_shotgun_mag.autofire_rounds = {4, 9}
	presets.weapon.gang_member.is_shotgun_mag.FALLOFF = {
		{
			r = 100,
			acc = {0.6, 0.9},
			dmg_mul = 1,
			recoil = {0.4, 0.7},
			mode = {
				0,
				1,
				2,
				1
			}
		},
		{
			r = 900,
			acc = {0.6, 0.9},
			dmg_mul = 1,
			recoil = {0.4, 0.7},
			mode = {
				0,
				1,
				2,
				1
			}
		},		
		{
			r = 1000,
			acc = {0.4, 0.9},
			dmg_mul = 0.95,
			recoil = {0.4, 0.7},
			mode = {
				0,
				1,
				2,
				1
			}
		},
		{
			r = 1100,
			acc = {0.4, 0.9},
			dmg_mul = 0.9,
			recoil = {0.4, 0.7},
			mode = {
				0,
				1,
				2,
				1
			}
		},
		{
			r = 1200,
			acc = {0.4, 0.9},
			dmg_mul = 0.85,
			recoil = {0.4, 0.7},
			mode = {
				0,
				1,
				2,
				1
			}
		},
		{
			r = 1300,
			acc = {0.4, 0.9},
			dmg_mul = 0.8,
			recoil = {0.4, 0.7},
			mode = {
				0,
				1,
				2,
				1
			}
		},
		{
			r = 1400,
			acc = {0.4, 0.9},
			dmg_mul = 0.75,
			recoil = {0.4, 0.7},
			mode = {
				0,
				1,
				2,
				1
			}
		},
		{
			r = 1500,
			acc = {0.4, 0.75},
			dmg_mul = 0.7,
			recoil = {0.4, 0.7},
			mode = {
				0,
				1,
				2,
				1
			}
		},
		{
			r = 1600,
			acc = {0.4, 0.75},
			dmg_mul = 0.65,
			recoil = {0.4, 0.7},
			mode = {
				0,
				1,
				2,
				1
			}
		},
		{
			r = 1700,
			acc = {0.4, 0.75},
			dmg_mul = 0.6,
			recoil = {0.4, 0.7},
			mode = {
				0,
				1,
				2,
				1
			}
		},
		{
			r = 1800,
			acc = {0.4, 0.75},
			dmg_mul = 0.55,
			recoil = {0.4, 0.7},
			mode = {
				0,
				1,
				2,
				1
			}
		},
		{
			r = 1900,
			acc = {0.4, 0.75},
			dmg_mul = 0.5,
			recoil = {0.4, 0.7},
			mode = {
				0,
				1,
				2,
				1
			}
		},
		{
			r = 2000,
			acc = {0.4, 0.75},
			dmg_mul = 0.45,
			recoil = {0.4, 0.7},
			mode = {
				0,
				1,
				2,
				1
			}
		},
		{
			r = 2100,
			acc = {0.1, 0.55},
			dmg_mul = 0.4,
			recoil = {0.4, 0.7},
			mode = {
				0,
				1,
				2,
				1
			}
		},
		{
			r = 2200,
			acc = {0.1, 0.55},
			dmg_mul = 0.35,
			recoil = {0.4, 0.7},
			mode = {
				0,
				1,
				2,
				1
			}
		},
		{
			r = 2300,
			acc = {0.1, 0.55},
			dmg_mul = 0.3,
			recoil = {0.4, 0.7},
			mode = {
				0,
				1,
				2,
				1
			}
		},
		{
			r = 2400,
			acc = {0.1, 0.55},
			dmg_mul = 0.25,
			recoil = {0.4, 0.7},
			mode = {
				0,
				1,
				2,
				1
			}
		},
		{
			r = 2500,
			acc = {0.1, 0.55},
			dmg_mul = 0.2,
			recoil = {0.4, 0.7},
			mode = {
				0,
				1,
				2,
				1
			}
		},
		{
			r = 2600,
			acc = {0.1, 0.55},
			dmg_mul = 0.15,
			recoil = {0.4, 0.7},
			mode = {
				0,
				1,
				2,
				1
			}
		},
		{
			r = 2700,
			acc = {0.1, 0.55},
			dmg_mul = 0.1,
			recoil = {0.4, 0.7},
			mode = {
				0,
				1,
				2,
				1
			}
		},
		{
			r = 2800,
			acc = {0.1, 0.55},
			dmg_mul = 0.05,
			recoil = {0.4, 0.7},
			mode = {
				0,
				1,
				2,
				1
			}
		},
		{
			r = 2900,
			acc = {0, 0},
			dmg_mul = 0,
			recoil = {1.5, 2},
			mode = {
				1,
				0,
				0,
				0
			}
		}
	}		
	presets.weapon.gang_member.is_sniper = deep_clone(presets.weapon.gang_member.rifle)
	RestorationCore.log_shit("SC: normal presets")
	presets.weapon.normal.akimbo_pistol = deep_clone(presets.weapon.normal.is_pistol)
	presets.weapon.normal.mac11 = deep_clone(presets.weapon.normal.is_pistol)
	presets.weapon.normal.rifle = deep_clone(presets.weapon.normal.is_rifle)
	presets.weapon.normal.is_sniper = deep_clone(presets.weapon.normal.rifle)
	
	RestorationCore.log_shit("SC: good presets")
	presets.weapon.good.akimbo_pistol = deep_clone(presets.weapon.good.is_pistol)
	presets.weapon.good.mac11 = deep_clone(presets.weapon.good.is_pistol)
	presets.weapon.good.rifle = deep_clone(presets.weapon.good.is_rifle)
	presets.weapon.good.is_sniper = deep_clone(presets.weapon.good.rifle)
	
	RestorationCore.log_shit("SC: expert presets")
	presets.weapon.expert.akimbo_pistol = deep_clone(presets.weapon.expert.is_pistol)
	presets.weapon.expert.mac11 = deep_clone(presets.weapon.expert.is_pistol)
	presets.weapon.expert.rifle = deep_clone(presets.weapon.expert.is_rifle)
	presets.weapon.expert.is_sniper = deep_clone(presets.weapon.expert.rifle)

	RestorationCore.log_shit("SC: deathwish presets")
	presets.weapon.deathwish.akimbo_pistol = deep_clone(presets.weapon.deathwish.is_pistol)
	presets.weapon.deathwish.mac11 = deep_clone(presets.weapon.deathwish.is_pistol)
	presets.weapon.deathwish.rifle = deep_clone(presets.weapon.deathwish.is_rifle)
	presets.weapon.deathwish.is_sniper = deep_clone(presets.weapon.deathwish.rifle)
	
	presets.weapon.sniper = deep_clone(presets.weapon.normal)
	presets.weapon.sniper.is_rifle.aim_delay = {0.1, 0.1}
	presets.weapon.sniper.is_rifle.focus_delay = 7
	presets.weapon.sniper.is_rifle.focus_dis = 200
	presets.weapon.sniper.is_rifle.spread = 30
	presets.weapon.sniper.is_rifle.miss_dis = 250
	presets.weapon.sniper.is_rifle.RELOAD_SPEED = 1
	presets.weapon.sniper.is_rifle.melee_speed = presets.weapon.normal.is_rifle.melee_speed
	presets.weapon.sniper.is_rifle.melee_dmg = 5
	presets.weapon.sniper.is_rifle.melee_retry_delay = presets.weapon.normal.is_rifle.melee_retry_delay
	presets.weapon.sniper.is_rifle.range = {
		close = 15000,
		optimal = 15000,
		far = 15000
	}
	presets.weapon.sniper.is_rifle.use_laser = true
	presets.weapon.sniper.is_rifle.FALLOFF = {
		{
			r = 1000,
			acc = {0.7, 0.95},
			dmg_mul = 1,
			recoil = {3, 6},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2000,
			acc = {0.7, 0.95},
			dmg_mul = 1,
			recoil = {3, 6},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 4000,
			acc = {0.5, 0.95},
			dmg_mul = 1,
			recoil = {4, 6},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 6000,
			acc = {0.5, 0.85},
			dmg_mul = 1,
			recoil = {4, 6},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 8000,
			acc = {0.5, 0.75},
			dmg_mul = 1,
			recoil = {4, 6},
			mode = {
				1,
				0,
				0,
				0
			}
		}
	}
	presets.weapon.sniper_good = deep_clone(presets.weapon.sniper)
	presets.weapon.sniper_good.is_rifle.melee_dmg = 10
	presets.weapon.sniper_good.is_rifle.FALLOFF = {
		{
			r = 1000,
			acc = {0.7, 0.95},
			dmg_mul = 2,
			recoil = {3, 6},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2000,
			acc = {0.7, 0.95},
			dmg_mul = 2,
			recoil = {3, 6},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 4000,
			acc = {0.5, 0.95},
			dmg_mul = 2,
			recoil = {4, 6},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 6000,
			acc = {0.5, 0.85},
			dmg_mul = 1,
			recoil = {4, 6},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 8000,
			acc = {0.5, 0.75},
			dmg_mul = 1,
			recoil = {4, 6},
			mode = {
				1,
				0,
				0,
				0
			}
		}
	}
	presets.weapon.sniper_expert = deep_clone(presets.weapon.sniper)
	presets.weapon.sniper_expert.is_rifle.melee_dmg = 12
	presets.weapon.sniper_expert.is_rifle.FALLOFF = {
		{
			r = 1000,
			acc = {0.7, 1},
			dmg_mul = 2.3,
			recoil = {3, 5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1800,
			acc = {0.7, 1},
			dmg_mul = 2.1,
			recoil = {3, 5},
			mode = {
				1,
				0,
				0,
				0
			}
		},		
		{
			r = 2000,
			acc = {0.7, 1},
			dmg_mul = 2.1,
			recoil = {3, 5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 4000,
			acc = {0.6, 0.95},
			dmg_mul = 2.1,
			recoil = {3, 5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 6000,
			acc = {0.6, 0.85},
			dmg_mul = 1.05,
			recoil = {3, 5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 8000,
			acc = {0.6, 0.75},
			dmg_mul = 1.05,
			recoil = {3, 5},
			mode = {
				1,
				0,
				0,
				0
			}
		}
	}
	presets.weapon.sniper_deathwish = deep_clone(presets.weapon.sniper)
	presets.weapon.sniper_deathwish.is_rifle.melee_dmg = 12
	presets.weapon.sniper_deathwish.is_rifle.FALLOFF = {
		{
			r = 1000,
			acc = {0.7, 1},
			dmg_mul = 2.875,
			recoil = {3, 5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 1800,
			acc = {0.7, 1},
			dmg_mul = 2.625,
			recoil = {3, 5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 2000,
			acc = {0.7, 1},
			dmg_mul = 2.625,
			recoil = {3, 5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 4000,
			acc = {0.6, 0.95},
			dmg_mul = 2.625,
			recoil = {3, 5},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			r = 6000,
			acc = {0.6, 0.85},
			dmg_mul = 1.05,
			recoil = {3, 5},
			mode = {
				1,
				0,
				0,
				0
			}
		}
	}
	presets.base.use_pdth_shit = false
	presets.dodge.deathvox = {
		speed = 1.7,
		occasions = {
			hit = {
				chance = 1,
				check_timeout = {0, 3},
				variations = {
					side_step = {
						chance = 3,
						timeout = {1, 2},
						shoot_chance = 1,
						shoot_accuracy = 0.8
					},
					roll = {
						chance = 1,
						timeout = {1.2, 2}
					}
				}
			},
			preemptive = {
				chance = 0.9,
				check_timeout = {0, 3},
				variations = {
					side_step = {
						chance = 3,
						timeout = {1, 2},
						shoot_chance = 1,
						shoot_accuracy = 0.8
					},
					roll = {
						chance = 1,
						timeout = {1.2, 2}
					}
				}
			},
			scared = {
				chance = 0.9,
				check_timeout = {0, 3},
				variations = {
					side_step = {
						chance = 5,
						timeout = {1, 2},
						shoot_chance = 1,
						shoot_accuracy = 0.7
					},
					roll = {
						chance = 3,
						timeout = {1.2, 2}
					},
					dive = {
						chance = 1,
						timeout = {1.2, 2}
					}
				}
			}
		}
	}
	presets.dodge.deathvoxninja = {
		speed = 1.7,
		occasions = {
			hit = {
				chance = 1,
				check_timeout = {0, 1},
				variations = {
					roll = {
						chance = 2,
						timeout = {1, 1.5}
					},
					wheel = {
						chance = 1,
						shoot_chance = 0.9,
						shoot_accuracy = 0.8,
						timeout = {1, 1.5}
					}
				}
			},
			preemptive = {
				chance = 1,
				check_timeout = {0, .6},
				variations = {
					side_step = {
						chance = 1,
						shoot_chance = 0.8,
						shoot_accuracy = 0.6,
						timeout = {1, 1.5}
					},
					roll = {
						chance = 2,
						timeout = {1, 1.5}
					},
					wheel = {
						chance = 2,
						shoot_chance = 0.9,
						shoot_accuracy = 0.8,
						timeout = {1, 1.5}
					}
				}
			},
			scared = {
				chance = 1,
				check_timeout = {0, 0.6},
				variations = {
					side_step = {
						chance = 1,
						shoot_chance = 0.8,
						shoot_accuracy = 0.6,
						timeout = {1, 1.5}
					},
					roll = {
						chance = 3,
						timeout = {1, 1.5}
					},
					wheel = {
						chance = 3,
						shoot_chance = 0.9,
						shoot_accuracy = 0.8,
						timeout = {1, 1.5}
					}
				}
			}
		}
	}
	presets.dodge.deathvox_guard = {
		speed = 1.2,
		occasions = {
			hit = {
				chance = 1,
				check_timeout = {0, 3},
				variations = {
					side_step = {
						chance = 3,
						timeout = {1, 2},
					},
					roll = {
						chance = 1,
						timeout = {1.2, 2}
					}
				}
			},
			scared = {
				chance = 0.9,
				check_timeout = {0, 3},
				variations = {
					side_step = {
						chance = 5,
						timeout = {1, 2},
					},
					roll = {
						chance = 3,
						timeout = {1.2, 2}
					}
				}
			}
		}
	}		
	--[[presets.weapon.deathvox = {
		is_pistol = {},-- used for guards and numerous scripted enemies, as well as beat police. Assumes base damage 40.
		is_revolver = {},-- used for medics and numerous scripted enemies, as well as beat police. Assumes base damage 60.
		is_rifle = {}, -- clones heavy ar. Used enemy types unknown. assumes base damage 75.
		is_lmg = {},-- used for scripted boss enemies, lmg dozers. Assumes base damage 100.
		is_shotgun_pump = {}, -- used for green dozers. Assumes base damage 400.
		is_shotgun_mag = {}, -- used for saiga dozers. Assumes base damage 225.
		mossberg = {}, -- scripted enemy (e.g. beat cop) shotgun. clones light shotgun. Assumes base damage 75.
		is_smg = {}, -- Ased for shield, variety of enemies. Assumes base damage 45.
		mp9 = {}, -- Clones smg. Used primarily by security, FBI HRT.
		rifle = {}, -- clones light ar. Used enemy types unknown. Assumes base damage 60.
		mac11 = {}, -- Clones smg. Used primarily by criminal enemies. Assumes base damage 45.
		akimbo_pistol = {}, -- used by boss enemy on Panic Room. Clones pistol.
		mini = {}, -- unused aside from Spring, crime spree enemy. Will revise in future build for possible scripted use.
		flamethrower = {}, -- Used for Summers.
		is_light_rifle = {}, -- Used for light AR SWAT, Tasers, Grenadiers. Assumes base damage 60.
		is_heavy_rifle = {}, -- Used for heavy AR. Assumes base damage 75.
		is_light_shotgun = {}, -- Used for light shotgun SWAT. Assumes base damage 75.
		is_heavy_shotgun = {}, -- Used for heavy shotgun SWAT. Assumes base damage 100.
		is_tank_smg = {}, -- used for medic dozer. Clones smg. Assumes base damage 45.
		is_bullpup = {}, -- clones light rifle. Assumes base damage 60.
		is_sniper = {}, -- initializing sniper. Assumes base damage 240.
		is_assault_sniper = {} -- initializing assault sniper preset. Assumes base damage 240.
	}]]--
	presets.weapon.deathvox = deep_clone(presets.weapon.deathwish)
	--note to self- clean up is_revolver and make consistent.
	presets.weapon.deathvox.is_revolver = { -- used by medics.
		aim_delay = { -- mark 3 values complete.
		0,
		0
		},
		focus_delay = 10, -- validated, unchanged.
		focus_dis = 200,
		spread = 20,
		miss_dis = 50,
		RELOAD_SPEED = 0.9, --validated, unchanged.
		melee_speed = 1,
		melee_dmg = 8,
		melee_retry_delay = {
		1,
		2
		},
		range = { --validated, unchanged, consider adjustment to increase engage range.
			optimal = 2000,
			far = 5000,
			close = 1000
		},
		FALLOFF = { 
			{
				dmg_mul = 1,
				r = 100,
				acc = {
					0.7, --note to self 2 values show acc increase with focus delay
					0.9
				},
				recoil = {
					0.8,
					1
				},
				mode = {
					1,
					0,
					0,
					0
				}
			},
			{
				dmg_mul = .8, -- new from mark 1.
				r = 500,
				acc = {
					0.6,
					0.85
				},
				recoil = {
					0.8,
					1.1
				},
				mode = {
					1,
					0,
					0,
					0
				}
			},
			{
				dmg_mul = 0.65,
				r = 1000,
				acc = {
					0.5,
					0.75
				},
				recoil = {
					0.8,
					1.1
				},
				mode = {
					1,
					0,
					0,
					0
				}
			},
			{
				dmg_mul = 0.5,
				r = 2000,
				acc = {
					0.5,
					0.65
				},
				recoil = {
					1,
					1.3
				},
				mode = {
					1,
					0,
					0,
					0
				}
			},
			{
				dmg_mul = 0.37,
				r = 3000,
				acc = {
					0.1,
					0.35
				},
				recoil = {
					1,
					1.5
				},
				mode = {
					1,
					0,
					0,
					0
				}
			}
		}
	}
	presets.weapon.deathvox.is_pistol = { -- mark 3 values complete. Currently valid for guards, beat police, low level enemies. basis: presets.weapon.deathwish.is_pistol.
		aim_delay = {
			0,
			0
		},
		focus_delay = 0,
		focus_dis = 200,
		spread = 20,
		miss_dis = 50,
		RELOAD_SPEED = 1.4, -- validated, unchanged.
		melee_speed = presets.weapon.expert.is_pistol.melee_speed,
		melee_dmg = 20,
		melee_retry_delay = presets.weapon.expert.is_pistol.melee_retry_delay,
		range = {
			optimal = 3200, -- validated, unchanged.
			far = 5000,
			close = 2000
		},
		FALLOFF = {
			{
				dmg_mul = 1,
				r = 100,
				acc = {
					0.9,
					0.95
				},
				recoil = {
					0.15,
					0.25
				},
				mode = {
					0,
					0,
					1,
					0
				}
			},
			{
				dmg_mul = 1,
				r = 500,
				acc = {
					0.9,
					0.95
				},
				recoil = {
					0.15,
					0.3
				},
				mode = {
					0,
					0,
					1,
					0
				}
			},
			{
				dmg_mul = .8,
				r = 1000,
				acc = {
					0.7,
					0.8
				},
				recoil = {
					0.25,
					0.3
				},
				mode = {
					0,
					1,
					0,
					0
				}
			},
			{
				dmg_mul = .65,
				r = 2000,
				acc = {
					0.6,
					0.7
				},
				recoil = {
					0.4,
					0.5
				},
				mode = {
					1,
					0,
					0,
					0
				}
			},
			{
				dmg_mul = .6,
				r = 3000,
				acc = {
					0.6,
					0.65
				},
				recoil = {
					0.6,
					0.8
				},
				mode = {
					1,
					0,
					0,
					0
				}
			},
			{
				dmg_mul = .5, -- no flat damage.
				r = 4000,
				acc = {
					0.2,
					0.60 -- no infinite range.
				},
				recoil = {
					1,
					1.5
				},
				mode = {
					1,
					0,
					0,
					0
				}
			}
		}
	}
	presets.weapon.deathvox.is_shotgun_pump = { -- mark 4 values complete. Assumes base damage 400. basis is presets.weapon.deathwish.is_shotgun_pump. Extremely dangerous close range, much less so further out.
		aim_delay = {
			0,
			0
		},
		focus_delay = 5, -- re-added from lower difficulties.
		focus_dis = 200,
		spread = 15,
		miss_dis = 20,
		RELOAD_SPEED = 1.4, --unchanged, validated.
		melee_speed = 1,
		melee_dmg = 20,
		melee_retry_delay = presets.weapon.expert.is_shotgun_pump.melee_retry_delay,
		range = { -- using expert ranges. Should have effect of causing enemy to fire when closer.
			optimal = 2000,
			far = 5000,
			close = 1000
		},
		FALLOFF = {
			{
				dmg_mul = 1,
				r = 100,
				acc = { -- Vanilla .95-.95.
					0.95,
					1
				},
				recoil = {
					1,
					1.1
				},
				mode = {
					1,
					0,
					0,
					0
				}
			},
			{
				dmg_mul = 1, -- no falloff to 5 meters. Falloff arc undergoes bifurcal distortion.
				r = 500,
				acc = {
					0.7,
					0.95
				},
				recoil = {
					1,
					1.25
				},
				mode = {
					1,
					0,
					0,
					0
				}
			},
			{
				dmg_mul = .875,
				r = 1000,
				acc = {
					0.5,
					0.8
				},
				recoil = {
					1,
					1.5
				},
				mode = {
					1,
					0,
					0,
					0
				}
			},
			{
				dmg_mul = .350,
				r = 2000,
				acc = {
					0.45,
					0.65
				},
				recoil = {
					1.25,
					1.5
				},
				mode = {
					1,
					0,
					0,
					0
				}
			},
			{
				dmg_mul = .150,
				r = 3000,
				acc = {
					0.3,
					0.5
				},
				recoil = { -- greater max recoil for conveyance purposes.
					1.5,
					2.25
				},
				mode = {
					1,
					0,
					0,
					0
				}
			}
		}
	}
	presets.weapon.deathvox.is_shotgun_mag = { -- mark 3 values complete. assumes base damage 225. Basis is presets.weapon.deathwish.is_shotgun_pump. Much more even arc distribution-focus/shotcount becomes crucial.
		aim_delay = {
			0,
			0
		},
		focus_delay = 5, -- re-added from lower difficulties.
		focus_dis = 200,
		spread = 15,
		miss_dis = 20,
		RELOAD_SPEED = 1.4, --unchanged, validated.
		melee_speed = 1,
		melee_dmg = 20,
		melee_retry_delay = presets.weapon.expert.is_shotgun_pump.melee_retry_delay,
		range = {
			optimal = 3000,
			far = 5000,
			close = 2000
		},
		FALLOFF = {
			{
				dmg_mul = 1,
				r = 100,
				acc = {
					0.95,
					0.95
				},
				recoil = {
					1,
					1.1
				},
				mode = {
					0,
					0,
					1,
					0
				}
			},
			{
				dmg_mul = 1,
				r = 500,
				acc = { -- reduced lower end, vanilla .7.
					0.5,
					0.95
				},
				recoil = {
					1,
					1.25
				},
				mode = {
					0,
					0,
					1,
					0
				}
			},
			{
				dmg_mul = .93,
				r = 1000,
				acc = { -- reduced lower end, vanilla .5.
					0.4,
					0.85
				},
				recoil = {
					1,
					1.5
				},
				mode = {
					1,
					1,
					0,
					0
				}
			},
			{
				dmg_mul = .7,
				r = 2000,
				acc = { -- reduced lower end, vanilla .35.
					0.35,
					0.65
				},
				recoil = {
					1.25,
					1.5
				},
				mode = {
					1,
					1,
					0,
					0
				}
			},
			{
				dmg_mul = .3,
				r = 3000,
				acc = {
					0.3,
					0.5
				},
				recoil = {
					1.5,
					1.75
				},
				mode = {
					1,
					0,
					0,
					0
				}
			}
		}
	}

	presets.weapon.deathvox.is_light_rifle = { -- mark 3 values complete. basis is presets.weapon.deathwish.is_rifle. General goal- more shots, less damage, reduced range.
		aim_delay = {
			0,
			0
		},
		focus_delay = 3, -- Re-added from lower difficulties.
		focus_dis = 200,
		spread = 20,
		miss_dis = 40,
		RELOAD_SPEED = 1.4, -- validated, unchanged.
		melee_speed = 1,
		melee_dmg = 20,
		tase_distance = 1500,
		aim_delay_tase = {
			0,
			0
		},
		tase_sphere_cast_radius = 30,
		melee_retry_delay = presets.weapon.expert.is_rifle.melee_retry_delay,
		range = { 
			optimal = 3500,
			far = 6000,  -- currently unchanged. Consider adjustment if needed to improve differentiation. Light should prefer closer range, if so.
			close = 2000
		},
		autofire_rounds = {
			4,
			9
		},
		FALLOFF = {
			{
				dmg_mul = 1,
				r = 100,
				acc = {
					0.9,
					0.975
				},
				recoil = {
					0.25,
					0.3
				},
				mode = {
					0,
					0,
					1,
					0
				}
			},
			{
				dmg_mul = 1,
				r = 500,
				acc = {
					0.875,
					0.95
				},
				recoil = {
					0.25,
					0.3
				},
				mode = {
					0,
					0,
					1,
					0
				}
			},
			{
				dmg_mul = 0.8, --falloff after 5 meters, no flat damage.
				r = 1000,
				acc = {
					0.7,
					0.9
				},
				recoil = { --reduced to increase attack rate at lower range. Vanilla values .35-.55. No changes to later ranges.
					0.25,
					0.45
				},
				mode = {
					0,
					1,
					1,
					0
				}
			},
			{
				dmg_mul = 0.7,
				r = 2000,
				acc = {
					0.7,
					0.85
				},
				recoil = {
					0.4,
					0.7
				},
				mode = {
					0,
					1,
					1,
					0
				}
			},
			{
				dmg_mul = 0.6,
				r = 3000,
				acc = { -- reduced accuracy begins here. vanilla values .65-.75.
					0.45,
					0.6
				},
				recoil = {
					0.7,
					1.1
				},
				mode = {
					0,
					1,
					0,
					0
				}
			},
			{
				dmg_mul = 0.5,
				r = 4500, -- uses lower difficulty outer bound to begin falloff.
				acc = { -- vanilla values .25-.7.
					0.25,
					0.6
				},
				recoil = {
					1,
					2
				},
				mode = {
					1,
					1,
					0,
					0
				}
			}
		}
	}
	presets.weapon.deathvox.is_heavy_rifle = { -- mark 3 values complete. basis is presets.weapon.deathwish.is_rifle. General goal- fewer shots, more damage, greater range.
		aim_delay = {
			0,
			0
		},
		focus_delay = 3, -- Re-added from lower difficulties.
		focus_dis = 200,
		spread = 20,
		miss_dis = 40,
		RELOAD_SPEED = 1.4, -- validated, unchanged.
		melee_speed = 1,
		melee_dmg = 20,
		melee_retry_delay = presets.weapon.expert.is_rifle.melee_retry_delay,
		range = {
			optimal = 3500, -- currently unchanged. Consider adjustment if needed to improve differentiation. Heavies should prefer more range, if so.
			far = 6000,
			close = 2000
		},
		autofire_rounds = {
			4,
			9
		},
		FALLOFF = {
			{
				dmg_mul = 1,
				r = 100,
				acc = {
					0.9,
					0.975
				},
				recoil = {
					0.25,
					0.3
				},
				mode = {
					0,
					0,
					1,
					0
				}
			},
			{
				dmg_mul = 1,
				r = 500,
				acc = {
					0.875,
					0.95
				},
				recoil = {
					0.25,
					0.3
				},
				mode = {
					0,
					0,
					1,
					0
				}
			},
			{
				dmg_mul = 0.9, -- damage falloff begins.
				r = 1000,
				acc = {
					0.7,
					0.9
				},
				recoil = {
					0.35,
					0.55
				},
				mode = {
					0,
					0,
					1,
					0
				}
			},
			{
				dmg_mul = 0.85,
				r = 2000,
				acc = {
					0.7,
					0.85
				},
				recoil = {
					0.4,
					0.7
				},
				mode = {
					0,
					1,
					0,
					0
				}
			},
			{
				dmg_mul = 0.7,
				r = 3000,
				acc = {
					0.65,
					0.75
				},
				recoil = {
					0.7,
					1.1
				},
				mode = {
					0,
					1,
					0,
					0
				}
			},
			{
				dmg_mul = 0.6,
				r = 6000, -- uses longer range, per vanilla, to maintain long falloff tail.
				acc = {
					0.45, -- increased tail accuracy. Vanilla values .25-.7.
					0.7
				},
				recoil = {
					1.5, -- increased tail recoil to reduce attack rate. Vanilla values 1-2.
					2
				},
				mode = {
					1,
					0,
					0,
					0
				}
			}
		}
	}
	presets.weapon.deathvox.is_light_shotgun = { -- mark 3 values complete. basis is presets.weapon.deathwish.is_shotgun_pump. Light shotgunner fires and gains focus faster than Heavy.
		aim_delay = {
			0,
			0
		},
		focus_delay = 4, -- re-added from lower difficulties, but reduced for light shotgunner.
		focus_dis = 200,
		spread = 15,
		miss_dis = 20,
		RELOAD_SPEED = 1.8, -- faster speed reload, vanilla value 1.4
		melee_speed = 1,
		melee_dmg = 20,
		melee_retry_delay = presets.weapon.expert.is_shotgun_pump.melee_retry_delay,
		range = { -- validated, unchanged. I believe same for all shotgun enemy types in vanilla.
			optimal = 3000,
			far = 5000,
			close = 2000
		},
		FALLOFF = {
			{
				dmg_mul = 1,
				r = 100,
				acc = {
					0.95,
					0.95
				},
				recoil = {
					1,
					1.1
				},
				mode = {
					1,
					0,
					0,
					0
				}
			},
			{
				dmg_mul = 1,
				r = 500,
				acc = {
					0.7,
					0.95
				},
				recoil = { -- slight recoil reduction. Vanilla stats 1-1.25.
					1,
					1.2
				},
				mode = {
					1,
					0,
					0,
					0
				}
			},
			{
				dmg_mul = .8,
				r = 1000,
				acc = {
					0.5,
					0.8
				},
				recoil = { -- slight recoil reduction. Vanilla stats 1-1.5.
					1,
					1.3
				},
				mode = {
					1,
					0,
					0,
					0
				}
			},
			{
				dmg_mul = .6, -- lower falloff arc.
				r = 2000,
				acc = {
					0.15,
					0.45
				},
				recoil = { -- return to vanilla recoil.
					1.25,
					1.5
				},
				mode = {
					1,
					0,
					0,
					0
				}
			},
			{
				dmg_mul = .2,
				r = 3000,
				acc = {
					0.1,
					0.25
				},
				recoil = {
					1.5,
					1.75
				},
				mode = {
					1,
					0,
					0,
					0
				}
			}
		}
	}
	presets.weapon.deathvox.is_heavy_shotgun = { -- mark 3 values complete. basis is presets.weapon.deathwish.is_shotgun_pump. Heavy Shotgunner has conventional focal stats.
		aim_delay = {
			0,
			0
		},
		focus_delay = 5, -- focus delay returned from lower difficulties.
		focus_dis = 200,
		spread = 15,
		miss_dis = 20,
		RELOAD_SPEED = 1.4, -- validated, unchanged.
		melee_speed = 1,
		melee_dmg = 20,
		melee_retry_delay = presets.weapon.expert.is_shotgun_pump.melee_retry_delay,
		range = { -- using expert ranges. Should have effect of causing enemy to fire when closer.
			optimal = 2000,
			far = 5000,
			close = 1000
		},
		FALLOFF = {
			{
				dmg_mul = 1,
				r = 100,
				acc = {
					0.95,
					0.95
				},
				recoil = {
					1,
					1.1
				},
				mode = {
					1,
					0,
					0,
					0
				}
			},
			{
				dmg_mul = 1, -- less falloff at close range versus vanilla.
				r = 500,
				acc = {
					0.7,
					0.95
				},
				recoil = {
					1,
					1.25
				},
				mode = {
					1,
					0,
					0,
					0
				}
			},
			{
				dmg_mul = .7, -- falloff rate increase versus vanilla.
				r = 1000,
				acc = {
					0.5,
					0.8
				},
				recoil = {
					1,
					1.5
				},
				mode = {
					1,
					0,
					0,
					0
				}
			},
			{
				dmg_mul = .4,
				r = 2000,
				acc = { -- slight max accuracy increase, vanilla stats .45-.7.
					0.45,
					0.75
				},
				recoil = {
					1.25,
					1.5
				},
				mode = {
					1,
					0,
					0,
					0
				}
			},
			{
				dmg_mul = .2,
				r = 3000,
				acc = {
					0.3,
					0.5
				},
				recoil = {
					1.5,
					1.75
				},
				mode = {
					1,
					0,
					0,
					0
				}
			}
		}
	}
	presets.weapon.deathvox.is_smg = { -- mark 3 values complete. Assumes base damage of 45. basis is presets.weapon.deathwish.is_smg. Currently copies medidozer values.
		aim_delay = {
			0,
			0.1 --re-adding aim delay from lower difficulties.
		},
		focus_delay = 1, --re-adding slight focus delay from lower difficulties.
		focus_dis = 200,
		spread = 15,
		miss_dis = 10,
		RELOAD_SPEED = 1.4, -- validated, unchanged.
		melee_speed = presets.weapon.expert.is_smg.melee_speed,
		melee_dmg = presets.weapon.expert.is_smg.melee_dmg,
		melee_retry_delay = presets.weapon.expert.is_smg.melee_retry_delay,
		range = {
			optimal = 3200,
			far = 6000,
			close = 2000
		},
		autofire_rounds = {
			8,
			16
		},
		FALLOFF = {
			{
				dmg_mul = 1,
				r = 100,
				acc = {
					0.6, -- applying lower bound on accuracy based on lower difficulties.
					0.95
				},
				recoil = {
					0.1,
					0.25
				},
				mode = {
					0,
					0,
					0,
					1
				}
			},
			{
				dmg_mul = 1,
				r = 500,
				acc = {
					0.6,
					0.75
				},
				recoil = {
					0.1,
					0.3
				},
				mode = {
					0,
					0,
					0,
					1
				}
			},
			{
				dmg_mul = .9, -- applying falloff, unlike DW.
				r = 1000,
				acc = {
					0.5,
					0.75
				},
				recoil = {
					0.35,
					0.5
				},
				mode = {
					0,
					0,
					0,
					1
				}
			},
			{
				dmg_mul = .7,
				r = 2000,
				acc = {
					0.4,
					0.7
				},
				recoil = {
					0.35,
					0.5
				},
				mode = {
					0,
					0,
					1,
					0
				}
			},
			{
				dmg_mul = .6,
				r = 3000,
				acc = {
					0.55,
					0.6
				},
				recoil = {
					0.5,
					1.5
				},
				mode = {
					0,
					0,
					1,
					0
				}
			},
			{
				dmg_mul = .4,
				r = 4500,
				acc = {
					0.3,
					0.6
				},
				recoil = {
					1,
					1.5
				},
				mode = {
					0,
					1,
					0,
					0
				}
			}
		}
	}
	presets.weapon.deathvox.mini = { -- unused and unchanged as of mark 3 revisions.
		aim_delay = {
			0.1,
			0.2
		},
		focus_delay = 4,
		focus_dis = 800,
		spread = 20,
		miss_dis = 40,
		RELOAD_SPEED = 0.5,
		melee_speed = 1,
		melee_dmg = 25,
		melee_retry_delay = {
			1,
			2
		},
		range = {
			optimal = 2500,
			far = 5000,
			close = 1000
		},
		autofire_rounds = {
			20,
			40
		},
		FALLOFF = {
			{
				dmg_mul = 5,
				r = 100,
				acc = {
					0.6,
					0.9
				},
				recoil = {
					0.4,
					0.7
				},
				mode = {
					0,
					0,
					0,
					1
				}
			},
			{
				dmg_mul = 4,
				r = 500,
				acc = {
					0.5,
					0.7
				},
				recoil = {
					0.4,
					0.7
				},
				mode = {
					0,
					1,
					2,
					8
				}
			},
			{
				dmg_mul = 3.5,
				r = 1000,
				acc = {
					0.4,
					0.6
				},
				recoil = {
					0.45,
					0.8
				},
				mode = {
					1,
					3,
					6,
					6
				}
			},
			{
				dmg_mul = 3,
				r = 2000,
				acc = {
					0.2,
					0.5
				},
				recoil = {
					0.45,
					0.8
				},
				mode = {
					1,
					2,
					2,
					1
				}
			},
			{
				dmg_mul = 3,
				r = 3000,
				acc = {
					0.1,
					0.35
				},
				recoil = {
					1,
					1.2
				},
				mode = {
					4,
					2,
					1,
					0
				}
			}
		}
	}
	presets.weapon.deathvox.is_lmg = { --mark 3 values complete. Basis is presets.weapon.deathwish.is_lmg. Assumes 100 base damage. Used for LMG Dozers, certain scripted enemies. using a balance between expert and DW values here.
		aim_delay = { 
			0.1,
			0.1
		},
		focus_delay = 3,
		focus_dis = 200,
		spread = 24,
		miss_dis = 40,
		RELOAD_SPEED = 0.75,
		melee_speed = 1,
		melee_dmg = 15,
		melee_retry_delay = presets.weapon.normal.is_lmg.melee_retry_delay,
		range = {
			optimal = 3500,
			far = 6000,
			close = 2000
		},
		autofire_rounds = {
			25,
			50
		},
		FALLOFF = { 
			{
				dmg_mul = 1,
				r = 100,
				acc = {
					0.8,
					0.9
				},
				recoil = {
					0.25,
					0.5
				},
				mode = {
					0,
					0,
					0,
					1
				}
			},
			{
				dmg_mul = 1,
				r = 500,
				acc = {
					0.7,
					0.8
				},
				recoil = {
					0.45,
					0.6
				},
				mode = {
					0,
					0,
					0,
					1
				}
			},
			{
				dmg_mul = .8,
				r = 1000,
				acc = {
					0.5,
					0.8
				},
				recoil = {
					0.35,
					0.75
				},
				mode = {
					0,
					0,
					0,
					1
				}
			},
			{
				dmg_mul = .6,
				r = 2000,
				acc = {
					0.4,
					0.65
				},
				recoil = {
					0.4,
					1
				},
				mode = {
					0,
					0,
					0,
					1
				}
			},
			{
				dmg_mul = .3,
				r = 3000,
				acc = {
					0.2,
					0.35
				},
				recoil = {
					0.8,
					2
				},
				mode = {
					0,
					0,
					0,
					1
				}
			},
			{
				dmg_mul = .16,
				r = 6000,
				acc = {
					0.1, -- generally a warning shot at range.
					0.3
				},
				recoil = {
					1.5,
					3
				},
				mode = {
					0,
					0,
					0,
					1
				}
			}
		}
	}
	presets.weapon.deathvox_sniper = {is_rifle = {}, is_assault_sniper = {}}
	presets.weapon.deathvox_sniper.is_rifle = { -- mark 3 values complete. basis is presets.weapon.sniper. For non-assault wave snipers. Headings revised to fit standard format.
		aim_delay = {
			0,
			0.1
		},
		focus_delay = 7,
		focus_dis = 200,
		spread = 30,
		miss_dis = 250,
		RELOAD_SPEED = 1.25,  -- validated, unchanged.
		melee_speed = presets.weapon.normal.is_rifle.melee_speed,
		melee_dmg = presets.weapon.normal.is_rifle.melee_dmg,
		melee_retry_delay = presets.weapon.normal.is_rifle.melee_retry_delay,
		range = { --validated, unchanged. Will need to see values used by crimespree zeal heavy snipers for assault snipers.
			optimal = 15000,
			far = 15000,
			close = 15000
		},
		autofire_rounds = presets.weapon.normal.is_rifle.autofire_rounds,
		use_laser = true, -- where the laser change goes.
		FALLOFF = { -- note values do not match frank's table. Largely eyeballed, may need revision.
			{
				dmg_mul = 1,
				r = 700,
				acc = {
					0.4,
					0.95
				},
				recoil = {
					2,
					4
				},
				mode = {
					1,
					0,
					0,
					0
				}
			},
			{
				dmg_mul = .95, -- slight falloff, frank indicates flat damage on DW.
				r = 4500,
				acc = {
					0.1,
					0.75
				},
				recoil = {
					3,
					4
				},
				mode = {
					1,
					0,
					0,
					0
				}
			},
			{
				dmg_mul = .83,
				r = 12000,
				acc = {
					0,
					0.5
				},
				recoil = {
					3,
					5
				},
				mode = {
					1,
					0,
					0,
					0
				}
			}
		}
	}
	presets.weapon.deathvox_sniper.is_assault_sniper = deep_clone(presets.weapon.deathvox_sniper.is_rifle)
	presets.weapon.deathvox.is_assault_sniper = deep_clone(presets.weapon.deathvox_sniper.is_rifle) --defining the assault sniper preset.
	presets.weapon.deathvox.is_assault_sniper.FALLOFF = { -- revising assault sniper falloff values.
		{
			dmg_mul = 1,
			r = 700,
			acc = {
				0, --zeroing base focus accuracy to ensure warning.
				0.95
			},
			recoil = {
				2,
				4
			},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			dmg_mul = .95, -- slight falloff, frank indicates flat damage on DW.
			r = 4500,
			acc = {
				0, --zeroing base focus accuracy to ensure warning.
				0.75
			},
			recoil = {
				3,
				4
			},
			mode = {
				1,
				0,
				0,
				0
			}
		},
		{
			dmg_mul = .83,
			r = 12000,
			acc = {
				0,
				0.5
			},
			recoil = {
				3,
				5
			},
			mode = {
				1,
				0,
				0,
				0
			}
		}
	}
	presets.weapon.deathvox.is_tank_smg = deep_clone(presets.weapon.deathvox.is_smg) --Used for medidozer. May separate.
	presets.weapon.deathvox.is_cloaker_smg = deep_clone(presets.weapon.deathvox.is_smg) -- clone similar to other vars.
	presets.weapon.deathvox.is_dozer_saiga = deep_clone(presets.weapon.deathvox.is_shotgun_mag)
	presets.weapon.deathvox.is_dozer_pump = deep_clone(presets.weapon.deathvox.is_shotgun_pump)
	presets.weapon.deathvox.is_dozer_lmg = deep_clone(presets.weapon.deathvox.is_lmg)
	presets.weapon.deathvox.is_bullpup = deep_clone(presets.weapon.deathvox.is_light_rifle) -- moving this clone down from inappropriate position above.
	presets.weapon.deathvox.mac11 = deep_clone(presets.weapon.deathvox.is_smg) -- revises erroneous clone of pistol from previous setup.
	presets.weapon.deathvox.mp9 = deep_clone(presets.weapon.deathvox.is_smg) -- revises erroneous clone of pistol from previous setup.
	presets.weapon.deathvox.rifle = deep_clone(presets.weapon.deathvox.is_light_rifle)
	presets.weapon.deathvox.is_sniper = deep_clone(presets.weapon.deathvox.is_light_rifle)
	presets.weapon.deathvox.is_rifle = deep_clone(presets.weapon.deathvox.is_light_rifle)
	presets.weapon.deathvox.akimbo_pistol = deep_clone(presets.weapon.deathvox.is_pistol) -- Will revise for test version of Chavez boss at future date.
	presets.weapon.deathvox.mossberg = deep_clone(presets.weapon.deathvox.is_light_shotgun)
	presets.detection = {}
	presets.detection.normal = {
		idle = {},
		combat = {},
		recon = {},
		guard = {},
		ntl = {}
	}
	presets.detection.normal.idle.dis_max = 10000
	presets.detection.normal.idle.angle_max = 120
	presets.detection.normal.idle.delay = {0, 0}
	presets.detection.normal.idle.use_uncover_range = true
	presets.detection.normal.combat.dis_max = 10000
	presets.detection.normal.combat.angle_max = 120
	presets.detection.normal.combat.delay = {0, 0}
	presets.detection.normal.combat.use_uncover_range = true
	presets.detection.normal.recon.dis_max = 10000
	presets.detection.normal.recon.angle_max = 120
	presets.detection.normal.recon.delay = {0, 0}
	presets.detection.normal.recon.use_uncover_range = true
	presets.detection.normal.guard.dis_max = 10000
	presets.detection.normal.guard.angle_max = 120
	presets.detection.normal.guard.delay = {0, 0}
	presets.detection.normal.ntl.dis_max = 4000
	presets.detection.normal.ntl.angle_max = 60
	presets.detection.normal.ntl.delay = {0.2, 2}
	presets.detection.normal_undercover = {
		idle = {},
		combat = {},
		recon = {},
		guard = {},
		ntl = {}
	}
	presets.detection.normal_undercover.idle.dis_max = 700
	presets.detection.normal_undercover.idle.angle_max = 60
	presets.detection.normal_undercover.idle.delay = {0, 0}
	presets.detection.normal_undercover.idle.use_uncover_range = false
	presets.detection.normal_undercover.combat.dis_max = 10000
	presets.detection.normal_undercover.combat.angle_max = 120
	presets.detection.normal_undercover.combat.delay = {0, 0}
	presets.detection.normal_undercover.combat.use_uncover_range = true
	presets.detection.normal_undercover.recon.dis_max = 10000
	presets.detection.normal_undercover.recon.angle_max = 120
	presets.detection.normal_undercover.recon.delay = {0, 0}
	presets.detection.normal_undercover.recon.use_uncover_range = true
	presets.detection.normal_undercover.guard.dis_max = 10000
	presets.detection.normal_undercover.guard.angle_max = 120
	presets.detection.normal_undercover.guard.delay = {0, 0}
	presets.detection.normal_undercover.ntl.dis_max = 4000
	presets.detection.normal_undercover.ntl.angle_max = 60
	presets.detection.normal_undercover.ntl.delay = {0.2, 2}
	presets.detection.guard = {
		idle = {},
		combat = {},
		recon = {},
		guard = {},
		ntl = {}
	}
	presets.detection.guard.idle.dis_max = 10000
	presets.detection.guard.idle.angle_max = 120
	presets.detection.guard.idle.delay = {0, 0}
	presets.detection.guard.idle.use_uncover_range = true
	presets.detection.guard.combat.dis_max = 10000
	presets.detection.guard.combat.angle_max = 120
	presets.detection.guard.combat.delay = {0, 0}
	presets.detection.guard.combat.use_uncover_range = true
	presets.detection.guard.recon.dis_max = 10000
	presets.detection.guard.recon.angle_max = 120
	presets.detection.guard.recon.delay = {0, 0}
	presets.detection.guard.recon.use_uncover_range = true
	presets.detection.guard.guard.dis_max = 10000
	presets.detection.guard.guard.angle_max = 120
	presets.detection.guard.guard.delay = {0, 0}
	presets.detection.guard.ntl = presets.detection.normal.ntl
	presets.detection.sniper = {
		idle = {},
		combat = {},
		recon = {},
		guard = {},
		ntl = {}
	}
	presets.detection.sniper.idle.dis_max = 10000
	presets.detection.sniper.idle.angle_max = 180
	presets.detection.sniper.idle.delay = {0.5, 1}
	presets.detection.sniper.idle.use_uncover_range = true
	presets.detection.sniper.combat.dis_max = 10000
	presets.detection.sniper.combat.angle_max = 120
	presets.detection.sniper.combat.delay = {0.5, 1}
	presets.detection.sniper.combat.use_uncover_range = true
	presets.detection.sniper.recon.dis_max = 10000
	presets.detection.sniper.recon.angle_max = 120
	presets.detection.sniper.recon.delay = {0.5, 1}
	presets.detection.sniper.recon.use_uncover_range = true
	presets.detection.sniper.guard.dis_max = 10000
	presets.detection.sniper.guard.angle_max = 150
	presets.detection.sniper.guard.delay = {0.3, 1}
	presets.detection.sniper.ntl = presets.detection.normal.ntl
	presets.detection.gang_member = {
		idle = {},
		combat = {},
		recon = {},
		guard = {},
		ntl = {}
	}
	presets.detection.gang_member.idle.dis_max = 10000
	presets.detection.gang_member.idle.angle_max = 240
	presets.detection.gang_member.idle.delay = {0, 0}
	presets.detection.gang_member.idle.use_uncover_range = true
	presets.detection.gang_member.combat.dis_max = 10000
	presets.detection.gang_member.combat.angle_max = 240
	presets.detection.gang_member.combat.delay = {0, 0}
	presets.detection.gang_member.combat.use_uncover_range = true
	presets.detection.gang_member.recon.dis_max = 10000
	presets.detection.gang_member.recon.angle_max = 240
	presets.detection.gang_member.recon.delay = {0, 0}
	presets.detection.gang_member.recon.use_uncover_range = true
	presets.detection.gang_member.guard.dis_max = 10000
	presets.detection.gang_member.guard.angle_max = 240
	presets.detection.gang_member.guard.delay = {0, 0}
	presets.detection.gang_member.ntl = presets.detection.normal.ntl
	presets.detection.civilian = {
		cbt = {},
		ntl = {}
	}
	presets.detection.civilian.cbt.dis_max = 700
	presets.detection.civilian.cbt.angle_max = 120
	presets.detection.civilian.cbt.delay = {0, 0}
	presets.detection.civilian.cbt.use_uncover_range = true
	presets.detection.civilian.ntl.dis_max = 2000
	presets.detection.civilian.ntl.angle_max = 60
	presets.detection.civilian.ntl.delay = {0.2, 3}
	presets.detection.blind = {
		idle = {},
		combat = {},
		recon = {},
		guard = {},
		ntl = {}
	}
	presets.detection.blind.idle.dis_max = 1
	presets.detection.blind.idle.angle_max = 0
	presets.detection.blind.idle.delay = {0, 0}
	presets.detection.blind.idle.use_uncover_range = false
	presets.detection.blind.combat.dis_max = 1
	presets.detection.blind.combat.angle_max = 0
	presets.detection.blind.combat.delay = {0, 0}
	presets.detection.blind.combat.use_uncover_range = false
	presets.detection.blind.recon.dis_max = 1
	presets.detection.blind.recon.angle_max = 0
	presets.detection.blind.recon.delay = {0, 0}
	presets.detection.blind.recon.use_uncover_range = false
	presets.detection.blind.guard.dis_max = 1
	presets.detection.blind.guard.angle_max = 0
	presets.detection.blind.guard.delay = {0, 0}
	presets.detection.blind.guard.use_uncover_range = false
	presets.detection.blind.ntl.dis_max = 1
	presets.detection.blind.ntl.angle_max = 0
	presets.detection.blind.ntl.delay = {0, 0}
	presets.detection.blind.ntl.use_uncover_range = false
	presets.dodge = {
		poor = {
			speed = 0.9,
			occasions = {
				hit = {
					chance = 0.9,
					check_timeout = {0, 0},
					variations = {
						side_step = {
							chance = 1,
							timeout = {2, 3}
						}
					}
				},
				scared = {
					chance = 0.5,
					check_timeout = {1, 2},
					variations = {
						side_step = {
							chance = 1,
							timeout = {2, 3}
						}
					}
				}
			}
		},
		average = {
			speed = 1,
			occasions = {
				hit = {
					chance = 0.35,
					check_timeout = {0, 0},
					variations = {
						side_step = {
							chance = 1,
							timeout = {2, 3}
						}
					}
				},
				scared = {
					chance = 0.4,
					check_timeout = {4, 7},
					variations = {
						dive = {
							chance = 1,
							timeout = {5, 8}
						}
					}
				}
			}
		},
		heavy = {
			speed = 1,
			occasions = {
				hit = {
					chance = 0.75,
					check_timeout = {0, 0},
					variations = {
						side_step = {
							chance = 9,
							timeout = {0, 7},
							shoot_chance = 0.8,
							shoot_accuracy = 0.5
						},
						roll = {
							chance = 1,
							timeout = {8, 10}
						}
					}
				},
				preemptive = {
					chance = 0.1,
					check_timeout = {1, 7},
					variations = {
						side_step = {
							chance = 1,
							timeout = {1, 7},
							shoot_chance = 1,
							shoot_accuracy = 0.7
						}
					}
				},
				scared = {
					chance = 0.8,
					check_timeout = {1, 2},
					variations = {
						side_step = {
							chance = 5,
							timeout = {1, 2},
							shoot_chance = 0.5,
							shoot_accuracy = 0.4
						},
						roll = {
							chance = 1,
							timeout = {8, 10}
						},
						dive = {
							chance = 2,
							timeout = {8, 10}
						}
					}
				}
			}
		},
		athletic = {
			speed = 1.3,
			occasions = {
				hit = {
					chance = 0.9,
					check_timeout = {0, 0},
					variations = {
						side_step = {
							chance = 5,
							timeout = {1, 3},
							shoot_chance = 0.8,
							shoot_accuracy = 0.5
						},
						roll = {
							chance = 1,
							timeout = {3, 4}
						}
					}
				},
				preemptive = {
					chance = 0.35,
					check_timeout = {2, 3},
					variations = {
						side_step = {
							chance = 3,
							timeout = {1, 2},
							shoot_chance = 1,
							shoot_accuracy = 0.7
						},
						roll = {
							chance = 1,
							timeout = {3, 4}
						}
					}
				},
				scared = {
					chance = 0.4,
					check_timeout = {1, 2},
					variations = {
						side_step = {
							chance = 5,
							timeout = {1, 2},
							shoot_chance = 0.5,
							shoot_accuracy = 0.4
						},
						roll = {
							chance = 3,
							timeout = {3, 5}
						},
						dive = {
							chance = 1,
							timeout = {3, 5}
						}
					}
				}
			}
		},
		athletic_very_hard = {
			speed = 1.4,
			occasions = {
				hit = {
					chance = 0.9,
					check_timeout = {0, 0},
					variations = {
						side_step = {
							chance = 5,
							timeout = {1, 3},
							shoot_chance = 0.8,
							shoot_accuracy = 0.5
						},
						roll = {
							chance = 1,
							timeout = {3, 4}
						}
					}
				},
				preemptive = {
					chance = 0.5,
					check_timeout = {2, 3},
					variations = {
						side_step = {
							chance = 3,
							timeout = {1, 2},
							shoot_chance = 1,
							shoot_accuracy = 0.7
						},
						roll = {
							chance = 1,
							timeout = {3, 4}
						}
					}
				},
				scared = {
					chance = 0.4,
					check_timeout = {1, 2},
					variations = {
						side_step = {
							chance = 5,
							timeout = {1, 2},
							shoot_chance = 0.5,
							shoot_accuracy = 0.4
						},
						roll = {
							chance = 3,
							timeout = {3, 5}
						},
						dive = {
							chance = 1,
							timeout = {3, 5}
						}
					}
				}
			}
		},
		heavy_very_hard = {
			speed = 1.1,
			occasions = {
				hit = {
					chance = 0.75,
					check_timeout = {0, 0},
					variations = {
						side_step = {
							chance = 9,
							timeout = {0, 7},
							shoot_chance = 0.8,
							shoot_accuracy = 0.5
						},
						roll = {
							chance = 1,
							timeout = {8, 10}
						}
					}
				},
				preemptive = {
					chance = 0.25,
					check_timeout = {1, 7},
					variations = {
						side_step = {
							chance = 1,
							timeout = {1, 7},
							shoot_chance = 1,
							shoot_accuracy = 0.7
						}
					}
				},
				scared = {
					chance = 0.8,
					check_timeout = {1, 2},
					variations = {
						side_step = {
							chance = 5,
							timeout = {1, 2},
							shoot_chance = 0.5,
							shoot_accuracy = 0.4
						},
						roll = {
							chance = 1,
							timeout = {8, 10}
						},
						dive = {
							chance = 2,
							timeout = {8, 10}
						}
					}
				}
			}
		},
		athletic_overkill = {
			speed = 1.5,
			occasions = {
				hit = {
					chance = 0.9,
					check_timeout = {0, 0},
					variations = {
						side_step = {
							chance = 5,
							timeout = {1, 3},
							shoot_chance = 0.8,
							shoot_accuracy = 0.5
						},
						roll = {
							chance = 1,
							timeout = {3, 4}
						}
					}
				},
				preemptive = {
					chance = 0.6,
					check_timeout = {2, 3},
					variations = {
						side_step = {
							chance = 3,
							timeout = {1, 2},
							shoot_chance = 1,
							shoot_accuracy = 0.7
						},
						roll = {
							chance = 1,
							timeout = {3, 4}
						}
					}
				},
				scared = {
					chance = 0.4,
					check_timeout = {1, 2},
					variations = {
						side_step = {
							chance = 5,
							timeout = {1, 2},
							shoot_chance = 0.5,
							shoot_accuracy = 0.4
						},
						roll = {
							chance = 3,
							timeout = {3, 5}
						},
						dive = {
							chance = 1,
							timeout = {3, 5}
						}
					}
				}
			}
		},
		ninja = {
			speed = 1.6,
			occasions = {
				hit = {
					chance = 0.9,
					check_timeout = {0, 3},
					variations = {
						side_step = {
							chance = 3,
							timeout = {1, 2},
							shoot_chance = 1,
							shoot_accuracy = 0.7
						},
						roll = {
							chance = 1,
							timeout = {1.2, 2}
						},
						wheel = {
							chance = 2,
							timeout = {1.2, 2}
						}
					}
				},
				preemptive = {
					chance = 0.7,
					check_timeout = {0, 3},
					variations = {
						side_step = {
							chance = 3,
							timeout = {1, 2},
							shoot_chance = 1,
							shoot_accuracy = 0.8
						},
						roll = {
							chance = 1,
							timeout = {1.2, 2}
						},
						wheel = {
							chance = 2,
							timeout = {1.2, 2}
						}
					}
				},
				scared = {
					chance = 0.9,
					check_timeout = {0, 3},
					variations = {
						side_step = {
							chance = 5,
							timeout = {1, 2},
							shoot_chance = 0.8,
							shoot_accuracy = 0.6
						},
						roll = {
							chance = 3,
							timeout = {1.2, 2}
						},
						wheel = {
							chance = 3,
							timeout = {1.2, 2}
						},
						dive = {
							chance = 1,
							timeout = {1.2, 2}
						}
					}
				}
			}
		},
		deathwish = {
			speed = 1.6,
			occasions = {
				hit = {
					chance = 0.9,
					check_timeout = {0, 3},
					variations = {
						side_step = {
							chance = 3,
							timeout = {1, 2},
							shoot_chance = 1,
							shoot_accuracy = 0.7
						},
						roll = {
							chance = 1,
							timeout = {1.2, 2}
						}
					}
				},
				preemptive = {
					chance = 0.7,
					check_timeout = {0, 3},
					variations = {
						side_step = {
							chance = 3,
							timeout = {1, 2},
							shoot_chance = 1,
							shoot_accuracy = 0.8
						},
						roll = {
							chance = 1,
							timeout = {1.2, 2}
						}
					}
				},
				scared = {
					chance = 0.9,
					check_timeout = {0, 3},
					variations = {
						side_step = {
							chance = 5,
							timeout = {1, 2},
							shoot_chance = 0.8,
							shoot_accuracy = 0.6
						},
						roll = {
							chance = 3,
							timeout = {1.2, 2}
						},
						dive = {
							chance = 1,
							timeout = {1.2, 2}
						}
					}
				}
			}
		},
		elite = {
			speed = 1.7,
			occasions = {
				hit = {
					chance = 0.9,
					check_timeout = {0, 3},
					variations = {
						side_step = {
							chance = 3,
							timeout = {1, 2},
							shoot_chance = 1,
							shoot_accuracy = 0.7
						},
						roll = {
							chance = 1,
							timeout = {1.2, 2}
						}
					}
				},
				preemptive = {
					chance = 0.8,
					check_timeout = {0, 3},
					variations = {
						side_step = {
							chance = 3,
							timeout = {1, 2},
							shoot_chance = 1,
							shoot_accuracy = 0.8
						},
						roll = {
							chance = 1,
							timeout = {1.2, 2}
						}
					}
				},
				scared = {
					chance = 0.9,
					check_timeout = {0, 3},
					variations = {
						side_step = {
							chance = 5,
							timeout = {1, 2},
							shoot_chance = 0.8,
							shoot_accuracy = 0.6
						},
						roll = {
							chance = 3,
							timeout = {1.2, 2}
						},
						dive = {
							chance = 1,
							timeout = {1.2, 2}
						}
					}
				}
			}
		},
		veteran = {
			speed = 3,
			occasions = {
				hit = {
					chance = 1,
					check_timeout = {0, 0},
					variations = {
						dive = {
							chance = 1,
							timeout = {0, 0}
						}
					}
				},
				preemptive = {
					chance = 0.95,
					check_timeout = {0, 0},
					variations = {
						dive = {
							chance = 1,
							timeout = {0, 0}
						}
					}
				}
			}
		}
	}
	for preset_name, preset_data in pairs(presets.dodge) do
		for reason_name, reason_data in pairs(preset_data.occasions) do
			local total_w = 0
			for variation_name, variation_data in pairs(reason_data.variations) do
				total_w = total_w + variation_data.chance
			end
			if total_w > 0 then
				for variation_name, variation_data in pairs(reason_data.variations) do
					variation_data.chance = variation_data.chance / total_w
				end
			end
		end
	end
	presets.dodge.deathvox = {
		speed = 1.7,
		occasions = {
			hit = {
				chance = 1,
				check_timeout = {0, 3},
				variations = {
					side_step = {
						chance = 3,
						timeout = {1, 2},
						shoot_chance = 1,
						shoot_accuracy = 0.8
					},
					roll = {
						chance = 1,
						timeout = {1.2, 2}
					}
				}
			},
			preemptive = {
				chance = 0.9,
				check_timeout = {0, 3},
				variations = {
					side_step = {
						chance = 3,
						timeout = {1, 2},
						shoot_chance = 1,
						shoot_accuracy = 0.8
					},
					roll = {
						chance = 1,
						timeout = {1.2, 2}
					}
				}
			},
			scared = {
				chance = 0.9,
				check_timeout = {0, 3},
				variations = {
					side_step = {
						chance = 5,
						timeout = {1, 2},
						shoot_chance = 1,
						shoot_accuracy = 0.7
					},
					roll = {
						chance = 3,
						timeout = {1.2, 2}
					},
					dive = {
						chance = 1,
						timeout = {1.2, 2}
					}
				}
			}
		}
	}
	presets.dodge.deathvoxninja = {
		speed = 1.7,
		occasions = {
			hit = {
				chance = 1,
				check_timeout = {0, 1},
				variations = {
					roll = {
						chance = 2,
						timeout = {1, 1.5}
					},
					wheel = {
						chance = 1,
						shoot_chance = 0.9,
						shoot_accuracy = 0.8,
						timeout = {1, 1.5}
					}
				}
			},
			preemptive = {
				chance = 1,
				check_timeout = {0, .6},
				variations = {
					side_step = {
						chance = 1,
						shoot_chance = 0.8,
						shoot_accuracy = 0.6,
						timeout = {1, 1.5}
					},
					roll = {
						chance = 2,
						timeout = {1, 1.5}
					},
					wheel = {
						chance = 2,
						shoot_chance = 0.9,
						shoot_accuracy = 0.8,
						timeout = {1, 1.5}
					}
				}
			},
			scared = {
				chance = 1,
				check_timeout = {0, 0.6},
				variations = {
					side_step = {
						chance = 1,
						shoot_chance = 0.8,
						shoot_accuracy = 0.6,
						timeout = {1, 1.5}
					},
					roll = {
						chance = 3,
						timeout = {1, 1.5}
					},
					wheel = {
						chance = 3,
						shoot_chance = 0.9,
						shoot_accuracy = 0.8,
						timeout = {1, 1.5}
					}
				}
			}
		}
	}
	presets.dodge.deathvox_guard = {
		speed = 1.2,
		occasions = {
			hit = {
				chance = 1,
				check_timeout = {0, 3},
				variations = {
					side_step = {
						chance = 3,
						timeout = {1, 2},
					},
					roll = {
						chance = 1,
						timeout = {1.2, 2}
					}
				}
			},
			scared = {
				chance = 0.9,
				check_timeout = {0, 3},
				variations = {
					side_step = {
						chance = 5,
						timeout = {1, 2},
					},
					roll = {
						chance = 3,
						timeout = {1.2, 2}
					}
				}
			}
		}
	}		

	presets.move_speed = {
		civ_fast = {
			stand = {
				walk = {
					ntl = {
						fwd = 150,
						strafe = 120,
						bwd = 100
					},
					hos = {
						fwd = 210,
						strafe = 190,
						bwd = 160
					},
					cbt = {
						fwd = 210,
						strafe = 175,
						bwd = 160
					}
				},
				run = {
					hos = {
						fwd = 500,
						strafe = 192,
						bwd = 230
					},
					cbt = {
						fwd = 500,
						strafe = 250,
						bwd = 230
					}
				}
			},
			crouch = {
				walk = {
					hos = {
						fwd = 174,
						strafe = 160,
						bwd = 163
					},
					cbt = {
						fwd = 174,
						strafe = 160,
						bwd = 163
					}
				},
				run = {
					hos = {
						fwd = 312,
						strafe = 245,
						bwd = 260
					},
					cbt = {
						fwd = 312,
						strafe = 245,
						bwd = 260
					}
				}
			}
		},
		gang_member = {
			stand = {
				walk = {
					ntl = {
						fwd = 150,
						strafe = 150,
						bwd = 150
					},
					hos = {
						fwd = 437.5,
						strafe = 437.5,
						bwd = 437.5
					},
					cbt = {
						fwd = 437.5,
						strafe = 437.5,
						bwd = 437.5
					}
				},
				run = {
					hos = {
						fwd = 718.75,
						strafe = 718.75,
						bwd = 718.75
					},
					cbt = {
						fwd = 718.75,
						strafe = 718.75,
						bwd = 718.75
					}
				}
			},
			crouch = {
				walk = {
					hos = {
						fwd = 281.25,
						strafe = 281.25,
						bwd = 281.25
					},
					cbt = {
						fwd = 281.25,
						strafe = 281.25,
						bwd = 281.25
					}
				},
				run = {
					hos = {
						fwd = 281.25,
						strafe = 281.25,
						bwd = 281.25
					},
					cbt = {
						fwd = 281.25,
						strafe = 281.25,
						bwd = 281.25
					}
				}
			}
		},
		lightning = {
			stand = {
				walk = {
					ntl = {
						fwd = 150,
						strafe = 120,
						bwd = 110
					},
					hos = {
						fwd = 285,
						strafe = 225,
						bwd = 215
					},
					cbt = {
						fwd = 285,
						strafe = 225,
						bwd = 215
					}
				},
				run = {
					hos = {
						fwd = 800,
						strafe = 400,
						bwd = 350
					},
					cbt = {
						fwd = 750,
						strafe = 380,
						bwd = 320
					}
				}
			},
			crouch = {
				walk = {
					hos = {
						fwd = 245,
						strafe = 210,
						bwd = 190
					},
					cbt = {
						fwd = 255,
						strafe = 190,
						bwd = 190
					}
				},
				run = {
					hos = {
						fwd = 420,
						strafe = 300,
						bwd = 250
					},
					cbt = {
						fwd = 412,
						strafe = 300,
						bwd = 280
					}
				}
			}
		},
		veteran = {
			stand = {
				walk = {
					ntl = {
						fwd = 150,
						strafe = 120,
						bwd = 110
					},
					hos = {
						fwd = 800,
						strafe = 800,
						bwd = 800
					},
					cbt = {
						fwd = 800,
						strafe = 800,
						bwd = 800
					}
				},
				run = {
					hos = {
						fwd = 800,
						strafe = 800,
						bwd = 800
					},
					cbt = {
						fwd = 800,
						strafe = 800,
						bwd = 800
					}
				}
			},
			crouch = {
				walk = {
					hos = {
						fwd = 800,
						strafe = 800,
						bwd = 800
					},
					cbt = {
						fwd = 800,
						strafe = 800,
						bwd = 800
					}
				},
				run = {
					hos = {
						fwd = 800,
						strafe = 800,
						bwd = 800
					},
					cbt = {
						fwd = 800,
						strafe = 800,
						bwd = 800
					}
				}
			}
		},
		very_slow = {
			stand = {
				walk = {
					ntl = {
						fwd = 144,
						strafe = 120,
						bwd = 113
					},
					hos = {
						fwd = 144,
						strafe = 120,
						bwd = 113
					},
					cbt = {
						fwd = 144,
						strafe = 120,
						bwd = 113
					}
				},
				run = {
					hos = {
						fwd = 144,
						strafe = 140,
						bwd = 113
					},
					cbt = {
						fwd = 144,
						strafe = 100,
						bwd = 125
					}
				}
			},
			crouch = {
				walk = {
					hos = {
						fwd = 144,
						strafe = 120,
						bwd = 113
					},
					cbt = {
						fwd = 144,
						strafe = 120,
						bwd = 113
					}
				},
				run = {
					hos = {
						fwd = 144,
						strafe = 130,
						bwd = 113
					},
					cbt = {
						fwd = 144,
						strafe = 100,
						bwd = 125
					}
				}
			}
		},
		slow = {
			stand = {
				walk = {
					ntl = {
						fwd = 144,
						strafe = 120,
						bwd = 113
					},
					hos = {
						fwd = 144,
						strafe = 120,
						bwd = 113
					},
					cbt = {
						fwd = 144,
						strafe = 120,
						bwd = 113
					}
				},
				run = {
					hos = {
						fwd = 360,
						strafe = 150,
						bwd = 135
					},
					cbt = {
						fwd = 360,
						strafe = 150,
						bwd = 155
					}
				}
			},
			crouch = {
				walk = {
					hos = {
						fwd = 144,
						strafe = 120,
						bwd = 113
					},
					cbt = {
						fwd = 144,
						strafe = 120,
						bwd = 113
					}
				},
				run = {
					hos = {
						fwd = 360,
						strafe = 140,
						bwd = 150
					},
					cbt = {
						fwd = 360,
						strafe = 140,
						bwd = 155
					}
				}
			}
		},
		normal = {
			stand = {
				walk = {
					ntl = {
						fwd = 150,
						strafe = 120,
						bwd = 100
					},
					hos = {
						fwd = 220,
						strafe = 190,
						bwd = 170
					},
					cbt = {
						fwd = 220,
						strafe = 190,
						bwd = 170
					}
				},
				run = {
					hos = {
						fwd = 450,
						strafe = 290,
						bwd = 255
					},
					cbt = {
						fwd = 400,
						strafe = 250,
						bwd = 255
					}
				}
			},
			crouch = {
				walk = {
					hos = {
						fwd = 210,
						strafe = 170,
						bwd = 160
					},
					cbt = {
						fwd = 210,
						strafe = 170,
						bwd = 160
					}
				},
				run = {
					hos = {
						fwd = 310,
						strafe = 260,
						bwd = 235
					},
					cbt = {
						fwd = 350,
						strafe = 260,
						bwd = 235
					}
				}
			}
		},
		fast = {
			stand = {
				walk = {
					ntl = {
						fwd = 150,
						strafe = 120,
						bwd = 110
					},
					hos = {
						fwd = 270,
						strafe = 215,
						bwd = 185
					},
					cbt = {
						fwd = 270,
						strafe = 215,
						bwd = 185
					}
				},
				run = {
					hos = {
						fwd = 625,
						strafe = 315,
						bwd = 280
					},
					cbt = {
						fwd = 450,
						strafe = 285,
						bwd = 280
					}
				}
			},
			crouch = {
				walk = {
					hos = {
						fwd = 235,
						strafe = 180,
						bwd = 170
					},
					cbt = {
						fwd = 235,
						strafe = 180,
						bwd = 170
					}
				},
				run = {
					hos = {
						fwd = 330,
						strafe = 280,
						bwd = 255
					},
					cbt = {
						fwd = 312,
						strafe = 270,
						bwd = 255
					}
				}
			}
		},
		very_fast = {
			stand = {
				walk = {
					ntl = {
						fwd = 150,
						strafe = 120,
						bwd = 110
					},
					hos = {
						fwd = 285,
						strafe = 225,
						bwd = 215
					},
					cbt = {
						fwd = 285,
						strafe = 225,
						bwd = 215
					}
				},
				run = {
					hos = {
						fwd = 670,
						strafe = 340,
						bwd = 325
					},
					cbt = {
						fwd = 475,
						strafe = 325,
						bwd = 300
					}
				}
			},
			crouch = {
				walk = {
					hos = {
						fwd = 245,
						strafe = 210,
						bwd = 190
					},
					cbt = {
						fwd = 255,
						strafe = 190,
						bwd = 190
					}
				},
				run = {
					hos = {
						fwd = 350,
						strafe = 282,
						bwd = 268
					},
					cbt = {
						fwd = 312,
						strafe = 282,
						bwd = 268
					}
				}
			}
		}
	}
	for speed_preset_name, poses in pairs(presets.move_speed) do
		for pose, hastes in pairs(poses) do
			hastes.run.ntl = hastes.run.hos
		end
		poses.crouch.walk.ntl = poses.crouch.walk.hos
		poses.crouch.run.ntl = poses.crouch.run.hos
		poses.stand.run.ntl = poses.stand.run.hos
		poses.panic = poses.stand
	end
	presets.surrender = {}
	presets.surrender.always = {base_chance = 1}
	presets.surrender.never = {base_chance = 0}
	presets.surrender.easy = {
		base_chance = 0.75,
		significant_chance = 0.35,
		violence_timeout = 2,
		reasons = {
			health = {
				[1] = 0.25,
				[0.75] = 0.5,
				[0.5] = 0.75,
			},
			weapon_down = 0.5,
			pants_down = 1,
			isolated = 0.08
		},
		factors = {
			flanked = 0.05,
			unaware_of_aggressor = 0.1,
			enemy_weap_cold = 0.11,
			aggressor_dis = {
				[1000] = 0,
				[300] = 0.2
			}
		}
	}
	presets.surrender.hard = {
		base_chance = 0.5,
		significant_chance = 0.35,
		violence_timeout = 2,
		reasons = {
			health = {
				[1] = 0.25,
				[0.75] = 0.5,
				[0.5] = 0.75,
			},
			weapon_down = 0.5,
			pants_down = 1,
			isolated = 0.08
		},
		factors = {
			flanked = 0.05,
			unaware_of_aggressor = 0.1,
			enemy_weap_cold = 0.11,
			aggressor_dis = {
				[1000] = 0,
				[300] = 0.2
			}
		}
	}
	presets.surrender.special = {
		base_chance = 0.25,
		significant_chance = 0.35,
		violence_timeout = 2,
		reasons = {
			health = {
				[1] = 0.25,
				[0.75] = 0.5,
				[0.5] = 0.75,
			},
			weapon_down = 0.5,
			pants_down = 1,
			isolated = 0.08
		},
		factors = {
			flanked = 0.05,
			unaware_of_aggressor = 0.1,
			enemy_weap_cold = 0.11,
			aggressor_dis = {
				[1000] = 0,
				[300] = 0.2
			}
		}
	}
	presets.suppression = {
		easy = {
			duration = {10, 15},
			react_point = {0, 2},
			brown_point = {3, 5},
			panic_chance_mul = 1
		},
		hard_def = {
			duration = {5, 10},
			react_point = {0, 2},
			brown_point = {5, 6},
			panic_chance_mul = 1
		},
		hard_agg = {
			duration = {5, 8},
			react_point = {2, 5},
			brown_point = {5, 6},
			panic_chance_mul = 1
		},
		no_supress = {
			duration = {0.1, 0.15},
			react_point = {100, 200},
			brown_point = {400, 500},
			panic_chance_mul = 0
		}
	}
	presets.enemy_chatter = {
		no_chatter = {},
		cop = {
			aggressive = true,
			retreat = true,
			contact = true,
			clear = true,
			go_go = true,
			push = true,
			reload = true,
			look_for_angle = true,
			ecm = true,
			saw = true,
			trip_mines = true,
			sentry = true,
			ready = true,
			smoke = true,
			flash_grenade = true,
			follow_me = true,
			suppress = true
		},
		swat = {
			aggressive = true,
			retreat = true,
			contact = true,
			clear = true,
			go_go = true,
			push = true,
			reload = true,
			look_for_angle = true,
			ecm = true,
			saw = true,
			trip_mines = true,
			sentry = true,
			ready = true,
			smoke = true,
			flash_grenade = true,
			follow_me = true,
			suppress = true
		},
		summers = {
			aggressive = true,
			retreat = true,
			contact = true,
			clear = true,
			go_go = true,
			push = true,
			reload = true,
			look_for_angle = true,
			ecm = true,
			saw = true,
			trip_mines = true,
			sentry = true,
			ready = true,
			smoke = true,
			flash_grenade = true,
			follow_me = true,
			suppress = true
		},
		shield = {follow_me = true}
	}
	return presets
end


function CharacterTweakData:_create_table_structure()
	self.weap_ids = {
		"beretta92",
		"c45",
		"raging_bull",
		"m4",
		"ak47",
		"r870",
		"mossberg",
		"mp5",
		"mp5_tactical",
		"mp9",
		"mac11",
		"m14_sniper_npc",
		"saiga",
		"m249",
		"benelli",
		"g36",
		"ump",
		"scar_murky",
		"rpk_lmg",
		"svd_snp",
		"akmsu_smg",
		"asval_smg",
		"sr2_smg",
		"ak47_ass",
		"peacemaker",
		"x_akmsu",
		"x_c45",
		"sg417",
		"svdsil_snp",
		"mini",
		"heavy_zeal_sniper",
		"m4_boom",
		"hk21_sc",
		"mp5_zeal",
		"p90_summer",
		"m16_summer",
		"mp5_cloak",
		"s552_sc"
	}
	self.weap_unit_names = {
		Idstring("units/payday2/weapons/wpn_npc_beretta92/wpn_npc_beretta92"),
		Idstring("units/payday2/weapons/wpn_npc_c45/wpn_npc_c45"),
		Idstring("units/payday2/weapons/wpn_npc_raging_bull/wpn_npc_raging_bull"),
		Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4"),
		Idstring("units/payday2/weapons/wpn_npc_ak47/wpn_npc_ak47"),
		Idstring("units/payday2/weapons/wpn_npc_r870/wpn_npc_r870"),
		Idstring("units/payday2/weapons/wpn_npc_sawnoff_shotgun/wpn_npc_sawnoff_shotgun"),
		Idstring("units/payday2/weapons/wpn_npc_mp5/wpn_npc_mp5"),
		Idstring("units/payday2/weapons/wpn_npc_mp5_tactical/wpn_npc_mp5_tactical"),
		Idstring("units/payday2/weapons/wpn_npc_smg_mp9/wpn_npc_smg_mp9"),
		Idstring("units/payday2/weapons/wpn_npc_mac11/wpn_npc_mac11"),
		Idstring("units/payday2/weapons/wpn_npc_sniper/wpn_npc_sniper"),
		Idstring("units/payday2/weapons/wpn_npc_saiga/wpn_npc_saiga"),
		Idstring("units/payday2/weapons/wpn_npc_lmg_m249/wpn_npc_lmg_m249"),
		Idstring("units/payday2/weapons/wpn_npc_benelli/wpn_npc_benelli"),
		Idstring("units/payday2/weapons/wpn_npc_g36/wpn_npc_g36"),
		Idstring("units/payday2/weapons/wpn_npc_ump/wpn_npc_ump"),
		Idstring("units/payday2/weapons/wpn_npc_scar_murkywater/wpn_npc_scar_murkywater"),
		Idstring("units/pd2_dlc_mad/weapons/wpn_npc_rpk/wpn_npc_rpk"),
		Idstring("units/pd2_dlc_mad/weapons/wpn_npc_svd/wpn_npc_svd"),
		Idstring("units/pd2_dlc_mad/weapons/wpn_npc_akmsu/wpn_npc_akmsu"),
		Idstring("units/pd2_dlc_mad/weapons/wpn_npc_asval/wpn_npc_asval"),
		Idstring("units/pd2_dlc_mad/weapons/wpn_npc_sr2/wpn_npc_sr2"),
		Idstring("units/pd2_dlc_mad/weapons/wpn_npc_ak47/wpn_npc_ak47"),
		Idstring("units/payday2/weapons/wpn_npc_peacemaker/wpn_npc_peacemaker"),
		Idstring("units/pd2_dlc_mad/weapons/wpn_npc_akmsu/wpn_npc_x_akmsu"),
		Idstring("units/payday2/weapons/wpn_npc_c45/wpn_npc_x_c45"),
		Idstring("units/pd2_dlc_chico/weapons/wpn_npc_sg417/wpn_npc_sg417"),
		Idstring("units/pd2_dlc_spa/weapons/wpn_npc_svd_silenced/wpn_npc_svd_silenced"),
		Idstring("units/pd2_dlc_drm/weapons/wpn_npc_mini/wpn_npc_mini"),
		Idstring("units/payday2/weapons/wpn_npc_scar_murkywater/wpn_npc_scar_murkywater"),
		Idstring("units/payday2/weapons/wpn_npc_m4_boom/wpn_npc_m4_boom"),
		Idstring("units/payday2/weapons/wpn_npc_hk21_sc/wpn_npc_hk21_sc"),
		Idstring("units/payday2/weapons/wpn_npc_mp5/wpn_npc_mp5"),
		Idstring("units/payday2/weapons/wpn_npc_mp5/wpn_npc_mp5"),
		Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4"),
		Idstring("units/payday2/weapons/wpn_npc_mp5_cloak/wpn_npc_mp5_cloak"),
		Idstring("units/payday2/weapons/wpn_npc_s552_sc/wpn_npc_s552_sc")
	}
end

function CharacterTweakData:_set_easy()
	self:_multiply_all_hp(0.75, 1)
	self:_multiply_weapon_delay(self.presets.weapon.normal, 0)
	self:_multiply_weapon_delay(self.presets.weapon.good, 0)
	self:_multiply_weapon_delay(self.presets.weapon.expert, 0)
	self:_multiply_weapon_delay(self.presets.weapon.sniper, 0)
	self:_multiply_weapon_delay(self.presets.weapon.gang_member, 0)
	self:_set_characters_weapon_preset("normal", "normal")
	self.city_swat.weapon = deep_clone(self.presets.weapon.normal)
	self.city_swat_titan.weapon = deep_clone(self.presets.weapon.normal)
	self.city_swat_titan_assault.weapon = deep_clone(self.presets.weapon.normal)
	self:_set_characters_dodge_preset("athletic")
	self:_set_characters_melee_preset("1", "1")
	self.shield.weapon.is_pistol.melee_speed = nil
	self.shield.weapon.is_pistol.melee_dmg = nil
	self.shield.weapon.is_pistol.melee_retry_delay = nil
	self.flashbang_multiplier = 2
	self.concussion_multiplier = 2
	self.presets.gang_member_damage.HEALTH_INIT = 25
	self.presets.gang_member_damage.MIN_DAMAGE_INTERVAL = 0.6
	self.old_hoxton_mission.HEALTH_INIT = 25
	self.spa_vip.HEALTH_INIT = 25
	self.presets.gang_member_damage.BLEED_OUT_HEALTH_INIT = 25
	self.weap_unit_names[5] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")
	self.weap_unit_names[12] = Idstring("units/payday2/weapons/wpn_npc_scar_murkywater/wpn_npc_scar_murkywater")
	self.weap_unit_names[18] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")
	self.weap_unit_names[9] = Idstring("units/payday2/weapons/wpn_npc_mp5/wpn_npc_mp5")
	self.weap_unit_names[20] = Idstring("units/pd2_dlc_mad/weapons/wpn_npc_asval/wpn_npc_asval")
	self.weap_unit_names[24] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")
	self.weap_unit_names[22] = Idstring("units/payday2/weapons/wpn_npc_mp5/wpn_npc_mp5")
end

function CharacterTweakData:_set_normal()
	self:_multiply_all_hp(0.75, 1)
	self:_multiply_weapon_delay(self.presets.weapon.normal, 0)
	self:_multiply_weapon_delay(self.presets.weapon.good, 0)
	self:_multiply_weapon_delay(self.presets.weapon.expert, 0)
	self:_multiply_weapon_delay(self.presets.weapon.sniper, 0)
	self:_multiply_weapon_delay(self.presets.weapon.gang_member, 0)
	self:_set_characters_weapon_preset("normal", "normal")
	self.city_swat.weapon = deep_clone(self.presets.weapon.normal)
	self.city_swat_titan.weapon = deep_clone(self.presets.weapon.normal)
	self.city_swat_titan_assault.weapon = deep_clone(self.presets.weapon.normal)	
	self:_set_characters_dodge_preset("athletic")
	self:_set_characters_melee_preset("1", "1")
	self.shield.weapon.is_pistol.melee_speed = nil
	self.shield.weapon.is_pistol.melee_dmg = nil
	self.shield.weapon.is_pistol.melee_retry_delay = nil
	self.flashbang_multiplier = 2
	self.concussion_multiplier = 2
	self.presets.gang_member_damage.HEALTH_INIT = 50
	self.presets.gang_member_damage.MIN_DAMAGE_INTERVAL = 0.55
	self.old_hoxton_mission.HEALTH_INIT = 50
	self.spa_vip.HEALTH_INIT = 50
	self.presets.gang_member_damage.BLEED_OUT_HEALTH_INIT = 50
	self.weap_unit_names[5] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")
	self.weap_unit_names[12] = Idstring("units/payday2/weapons/wpn_npc_scar_murkywater/wpn_npc_scar_murkywater")
	self.weap_unit_names[9] = Idstring("units/payday2/weapons/wpn_npc_mp5/wpn_npc_mp5")
	self.weap_unit_names[18] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")
	self.weap_unit_names[20] = Idstring("units/pd2_dlc_mad/weapons/wpn_npc_asval/wpn_npc_asval")
	self.weap_unit_names[24] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")
	self.weap_unit_names[22] = Idstring("units/payday2/weapons/wpn_npc_mp5/wpn_npc_mp5")	
end

function CharacterTweakData:_set_hard()
	self:_multiply_all_hp(1, 1)
	self:_multiply_weapon_delay(self.presets.weapon.normal, 0)
	self:_multiply_weapon_delay(self.presets.weapon.good, 0)
	self:_multiply_weapon_delay(self.presets.weapon.expert, 0)
	self:_multiply_weapon_delay(self.presets.weapon.sniper, 0)
	self:_multiply_weapon_delay(self.presets.weapon.gang_member, 0)
	self:_set_characters_weapon_preset("normal", "normal")
	self.city_swat.weapon = deep_clone(self.presets.weapon.normal)
	self.city_swat_titan.weapon = deep_clone(self.presets.weapon.normal)
	self.city_swat_titan_assault.weapon = deep_clone(self.presets.weapon.normal)	
	self:_set_characters_dodge_preset("athletic")
	self:_set_characters_melee_preset("1", "1")
	self.shield.weapon.is_pistol.melee_speed = nil
	self.shield.weapon.is_pistol.melee_dmg = nil
	self.shield.weapon.is_pistol.melee_retry_delay = nil
	self.flashbang_multiplier = 2
	self.concussion_multiplier = 2
	self.presets.gang_member_damage.HEALTH_INIT = 75
	self.presets.gang_member_damage.MIN_DAMAGE_INTERVAL = 0.5
	self.old_hoxton_mission.HEALTH_INIT = 75
	self.spa_vip.HEALTH_INIT = 75
	self.presets.gang_member_damage.BLEED_OUT_HEALTH_INIT = 75
	self.weap_unit_names[5] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")
	self.weap_unit_names[12] = Idstring("units/payday2/weapons/wpn_npc_scar_murkywater/wpn_npc_scar_murkywater")
	self.weap_unit_names[9] = Idstring("units/payday2/weapons/wpn_npc_mp5/wpn_npc_mp5")
	self.weap_unit_names[18] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")
	self.weap_unit_names[20] = Idstring("units/pd2_dlc_mad/weapons/wpn_npc_asval/wpn_npc_asval")
	self.weap_unit_names[24] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")
	self.weap_unit_names[22] = Idstring("units/payday2/weapons/wpn_npc_mp5/wpn_npc_mp5")
end

function CharacterTweakData:_set_overkill()
	self:_multiply_all_hp(1, 1)
	self:_multiply_weapon_delay(self.presets.weapon.normal, 0)
	self:_multiply_weapon_delay(self.presets.weapon.good, 0)
	self:_multiply_weapon_delay(self.presets.weapon.expert, 0)
	self:_multiply_weapon_delay(self.presets.weapon.sniper, 0)
	self:_multiply_weapon_delay(self.presets.weapon.gang_member, 0)
	self:_set_characters_weapon_preset("good", "normal")
	self.city_swat.weapon = deep_clone(self.presets.weapon.normal)
	self.city_swat_titan.weapon = deep_clone(self.presets.weapon.normal)
	self.city_swat_titan_assault.weapon = deep_clone(self.presets.weapon.normal)	
	self:_set_characters_dodge_preset("athletic_very_hard")
	self:_set_characters_melee_preset("2", "1")
	self.shield.weapon.is_pistol.melee_speed = nil
	self.shield.weapon.is_pistol.melee_dmg = nil
	self.shield.weapon.is_pistol.melee_retry_delay = nil
	self.flashbang_multiplier = 2
	self.concussion_multiplier = 2
	self.presets.gang_member_damage.HEALTH_INIT = 100
	self.presets.gang_member_damage.MIN_DAMAGE_INTERVAL = 0.45
	self.old_hoxton_mission.HEALTH_INIT = 100
	self.spa_vip.HEALTH_INIT = 100
	self.presets.gang_member_damage.BLEED_OUT_HEALTH_INIT = 100
	self.weap_unit_names[5] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")
	self.weap_unit_names[9] = Idstring("units/payday2/weapons/wpn_npc_mp5/wpn_npc_mp5")
	self.weap_unit_names[18] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")
	self.weap_unit_names[24] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")
	self.weap_unit_names[22] = Idstring("units/payday2/weapons/wpn_npc_mp5/wpn_npc_mp5")
end

function CharacterTweakData:_set_overkill_145()
	if SystemInfo:platform() == Idstring("PS3") then
		self:_multiply_all_hp(1.5, 1)
	else
		self:_multiply_all_hp(1.5, 1)
	end
	self:_multiply_weapon_delay(self.presets.weapon.normal, 0)
	self:_multiply_weapon_delay(self.presets.weapon.good, 0)
	self:_multiply_weapon_delay(self.presets.weapon.expert, 0)
	self:_multiply_weapon_delay(self.presets.weapon.sniper, 0)
	self:_multiply_weapon_delay(self.presets.weapon.gang_member, 0)
	self:_set_characters_weapon_preset("expert", "good")
	self.city_swat.weapon = deep_clone(self.presets.weapon.good)
	self.city_swat_titan.weapon = deep_clone(self.presets.weapon.good)
	self.city_swat_titan_assault.weapon = deep_clone(self.presets.weapon.good)
	self:_set_characters_dodge_preset("athletic_overkill")
	self:_set_characters_melee_preset("2.5", "2")
	self.shield.weapon.is_pistol.melee_speed = nil
	self.shield.weapon.is_pistol.melee_dmg = nil
	self.shield.weapon.is_pistol.melee_retry_delay = nil
	self.sniper.weapon = deep_clone(self.presets.weapon.sniper_good)
	self.heavy_swat_sniper.weapon = deep_clone(self.presets.weapon.sniper_good)
	self.flashbang_multiplier = 2
	self.concussion_multiplier = 2
	self.presets.gang_member_damage.HEALTH_INIT = 125
	self.presets.gang_member_damage.MIN_DAMAGE_INTERVAL = 0.4
	self.old_hoxton_mission.HEALTH_INIT = 125
	self.spa_vip.HEALTH_INIT = 125
	self.presets.gang_member_damage.BLEED_OUT_HEALTH_INIT = 125
	self:_multiply_all_speeds(1, 1.05)
	self.weap_unit_names[5] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")
	self.weap_unit_names[9] = Idstring("units/payday2/weapons/wpn_npc_mp5/wpn_npc_mp5")
	self.weap_unit_names[18] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")
	self.weap_unit_names[24] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")
	self.weap_unit_names[22] = Idstring("units/payday2/weapons/wpn_npc_mp5/wpn_npc_mp5")
end

function CharacterTweakData:_set_easy_wish()
	if SystemInfo:platform() == Idstring("PS3") then
		self:_multiply_all_hp(1.75, 0.8)
	else
		self:_multiply_all_hp(1.75, 0.8)
	end
	self:_multiply_weapon_delay(self.presets.weapon.normal, 0)
	self:_multiply_weapon_delay(self.presets.weapon.good, 0)
	self:_multiply_weapon_delay(self.presets.weapon.expert, 0)
	self:_multiply_weapon_delay(self.presets.weapon.sniper, 0)
	self:_multiply_weapon_delay(self.presets.weapon.gang_member, 0)
	self:_set_characters_weapon_preset("expert", "good")
	self:_set_characters_dodge_preset("athletic_overkill")
	self:_set_characters_melee_preset("2.5", "2")
	self.shield.weapon.is_pistol.melee_speed = nil
	self.shield.weapon.is_pistol.melee_dmg = nil
	self.shield.weapon.is_pistol.melee_retry_delay = nil
	self.sniper.weapon = deep_clone(self.presets.weapon.sniper_good)
	self.heavy_swat_sniper.weapon = deep_clone(self.presets.weapon.sniper_good)
	self.city_swat.weapon = deep_clone(self.presets.weapon.good)
	self.city_swat_titan.weapon = deep_clone(self.presets.weapon.good)
	self.city_swat_titan_assault.weapon = deep_clone(self.presets.weapon.good)	
	self:_multiply_all_speeds(1.05, 1.1)
	self.presets.gang_member_damage.HEALTH_INIT = 150
	self.presets.gang_member_damage.MIN_DAMAGE_INTERVAL = 0.35
	self.old_hoxton_mission.HEALTH_INIT = 150
	self.spa_vip.HEALTH_INIT = 150
	self.presets.gang_member_damage.BLEED_OUT_HEALTH_INIT = 150
	self.flashbang_multiplier = 2
	self.concussion_multiplier = 2
	self.weap_unit_names[5] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")
	self.weap_unit_names[9] = Idstring("units/payday2/weapons/wpn_npc_mp5/wpn_npc_mp5")
	self.weap_unit_names[18] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")
	self.weap_unit_names[24] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")
	self.weap_unit_names[22] = Idstring("units/payday2/weapons/wpn_npc_mp5/wpn_npc_mp5")
end

function CharacterTweakData:_set_overkill_290()
	if SystemInfo:platform() == Idstring("PS3") then
		self:_multiply_all_hp(1.75, 0.8)
	else
		self:_multiply_all_hp(1.75, 0.8)
	end
	self:_multiply_weapon_delay(self.presets.weapon.normal, 0)
	self:_multiply_weapon_delay(self.presets.weapon.good, 0)
	self:_multiply_weapon_delay(self.presets.weapon.expert, 0)
	self:_multiply_weapon_delay(self.presets.weapon.sniper, 0)
	self:_multiply_weapon_delay(self.presets.weapon.gang_member, 0)
	self:_set_characters_weapon_preset("deathwish", "expert")
	self:_set_characters_dodge_preset("deathwish")
	self:_set_characters_melee_preset("3.125", "2.5")
	self.shield.weapon.is_pistol.melee_speed = nil
	self.shield.weapon.is_pistol.melee_dmg = nil
	self.shield.weapon.is_pistol.melee_retry_delay = nil
	self.sniper.weapon = deep_clone(self.presets.weapon.sniper_expert)
	self.heavy_swat_sniper.weapon = deep_clone(self.presets.weapon.sniper_expert)
	self:_multiply_all_speeds(1.05, 1.1)
	self.presets.gang_member_damage.HEALTH_INIT = 175
	self.presets.gang_member_damage.MIN_DAMAGE_INTERVAL = 0.35
	self.old_hoxton_mission.HEALTH_INIT = 175
	self.spa_vip.HEALTH_INIT = 175
	self.presets.gang_member_damage.BLEED_OUT_HEALTH_INIT = 175
	self.flashbang_multiplier = 2
	self.concussion_multiplier = 2
	self.weap_unit_names[5] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")
	self.weap_unit_names[9] = Idstring("units/payday2/weapons/wpn_npc_mp5/wpn_npc_mp5")
	self.weap_unit_names[18] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")
	self.weap_unit_names[24] = Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4")
	self.weap_unit_names[22] = Idstring("units/payday2/weapons/wpn_npc_mp5/wpn_npc_mp5")
end

local restoration_mod_instance = ModInstance
function CharacterTweakData:_set_sm_wish()
	restoration_mod_instance:GetSuperMod():GetAssetLoader():LoadAssetGroup("cops")
	self:_multiply_all_hp(1, 1)
	self:_multiply_weapon_delay(self.presets.weapon.normal, 0)
	self:_multiply_weapon_delay(self.presets.weapon.good, 0)
	self:_multiply_weapon_delay(self.presets.weapon.expert, 0)
	self:_multiply_weapon_delay(self.presets.weapon.sniper, 0)
	self:_multiply_weapon_delay(self.presets.weapon.gang_member, 0)
	self.security = deep_clone(self.deathvox_guard) -- fucking broke piece of shit movement stuff
	self.gensec = deep_clone(self.deathvox_guard)
	self.bolivian_indoors.HEALTH_INIT = 15
	self.gangster.HEALTH_INIT = 15
	self.biker.HEALTH_INIT = 15
	self.biker_escape.HEALTH_INIT = 15
	self.cop.HEALTH_INIT = 15
	self:_set_characters_dodge_preset("deathvox")
	self:_set_characters_melee_preset("3", "2.5")
	self:_set_characters_weapon_preset("deathvox", "deathvox")
	self.deathvox_sniper_assault.weapon = deep_clone(self.presets.weapon.deathvox_sniper)
	self.shield.weapon.is_pistol.melee_speed = nil
	self.shield.weapon.is_pistol.melee_dmg = nil
	self.shield.weapon.is_pistol.melee_retry_delay = nil
	self.sniper = deep_clone(self.deathvox_sniper)
	self.sniper.weapon = deep_clone(self.presets.weapon.deathvox_sniper)
	self.security.no_arrest = true
	self.gensec.no_arrest = true
	self.bolivian_indoors.no_arrest = true
	if job == "kosugi" or job == "dark" then
		self.city_swat.no_arrest = true
	else
		self.city_swat.no_arrest = false
	end
	self:_multiply_all_speeds(1, 1)
	self.presets.gang_member_damage.HEALTH_INIT = 175
	self.presets.gang_member_damage.MIN_DAMAGE_INTERVAL = 0.35
	self.old_hoxton_mission.HEALTH_INIT = 175
	self.spa_vip.HEALTH_INIT = 175
	self.presets.gang_member_damage.BLEED_OUT_HEALTH_INIT = 175
	self.flashbang_multiplier = 2
	self.concussion_multiplier = 2
end

function CharacterTweakData:is_special_unit(enemy_tweak)
	local is_special = false
	if self[enemy_tweak]["tags"] and #self[enemy_tweak].tags then
		is_special = true
	end
	return is_special
end

function CharacterTweakData:_multiply_weapon_delay(weap_usage_table, mul)
	for _, weap_id in ipairs(self.weap_ids) do
		local usage_data = weap_usage_table[weap_id]

		if usage_data then
			usage_data.focus_delay = usage_data.focus_delay * mul
		end
	end
end


function CharacterTweakData:_multiply_all_hp(hp_mul, hs_mul)
	for _, enemy_tweak in ipairs(self._enemy_list) do
		if self[enemy_tweak] then
			self[enemy_tweak].HEALTH_INIT = self[enemy_tweak].HEALTH_INIT * hp_mul
			if self[enemy_tweak].headshot_dmg_mul then
				self[enemy_tweak].headshot_dmg_mul = self[enemy_tweak].headshot_dmg_mul * hs_mul
			end
		end
	end
end

function CharacterTweakData:_multiply_all_speeds(walk_mul, run_mul)
	for _, enemy_tweak in ipairs(self._enemy_list) do
		if self[enemy_tweak] then
			local speed_table = self[enemy_tweak].SPEED_WALK
			speed_table.hos = speed_table.hos * walk_mul
			speed_table.cbt = speed_table.cbt * walk_mul
			self[enemy_tweak].SPEED_RUN = self[enemy_tweak].SPEED_RUN * run_mul
		end
	end
end

function CharacterTweakData:_set_characters_weapon_preset(preset, special_preset)
	for _, enemy_tweak in ipairs(self._enemy_list) do
		if self[enemy_tweak] then
			if not self[enemy_tweak].static_weapon_preset then
				if not self:is_special_unit(enemy_tweak) then
					self[enemy_tweak].weapon = deep_clone(self.presets.weapon[preset])
				else
					self[enemy_tweak].weapon = deep_clone(self.presets.weapon[special_preset])
				end
			end
		end
	end
end

function CharacterTweakData:_set_characters_dodge_preset(preset)
	for _, enemy_tweak in ipairs(self._enemy_list) do
		if self[enemy_tweak] then
			if not self[enemy_tweak].static_dodge_preset then
				if not self:is_special_unit(enemy_tweak) then
					self[enemy_tweak].dodge = self.presets.dodge[preset]
				end
			end
		end
	end
end

function CharacterTweakData:_set_characters_melee_preset(preset, special_preset)
	for _, enemy_tweak in ipairs(self._enemy_list) do
		if self[enemy_tweak] then
			if not self[enemy_tweak].static_melee_preset then
				if not self:is_special_unit(enemy_tweak) then
					self[enemy_tweak].melee_weapon_dmg_multiplier = preset
				else
					self[enemy_tweak].melee_weapon_dmg_multiplier = special_preset
				end
			end
		end
	end
end

function CharacterTweakData:character_map()
	local char_map = {
		basic = {
			path = "units/payday2/characters/",
			list = {
				"civ_female_bank_1",
				"civ_female_bank_manager_1",
				"civ_female_bikini_1",
				"civ_female_bikini_2",
				"civ_female_casual_1",
				"civ_female_casual_2",
				"civ_female_casual_3",
				"civ_female_casual_4",
				"civ_female_casual_5",
				"civ_female_casual_6",
				"civ_female_casual_7",
				"civ_female_casual_8",
				"civ_female_casual_9",
				"civ_female_casual_10",
				"civ_female_crackwhore_1",
				"civ_female_curator_1",
				"civ_female_curator_2",
				"civ_female_hostess_apron_1",
				"civ_female_hostess_jacket_1",
				"civ_female_hostess_shirt_1",
				"civ_female_party_1",
				"civ_female_party_2",
				"civ_female_party_3",
				"civ_female_party_4",
				"civ_female_waitress_1",
				"civ_female_waitress_2",
				"civ_female_waitress_3",
				"civ_female_waitress_4",
				"civ_female_wife_trophy_1",
				"civ_female_wife_trophy_2",
				"civ_male_bank_1",
				"civ_male_bank_2",
				"civ_male_bank_manager_1",
				"civ_male_bank_manager_3",
				"civ_male_bank_manager_4",
				"civ_male_bank_manager_5",
				"civ_male_bartender_1",
				"civ_male_bartender_2",
				"civ_male_business_1",
				"civ_male_business_2",
				"civ_male_casual_1",
				"civ_male_casual_2",
				"civ_male_casual_3",
				"civ_male_casual_4",
				"civ_male_casual_5",
				"civ_male_casual_6",
				"civ_male_casual_7",
				"civ_male_casual_8",
				"civ_male_casual_9",
				"civ_male_casual_12",
				"civ_male_casual_13",
				"civ_male_casual_14",
				"civ_male_curator_1",
				"civ_male_curator_2",
				"civ_male_curator_3",
				"civ_male_dj_1",
				"civ_male_italian_robe_1",
				"civ_male_janitor_1",
				"civ_male_janitor_2",
				"civ_male_janitor_3",
				"civ_male_meth_cook_1",
				"civ_male_party_1",
				"civ_male_party_2",
				"civ_male_party_3",
				"civ_male_pilot_1",
				"civ_male_scientist_1",
				"civ_male_miami_store_clerk_1",
				"civ_male_taxman",
				"civ_male_trucker_1",
				"civ_male_worker_1",
				"civ_male_worker_2",
				"civ_male_worker_3",
				"civ_male_worker_docks_1",
				"civ_male_worker_docks_2",
				"civ_male_worker_docks_3",
				"civ_male_dog_abuser_1",
				"civ_male_dog_abuser_2",
				"ene_biker_1",
				"ene_biker_2",
				"ene_biker_3",
				"ene_biker_4",
				"ene_bulldozer_1",
				"ene_bulldozer_2",
				"ene_bulldozer_2_hw",
				"ene_bulldozer_3",
				"ene_bulldozer_4",
				"ene_city_swat_1",
				"ene_city_swat_2",
				"ene_city_swat_3",
				"ene_city_swat_heavy_1",
				"ene_city_swat_heavy_2",
				"ene_murkywater_1",
				"ene_murkywater_2",
				"ene_cop_1",
				"ene_cop_2",
				"ene_cop_3",
				"ene_cop_4",
				"ene_fbi_1",
				"ene_fbi_2",
				"ene_fbi_3",
				"ene_fbi_boss_1",
				"ene_fbi_female_1",
				"ene_fbi_female_2",
				"ene_fbi_female_3",
				"ene_fbi_female_4",
				"ene_fbi_heavy_1",
				"ene_fbi_heavy_r870",
				"ene_fbi_office_1",
				"ene_fbi_office_2",
				"ene_fbi_office_3",
				"ene_fbi_office_4",
				"ene_fbi_swat_1",
				"ene_fbi_swat_2",
				"ene_fbi_swat_3",
				"ene_gang_black_1",
				"ene_gang_black_2",
				"ene_gang_black_3",
				"ene_gang_black_4",
				"ene_gang_mexican_1",
				"ene_gang_mexican_2",
				"ene_gang_mexican_3",
				"ene_gang_mexican_4",
				"ene_gang_russian_1",
				"ene_gang_russian_2",
				"ene_gang_russian_3",
				"ene_gang_russian_4",
				"ene_gang_russian_5",
				"ene_gang_mobster_1",
				"ene_gang_mobster_2",
				"ene_gang_mobster_3",
				"ene_gang_mobster_4",
				"ene_gang_mobster_boss",
				"ene_guard_national_1",
				"ene_hoxton_breakout_guard_1",
				"ene_hoxton_breakout_guard_2",
				"ene_male_tgt_1",
				"ene_murkywater_1",
				"ene_murkywater_2",
				"ene_prisonguard_female_1",
				"ene_prisonguard_male_1",
				"ene_secret_service_1",
				"ene_secret_service_2",
				"ene_security_1",
				"ene_security_2",
				"ene_security_3",
				"ene_security_4",
				"ene_security_5",
				"ene_security_6",
				"ene_security_7",
				"ene_security_8",
				"ene_shield_1",
				"ene_shield_2",
				"ene_city_shield",
				"ene_shield_gensec",
				"ene_phalanx_1",
				"ene_vip_1",
				"ene_vip_2",
				"ene_sniper_1",
				"ene_sniper_2",
				"ene_spook_1",
				"ene_swat_1",
				"ene_swat_2",
				"ene_swat_heavy_1",
				"ene_swat_heavy_r870",
				"ene_tazer_1",
				"ene_grenadier_1",
				"ene_veteran_cop_1",
				"ene_veteran_cop_2",
				"npc_old_hoxton_prisonsuit_1",
				"npc_old_hoxton_prisonsuit_2",
				"ene_medic_r870",
				"ene_medic_m4",
				"ene_city_heavy_r870",
				"ene_city_heavy_g36",
				"ene_bulldozer_biker_1",
				"ene_guard_biker_1",
				"ene_murky_heavy_m4",
				"ene_murky_heavy_r870"
			}
		},
		dlc1 = {
			path = "units/pd2_dlc1/characters/",
			list = {
				"civ_male_bank_manager_2",
				"civ_male_casual_10",
				"civ_male_casual_11",
				"civ_male_firefighter_1",
				"civ_male_paramedic_1",
				"civ_male_paramedic_2",
				"ene_security_gensec_1",
				"ene_security_gensec_2"
			}
		},
		dlc2 = {
			path = "units/pd2_dlc2/characters/",
			list = {
				"civ_female_bank_assistant_1",
				"civ_female_bank_assistant_2"
			}
		},
		mansion = {
			path = "units/pd2_mcmansion/characters/",
			list = {
				"ene_male_hector_1",
				"ene_male_hector_2",
				"ene_hoxton_breakout_guard_1",
				"ene_hoxton_breakout_guard_2"
			}
		},
		cage = {
			path = "units/pd2_dlc_cage/characters/",
			list = {
				"civ_female_bank_2"
			}
		},
		arena = {
			path = "units/pd2_dlc_arena/characters/",
			list = {
				"civ_female_fastfood_1",
				"civ_female_party_alesso_1",
				"civ_female_party_alesso_2",
				"civ_female_party_alesso_3",
				"civ_female_party_alesso_4",
				"civ_female_party_alesso_5",
				"civ_female_party_alesso_6",
				"civ_male_party_alesso_1",
				"civ_male_party_alesso_2",
				"civ_male_alesso_booth",
				"civ_male_fastfood_1",
				"ene_guard_security_heavy_2",
				"ene_guard_security_heavy_1"
			}
		},
		kenaz = {
			path = "units/pd2_dlc_casino/characters/",
			list = {
				"civ_male_casino_1",
				"civ_male_casino_2",
				"civ_male_casino_3",
				"civ_male_casino_4",
				"ene_secret_service_1_casino",
				"civ_male_business_casino_1",
				"civ_male_business_casino_2",
				"civ_male_impersonator",
				"civ_female_casino_1",
				"civ_female_casino_2",
				"civ_female_casino_3",
				"civ_male_casino_pitboss"
			}
		},
		vip = {
			path = "units/pd2_dlc_vip/characters/",
			list = {
				"ene_vip_1",
				"ene_vip_2",
				"ene_spring",
				"ene_summers",
				"ene_phalanx_medic",
				"ene_phalanx_grenadier",
				"ene_phalanx_taser",
				"ene_phalanx_1",
				"ene_titan_shotgun",
				"ene_titan_rifle",
				"ene_omnia_lpf"
			}
		},
		holly = {
			path = "units/pd2_dlc_holly/characters/",
			list = {
				"civ_male_hobo_1",
				"civ_male_hobo_2",
				"civ_male_hobo_3",
				"civ_male_hobo_4",
				"ene_gang_hispanic_1",
				"ene_gang_hispanic_3",
				"ene_gang_hispanic_2"
			}
		},
		red = {
			path = "units/pd2_dlc_red/characters/",
			list = {
				"civ_female_inside_man_1"
			}
		},
		dinner = {
			path = "units/pd2_dlc_dinner/characters/",
			list = {
				"civ_male_butcher_2",
				"civ_male_butcher_1"
			}
		},
		pal = {
			path = "units/pd2_dlc_pal/characters/",
			list = {
				"civ_male_mitch"
			}
		},
		cane = {
			path = "units/pd2_dlc_cane/characters/",
			list = {
				"civ_male_helper_1",
				"civ_male_helper_2",
				"civ_male_helper_3",
				"civ_male_helper_4"
			}
		},
		berry = {
			path = "units/pd2_dlc_berry/characters/",
			list = {
				"ene_murkywater_no_light",
				"npc_locke"
			}
		},
		peta = {
			path = "units/pd2_dlc_peta/characters/",
			list = {
				"civ_male_boris"
			}
		},
		mad = {
			path = "units/pd2_dlc_mad/characters/",
			list = {
				"civ_male_scientist_01",
				"civ_male_scientist_02",
				"ene_akan_fbi_heavy_g36",
				"ene_akan_fbi_heavy_r870",
				"ene_akan_fbi_shield_sr2_smg",
				"ene_akan_fbi_spooc_asval_smg",
				"ene_akan_fbi_swat_ak47_ass",
				"ene_akan_fbi_swat_dw_ak47_ass",
				"ene_akan_fbi_swat_dw_r870",
				"ene_akan_fbi_swat_dw_ump",
				"ene_akan_fbi_swat_r870",
				"ene_akan_fbi_swat_ump",
				"ene_akan_fbi_tank_r870",
				"ene_akan_fbi_tank_rpk_lmg",
				"ene_akan_fbi_tank_saiga",
				"ene_akan_cs_cop_ak47_ass",
				"ene_akan_cs_cop_akmsu_smg",
				"ene_akan_cs_cop_asval_smg",
				"ene_akan_cs_cop_r870",
				"ene_akan_cs_heavy_ak47_ass",
				"ene_akan_cs_heavy_r870",
				"ene_akan_cs_shield_c45",
				"ene_akan_cs_swat_ak47_ass",
				"ene_akan_cs_swat_r870",
				"ene_akan_cs_swat_sniper_svd_snp",
				"ene_akan_cs_tazer_ak47_ass",
				"ene_akan_fbi_heavy_dw",
				"ene_akan_fbi_heavy_dw_r870",
				"ene_akan_fbi_1",
				"ene_akan_fbi_2",
				"ene_akan_veteran_1",
				"ene_akan_veteran_2",
				"ene_akan_grenadier_1",
				"ene_akan_medic_m4"
			}
		},
		born = {
			path = "units/pd2_dlc_born/characters/",
			list = {
				"ene_gang_biker_boss",
				"ene_biker_female_1",
				"ene_biker_female_2",
				"ene_biker_female_3",
				"npc_male_mechanic"
			}
		},
		flat = {
			path = "units/pd2_dlc_flat/characters/",
			list = {
				"npc_chavez",
				"npc_jamaican"
			}
		},
		help = {
			path = "units/pd2_dlc_help/characters/",
			list = {
				"ene_zeal_bulldozer_halloween"
			}
		},
		glace = {
			path = "units/pd2_dlc_glace/characters/",
			list = {
				"npc_chinese_prisoner",
				"npc_prisoner_1",
				"npc_prisoner_2",
				"npc_prisoner_3",
				"npc_prisoner_4",
				"npc_prisoner_5",
				"npc_prisoner_6",
				"npc_yakuza_prisoner"
			}
		},
		moon = {
			path = "units/pd2_dlc_moon/characters/",
			list = {
				"civ_male_pilot_2"
			}
		},
		friend = {
			path = "units/pd2_dlc_friend/characters/",
			list = {
				"ene_bolivian_thug_outdoor_01",
				"ene_bolivian_thug_outdoor_02",
				"ene_drug_lord_boss",
				"ene_security_manager",
				"ene_thug_indoor_01",
				"ene_thug_indoor_02"
			}
		},
		gitgud = {
			path = "units/pd2_dlc_gitgud/characters/",
			list = {
				"ene_zeal_bulldozer",
				"ene_zeal_bulldozer_2",
				"ene_zeal_bulldozer_3",
				"ene_zeal_cloaker",
				"ene_zeal_swat",
				"ene_zeal_city_1",
				"ene_zeal_city_2",
				"ene_zeal_swat_heavy",
				"ene_zeal_heavy_shield",
				"ene_zeal_swat_shield"
			}
		},
		spa = {
			path = "units/pd2_dlc_spa/characters/",
			list = {
				"ene_sniper_3",
				"npc_spa",
				"npc_spa_2",
				"npc_spa_3",
				"npc_gage"
			}
		},
		fish = {
			path = "units/pd2_dlc_lxy/characters/",
			list = {
				"civ_female_guest_gala_1",
				"civ_female_guest_gala_2",
				"civ_male_guest_gala_1",
				"civ_male_guest_gala_2",
				"civ_male_camera_crew_1"
			}
		},
		slu = {
			path = "units/pd2_dlc_slu/characters/",
			list = {"npc_vlad", "npc_sophia"}
		},
		run = {
			path = "units/pd2_dlc_run/characters/",
			list = {"npc_matt"}
		},
		rvd = {
			path = "units/pd2_dlc_rvd/characters/",
			list = {
				"npc_cop",
				"npc_cop_01",
				"npc_mr_brown",
				"npc_mr_pink",
				"npc_mr_orange",
				"npc_mr_blonde",
				"npc_mr_pink_escort",
				"ene_la_cop_1",
				"ene_la_cop_2",
				"ene_la_cop_3",
				"ene_la_cop_4",
				"ene_female_civ_undercover"
			}
		},		
		drm = {
			path = "units/pd2_dlc_drm/characters/",
			list = {
				"ene_bulldozer_medic",
				"ene_bulldozer_minigun",
				"ene_zeal_swat_heavy_sniper"
			}
		},
		wwh = {
			path = "units/pd2_dlc_wwh/characters/",
			list = {
				"ene_female_crew",
				"ene_male_crew_01",
				"ene_male_crew_02",
				"ene_captain",
				"ene_locke"
			}			
		},		
		dah = {
			path = "units/pd2_dlc_dah/characters/",
			list = {
				"npc_male_cfo",
				"npc_male_ralph"
			}
		},		
		hvh = {
			path = "units/pd2_dlc_hvh/characters/",
			list = {
				"ene_cop_hvh_1",
				"ene_cop_hvh_2",
				"ene_cop_hvh_3",
				"ene_cop_hvh_4",
				"ene_swat_hvh_1",
				"ene_swat_hvh_2",
				"ene_fbi_hvh_1",
				"ene_fbi_hvh_2",
				"ene_fbi_hvh_3",
				"ene_spook_hvh_1",
				"ene_swat_heavy_hvh_1",
				"ene_swat_heavy_hvh_r870",
				"ene_tazer_hvh_1",
				"ene_shield_hvh_1",
				"ene_shield_hvh_2",
				"ene_medic_hvh_r870",
				"ene_medic_hvh_m4",
				"ene_bulldozer_hvh_1",
				"ene_bulldozer_hvh_2",
				"ene_bulldozer_hvh_3",
				"ene_fbi_swat_hvh_1",
				"ene_fbi_swat_hvh_2",
				"ene_fbi_heavy_hvh_1",
				"ene_fbi_heavy_hvh_r870",
				"ene_sniper_hvh_2"
			}
		},		
		sharks = {
			path = "units/pd2_mod_sharks/characters/",
			list = {
				"ene_murky_swat_m4",
				"ene_murky_swat_r870",
				"ene_murky_hrt_1",
				"ene_murky_hrt_2",
				"ene_murky_heavy_m4",
				"ene_murky_heavy_r870",
				"ene_murky_fbi_heavy_m4",
				"ene_murky_fbi_heavy_r870",
				"ene_murky_yellow_m4",
				"ene_murky_yellow_r870",
				"ene_murky_shield_yellow",
				"ene_murky_shield_fbi",
				"ene_murky_city_ump",
				"ene_murky_city_bnl",
				"ene_murky_city_m4",
				"ene_murky_fbi_tank_m249",
				"ene_murky_fbi_tank_saiga",
				"ene_murky_fbi_tank_r870",
				"ene_murky_spook",
				"ene_murky_tazer"
			}
		}		
	}
	return char_map
end

end