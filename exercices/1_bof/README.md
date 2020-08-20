# Training_Ressources

## Compilation options
gcc -no-pie -Wl,-z,norelro -fno-stack-protector -z execstack stack5.c -o stack5

## Assembly command
``` console
as bind_shell.s -o bind_shell.o && ld -N bind_shell.o -o bind_shell  
objcopy -O binary bind_shell bind_shell.bin  
hexdump -v -e '"\\""x" 1/1 "%02x" ""' bind_shell.bin  
```  
