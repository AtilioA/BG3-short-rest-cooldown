EHandlers = {}

function EHandlers.OnTimerFinished(timer)
  if timer == "ShortRestCooldown" then
    ShortRestInstance:HandleCooldownFinished(timer)
  end
end

return EHandlers
