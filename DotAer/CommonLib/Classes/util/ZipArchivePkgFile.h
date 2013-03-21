//
//  ZipArchivePkgFile.h
//  iMobeeBook
//
//  Created by ellison on 11-6-24.
//  Copyright 2011年 borqs. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "zip.h"
#include "unzip.h"


@interface ZipArchivePkgFile : NSObject {
    unzFile		_unzFile;
}
@property (assign) id callback;
@property (retain) NSError *error;
@property (assign) NSInteger unzipTotalFile;
@property (assign) NSInteger unzipCurFileId;
@property (copy) NSString *zipFilePath;
@property (copy) NSString *unzipPath;
@property (assign) id attached;
@property (copy) NSString *password;

-(BOOL) UnzipFileInBackground:(NSString*) zipFile To:(NSString*)path;

@end

@protocol ZipArchivePkgFileCallback <NSObject>
@optional
-(void) unzipProgress: (ZipArchivePkgFile*)obj;
-(void) unzipFinished:(ZipArchivePkgFile*)obj;

@end
