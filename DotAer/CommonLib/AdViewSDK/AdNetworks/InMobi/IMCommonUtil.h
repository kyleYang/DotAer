//
//  IMCommonUtil.h
//  InMobi Commons SDK
//
//  Copyright (c) 2013 InMobi Technology Services Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Console logging levels.
 */
typedef enum {
    /**
     * IMLogLevelTypeNone
     *   No logs. (default)
     */
    IMLogLevelTypeNone    = 0,
    /**
     * IMLogLevelTypeDebug
     *   Log level for normal debugging.
     */
    IMLogLevelTypeDebug   = 1,
    /**
     * IMLogLevelTypeVerbose
     *   Log level for verbose (full) debugging.
     */
    IMLogLevelTypeVerbose = 2,
    
} IMLogLevelType;

/**
 * InMobi Device id collection mask.
 */
typedef enum {
    /**
     * IMDevice_IncludeDefaultIds
     *   Use default ids for sdk device id collection. (default)
     */
    IMDevice_IncludeDefaultIds = 0,
    /**
     * IMDevice_ExcludeODIN1
     *   Exclude odin1 identifier from sdk device id collection.
     */
    IMDevice_ExcludeODIN1 = 1<<0,
    /**
     * IMDevice_ExcludeAdvertisingId
     *   Exclude advertiser identifier from sdk device id collection. (iOS 6+)
     */
    IMDevice_ExcludeAdvertisingId = 1<<1,
    /**
     * IMDevice_ExcludeVendorId
     *   Exclude vendor identifier from sdk device id collection. (iOS 6+)
     */
    IMDevice_ExcludeVendorId = 1<<2,
    /**
     * IMDevice_ExcludeUDID
     * @deprecated
     * @note: This flag is deprecated as sdk does not collect UDID any more.
     *   Exclude udid identifier from sdk device id collection.
     */
    IMDevice_ExcludeUDID = 1<<3,
    /**
     * IMDevice_ExcludeFacebookAttributionId
     *   Exclude facebook's attribution id from sdk device id collection.
     */
    IMDevice_ExcludeFacebookAttributionId = 1<<4,

} IMDeviceIdMask;

/**
 * InMobi commons that provides common services to all InMobi SDKs.
 */
@interface IMCommonUtil : NSObject {

}
/**
 * Set the console logging level for debugging purpose.
 * @param logLevel - Log Level to be set.
 */
+ (void)setLogLevel:(IMLogLevelType)logLevel;
/**
 * Returns the log level set.
 * @return the log level set.
 */
+ (IMLogLevelType)getLogLevel;

/**
 * This sets the Device Id Mask so as to restrict the Device Tracking not
 * to be based on certain Device Ids.
 * @param deviceIdMask - Device Id Mask to be set.
 */
+ (void)setDeviceIdMask:(IMDeviceIdMask)deviceIdMask;
/**
 * Returns the Device Id Mask set.
 * @return the Device Id Mask set.
 */
+ (IMDeviceIdMask)getDeviceIdMask;

/**
 * Returns the sdk release version.
 * @return the sdk release version.
 */
+ (NSString *)getReleaseVersion;

@end
