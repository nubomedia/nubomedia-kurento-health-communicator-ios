// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

#import "BLEManager.h"

#define TRANSFER_SERVICE_UUID           @"E20A39F4-73F5-4BC4-A12F-17D1AD07A961"
#define TRANSFER_CHARACTERISTIC_UUID    @"08590F7E-DB05-467E-8757-72F6FAEB13D4"
#define K_SERVICE_UUID @"46A970E0-0D5F-11E2-8B5E-0002A5D5C51B"
#define K_CHARACTERISTIC_UUID @"0AAD7EA0-0D60-11E2-8E3C-0002A5D5C51B"

@interface BLEManager () <CBCentralManagerDelegate, CBPeripheralDelegate>
    @property (strong, nonatomic) CBCentralManager *mgr;
    @property (strong, nonatomic) CBPeripheral *discoveredPeripheral;
@end

@implementation BLEManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _mgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }

    return self;
}

- (void)connectToPeripheral: (CBPeripheral *)peripheral {
    [_mgr connectPeripheral:peripheral options:nil];
}

- (void)stopBLE {
    [_mgr stopScan];
}

#pragma MARK - CBCentralManagerDelegate
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    self.discoveredPeripheral = peripheral;

    if (_delegate) {
        [_delegate discoveredPeripheral:peripheral];
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBCentralManagerStateUnknown:
        {
            NSLog(@"State unknown, update imminent.");
            if (_delegate) {
                [_delegate bleError:@"State unknown"];
            }
            break;
        }
        case CBCentralManagerStateResetting:
        {
            NSLog(@"The connection with the system service was momentarily lost, update imminent.");
            if (_delegate) {
                [_delegate bleError:@"Connection with the system service was lost"];
            }
            break;
        }
        case CBCentralManagerStateUnsupported:
        {
            NSLog(@"The platform doesn't support Bluetooth Low Energy");
            if (_delegate) {
                [_delegate bleError:@"Platform not support BLE"];
            }
            break;
        }
        case CBCentralManagerStateUnauthorized:
        {
            NSLog(@"The app is not authorized to use Bluetooth Low Energy");
            if (_delegate) {
                [_delegate bleError:@"Not Authorized to use BLE"];
            }
            break;
        }
        case CBCentralManagerStatePoweredOff:
        {
            NSLog(@"Bluetooth is currently powered off.");
            if (_delegate) {
                [_delegate bleError:@"Bluetooth is currently powered off."];
            }
            break;
        }
        case CBCentralManagerStatePoweredOn:
        {
            NSLog(@"Bluetooth is currently powered on and available to use.");
            [_mgr scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:K_SERVICE_UUID]] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
            break;
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Failed to connect to %@. (%@)", peripheral, [error localizedDescription]);
    if (_delegate) {
        [_delegate bleError:[NSString stringWithFormat:@"Failed to connect to %@. (%@)", peripheral, [error localizedDescription]]];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Peripheral Connected");

    if (_delegate) {
        [_delegate peripheralConnected];
    }

    // Stop scanning
    [_mgr stopScan];
    NSLog(@"Scanning stopped");

    // Make sure we get the discovery callbacks
    peripheral.delegate = self;

    // Search only for services that match our UUID
    [peripheral discoverServices:@[[CBUUID UUIDWithString:K_SERVICE_UUID]]];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Peripheral Disconnected");
    if (_delegate) {
        [_delegate peripheralDisconnected];
    }
}

#pragma MARK - CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering services: %@", [error localizedDescription]);
        if (_delegate) {
            [_delegate bleError:@"Error discovering services"];
        }
        return;
    }

    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:K_CHARACTERISTIC_UUID]] forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        if (_delegate) {
            [_delegate bleError:@"Error discovering characteristics"];
        }
        return;
    }

    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:K_CHARACTERISTIC_UUID]]) {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}

/** This callback lets us know more data has arrived via notification on the characteristic
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }

    const unsigned char *dbytes = [characteristic.value bytes];

    NSString *pulsStr = [NSString stringWithFormat:@"%d", dbytes[9]];
    NSString *oxStr = [NSString stringWithFormat:@"%d", dbytes[7]];
    NSLog(@"Retrieved: Pulse: %@, Oxygen: %@", pulsStr, oxStr);

    if (_delegate) {
        NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
        [dataDict setObject:pulsStr forKey:@"Pulse"];
        [dataDict setObject:oxStr forKey:@"Oxygen"];

        [_delegate retrievedData:dataDict];
    }
}

/** The peripheral letting us know whether our subscribe/unsubscribe happened or not
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
        if (_delegate) {
            [_delegate bleError:@"Error retreiving data"];
        }
        return;
    }

    // Exit if it's not the transfer characteristic
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:K_CHARACTERISTIC_UUID]]) {
        return;
    }

    // Notification has started
    if (characteristic.isNotifying) {
        NSLog(@"Notification began on %@", characteristic);
    }

    // Notification has stopped
    else {
        // so disconnect from the peripheral
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
        [_mgr cancelPeripheralConnection:peripheral];
    }
}

@end
