//
//  ZipArchive.h
//  
//
//  Created by aish on 08-9-11.
//  acsolu@gmail.com
//  Copyright 2008  Inc. All rights reserved.
//
// History: 
//    09-11-2008 version 1.0    release
//    10-18-2009 version 1.1    support password protected zip files
//    10-21-2009 version 1.2    fix date bug

#import <UIKit/UIKit.h>

#include "zip.h"
#include "unzip.h"

@class ZipArchive;

@protocol ZipArchiveDelegate <NSObject>
@optional
//-(void) ErrorMessage:(NSString*) msg;
//-(BOOL) OverWriteOperation:(NSString*) file;
-(void) unzipProgress: (ZipArchive*)obj;
-(void) unzipFinished:(ZipArchive*)obj;

@end


@interface ZipArchive : NSObject {
@private
	zipFile		_zipFile;
	unzFile		_unzFile;
	
	NSString*   _password;
	id			_delegate;
	
	NSInteger _unzipTotalFile;
	NSInteger _unzipCurFileId;
	NSError *_error;
	
	NSString *_zipFilePath;
	NSString *_unzipPath;
	BOOL _bOverwrite;
    
	id _attached;
}

@property (assign) id delegate;
@property (retain) NSError *error;
@property (assign) NSInteger unzipTotalFile;
@property (assign) NSInteger unzipCurFileId;
@property (copy) NSString *zipFilePath;
@property (copy) NSString *unzipPath;
@property (assign) BOOL bOverwrite;
@property (assign) id attached;

-(BOOL) CreateZipFile2:(NSString*) zipFile;
-(BOOL) CreateZipFile2:(NSString*) zipFile Password:(NSString*) password;
-(BOOL) addFileToZip:(NSString*) file newname:(NSString*) newname;
-(BOOL) CloseZipFile2;

-(BOOL) UnzipOpenFile:(NSString*) zipFile;
-(BOOL) UnzipOpenFile:(NSString*) zipFile Password:(NSString*) password;
-(BOOL) UnzipFileTo:(NSString*) path overWrite:(BOOL) overwrite;
-(BOOL) UnzipCloseFile;

-(BOOL) UnzipFileInBackground:(NSString*) zipFile To:(NSString*)path overWrite:(BOOL)overwrite;
@end
