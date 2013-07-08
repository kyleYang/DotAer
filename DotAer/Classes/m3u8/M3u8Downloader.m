//
//  M3u8Downloader.m
//  DotAer
//
//  Created by Kyle on 13-5-29.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "M3u8Downloader.h"
#import "HumDotaVideoManager.h"
#import "Env.h"
#import "BqsUtils.h"
#import "SaveVideo.h"

#define kTsFormat @"ts%d"

@implementation M3u8Downloader
@synthesize totalprogress,playlist,delegate,m3u8Url,youkuId,fileDir,downingState,sVideo;

-(void)dealloc
{
    [playlist release];
    [delegate release];
    [downloadArray release];
    self.sVideo = nil;
    self.fileDir = nil;
    self.m3u8Url = nil;
    self.youkuId = nil;
    [super dealloc];
}

-(id)initWithM3U8List:(M3U8SegmentInfoList *)list withSaveVideo:(SaveVideo *)sVdeo withDir:(NSString *)dir
{
    self = [super init];
    if(self != nil)
    {
        self.playlist = list;
        self.youkuId = sVdeo.youkuId;
        totalprogress = 0.0;
        self.downingState = TRUE;
        self.sVideo = sVdeo;
        self.fileDir = dir;
    }
    return  self;
}



-(id)initWithM3U8List:(M3U8SegmentInfoList *)list withSaveVideo:(SaveVideo *)sVdeo
{
    self = [super init];
    if(self != nil)
    {
        self.playlist = list;
        self.youkuId = sVdeo.youkuId;
        totalprogress = 0.0;
        self.downingState = TRUE;
        self.sVideo = sVdeo;
        self.fileDir = [[HumDotaVideoManager instance] pathofM3U8DirWithVideoId:sVdeo.youkuId];
    }
    return  self;
}






-(void)startDownloadVideo
{
    NSLog(@"start download video");
    if(downloadArray == nil)
    {
        downloadArray = [[NSMutableArray alloc]init];
        for(int i = 0;i< self.playlist.count;i++)
        {
            NSString* filename = [NSString stringWithFormat:kTsFormat,i];
            NSString *absolulatePaht = [self.fileDir stringByAppendingPathComponent:filename];
            NSFileManager *fm = [NSFileManager defaultManager];
            if([fm fileExistsAtPath:absolulatePaht])
            {
                continue;
            }            
            M3U8SegmentInfo* segment = [self.playlist segmentInfoAtIndex:i];
            SegmentDownloader* sgDownloader = [[SegmentDownloader alloc] initWithUrl:segment.mediaURL andFilePath:[[HumDotaVideoManager instance] pathofM3U8DirWithVideoId:self.youkuId] andFileName:filename];
            sgDownloader.delegate = self;
            [downloadArray addObject:sgDownloader];
            [sgDownloader release];
        }
    }
    totalprogress = (CGFloat)(self.playlist.count - [downloadArray count])/(CGFloat)self.playlist.count;
    for(SegmentDownloader* obj in downloadArray)
    {
        [obj start];
    }
    bDownloading = YES;
}

-(void)cleanDownloadFiles
{
    NSLog(@"cleanDownloadFiles");
    
    for(int i = 0;i<self.playlist.count;i++)
    {
        NSString* filename = [NSString stringWithFormat:kTsFormat,i];
        NSString* tmpfilename = [filename stringByAppendingString:kTextDownloadingFileSuffix];
        NSString* fullpath = [self.fileDir stringByAppendingPathComponent:filename];
        NSString* fullpath_tmp = [self.fileDir stringByAppendingPathComponent:tmpfilename];
        
        NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
        
        if ([fileManager fileExistsAtPath:fullpath]) {
            NSError *removeError = nil;
            [fileManager removeItemAtPath:fullpath error:&removeError];
            if (removeError)
            {
                NSLog(@"delete file=%@ err, err is %@",fullpath,removeError);
            }
        }
        
        if ([fileManager fileExistsAtPath:fullpath_tmp]) {
            NSError *removeError = nil;
            [fileManager removeItemAtPath:fullpath_tmp error:&removeError];
            if (removeError)
            {
                NSLog(@"delete file=%@ err, err is %@",fullpath_tmp,removeError);
            }
        }
        
    }
    
}


