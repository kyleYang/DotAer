/*

 AdViewAdNetworkRegistry.h

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

@class AdViewAdNetworkAdapter;
@class AdViewClassWrapper;

@interface AdViewAdNetworkRegistry : NSObject {
  NSMutableDictionary *adapterDict;
}

+ (AdViewAdNetworkRegistry *)sharedRegistry;
- (void)registerClass:(Class)adapterClass;
- (AdViewClassWrapper *)adapterClassFor:(NSInteger)adNetworkType;

- (void)enableClass:(BOOL)bEnable For:(NSInteger)adNetworkType;
- (void)listAdapterClasses;

- (NSDictionary*)getClassesStatus;
- (void)setClassesStatus:(NSDictionary*)dict;

@end
