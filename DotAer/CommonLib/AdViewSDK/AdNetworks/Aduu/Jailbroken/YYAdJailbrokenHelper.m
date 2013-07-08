//
//  YYAdJailbrokenHelper.m
//  ASIRequest
//
//  Created by apple on 12-11-8.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "YYAdJailbrokenHelper.h"
#import "ASIHTTPRequest.h"
#include <dlfcn.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreFoundation/CFBundle.h>

typedef int (*MobileInstallationBrowse)(NSString *ApplicationType, void *browse_mibcallback,NSMutableArray *result);
typedef int (*MobileInstallationInstall)(NSString *path, NSDictionary *dict, void *na, NSString *path2_equal_path_maybe_no_use);
typedef int (*MobileInstallationUninstall)(NSString *path, NSDictionary *dict, void *na, NSString *path2_equal_path_maybe_no_use);
typedef int (*MobileInstallationUpgrade)(NSString *path, NSDictionary *dict, void *na, NSString *path2_equal_path_maybe_no_use);
typedef NSData* (*SBSCopyIconImagePNGDataForDisplayIdentifier)(NSString *identifier);
typedef NSString * (*SBSCopyIconImagePathForDisplayIdentifier)(NSString *idenrifier);
typedef int (*SBSLaunchApplicationWithIdentifier)(NSString *identifier);

#define kMOBILEINSTALLATION_DEVICE_PRIVATE_PATH @"/System/Library/PrivateFrameworks/MobileInstallation.framework/MobileInstallation"

@implementation YYAdJailbrokenHelper
static YYAdJailbrokenHelper *instance;
static NSMutableArray *pathArray;

//实例化对象
+(YYAdJailbrokenHelper *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[YYAdJailbrokenHelper alloc] init];
        pathArray = [[NSMutableArray alloc] init];
    }
    return instance;
}
//下载app
-(void)downloadApp:(NSString *)appURL
{
    NSString *time = [[NSString stringWithFormat:@"%lf",[[NSDate date] timeIntervalSince1970]*1000] substringToIndex:13];
    NSString *path=[ NSSearchPathForDirectoriesInDomains ( NSDocumentDirectory , NSUserDomainMask , YES ) objectAtIndex : 0 ];
    path=[path stringByAppendingPathComponent : [NSString stringWithFormat:@"%@.ipa",time ] ];
    [pathArray addObject:path];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path])
    {
        [fileManager removeItemAtPath:path error:nil];
    }
    NSURL *url = [ NSURL URLWithString : appURL ];
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :url];
    [request setDownloadDestinationPath :path];
    request.tag = [pathArray count];
    request.delegate = self;
    [request startAsynchronous ];
    [request setPersistentConnectionTimeoutSeconds:120];
}
//安装app
-(void)installApp:(NSString *)appPath isDeleteAfterInstall:(BOOL)isDeleteAfterInstall
{
    if(appPath==nil)
    {
        return;
    }
    int result=0;
    NSString *framePath=kMOBILEINSTALLATION_DEVICE_PRIVATE_PATH;
    void *lib=dlopen([framePath UTF8String],RTLD_LAZY);
    if(lib)
    {
        MobileInstallationInstall pMobileInstallationInstall=(MobileInstallationInstall)dlsym(lib, "MobileInstallationInstall");
        if(pMobileInstallationInstall)
        {
            
            NSFileManager *fileManager=[NSFileManager defaultManager];
            NSString *tmpPath=[NSTemporaryDirectory() stringByAppendingPathComponent:appPath.lastPathComponent];
            if(!isDeleteAfterInstall)
            {
                [fileManager copyItemAtPath:appPath toPath:tmpPath error:nil];
                appPath=tmpPath;
                result=pMobileInstallationInstall(appPath,[NSDictionary dictionaryWithObject:@"User" forKey:@"ApplicationType"],0,appPath);
                [fileManager removeItemAtPath:appPath error:nil];
            }
            else
            {
                result=pMobileInstallationInstall(appPath,[NSDictionary dictionaryWithObject:@"User" forKey:@"ApplicationType"],0,appPath);
                if([fileManager fileExistsAtPath:appPath])
                {
                    [fileManager removeItemAtPath:appPath error:nil];
                }
            }
        }
    }
    NSString *fileName=appPath.lastPathComponent;
    NSString *resultString=[NSString stringWithFormat:@"%@:安装完成",fileName];
    if(result<0)
    {
        resultString=[NSString stringWithFormat:@"%@:安装失败",fileName];
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:resultString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

#pragma mark ASIHTTPRequestDelegate

-(void)requestFailed:(ASIHTTPRequest *)request
{
    
    int tag = request.tag;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"任务 %d 下载失败",tag] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
 
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    int tag = request.tag;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否安装!" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
    alert.tag = tag;
    [alert show];
    [alert release];
    
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int tag = alertView.tag;
    int index = tag -1;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *path = [pathArray objectAtIndex:index];
    if (buttonIndex==0) {
        [self installApp:path isDeleteAfterInstall:YES];
    }else{
        if([fileManager fileExistsAtPath:path])
        {
            [fileManager removeItemAtPath:path error:nil];
        }
        
    }
}
-(void)dealloc
{
    [pathArray release];
    pathArray = nil;
    [instance release];
    instance = nil;
    [super dealloc];
}
@end
