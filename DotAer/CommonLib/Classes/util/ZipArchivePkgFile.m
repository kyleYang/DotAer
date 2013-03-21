//
//  ZipArchivePkgFile.m
//  iMobeeBook
//
//  Created by ellison on 11-6-24.
//  Copyright 2011年 borqs. All rights reserved.
//

#import "ZipArchivePkgFile.h"
#import "zlib.h"
#import "zconf.h"
#import "BqsUtils.h"
#import "PackageFile.h"

@interface ZipArchivePkgFile (Private)

-(void) OutputErrorMessage:(NSString*) msg;
-(void) DoUnzipFileInBackground;

-(BOOL) UnzipOpenFile:(NSString*) zipFile;
-(BOOL) UnzipOpenFile:(NSString*) zipFile Password:(NSString*) password;
-(BOOL) UnzipFileTo:(NSString*) path overWrite:(BOOL) overwrite;
-(BOOL) UnzipCloseFile;


@end



@implementation ZipArchivePkgFile
@synthesize callback;
@synthesize error;
@synthesize unzipTotalFile;
@synthesize unzipCurFileId;
@synthesize zipFilePath;
@synthesize unzipPath;
@synthesize attached;
@synthesize password;

-(id) init
{
	self=[super init];
	return self;
}

-(void) dealloc
{
	[self UnzipCloseFile];
    
    self.error = nil;
    self.zipFilePath = nil;
    self.unzipPath = nil;
	self.password = nil;
    
	[super dealloc];
}

-(BOOL) UnzipOpenFile:(NSString*) zipFile
{
	_unzFile = unzOpen( (const char*)[zipFile UTF8String] );
	if( _unzFile )
	{
		unz_global_info  globalInfo = {0};
		if( unzGetGlobalInfo(_unzFile, &globalInfo )==UNZ_OK )
		{
			NSLog(@"%@", [NSString stringWithFormat:@"%d entries in the zip file",globalInfo.number_entry]);
			self.unzipTotalFile = globalInfo.number_entry;
			self.unzipCurFileId = 0;
		}
	}
	return _unzFile!=NULL;
}

-(BOOL) UnzipOpenFile:(NSString*) zipFile Password:(NSString*) passwd
{
	self.password = passwd;
	return [self UnzipOpenFile:zipFile];
}

