
failure="Unknown failure!"

efup:umount("/volumes/boot")
efup:umount("/volumes/root")
efup:umount("/volumes/data")

PrintMessage("Partitioning boot device...")
pm = efup:partition("/dev/sdb")
ret = pm:reset()
if ret == 0 then
   ret = pm:add(0xc, "200M")
   if ret == 0 then
      ret = pm:add(0x83, "2G")
      if ret == 0 then
         ret = pm:add(0x83)
      end
   end
   if ret ~= 0 then
      failure="Failed to partition boot device!"
   end
end

-- Write partition table
if ret == 0 then
   ret = pm:write()
   if ret ~= 0 then
      failure="Failed to write partition table!"
   end
end

-- Refresh /dev
if ret == 0 then
   ret = efup:mdev()
   if ret ~= 0 then
      failure="Failed to reload device nodes!"
   end
end

-- Format boot partition
if ret == 0 then
   PrintMessage("Formatting boot partition...")
   ret = efup:format("/volumes/boot")
   if ret ~= 0 then
      failure="Failed to format boot partition!"
   end
end

-- Format root partition
if ret == 0 then
   PrintMessage("Formatting root partition...")
   ret = efup:format("/volumes/root")
   if ret ~= 0 then
      failure="Failed to format root partition!"
   end
end

-- Try mounting data partition
if ret == 0 then
   ret = efup:mount("/volumes/data")
   if ret ~= 0 then
      -- Format data partition
      PrintMessage("Formatting data partition...")
      ret = efup:format("/volumes/data")
      if ret ~= 0 then
         failure="Failed to format data partition!"
      end
   end
end

-- Populate root file-system
if ret == 0 then
   ret = efup:mount("/volumes/root")
   if ret == 0 then
      PrintMessage("Extracting root file-system...")
      ShowProgress()
      ret = efup:extract("xubuntu_13_04_gpu.tar", "/volumes/root")
      HideProgress()
      efup:umount("/volumes/root")
      if ret ~= 0 then
         failure="Failed to populate root partition!"
      end
   else
      failure="Failed to mount root partition!"
   end
end

-- Print failure message if something went wrong
if ret ~= 0 then
   print(failure)
end

