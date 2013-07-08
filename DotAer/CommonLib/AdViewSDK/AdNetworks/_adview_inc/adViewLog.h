/*

 AdViewLog.h

 Copyright 2010 www.adview.cn

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

*/

#import <Foundation/Foundation.h>

typedef enum {
  AWLogLevelNone  = 0,
  AWLogLevelCrit  = 10,
  AWLogLevelError = 20,
  AWLogLevelWarn  = 30,
  AWLogLevelInfo  = 40,
  AWLogLevelDebug = 50
} AWLogLevel;

void ADVLogSetLogLevel(AWLogLevel level);

// The actual function name has an underscore prefix, just so we can
// hijack AWLog* with other functions for testing, by defining
// preprocessor macros
void _ADVLogCrit(NSString *format, ...);
void _ADVLogError(NSString *format, ...);
void _ADVLogWarn(NSString *format, ...);
void _ADVLogInfo(NSString *format, ...);
void _ADVLogDebug(NSString *format, ...);

#ifndef AWLogCrit
#define AWLogCrit(...) _ADVLogCrit(__VA_ARGS__)
#endif

#ifndef AWLogError
#define AWLogError(...) _ADVLogError(__VA_ARGS__)
#endif

#ifndef AWLogWarn
#define AWLogWarn(...) _ADVLogWarn(__VA_ARGS__)
#endif

#ifndef AWLogInfo
#define AWLogInfo(...) _ADVLogInfo(__VA_ARGS__)
#endif

#ifndef AWLogDebug
#define AWLogDebug(...) _ADVLogDebug(__VA_ARGS__)
#endif
