//
//  FullScrAdItem.m
//  iMobeeBook
//
//  Created by ellison on 11-11-25.
//  Copyright (c) 2011年 borqs. All rights reserved.
//

#import "FullScrAdItem.h"
#import "TBXML.h"
#import "BqsUtils.h"
#import "Env.h"
#import "XmlWriter.h"

#define kTagList @"list"
#define kTagItem @"item"
#define kTagImages @"images"
#define kTagImage @"image"
#define kTagSize @"size"
#define kTagUrl @"url"
#define kTagRate @"rate"
#define kTagAutoRemove @"autoremove"
#define kTagInterval @"interval"
#define kTagAction @"action"
#define kTagOpType @"optype"
#define kTagData @"data"

#define kDefaultRemainIntervalS 5

@implementation FullScrAdItem
@synthesize imgUrlVer, imgUrlHori, ratio, bAutoRemove, minIntervalS, actionOpType, actionOpData;

-(id)init {
    self = [super init];
    if(nil == self) return nil;
    
    self.bAutoRemove = YES;
    self.minIntervalS = kDefaultRemainIntervalS;
    self.actionOpType = -1;
    
    return self;
}
-(void)dealloc {
    self.imgUrlHori = nil;
    self.imgUrlVer = nil;
    self.actionOpData = nil;
    
    [super dealloc];
}

-(id)copyWithZone:(NSZone*)zone {
    FullScrAdItem* other = [FullScrAdItem allocWithZone:zone];
    if(nil == other) return nil;
    
    other.imgUrlVer = self.imgUrlVer;
    other.imgUrlHori = self.imgUrlHori;
    other.ratio = self.ratio;
    other.bAutoRemove = self.bAutoRemove;
    other.minIntervalS = self.minIntervalS;
    other.actionOpType = self.actionOpType;
    other.actionOpData = self.actionOpData;
    
    return other;
}

-(NSString*)description {
    return [NSString stringWithFormat:@"[%@,%@,%d,%d,%d,%d,%@]", self.imgUrlVer, self.imgUrlHori, self.ratio, self.bAutoRemove, self.minIntervalS, self.actionOpType,
            self.actionOpData];
}

