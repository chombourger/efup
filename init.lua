
-- Create device nodes
efup:mknod("/dev/fb0", "c", 29, 0)
efup:mknod("/dev/tty0", "c", 4, 0)
efup:mknod("/dev/tty1", "c", 4, 1)
efup:mknod("/dev/tty2", "c", 4, 2)
efup:mknod("/dev/console", "c", 5, 1)

