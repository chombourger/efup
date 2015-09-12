print("Formatting root partition...")
efup:umount("/volumes/root")
ret = efup:format("/volumes/root")
if ret == 0 then
   ret = efup:mount("/volumes/root")
   if ret == 0 then
      print("Extracting root file-system...")
      ret = efup:extract("xubuntu_13_04_gpu.tar", "/volumes/root")
      efup:umount("/volumes/root")
   else
      print("Failed to mount root partition!")
   end
else
   print("Failed to format root partition!")
end