+(NSArray *)parseXmlData:(NSData*)data {
    if(nil == data || [data length] < 1) {
        BqsLog(@"invalid param. data: %@", data);
        
        return nil;
    }
    
    Env *env = [Env sharedEnv];
    CGSize scrSize = env.screenSize;
    float scale = env.screenScale;
    if(scale > 0.0) {
        scrSize.width *= scale;
        scrSize.height *= scale;
    }
    
    NSMutableArray *arr = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
    
    TBXML *tbxml = [[TBXML alloc] initWithXMLData:data];
    
    if(NULL != tbxml.rootXMLElement) {
        TBXMLElement *item = tbxml.rootXMLElement->firstChild;
        
        while(NULL != item) {
            
            NSString *name = [TBXML elementName:item];
            if([kTagItem isEqualToString:name]) {
                
                FullScrAdItem *anItem = [[[FullScrAdItem alloc] init] autorelease];
                
                TBXMLElement *si = item->firstChild;
                while(NULL != si) {
                    
                    NSString *siName = [TBXML elementName:si];
                    NSString *siText = [TBXML textForElement:si];
                    if([kTagImages isEqualToString:siName]) {
                        
                        TBXMLElement *ssi = si->firstChild;
                        while(NULL != ssi) {
                                                        
                            if([kTagImage isEqualToString:[TBXML elementName:ssi]]) {
                                
                                BOOL bSizeFitVer = NO;
                                BOOL bSizeFitHori = NO;
                                NSString *imgUrl = nil;

                                TBXMLElement *xi = ssi->firstChild;
                                while(NULL != xi) {
                                    
                                    NSString *xiName = [TBXML elementName:xi];
                                    NSString *xiText = [TBXML textForElement:xi];
                                    
//                                    BqsLog(@"%@=%@", xiName, xiText);
                                    if([kTagSize isEqualToString:xiName]) {
                                        if(nil != xiText) {
                                            NSString *tx = [xiText stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n\r \t"]];
                                            NSArray* components = [tx componentsSeparatedByString:@"_"];
                                            if(nil != components && [components count] == 2) {
                                                CGSize sz = CGSizeMake([[components objectAtIndex:0] floatValue], [[components objectAtIndex:1] floatValue]);
                                                
//                                                BqsLog(@"size: %@ -> %.0fx%.0f", xiText, sz.width, sz.height);
                                                if(ABS(sz.width - scrSize.width) < 5.0 && ABS(sz.height - scrSize.height) < 5.0) {
                                                    // got size
                                                    bSizeFitVer = YES;
                                                } else if(ABS(sz.height - scrSize.width) < 5.0 && ABS(sz.width - scrSize.height) < 5.0) {
                                                    bSizeFitHori = YES;
                                                }
                                            }
                                        }
                                    } else if([kTagUrl isEqualToString:xiName]) {
                                        imgUrl = xiText;
                                    }
                                    xi = xi->nextSibling;
                                }
                                
                                if(nil != imgUrl && [imgUrl length] > 0) {
                                    if(bSizeFitVer) {
                                        anItem.imgUrlVer = imgUrl;
                                    } else if(bSizeFitHori) {
                                        anItem.imgUrlHori = imgUrl;
                                    }
                                }
                            }
                            ssi = ssi->nextSibling;
                        }
                    } else if([kTagRate isEqualToString:siName]) {
                        anItem.ratio = [siText intValue];
                    } else if([kTagAutoRemove isEqualToString:siName]) {
                        anItem.bAutoRemove = [BqsUtils parseBoolean:siText Def:YES];
                    } else if([kTagInterval isEqualToString:siName]) {
                        NSString *tx = [siText stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n\r \t"]];
                        if(nil != tx && [tx length] > 0) {
                            int iv = [tx intValue];
                            if(iv >= 0) anItem.minIntervalS = iv;
                        }
                    } else if([kTagAction isEqualToString:siName]) {
                        TBXMLElement *xi = si->firstChild;
                        while(NULL != xi) {
                            
                            NSString *xiName = [TBXML elementName:xi];
                            NSString *xiText = [TBXML textForElement:xi];
                            
                            //BqsLog(@"%@=%@", ssiName, ssiText);
                            if([kTagOpType isEqualToString:xiName]) {
                                anItem.actionOpType = [xiText intValue];
                            } else if([kTagData isEqualToString:xiName]) {
                                anItem.actionOpData = xiText;
                            }
                            xi = xi->nextSibling;
                        }
                    }
                    
                    si = si->nextSibling;
                }
                
                if((nil != anItem.imgUrlVer && [anItem.imgUrlVer length] > 0) ||
                   (nil != anItem.imgUrlHori && [anItem.imgUrlHori length] > 0)) {
//                    BqsLog(@"item: %@", anItem);
                    [arr addObject:anItem];
                }
            }
            
            item = item->nextSibling;
        }
    }
    [tbxml release];

    return arr;
}

+ (BOOL)saveToFile:(NSString*)path Data:(NSArray*)data {
	if(nil == data) {
		BqsLog(@"data is nil");
		return NO;
	}
	
	XmlWriter *wrt = [[XmlWriter alloc] initWithFile:path];
	if(nil == wrt) {
		BqsLog(@"Can't write to %@", path);
		return NO;
	}
    
    Env *env = [Env sharedEnv];
    CGSize scrSize = env.screenSize;
    float scale = env.screenScale;
    if(scale > 0.0) {
        scrSize.width *= scale;
        scrSize.height *= scale;
    }

    
    [wrt writeStartTag:kTagList];
	for(id d in data) {
		FullScrAdItem *cid = (FullScrAdItem*)d;
		
		[wrt writeStartTag:kTagItem];
        
        [wrt writeStartTag:kTagImages];
        
        if(nil != cid.imgUrlVer && [cid.imgUrlVer length] > 0) {
            [wrt writeStartTag:kTagImage];
            [wrt writeStringTag:kTagSize Value:[NSString stringWithFormat:@"%.0f_%.0f", scrSize.width, scrSize.height] CData:YES];
            [wrt writeStringTag:kTagUrl Value:cid.imgUrlVer CData:YES];
            [wrt writeEndTag:kTagImage];
        }
        if(nil != cid.imgUrlHori && [cid.imgUrlHori length] > 0) {
            [wrt writeStartTag:kTagImage];
            [wrt writeStringTag:kTagSize Value:[NSString stringWithFormat:@"%.0f_%.0f", scrSize.height, scrSize.width] CData:YES];
            [wrt writeStringTag:kTagUrl Value:cid.imgUrlHori CData:YES];
            [wrt writeEndTag:kTagImage];
        }
        
        
        [wrt writeEndTag:kTagImages];
        
        [wrt writeIntTag:kTagRate Value:cid.ratio];
        [wrt writeIntTag:kTagAutoRemove Value:cid.bAutoRemove ? 1 : 0];
        [wrt writeIntTag:kTagInterval Value:cid.minIntervalS];
        
        [wrt writeStartTag:kTagAction];
        [wrt writeIntTag:kTagOpType Value:cid.actionOpType];
        [wrt writeStringTag:kTagData Value:cid.actionOpData CData:YES];
        [wrt writeEndTag:kTagAction];
		
        [wrt writeEndTag:kTagItem];
        
		if(wrt.bError) {
			break;
		}
	}

    [wrt writeEndTag:kTagList];
    
	BOOL bError = wrt.bError;
	[wrt release];
	
	return !bError;
}
@end
