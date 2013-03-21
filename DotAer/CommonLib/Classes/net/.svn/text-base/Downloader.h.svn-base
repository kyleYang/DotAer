//
//  Downloader.h
//  iMobee
//
//  Created by ellison on 10-9-17.
//  Copyright 2010 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kHttpHeader_ReqETag @"If-None-Match"
#define kHttpHeader_ReqLastModifed @"If-Modified-Since"
#define kHttpPostContentType_UrlEncoded_Utf8 @"application/x-www-form-urlencoded; charset=utf-8"
#define kHttpPostContentType_TextXml_Utf8 @"text/xml; charset=utf-8"
#define kHttpPostContentType_OctetStream @"application/octet-stream"

@class PackageFile;

@interface Downloader : NSObject {
	NSMutableDictionary *_netTasks;
    NSMutableArray *_serialLoadTask;
	NSInteger _taskId;
    
    BOOL _bAlive;
}
@property (nonatomic, assign) BOOL bSearialLoad;
@property (nonatomic, assign) BOOL bAppendBqsHeaders;
@property (nonatomic, assign) int nRetryCnt;

// callback select must has the form:
// (void)callbackName:(DownloaderCallbackObj*)obj
-(NSInteger)addTask:(NSString*)url Target:(id)target Callback:(SEL)sel Attached:(id)attached;
-(NSInteger)addTask:(NSString*)url Target:(id)target Callback:(SEL)sel Attached:(id)attached AppendHeaders:(NSDictionary*)dic;
-(NSInteger)addTask:(NSString*)url Target:(id)target Callback:(SEL)sel Attached:(id)attached AppendPassport:(BOOL)bAppendPassport;
-(NSInteger)addTask:(NSString*)url Target:(id)target Callback:(SEL)sel Attached:(id)attached UserName:(NSString*)user Password:(NSString*)password;

-(NSInteger)addPostTask:(NSString*)url Data:(NSData*)data ContentType:(NSString*)sContentType Target:(id)target Callback:(SEL)sel Attached:(id)attached;
-(NSInteger)addPostTask:(NSString*)url Data:(NSData*)data ContentType:(NSString*)sContentType Target:(id)target Callback:(SEL)sel Attached:(id)attached AppendPassport:(BOOL)bAppendPassport;
-(NSInteger)addPostTask:(NSString*)url Data:(NSData*)data ContentType:(NSString*)sContentType Target:(id)target Callback:(SEL)sel Attached:(id)attached AppendPassport:(BOOL)bAppendPassport AdditionalHeader:(NSDictionary*)hdr;

-(NSInteger)addCachedTask:(NSString*)url PkgFile:(PackageFile*)pkgFile Target:(id)target Callback:(SEL)sel Attached:(id)attached;
-(NSInteger)addCachedTask:(NSString*)url PkgFile:(PackageFile*)pkgFile Target:(id)target Callback:(SEL)sel Attached:(id)attached AppendPassport:(BOOL)bAppendPassport;

-(void)cancelTask:(NSInteger)taskId;
-(void)cancelAll;
-(int)count;

@end

@interface DownloaderCallbackObj : NSObject
{
	NSInteger _taskId;
    NSString *_url;
	NSInteger _httpStatus;
	NSString *_httpContentType;
    NSDictionary *_rspHeaders;
	NSData *_rspData;
	NSError *_error;
	id _attached;
}
@property (nonatomic, assign) NSInteger taskId;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSInteger httpStatus;
@property (nonatomic, copy) NSString *httpContentType;
@property (nonatomic, copy) NSString *httpETag;
@property (nonatomic, copy) NSString *httpLastModified;
@property (nonatomic, retain) NSDictionary *rspHeaders;
@property (nonatomic, retain) NSData *rspData;
@property (nonatomic, retain) NSError *error;
@property (nonatomic, retain) id attached;

@end



@interface NetOpCbs : NSObject
{
	id _target;
	SEL _sel;
	id _attached;
}
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL sel;
@property (nonatomic, retain) id attached;

@end



