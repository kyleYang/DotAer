//
//  question.m
//  DotAer
//
//  Created by Kyle on 13-4-1.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "Question.h"
#import "Env.h"
#import "BqsUtils.h"



#define kList @"list"
#define kQuestion @"question"

#define kQuesId @"id"
#define kDescription @"description"
#define kTime @"time"
#define kAnswer @"answer"
#define kUserName @"userName"

@implementation Question
@synthesize questId;
@synthesize descript;
@synthesize time;
@synthesize answer;
@synthesize userName;

- (void)dealloc{
    self.descript = nil;
    self.time = nil;
    self.answer = nil;
    self.userName = nil;
    [super dealloc];
}



-(NSString*)description {
    return [NSString stringWithFormat:@"[QuestionId:%d,description:%@,time:%@,answer:%@,username:%@]",
            self.questId, self.descript,self.time,self.answer,self.userName];
}

- (void)writeXmlItem:(XmlWriter*)wrt {
    
    [wrt writeIntTag:kQuesId Value:self.questId];
    [wrt writeStringTag:kDescription Value:self.descript CData:YES];
    [wrt writeStringTag:kTime Value:self.time CData:NO];
    [wrt writeStringTag:kAnswer Value:self.answer CData:YES];
    [wrt writeStringTag:kUserName Value:self.userName CData:YES];
    
}

+(Question *)parseXml:(TBXMLElement*)element {
    if(NULL == element || NULL == element->name) return nil;
    if(![kQuestion isEqualToString:[TBXML elementName:element]]) return nil;
    
    TBXMLElement *item = element->firstChild;
    
    if(NULL == item) return nil;
    
    // item
    Question *question = [[[Question alloc] init] autorelease];
    
    while(NULL != item) {
        
        if(NULL != item->name) {
            NSString *sName = [TBXML elementName:item];
            NSString *text = [TBXML textForElement:item];
            
            if([kQuesId isEqualToString:sName]) {
                question.questId = [text intValue];
            }else if([kDescription isEqualToString:sName]){
                question.descript = text;
            }else if([kTime isEqualToString:sName]) {
                question.time = text;
            } else if([kAnswer isEqualToString:sName]) {
                question.answer = text;
            }else if([kUserName isEqualToString:sName]) {
                question.userName = text;
            }else{
                BqsLog(@"unknown tag: %@", sName);
            }
        }
        
        
        item = item->nextSibling;
    }
    
    return question;
    
}

+(NSArray *)parseXmlData:(NSData*)data {
    if(nil == data || [data length] < 1) {
        BqsLog(@"invalid param. data: %@", data);
        
        return nil;
    }
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:10];
    
    TBXML *tbxml = [[TBXML alloc] initWithXMLData:data];
    
    if(NULL == tbxml.rootXMLElement) {
        [tbxml release];
        return nil;
    }
    
    TBXMLElement *item = tbxml.rootXMLElement->firstChild;
    
    while(NULL != item) {
        
        NSString *name = [TBXML elementName:item];
        if([kList isEqualToString:name]) {
            
            TBXMLElement *si = item->firstChild;
            while(NULL != si) {
                
                NSString *siName = [TBXML elementName:si];
                if([kQuestion isEqualToString:siName]) {
                    
                    Question *question = [Question parseXml:si];
                    
                    if(nil != question) {
                        [arr addObject:question];
                    }
                    
                } else {
                    BqsLog(@"Unknown tag: %@", siName);
                }
                
                si = si->nextSibling;
            }
            
        }
        
        item = item->nextSibling;
    }
    
    [tbxml release];
    
    return arr;
    
}

+(BOOL)saveToFile:(NSString*)path Arr:(NSArray*)obj{
	if(nil == obj || nil == path) {
		BqsLog(@"Invalid param path: %@, obj: %@", path, obj);
		return NO;
	}
	
	XmlWriter *wrt = [[XmlWriter alloc] initWithFile:path];
	if(nil == wrt) {
		BqsLog(@"Can't write to file %@", path);
		return NO;
	}
    
    [wrt writeStartTag:@"result"];
    [wrt writeIntTag:@"total" Value:obj.count];
    [wrt writeStartTag:kList];
    
    for(Question *question in obj) {
        [wrt writeStartTag:kQuestion];
        
        [question writeXmlItem:wrt];
        
        [wrt writeEndTag:kQuestion];
    }
    
    [wrt writeEndTag:kList];
    [wrt writeEndTag:@"result"];
    
	BOOL bError = wrt.bError;
	[wrt release];
	
	return !bError;
    
}
@end
