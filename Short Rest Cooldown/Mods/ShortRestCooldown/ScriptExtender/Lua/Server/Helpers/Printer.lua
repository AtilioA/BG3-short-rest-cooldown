SRCPrinter = Printer:New { Prefix = "Short Rest Cooldown", ApplyColor = true, DebugLevel = MCMGet("debug_level") }

-- Update the Printer debug level when the setting is changed, since the value is only used during the object's creation
Ext.ModEvents.BG3MCM['MCM_Setting_Saved']:Subscribe(function(payload)
    if not payload or payload.modUUID ~= ModuleUUID or not payload.settingId then
        return
    end

    if payload.settingId == "debug_level" then
        SRCDebug(0, "Setting debug level to " .. payload.value)
        SRCPrinter.DebugLevel = payload.value
    end
end)

function SRCPrint(debugLevel, ...)
    SRCPrinter:SetFontColor(0, 255, 255)
    SRCPrinter:Print(debugLevel, ...)
end

function SRCTest(debugLevel, ...)
    SRCPrinter:SetFontColor(100, 200, 150)
    SRCPrinter:PrintTest(debugLevel, ...)
end

function SRCDebug(debugLevel, ...)
    SRCPrinter:SetFontColor(200, 200, 0)
    SRCPrinter:PrintDebug(debugLevel, ...)
end

function SRCWarn(debugLevel, ...)
    SRCPrinter:SetFontColor(255, 100, 50)
    SRCPrinter:PrintWarning(debugLevel, ...)
end

function SRCDump(debugLevel, ...)
    SRCPrinter:SetFontColor(190, 150, 225)
    SRCPrinter:Dump(debugLevel, ...)
end

function SRCDumpArray(debugLevel, ...)
    SRCPrinter:DumpArray(debugLevel, ...)
end
