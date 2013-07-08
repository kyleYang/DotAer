/*!
 @header SMAdEventCode.h
 @abstract SMAdEventCode
 @author madhouse
 @version 3.0.0 2013/01/14 Creation
 */

#import <Foundation/Foundation.h>


/*!
 @enum
 @abstract SmartMadCode
 @constant SM_SUCCEED 成功
 @constant SM_INVALID_ID 无效的id
 @constant SM_AD_TOO_MUCH_ON_SCREEN 太多相同的广告位在屏幕上
 @constant SM_INVALID_AREA_OR_BE_COVERD 无效的广告尺寸或广告被覆盖
 @constant SM_NETWORK_ERROR 网络错误
 @constant SM_INVALID_REQUEST 徐晓请求
 @constant SM_NO_FILL 无广告
 @constant SM_INTERNAL_ERROR 内部错误
 */

typedef enum {
    SM_SUCCEED = 0,
    SM_INVALID_ID = 1,
    SM_AD_TOO_MUCH_ON_SCREEN = 2,
    SM_INVALID_AREA_OR_BE_COVERD = 4,
    SM_NETWORK_ERROR = 6,
    SM_INVALID_REQUEST = 7,
    SM_NO_FILL = 8,
    SM_INTERNAL_ERROR = 9,
}SmartMadCode;


/*!
 @class
 @abstract SMAdEventCode
 */

@interface SMAdEventCode : NSError

@end
