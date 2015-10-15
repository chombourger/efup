PrintMessage("Formatting root partition...")
efup:umount("/volumes/root")
ret = efup:format("/volumes/root")
if ret == 0 then
   ret = efup:mount("/volumes/root")
   if ret == 0 then
      PrintMessage("Extracting root file-system...")
      ShowProgress()
      ret = efup:extract("xubuntu_13_04_gpu.tar", "/volumes/root")
      HideProgress()
      efup:umount("/volumes/root")
   else
      PrintMessage("Failed to mount root partition!")
   end
else
   PrintMessage("Failed to format root partition!")
end
