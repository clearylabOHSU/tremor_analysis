from mbientlab.metawear.cbindings import *
from mbientlab.warble import *
from time import sleep
import six

print('Scanning...')

devices = {}

def handler(result):
	devices[result.mac] = result.name

BleScanner.set_handler(handler)
BleScanner.start()
sleep(3.0)
BleScanner.stop()

Bid_arr = []
for address, name in six.iteritems(devices):
	if name =='MetaWear':
		Bid_arr.append(address)

print(Bid_arr)