local job = _G.job_id or game.JobId
local place = 109983668079237

game:GetService("TeleportService"):TeleportToPlaceInstance(place, job, game:GetService("Players").LocalPlayer)
print("Teleportação enviada para job:", job)
