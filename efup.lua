efup:fstab("efup.fstab")
efup:source("file://update.zip")
efup:verify()
efup:run("download.lua")
