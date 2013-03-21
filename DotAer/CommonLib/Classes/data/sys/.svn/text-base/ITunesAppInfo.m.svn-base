//
//  ITunesAppInfo.m
//  iMobeeNews
//
//  Created by ellison on 11-11-14.
//  Copyright (c) 2011年 borqs. All rights reserved.
//

#import "ITunesAppInfo.h"
#import "BqsUtils.h"
#import "JSON.h"

#define kTagVersion @"version"
#define kTagReleaseNotes @"releaseNotes"
#define kTagTrackViewUrl @"trackViewUrl"

@interface ITunesAppInfo() 
@property (nonatomic, retain) NSDictionary *dicInfo;
@end

@implementation ITunesAppInfo
@synthesize version,releaseNotes,downloadUrl;
@synthesize dicInfo;

+(ITunesAppInfo*)parseJSONData:(NSString*)str {
    if(nil == str || [str length] < 1) return nil;
    
    // parse
	id json = [str JSONValue];
    if(nil == json && ![json isKindOfClass:[NSDictionary class]]) {
        BqsLog(@"invalid json: %@", str);
        return nil;
    }
    NSDictionary *dic = (NSDictionary*)json;
    id obj = [dic objectForKey:@"results"];
    
    dic = nil;
    if(nil != obj && [obj isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)obj;
        if([arr count] > 0) {
            dic = [arr objectAtIndex:0];
        }
    } else if(nil != obj && [obj isKindOfClass:[NSDictionary class]]) {
        dic = (NSDictionary*)obj;
    }
    
    if(nil == dic) {
        BqsLog(@"invalid json, no results: %@", str);
        return nil;
    }

    ITunesAppInfo *info = [[[ITunesAppInfo alloc] init] autorelease];
    info.dicInfo = dic;
    
//    BqsLog(@"versionInfo: %@", dic);
    return info;
}


-(void)dealloc {
    
    self.dicInfo = nil;
    
    [super dealloc];
}

-(NSString*)version {
    if(nil == self.dicInfo) return nil;
    
    return [self.dicInfo objectForKey:kTagVersion];
}

-(NSString*)releaseNotes {
    if(nil == self.dicInfo) return nil;
    
    return [self.dicInfo objectForKey:kTagReleaseNotes];
}

-(NSString *)downloadUrl {
    if(nil == self.dicInfo) return nil;
    
    return [self.dicInfo objectForKey:kTagTrackViewUrl];
}


@end
