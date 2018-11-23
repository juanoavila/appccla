//
//  P4vAdapter.h
//  P4vAdapter
//
//  Created by Coges MacBook on 27/03/17.
//  Copyright © 2017 Coges Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

// --- CoreBlueTooth Framework -- //
#import <CoreBluetooth/CoreBluetooth.h>

typedef enum {
    p4vStatusReady          = 0,
    p4vStatusConnecting     = 1,
    p4vStatusConnected      = 2,
    p4vStatusDisconnected   = 3,
} P4vStatus;

typedef enum {
    p4vEventConnected       = 0,
    p4vEventDisconnected    = 1,
    p4vEventDataAvailable   = 2,
    p4vEventReadRSSI        = 3,
    p4vEventWrite           = 4,
    p4vEventAuthOk          = 10,
    p4vEventVendApproved    = 11,
    p4vEventVendDenied      = 12,
    p4vEventVendSuccess     = 13,
    p4vEventVendFailure     = 14,
    p4vEventRevalueApproved = 15,
    p4vEventRevalueDenied   = 16,
    
    p4vEventNone            = 99,
    
} P4vEvent;

typedef enum {
    p4vErrorInvalidName,
    p4vErrorInvalidOpCode,
    p4vErrorInvalidBtCode,
    p4vErrorInvalidPinCode,
    p4vErrorInvalidCredit,
    p4vErrorInvalidDecimals,
    p4vErrorInvalidConnTimeout,
    p4vErrorInvalidPriceTable,
    p4vErrorInvalidUserId,
    p4vErrorInvalidDiagCreditTot,
    p4vErrorInvalidDiagPaymentTot,
    p4vErrorVendorMismatch,
    p4vErrorConnectionNoResponse,
    p4vErrorRSSILow,
    p4vErrorBluetoothInitializeFail,
    p4vErrorBluetoothConnectError,
    
    p4vErrorSdkNotInitialized,
    
} P4vError;

@protocol IP4vListenerDelegate <NSObject>

@optional
- (void) p4vError:(P4vError) error;
- (void) p4vEvent:(P4vEvent) event;
- (void) p4vLicenceHours:(unsigned int) hours;

@required
- (unsigned int) protocolP4vGetCredit;
- (unsigned int) protocolP4vGetDiagnosticCreditTotal;
- (unsigned int) protocolP4vGetDiagnosticPaymentTotal;
- (int)          protocolP4vVendRequestWithAmount:(unsigned int)amount andItemNum: (NSString*) itemNum;
- (BOOL)         protocolP4vRevalueRequestWithAmount:(unsigned int)amount;

@end

@interface P4vAdapter : NSObject

@property (nonatomic, weak)   id<IP4vListenerDelegate> delegate;

@property (nonatomic, strong, readonly) NSString   *protocolBtcode;
@property (nonatomic, strong, readonly) NSString   *protocolOpCode;
@property (nonatomic, assign, readonly) NSInteger   protocolInactivityTimeout;
@property (nonatomic, assign, readonly) int         protocolNumDecimals;
@property (nonatomic, assign, readonly) BOOL        protocolMultivendIsOn;
@property (nonatomic, assign, readonly) int         protocolTablePrice;
@property (nonatomic, strong, readonly) NSString   *protocolDeveloperPin;
@property (nonatomic, strong, readonly) NSString   *protocolUserId;
@property (nonatomic, strong, readonly) NSString   *protocolLicenceToken;
//@property (nonatomic, assign) NSString  *protocolDisconnectOnBackground;


+ (instancetype)    sharedInstance;
+ (instancetype)    initWithDelegate:(id<IP4vListenerDelegate>)delegate;

- (void)            initWithDelegate:(id<IP4vListenerDelegate>)delegate;
- (void)            connectPeripheral:(CBPeripheral *)peripheral withBluetoothManager:(CBCentralManager *)centralManager
                               opCode:(NSString*) opCode
                               btCode:(NSString*) btCode
                              pinCode:(NSString*) pinCode
                             decimals:(NSUInteger) numDecimals
                           priceTable:(NSUInteger) priceTable
                          connTimeout:(NSInteger) inactivityTimeout
                               userId:(NSString*) userId
                           andLicence:(NSString*) licenceToken;
- (void)            disconnect;
- (BOOL)            getMultivend;
- (void)            setMultivend:(BOOL)onoff;
- (NSString *)      getVersion;

@end
