SubscribedEvents = {}

function SubscribedEvents:SubscribeToEvents()
    local function conditionalWrapper(handler)
        return function(...)
            if MCMGet("mod_enabled") then
                handler(...)
            else
                SRCPrint(1, "Event handling is disabled.")
            end
        end
    end

    SRCPrint(2,
        "Subscribing to events with JSON config: " ..
        Ext.Json.Stringify(Mods.BG3MCM.MCMAPI:GetAllModSettings(ModuleUUID), { Beautify = true }))

    -- Event subscriptions
    Events.Osiris.ShortRested:Subscribe(conditionalWrapper(function(character)
        ShortRestInstance:HandleShortRested(character)
    end))
end

return SubscribedEvents
