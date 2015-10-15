
-- Load and display logo
i = ui:Image("data/tux.png")
x = (ui:Width() - i:Width()) / 2
y = (ui:Height() - i:Height()) / 2
i:Draw(x, y)

f = ui:Font("data/Vera.ttf", 24)
ui:SetFont(f)

ui:SetColor(0, 80, 0, 255)
y = y + i:Height()
textx = x + (i:Width() / 2)
texty = y
ui:DrawString("Initializing", textx, texty, ui.TEXT_CENTER);

w = ui:Width() / 4
x = (ui:Width() / 2) - (w / 2)
y = y + 50
ui:ShowProgress(x, y, w, 24)

function PrintMessage(msg)
   ui:SetColor(0, 0, 0, 255)
   ui:FillRectangle(0, texty, ui:Width(), 24);
   ui:SetColor(0, 80, 0, 255)
   ui:DrawString(msg, textx, texty, ui.TEXT_CENTER);
   print(msg)
end

-- Load volume table 
ret = efup:fstab("efup.fstab")
if ret == 0 then
    print("Volumes loaded.")
    ret = efup:mount("/volumes/usb")
    if ret == 0 then
        PrintMessage("USB disk mounted")
        -- Use update.zip from the mounted volume
        ret = efup:source("file:///volumes/usb/update.zip")
        if ret == 0 then
            -- Verify its signature
            PrintMessage("Verifying update file...")
            ret = efup:verify()
            if ret == 0 then
                -- Run the actual download script from the archive
                PrintMessage("Processing update...")
                ret = efup:run("download.lua")
            else
                PrintMessage("Signature verification failed")
            end
        else
            PrintMessage("Failed to open update file!")
        end
    else
        PrintMessage("Failed to mount USB disk!")
    end
else
    PrintMessage("Failed to load volume table!")
end

if ret ~= 0 then
   PrintMessage("Update failed!")
else
   PrintMessage("Update completed!")
end