-(BOOL) UnzipFileTo:(PackageFile*) pkgFile
{
	BOOL success = YES;
	int ret = unzGoToFirstFile( _unzFile );
	unsigned char		buffer[4096] = {0};
//	NSFileManager* fman = [NSFileManager defaultManager];
	if( ret!=UNZ_OK )
	{
		[self OutputErrorMessage:@"Failed"];
	}
	
	do{
		self.unzipCurFileId ++;
		
		if( [self.password length]==0 )
			ret = unzOpenCurrentFile( _unzFile );
		else
			ret = unzOpenCurrentFilePassword( _unzFile, [self.password cStringUsingEncoding:NSASCIIStringEncoding] );
		if( ret!=UNZ_OK )
		{
			[self OutputErrorMessage:@"Error occurs"];
			success = NO;
			self.error = [NSError errorWithDomain:@"" code:NSURLErrorCannotOpenFile userInfo:nil];
			break;
		}
		// reading data and write to file
		int read ;
		unz_file_info	fileInfo ={0};
		ret = unzGetCurrentFileInfo(_unzFile, &fileInfo, NULL, 0, NULL, 0, NULL, 0);
		if( ret!=UNZ_OK )
		{
			[self OutputErrorMessage:@"Error occurs while getting file info"];
			success = NO;
			self.error = [NSError errorWithDomain:@"" code:NSURLErrorCannotOpenFile userInfo:nil];
			unzCloseCurrentFile( _unzFile );
			break;
		}
		char* filename = (char*) malloc( fileInfo.size_filename +1 );
		unzGetCurrentFileInfo(_unzFile, &fileInfo, filename, fileInfo.size_filename + 1, NULL, 0, NULL, 0);
		filename[fileInfo.size_filename] = '\0';
		
		// check if it contains directory
		NSString * strPath = [NSString  stringWithCString:filename encoding:NSUTF8StringEncoding];
		
		if(nil != self.callback && [self.callback respondsToSelector:@selector(unzipProgress:)]) {
			[self.callback performSelectorOnMainThread:@selector(unzipProgress:) withObject:self waitUntilDone:YES];
		}
		BOOL isDirectory = NO;
		if( filename[fileInfo.size_filename-1]=='/' || filename[fileInfo.size_filename-1]=='\\')
			isDirectory = YES;
		free( filename );
		
        if(!isDirectory) {
            NSMutableData *data = [[NSMutableData alloc] initWithCapacity:(fileInfo.uncompressed_size > 0 ? fileInfo.uncompressed_size : 4096)];
            
            while(YES) {
                read=unzReadCurrentFile(_unzFile, buffer, 4096);
                if( read > 0 )
                {
                    int curLen = [data length];
                    [data increaseLengthBy:read];
                    
                    void *pM = ([data mutableBytes] + curLen);
                    memcpy(pM, buffer, read);
                }
                else if( read<0 )
                {
                    [self OutputErrorMessage:@"Failed to reading zip file"];
                    self.error = [NSError errorWithDomain:@"" code:NSURLErrorCannotOpenFile userInfo:nil];
                    success = NO;
                    break;
                }
                else 
                    break;
            }
            
            if([data length] > 0) {
                [pkgFile writeDataName:strPath Data:data];
            }
            
            [data release];
        }
		if(!success) break;
		
		unzCloseCurrentFile( _unzFile );
		ret = unzGoToNextFile( _unzFile );
	}while( ret==UNZ_OK && ret!=UNZ_END_OF_LIST_OF_FILE );
	
	return success;
}

-(BOOL) UnzipCloseFile
{
	if( _unzFile ){
		BOOL ret = (unzClose( _unzFile )==UNZ_OK);
		_unzFile = nil;
		return ret;
	}
    
	return YES;
}

-(BOOL) UnzipFileInBackground:(NSString*) sZipFile To:(NSString*)path {
	if(nil == sZipFile || nil == path) {
		NSLog(@"Invalid param zipFile: %@ path: %@", sZipFile, path);
		return NO;
	}
	
	self.zipFilePath = sZipFile;
	self.unzipPath = path;
	
	[self performSelectorInBackground:@selector(DoUnzipFileInBackground) withObject: nil];
	return YES;
}
-(void) DoUnzipFileInBackground {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	BOOL bS = [self UnzipOpenFile:self.zipFilePath];
	
	if(!bS) {
		NSLog(@"Can't open file unzip: %@", self.zipFilePath);
		self.error = [NSError errorWithDomain:@"" code:NSURLErrorCannotOpenFile userInfo:nil];
		if(nil != self.callback && [self.callback respondsToSelector:@selector(unzipFinished:)]) {
			//[_delegate unzipFinished:success];
			[self.callback performSelectorOnMainThread:@selector(unzipFinished:) withObject:self waitUntilDone:YES];
		}
	} else {
        
        PackageFile *pkgF = [[PackageFile alloc] initWithPath:self.unzipPath];
		bS = [self UnzipFileTo:pkgF];
		[self UnzipCloseFile];
        
        [pkgF release];
	}
	
	[pool release];
	
	
	if(nil != self.callback && [self.callback respondsToSelector:@selector(unzipFinished:)]) {
		//[_delegate unzipFinished:success];
		[self.callback performSelectorOnMainThread:@selector(unzipFinished:) withObject:self waitUntilDone:YES];
	}
	
	return;
}

#pragma mark wrapper for delegate
-(void) OutputErrorMessage:(NSString*) msg
{
    //	if( _delegate && [_delegate respondsToSelector:@selector(ErrorMessage)] )
    //		//[_delegate ErrorMessage:msg];
    //		[_delegate performSelectorOnMainThread:@selector(ErrorMessage) withObject:msg waitUntilDone:YES];
}




@end

