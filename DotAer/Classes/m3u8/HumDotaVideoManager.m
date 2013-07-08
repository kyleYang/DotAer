//
//  HumDotaVideoManager.m
//  DotAer
//
//  Created by Kyle on 13-5-30.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaVideoManager.h"
#import "Env.h"
#import "BqsUtils.h"
#import "Downloader.h"
#import "News.h"
#import "HMPopMsgView.h"
#import "M3U8Parser.h"
#import "HumDotaNetOps.h"
#import "SaveVideo.h"


#define kHumDota @"dotaer"
#define kHumVideo @"video"
#define kDownloadedFile @"download.xml"
#define kDownloadingFile @"downloading.xml"


#define kM3u8XmlFile @"seglist.xml"


@interface HumDotaVideoManager()<VideoDownloadDelegate>

@property (nonatomic, retain) NSMutableArray *arrDownloadedFiles;
@property (nonatomic, retain) NSMutableArray *arrDownloadingFiles;
@property (nonatomic, retain) NSString *downloadedFile;
@property (nonatomic, retain) NSString *downloadingFile;
@property (nonatomic, retain) Downloader *downloader;

@end

@implementation HumDotaVideoManager
@synthesize rootPath,videoPath,downloader,downloadingArry;
@synthesize downloadedFile;
@synthesize downloadingFile;
@synthesize arrDownloadedFiles;
@synthesize arrDownloadingFiles;

- (void)dealloc{
    [self.downloader cancelAll];
    
    for (M3u8Downloader *downing  in downloadingArry) {
        [downing stopDownloadVideo];
    }
    
    self.downloadingArry = nil;
    self.arrDownloadedFiles = nil;
    self.arrDownloadingFiles = nil;
    self.downloadedFile = nil;
    self.downloadingFile = nil;
    self.downloader = nil;
    self.rootPath = nil;
    self.videoPath = nil;
    
    [super dealloc];
    
}


+ (HumDotaVideoManager*)instance {
	
	NSString *key = [[HumDotaVideoManager class] description];
	
	NSMutableDictionary *dict = [Env sharedEnv].runtimeData;
	
	HumDotaVideoManager *bdm = (HumDotaVideoManager*)[dict objectForKey: key];
	if(nil == bdm) {
		bdm = [[HumDotaVideoManager alloc] init];
		[dict setObject:bdm forKey: key];
		[bdm release];
	}
	
	return bdm;
}


-(id)init
{
    self = [super init];
    if(nil == self) return nil;
    
    self.rootPath = [[Env sharedEnv].dirCache stringByAppendingPathComponent:kHumDota];
    self.videoPath = [self.rootPath stringByAppendingPathComponent:kHumVideo];
   
	    
    self.downloader = [[[Downloader alloc] init] autorelease];
    self.downloader.bSearialLoad = YES;
    self.downloadingArry = [NSMutableArray arrayWithCapacity:10];
    
    self.arrDownloadedFiles = (NSMutableArray *)[SaveVideo parseXmlData:[NSData dataWithContentsOfFile:[self pathOfSaveDownloadedFile]]];
    self.arrDownloadingFiles = (NSMutableArray *)[SaveVideo parseXmlData:[NSData dataWithContentsOfFile:[self pathOfSaveDownloadingFile]]];
    
    if (!self.arrDownloadedFiles) {
        self.arrDownloadedFiles = [NSMutableArray arrayWithCapacity:10];
    }
    if (!self.arrDownloadingFiles) {
        self.arrDownloadingFiles = [NSMutableArray arrayWithCapacity:10];
    }
    
    for (SaveVideo *sVideo in self.arrDownloadingFiles) {
        [self addDownloadTaskForSaveVideo:sVideo];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appTermNtf:) name:UIApplicationWillResignActiveNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appResumeNtf:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    return self;
}


// init 
- (AddVideoTaskStatus)addDownloadTaskForSaveVideo:(SaveVideo *)sVideo{
     M3U8SegmentInfoList *M3U8InfoList = [self segmentInfoListForVideoId:sVideo.youkuId];
    
    if (!M3U8InfoList) {
        [HumDotaNetOps videoM3u8Downloader:self.downloader Url:sVideo.content PkgFile:nil Target:self Sel:@selector(m3u8InitFinished:) Attached:sVideo];
        return TaskStatusSuccess;
    }
    M3u8Downloader *m3u8Downloader = [[M3u8Downloader alloc] initWithM3U8List:M3U8InfoList withSaveVideo:sVideo withDir:[self pathofM3U8DirWithVideoId:sVideo.youkuId]];
    m3u8Downloader.delegate = self;
    m3u8Downloader.downingState = FALSE;
   [self.downloadingArry insertObject:m3u8Downloader atIndex:0];
    return TaskStatusSuccess;
}

