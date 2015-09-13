
-- Load and display logo
i = ui:Image("data/tux.png")
x = (ui:Width() - i:Width()) / 2
y = (ui:Height() - i:Height()) / 2
i:Draw(x, y)

f = ui:Font("data/Vera.ttf", 24)
ui:SetFont(f)

ui:SetColor(0, 80, 0, 255)
ui:DrawString("Initializing", x + (i:Width() / 2), y + i:Height(), ui.TEXT_CENTER);

ui:FlipBuffers()

-- Load volume table 
ret = efup:fstab("efup.fstab")
if ret == 0 then
    print("Volumes loaded.")
    ret = efup:mount("/volumes/usb")
    if ret == 0 then
        print("USB disk mounted")
        -- Use update.zip from the mounted volume
        ret = efup:source("file:///volumes/usb/update.zip")
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
        print("Failed to mount USB disk!")
    end
else
    print("Failed to load volume table!")
end

if ret ~= 0 then
   print("Update failed!")
end

