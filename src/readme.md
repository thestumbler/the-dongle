Messages:

msg000   ?30
msg001   259000059
msg002   256000056
msg003   1280129
msg004   ~OK

Common RAM at 0x0020, size: 64 bytes

Usage     Offset from 0x20
  0        0x00        0
 17        0x01        1     counter
  1        0x04        4    (1)
  1        0x05        5    (1)
  9        0x0a        10
  4        0x0b        11
  7        0x0c        12
  2        0x0e        14
  7        0x0f        15
  1        0x10        16   incoming string buffer
  1        0x12        18   ....


 24        0x22        34
 10        0x23        35    outgoing serial character
  2        0x24        36
  4        0x25        37
  3        0x26        38    incoming serial character

In PIC Assembly language, F is equivalent to 1 and W is equivalent to 0
defined in P******.inc, apparently

Internal oscillator, 4 MHz
One CPU cycle is 4 system clocks = 1 us

IRP bits not used by this PIC, should be kept as clear

mem[14] = eeprom[0]

uart input is looking for:


if '3':
  if eeprom[0]==0xab: 
    mem[12] = 0x0c
  else:
    mem[12] = 0x00
       
elif 0x7e:
  mem[12] = 0x02

else:
  mem[12] = 0x00

mem[12] ==> how many subsequent chars to read


fsr[0x30] = mem[0x10]

