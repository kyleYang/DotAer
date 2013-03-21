//
//  DownloadTask.h
//  iMobee
//
//  Created by ellison on 10-9-17.
//  Copyright 2010 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kErrMsgKey @"msg"
#define kNtfBqsAuthFailed @"downloadtask.ntf.auth.failed"

@protocol DownloadProgressCallback;
@protocol DownloadCallback;

@interface DownloadTask : NSObject
{
	NSString *_url;
	NSString *_path;
	BOOL _bResumeDownload;
	int _curBytes;
	int _totalBytes;
	id _attached;
    int _taskId;
    BOOL _bAppendPassport;
	
	id<DownloadProgressCallback> _cbProgress;
	id<DownloadCallback> _cbCallback;
	
	NSError *_error;
	
	NSURLConnection *_connection;
    NSOutputStream *_fileStream;
	NSMutableData *_downloadedData;
	NSInteger _httpStatus;
	NSString *_httpContentType;
    
    BOOL _bCanceled;
    
}
@property (assign, readonly) BOOL bIsPost;
@property (copy, readonly) NSString *postContentType;
@property (retain, readonly) NSData *postBody;
@property (retain, readonly) NSDictionary *reqHeader;
@property (assign) int nRetryCnt;

@property (copy) NSString *url;
@property (copy) NSString *path;
@property (assign) BOOL bResume;
@property (assign) int curBytes;
@property (assign) int totalBytes;
@property (assign) id attached;
@property (assign) int taskId;
@property (assign, readwrite) id<DownloadProgressCallback> progressCallback;
@property (assign, readwrite) id<DownloadCallback> callback;
@property (nonatomic, retain) NSError *error;
@property (retain) NSMutableData *downloadedData;
@property (assign) NSInteger httpStatus;
@property (copy) NSString *httpContentType;
@property (copy) NSString *httpExpires;
@property (copy) NSString *httpLastModified;
@property (copy) NSString *httpETag;
@property (retain, readwrite) NSDictionary *rspHeaders;
@property (assign) BOOL bAuthFailed;
@property (assign) BOOL bAppendBqsHeaders;

-(id)initWithUrl:(NSString*)sUrl Path:(NSString*)sPath Callback: (id<DownloadCallback>)cb ProgressCallback: (id<DownloadProgressCallback>)pcb Resume: (BOOL)bResume Attached:(id)iAttached;
-(id)initWithUrl:(NSString*)sUrl Path:(NSString*)sPath Callback: (id<DownloadCallback>)cb ProgressCallback: (id<DownloadProgressCallback>)pcb Resume: (BOOL)bResume Attached:(id)iAttached AppendPassport:(BOOL)bAppendPassport;
-(id)initWithUrl:(NSString*)sUrl Path:(NSString*)sPath Callback: (id<DownloadCallback>)cb ProgressCallback: (id<DownloadProgressCallback>)pcb Resume: (BOOL)bResume Attached:(id)iAttached AppendPassport:(BOOL)bAppendPassport UserName:(NSString*)userName Password:(NSString*)password AddtionalHeaders:(NSDictionary*)reqHeader;

-(id)initWithUrl:(NSString*)sUrl Callback: (id<DownloadCallback>)cb Attached:(id)attached;
-(id)initWithUrl:(NSString*)sUrl Callback: (id<DownloadCallback>)cb Attached:(id)attached AppendPassport:(BOOL)bAppendPassport;

-(id)initPostWithUrl:(NSString*)sUrl Data:(NSData*)data ContentType:(NSString*)sContentType Path:(NSString*)sPath Callback: (id<DownloadCallback>)cb ProgressCallback: (id<DownloadProgressCallback>)pcb Attached:(id)iAttached AppendPassport:(BOOL)bAppendPassport UserName:(NSString*)userName Password:(NSString*)password AddtionalHeaders:(NSDictionary*)aReqHeader;

-(void)dealloc;

-(BOOL)isReceiving;
-(void)start;
-(void)cancel;
-(void)cancel:(BOOL)bCallback;

@end

@protocol DownloadProgressCallback <NSObject>
-(void)downloadTask: (DownloadTask*)tsk DownloadBytes: (NSInteger)dBytes OfTotal: (NSInteger)dAllBytes;
@end

@protocol DownloadCallback <NSObject>
-(void)downloadTask: (DownloadTask*)tsk DidFinishWithError: (NSError*)error;
@end
