local job = _G.job_id or game.JobId
local place = YOUR_PLACE_ID -- substitua aqui

game:GetService("TeleportService"):TeleportToPlaceInstance(place, job, game:GetService("Players").LocalPlayer)
print("Teleportação enviada para job:", job)
