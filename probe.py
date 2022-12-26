#!/usr/bin/env python

import sys
import time
import serial
import gpiozero
import gpiozero.pins.rpigpio

# hexdump modified from here:
# https://gist.github.com/mzpqnxow/a368c6cd9fae97b87ef25f475112c84c
def hexdump(src, length=16, sep='.', offset=False):
  """Hex dump bytes to ASCII string, padded neatly
  In [107]: x = b'\x01\x02\x03\x04AAAAAAAAAAAAAAAAAAAAAAAAAABBBBBBBBBBBBBBBBBBBBBBBBBB'
  
  In [108]: print('\n'.join(hexdump(x)))
  00000000  01 02 03 04 41 41 41 41  41 41 41 41 41 41 41 41 |....AAAAAAAAAAAA|
  00000010  41 41 41 41 41 41 41 41  41 41 41 41 41 41 42 42 |AAAAAAAAAAAAAABB|
  00000020  42 42 42 42 42 42 42 42  42 42 42 42 42 42 42 42 |BBBBBBBBBBBBBBBB|
  00000030  42 42 42 42 42 42 42 42                          |BBBBBBBB        |
  """
  FILTER = ''.join([(len(repr(chr(x))) == 3) and chr(x) or sep for x in range(256)])
  lines = []
  for c in range(0, len(src), length):
      chars = src[c: c + length]
      hex_ = ' '.join(['{:02x}'.format(x) for x in chars])
      if len(hex_) > 24:
          hex_ = '{} {}'.format(hex_[:24], hex_[24:])
      printable = ''.join(['{}'.format((x <= 127 and FILTER[x]) or sep) for x in chars])
      if offset:
        lines.append(f'{c:08x}  {hex_:{3*length}s} {printable:{length}s}')
      else:
        lines.append(f'{hex_:{3*length}s} {printable:{length}s}')
  return '\n'.join(lines)

def help():
  print('help')

def boot():
  if relay.value:
    relay.off()
    time.sleep(0.5)
  relay.on()
  buff = port.read(100)
  print(type(buff))
  print(buff)
  print(hexdump(buff))
  relay.off()

def power( on=False ):
  if on: relay.on()
  else:  relay.off()

# Leave pins as-is when exiting program,
# see discussion here:
# https://github.com/gpiozero/gpiozero/issues/707
# workaround by user GAM-Gerlach 11 Feb 2020
# To preserve the current state of a pin when 
# starting the program, set initial_value=None
# in LED() initializer

def close(self): pass
gpiozero.pins.rpigpio.RPiGPIOPin.close = close

# Docs:
# https://pyserial.readthedocs.io/en/latest/
# https://gpiozero.readthedocs.io/en/latest/

serial_port = '/dev/ttyAMA0'
relay_pin = 26
relay = gpiozero.LED(relay_pin, initial_value=None,
        pin_factory=gpiozero.pins.rpigpio.RPiGPIOFactory())
port = serial.Serial(serial_port, 9600, timeout=3)

print(f'Port: {port.port}')
print(f'Relay: {relay.value}')

if len(sys.argv) < 2:
  help()
  sys.exit(0)

action = sys.argv[1].lower()

if action == 'on':
  power(True)
if action == 'off':
  power(False)
if action == 'boot':
  boot()





