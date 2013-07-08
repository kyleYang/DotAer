/*
 
 AdNetwork.h
 
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
#import "AdViewDelegateProtocol.h"

#define AWAdNetworkConfigKeyType      @"type"
#define AWAdNetworkConfigKeyNID       @"nid"
#define AWAdNetworkConfigKeyName      @"nname"
#define AWAdNetworkConfigKeyWeight    @"weight"
#define AWAdNetworkConfigKeyPriority  @"priority"
#define AWAdNetworkConfigKeyCred      @"key"

#define AWAdNetworkConfigKey2Cred     @"key2"

#define AWAdNetworkConfigKey3Cred     @"key3"

@class AdViewError;
@class AdViewAdNetworkRegistry;

@interface AdViewAdNetworkConfig : NSObject {
  NSInteger networkType;
  NSString *nid;
  NSString *networkName;
  double trafficPercentage;
  NSInteger priority;
  NSDictionary *credentials;
  NSDictionary *credentials2;
  Class adapterClass;
}

- (id)initWithDictionary:(NSDictionary *)adNetConfigDict
       adNetworkRegistry:(AdViewAdNetworkRegistry *)registry
                   error:(AdViewError **)error;

@property (nonatomic,readonly) NSInteger networkType;
@property (nonatomic,readonly) NSString *nid;
@property (nonatomic,readonly) NSString *networkName;
@property (nonatomic,readonly) double trafficPercentage;
@property (nonatomic,readonly) NSInteger priority;
@property (nonatomic,readonly) NSDictionary *credentials;
@property (nonatomic,readonly) NSDictionary *credentials2;
@property (nonatomic,readonly) NSDictionary *credentials3;
@property (nonatomic,readonly) NSString *pubId;
@property (nonatomic,readonly) NSString *pubId2;
@property (nonatomic,readonly) NSString *pubId3;
@property (nonatomic,readonly) Class adapterClass;

@end