- (void)m3u8InitFinished:(DownloaderCallbackObj *)cb{
    
    if(nil == cb) return;
    
    if(nil != cb.error || 200 != cb.httpStatus) {
        BqsLog(@"m3u8DownloaderFinished failed http: %d err: %@", cb.httpStatus, cb.error);
        [HMPopMsgView showPopMsgError:cb.error Msg:NSLocalizedString(@"error.networkfailed", nil) Delegate:nil];
        return;
    }
    
    SaveVideo *sVideo = (SaveVideo *)cb.attached;
    NSString *youkId = sVideo.youkuId;
    
    M3U8SegmentInfoList *M3U8InfoList = [M3U8Parser m3u8SegmentInfoListFromData:cb.rspData baseURL:nil];
    [M3U8SegmentInfoList saveToFile:[self pathofM3U8XmlFileWithVideoId:youkId]segmentInfoList:M3U8InfoList];
    
    
    M3u8Downloader *m3u8Downloader = [[M3u8Downloader alloc] initWithM3U8List:M3U8InfoList withSaveVideo:sVideo];
    m3u8Downloader.delegate = self;
    [self.downloadingArry insertObject:m3u8Downloader atIndex:0];
    [m3u8Downloader release];
}


//
- (AddVideoTaskStatus)addDownloadTaskSVideo:(SaveVideo *)sVideo{
    M3u8Downloader *m3u8Downloader = nil;
    for (M3u8Downloader *m3u8 in self.downloadingArry ) {
        if ([m3u8.sVideo.youkuId isEqualToString:sVideo.youkuId] ) {
            return TaskStatusAlready;
        }
        
    }
    
    M3U8SegmentInfoList *M3U8InfoList = [self segmentInfoListForVideoId:sVideo.youkuId];
    if (!M3U8InfoList) {
       [HumDotaNetOps videoM3u8Downloader:self.downloader Url:sVideo.content PkgFile:nil Target:self Sel:@selector(m3u8DownloaderFinished:) Attached:sVideo];
        return TaskStatusSuccess;
    }
    
    m3u8Downloader = [[M3u8Downloader alloc] initWithM3U8List:M3U8InfoList withSaveVideo:sVideo];
    m3u8Downloader.delegate = self;
    [self.arrDownloadingFiles insertObject:sVideo atIndex:0];
    [self.downloadingArry insertObject:m3u8Downloader atIndex:0];
    [self autoSaveDownloadingFile];
    [m3u8Downloader startDownloadVideo];
    [m3u8Downloader release];
    return TaskStatusSuccess;

}

- (AddVideoTaskStatus)addDownloadTaskForVideo:(Video *)video withStep:(VideoScreen)step{
    for (SaveVideo *sv in self.arrDownloadedFiles) {
        if ([sv.youkuId isEqualToString:video.youkuId]) {
            return TaskStatusExist;
        }
    }
    
    for (SaveVideo *sv in self.arrDownloadingFiles) {
        if ([sv.youkuId isEqualToString:video.youkuId]) {
            return TaskStatusAlready;
        }
    }
    
    SaveVideo *sVideo = [[[SaveVideo alloc] initWithVideo:video withStep:step] autorelease];
    return [self addDownloadTaskSVideo:sVideo];
    
}

- (AddVideoTaskStatus)addDownloadTaskForNews:(News *)news withStep:(VideoScreen)step{
    for (SaveVideo *sv in self.arrDownloadedFiles) {
        if ([sv.youkuId isEqualToString:news.youkuId]) {
            return TaskStatusExist;
        }
    }
    
    for (SaveVideo *sv in self.arrDownloadingFiles) {
        if ([sv.youkuId isEqualToString:news.youkuId]) {
            return TaskStatusAlready;
        }
    }
    
    SaveVideo *sVideo = [[[SaveVideo alloc] initWithNews:news withStep:step] autorelease];
    return [self addDownloadTaskSVideo:sVideo];
    
}



- (AddVideoTaskStatus)judgeStatusForVideo:(Video *)video{
    
    for (SaveVideo *sv in self.arrDownloadedFiles) {
        if ([sv.youkuId isEqualToString:video.youkuId]) {
            return TaskStatusExist;
        }
    }
    
    for (SaveVideo *sv in self.arrDownloadingFiles) {
        if ([sv.youkuId isEqualToString:video.youkuId]) {
            return TaskStatusAlready;
        }
    }
    
    return TaskStatusSuccess;
    
    
}



