//
//  Downloader.h
//  iMobee
//
//  Created by ellison on 10-9-17.
//  Copyright 2010 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadTask.h"

#define kHttpHeader_ReqETag @"If-None-Match"
#define kHttpHeader_ReqLastModifed @"If-Modified-Since"
#define kHttpPostContentType_UrlEncoded_Utf8 @"application/x-www-form-urlencoded; charset=utf-8"
#define kHttpPostContentType_TextXml_Utf8 @"text/xml; charset=utf-8"
#define kHttpPostContentType_OctetStream @"application/octet-stream"

enum {
	DS_Paused = 0,
	DS_Waiting = 1,
	DS_Downloading = 2,
	DS_Unziping = 3,
	DS_Finished = 4,
	DS_Error = 5,
};

enum {
	Download_Other = 0,
	Download_Zip = 1,
    Download_Chapter = 2,
};


enum {
    BDT_WholeBook = 0, // download the whole book
    BDT_Part = 1, // download partical chapter txt files
};


@class PackageFile;
@protocol DownloaderCallback;

@interface Downloader : NSObject {
	NSMutableDictionary *_netTasks;
    NSMutableArray *_serialLoadTask;
	NSInteger _taskId;
    
    BOOL _bAlive;
}
@property (nonatomic, assign) id delegate;
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

@interface BqsDownloaderItem : NSObject
{
	NSInteger _taskId;
	id _cbTarget;
	SEL _cbSelector;
	id _attached;
	DownloadTask *_downloadTask;
}
@property (nonatomic, assign) NSInteger taskId;
@property (nonatomic, assign) id cbTarget;
@property (nonatomic, assign) SEL cbSelector;
@property (nonatomic, retain) id attached;
@property (assign) NSInteger type;
@property (assign) NSInteger curBytes;
@property (assign) NSInteger totalBytes;
@property (assign) NSInteger curUnzipFileId;
@property (assign) NSInteger totalUnzipFile;
@property (assign) NSTimeInterval lastUIUpdateTS;
@property (nonatomic, retain) DownloadTask *downloadTask;
@property (nonatomic, retain) PackageFile *pkgFile;
@end



@protocol DownloaderCallback <NSObject>

@optional
-(void)DownloadProgres:(CGFloat)percentage;
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



