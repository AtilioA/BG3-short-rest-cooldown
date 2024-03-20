Config = VCHelpers.Config:New({
  folderName = "ShortRestCooldown",
  configFilePath = "short_rest_cooldown_config.json",
  defaultConfig = {
    GENERAL = {
      enabled = true, -- Toggle the mod on/off
    },
    FEATURES = {
      cooldown = 1, -- Cooldown in seconds
      -- only_in_multiplayer = false, -- If true, the cooldown will only be applied in multiplayer
    },
    DEBUG = {
      level = 0 -- 0 = no debug, 1 = minimal, 2 = verbose debug logs
    }
  },
  onConfigReloaded = {}
})

Config:UpdateCurrentConfig()

Config:AddConfigReloadedCallback(function(configInstance)
  SRCPrinter.DebugLevel = configInstance:GetCurrentDebugLevel()
  SRCPrint(0, "Config reloaded: " .. Ext.Json.Stringify(configInstance:getCfg(), { Beautify = true }))
end)
Config:RegisterReloadConfigCommand("src")