- (void)m3u8DownloaderFinished:(DownloaderCallbackObj *)cb{
    
    if(nil == cb) return;
    
    if(nil != cb.error || 200 != cb.httpStatus) {
        BqsLog(@"m3u8DownloaderFinished failed http: %d err: %@", cb.httpStatus, cb.error);
        [HMPopMsgView showPopMsgError:cb.error Msg:NSLocalizedString(@"error.networkfailed", nil) Delegate:nil];
        return;
    }
    
    SaveVideo *sVideo = (SaveVideo *)cb.attached;
    NSString *youkId = sVideo.youkuId;
    
    M3U8SegmentInfoList *M3U8InfoList = [M3U8Parser m3u8SegmentInfoListFromData:cb.rspData baseURL:nil];
    [M3U8SegmentInfoList saveToFile:[self pathofM3U8XmlFileWithVideoId:youkId]segmentInfoList:M3U8InfoList];
    
        
    M3u8Downloader *m3u8Downloader = [[M3u8Downloader alloc] initWithM3U8List:M3U8InfoList withSaveVideo:sVideo];
    m3u8Downloader.delegate = self;
    [self.arrDownloadingFiles insertObject:sVideo atIndex:0];
    [self.downloadingArry insertObject:m3u8Downloader atIndex:0];
    [self autoSaveDownloadingFile];
    [m3u8Downloader startDownloadVideo];
    [m3u8Downloader release];
}



#pragma mark
#pragma mark VideoDownloadDelegate

-(void)videoDownloaderFinished:(M3u8Downloader*)request{
    
    [request createLocalM3U8file];
    for (SaveVideo *video in self.arrDownloadingFiles) {
        if ([video.youkuId isEqualToString:request.youkuId]) {
            [self.arrDownloadedFiles insertObject:video atIndex:0];
            [self.arrDownloadingFiles removeObject:video];
            [self autoSaveDownloadedFile];
            [self autoSaveDownloadingFile];
            break;
        }
    }
    [self.downloadingArry removeObject:request];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNtfVideoDownloadFinished object:nil];
}

- (void)videoDownloader:(M3u8Downloader *)request precent:(CGFloat)percent{
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoDownloadPecentChangedForM3u8Downloader:)]) {
        [self.delegate videoDownloadPecentChangedForM3u8Downloader:request];
    }
}

-(void)videoDownloaderFailed:(M3u8Downloader*)request{
    
   
    
}




