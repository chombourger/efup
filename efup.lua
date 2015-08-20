
i = ui:Image("data/tux.png")
x = (ui:Width() - i:Width()) / 2
y = (ui:Height() - i:Height()) / 2
i:Draw(x, y)
ui:FlipBuffers()

-- Load volume table 
ret = efup:fstab("efup.fstab")
if ret == 0 then
    print("Volumes loaded.");
    -- Use update.zip from the current directory
    ret = efup:source("file://update.zip")
    if ret == 0 then
        print("Update source selected.")
        -- Verify its signature
        ret = efup:verify()
        if ret == 0 then
           print("Update verified.")
           -- Run the actual download script from the archive
           print("Running update script")
           ret = efup:run("download.lua")
        else
           print("Signature verification failed")
        end
    else
       print("Failed to open update file!")
    end
else
    print("Failed to load volume table!")
end

if ret ~= 0 then
   print("Update failed!")
end