-(void)stopDownloadVideo
{
    NSLog(@"stop Download Video");
    if(bDownloading && downloadArray != nil)
    {
        for(SegmentDownloader *obj in downloadArray)
        {
            [obj stop];
        }
        bDownloading = NO;
    }
}

-(void)cancelDownloadVideo
{
    NSLog(@"cancel download video");
    if(bDownloading && downloadArray != nil)
    {
        for(SegmentDownloader *obj in downloadArray)
        {
            [obj clean];
        }
    }
    [self cleanDownloadFiles];
}





#pragma mark - SegmentDownloadDelegate
-(void)segmentDownloadFailed:(SegmentDownloader *)request
{
    BqsLog(@"a segment Download Failed");
    
    if(delegate && [delegate respondsToSelector:@selector(videoDownloaderFailed:)])
    {
        [delegate videoDownloaderFailed:self];
    }
}

-(void)segmentDownloadFinished:(SegmentDownloader *)request
{
    BqsLog(@"a segment Download Finished");
    [downloadArray removeObject:request];
    
    totalprogress = (CGFloat)(self.playlist.count - [downloadArray count])/(CGFloat)self.playlist.count;
   
    if(delegate && [delegate respondsToSelector:@selector(videoDownloader:precent:)])
    {
        [delegate videoDownloader:self precent:totalprogress];
    }
    
    if([downloadArray count] == 0)
    {
        totalprogress = 1;
        BqsLog(@"all the segments downloaded. video download finished");
        if(delegate && [delegate respondsToSelector:@selector(videoDownloaderFinished:)])
        {
            [delegate videoDownloaderFinished:self];
        }
    }
}


-(NSString*)createLocalM3U8file
{
    if(playlist !=nil)
    {
        NSString *saveTo = [[HumDotaVideoManager instance] pathofM3U8DirWithVideoId:self.youkuId];
        NSString *fullpath = [saveTo stringByAppendingPathComponent:kDownloadM3u8];
        NSLog(@"createLocalM3U8file:%@",fullpath);
        
        //创建文件头部
        NSString* head = @"#EXTM3U\n#EXT-X-TARGETDURATION:30\n#EXT-X-VERSION:2\n#EXT-X-DISCONTINUITY\n";
        
        NSString* segmentPrefix = [NSString stringWithFormat:kLocalServiceFormat,self.youkuId];
        //填充片段数据
        for(int i = 0;i< self.playlist.count;i++)
        {
            NSString* filename = [NSString stringWithFormat:kTsFormat,i];
            M3U8SegmentInfo* segInfo = [self.playlist segmentInfoAtIndex:i];
            NSString* length = [NSString stringWithFormat:@"#EXTINF:%d,\n",segInfo.duration];
            NSString* url = [segmentPrefix stringByAppendingString:filename];
            head = [NSString stringWithFormat:@"%@%@%@\n",head,length,url];
        }
        //创建尾部
        NSString* end = @"#EXT-X-ENDLIST";
        head = [head stringByAppendingString:end];
        NSMutableData *writer = [[NSMutableData alloc] init];
        [writer appendData:[head dataUsingEncoding:NSUTF8StringEncoding]];
        
        BOOL bSucc =[writer writeToFile:fullpath atomically:YES];
        if(bSucc)
        {
            NSLog(@"create m3u8file succeed; fullpath:%@, content:%@",fullpath,head);
            return  fullpath;
        }
        else
        {
            NSLog(@"create m3u8file failed");
            return  nil;
        }
        [writer release];
    }
    return nil;
}


@end
