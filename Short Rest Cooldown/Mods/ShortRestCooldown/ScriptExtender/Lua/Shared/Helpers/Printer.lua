SRCPrinter = VolitionCabinetPrinter:New { Prefix = "Short Rest Cooldown", ApplyColor = true, DebugLevel = Config:GetCurrentDebugLevel() }

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