#pragma mark
#pragma mark - ntf handler
-(void)appTermNtf:(NSNotification*)ntf {
    BqsLog(@"appTermNtf");
    
    [self.downloader cancelAll];
    for ( M3u8Downloader *downing  in self.downloadingArry) {
            [downing stopDownloadVideo];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

-(void)appResumeNtf:(NSNotification*)ntf {
    BqsLog(@"appResumeNtf");
    
    [self performSelector:@selector(downloadResum) withObject:nil afterDelay:0.5];
}

- (void)downloadResum{
    
    for ( M3u8Downloader *downing  in self.downloadingArry) {
        if (downing.downingState) {
            [downing startDownloadVideo];
        }
    }

}

- (void)cleanAllFileForDir:(NSString *)path{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSArray* array = [fileManager contentsOfDirectoryAtPath:path error:nil];
    NSError *error;
    for(int i = 0; i<[array count]; i++)
    {
        NSString *fullPath = [path stringByAppendingPathComponent:[array objectAtIndex:i]];
        BqsLog(@"path:%@ the index:%d fileName:%@",path,i,fullPath);
        
        BOOL isDir;
        if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {
            [fileManager removeItemAtPath:fullPath error:&error];
        }
        else
        {
            [self cleanAllFileForDir:fullPath];
        }
    }
    [fileManager release];
}


//

- (void)removeVideoFileForId:(NSString *)videoId{
    NSString *path = [self pathofM3U8DirWithVideoId:videoId];
    [self cleanAllFileForDir:path];
}

- (NSString *)pathOfSaveDownloadedFile{
    if (self.downloadedFile) return self.downloadedFile;
    self.downloadedFile = [self.videoPath stringByAppendingPathComponent:kDownloadedFile];
    return self.downloadedFile;
}
- (NSMutableArray *)readDownloadedVideoFile{
    if (!self.arrDownloadedFiles) {
        self.arrDownloadedFiles = (NSMutableArray *)[SaveVideo parseXmlData:[NSData dataWithContentsOfFile:[self pathOfSaveDownloadedFile]]];
    }
    return self.arrDownloadedFiles;
}
- (BOOL)saveToDownloadedFilePath{
    return [SaveVideo saveToFile:[self pathOfSaveDownloadedFile] Arr:self.arrDownloadedFiles];
}


- (NSString *)pathOfSaveDownloadingFile{
    if (self.downloadingFile) return self.downloadingFile;
    self.downloadingFile = [self.videoPath stringByAppendingPathComponent:kDownloadingFile];
    return self.downloadingFile;

}
- (NSMutableArray *)readDownloadingVideoFile{
    if (!self.arrDownloadingFiles) {
        self.arrDownloadedFiles = (NSMutableArray *)[SaveVideo parseXmlData:[NSData dataWithContentsOfFile:[self pathOfSaveDownloadingFile]]];
    }
    return self.arrDownloadingFiles;
}

- (BOOL)saveToDownloadingPath:(NSString *)path withArry:(NSArray *)arry{
    return [SaveVideo saveToFile:path Arr:arry];
}

- (BOOL)autoSaveDownloadedFile{
    return [SaveVideo saveToFile:[self pathOfSaveDownloadedFile] Arr:self.arrDownloadedFiles];
}


- (BOOL)autoSaveDownloadingFile{
    return [self saveToDownloadingPath:[self pathOfSaveDownloadingFile] withArry:self.arrDownloadingFiles];
}

- (BOOL)autoSaveDownloadingRemoveId:(NSString *)videoId{
    BOOL have = FALSE;
    for (SaveVideo *svideo in self.arrDownloadingFiles) {
        if ([svideo.youkuId isEqualToString:videoId]) {
            [self.arrDownloadingFiles removeObject:svideo];
            have = TRUE;
            break;
        }
    }
    if (!have) {
        return TRUE;
    }
    return [self autoSaveDownloadingFile];
}

- (BOOL)changeIndexOfDowanloadingFrom:(NSUInteger)source destain:(NSUInteger)destine{
    
    if (source >= self.arrDownloadingFiles.count) {
        return FALSE;
    }
    
    M3u8Downloader *catFrom = [self.arrDownloadingFiles objectAtIndex:source];
    [catFrom retain];
    
    [self.arrDownloadingFiles removeObjectAtIndex:source];
    [self.arrDownloadingFiles insertObject:catFrom atIndex:destine];
    [catFrom release];
    
    return [self autoSaveDownloadingFile];

    
}


//pathoftestvied

- (NSString *)pathofM3U8DirWithVideoId:(NSString *)vidoId{
    NSString *m3u8Path =  [self.videoPath stringByAppendingPathComponent:vidoId];
    BqsLog(@"pathofM3U8WithVideoId videopath :%@",m3u8Path);
    BOOL isDir = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    if(!([fm fileExistsAtPath:m3u8Path isDirectory:&isDir] && isDir))
    {
        [fm createDirectoryAtPath:m3u8Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return m3u8Path;
}

- (NSString *)pathOfDownloadM3u8FileForVideo:(NSString *)vidoId{
    NSString *m3u8Path =  [[self.videoPath stringByAppendingPathComponent:vidoId] stringByAppendingPathComponent:kDownloadM3u8];
    BqsLog(@"pathOfDownloadM3u8FileForVideo videopath :%@",m3u8Path);
    return m3u8Path;

}

- (NSString *)localServicePathForM3u8FileWithVideoId:(NSString *)vidoId{
    NSString *m3u8Path =  [[NSString stringWithFormat:kLocalServiceFormat,vidoId] stringByAppendingPathComponent:kDownloadM3u8];
    BqsLog(@"localServicePathForM3u8FileWithVideoId videopath :%@",m3u8Path);
    return m3u8Path;

}

- (NSString *)localPlayPathForVideo:(NSString *)videoId{
    NSString *downM3u8 = [self pathOfDownloadM3u8FileForVideo:videoId];
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:downM3u8]){
        NSString *playM3u8 = [self localServicePathForM3u8FileWithVideoId:videoId];
        return playM3u8;
    }
    return nil;
}


- (NSString *)pathofM3U8XmlFileWithVideoId:(NSString *)videoId{
    NSString *m3u8XML = [[self pathofM3U8DirWithVideoId:videoId] stringByAppendingPathComponent:kM3u8XmlFile];
    BqsLog(@"pathofM3U8XmlFileWithVideoId m3u8XML :%@",m3u8XML);
    return m3u8XML;
}


- (M3U8SegmentInfoList *)segmentInfoListForVideoId:(NSString *)videoId{
    return [M3U8SegmentInfoList parseXmlData:[NSData dataWithContentsOfFile:[self pathofM3U8XmlFileWithVideoId:videoId]]];
}




@end
