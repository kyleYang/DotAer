//
//  ZipArchive.mm
//  
//
//  Created by aish on 08-9-11.
//  acsolu@gmail.com
//  Copyright 2008  Inc. All rights reserved.
//

#import "ZipArchive.h"
#import "zlib.h"
#import "zconf.h"
#import "BqsUtils.h"



@interface ZipArchive (Private)

-(void) OutputErrorMessage:(NSString*) msg;
-(BOOL) OverWrite:(NSString*) file;
-(NSDate*) Date1980;
-(void) DoUnzipFileInBackground;


@end



@implementation ZipArchive
@synthesize delegate = _delegate;
@synthesize error = _error;
@synthesize unzipTotalFile = _unzipTotalFile;
@synthesize unzipCurFileId = _unzipCurFileId;
@synthesize zipFilePath = _zipFilePath;
@synthesize unzipPath = _unzipPath;
@synthesize bOverwrite = _bOverwrite;
@synthesize attached = _attached;

-(id) init
{
    self=[super init];
    
	if(nil != self)
	{
		_zipFile = NULL ;
	}
	return self;
}

-(void) dealloc
{
	[self CloseZipFile2];
	[_error release];
	[_zipFilePath release];
	[_unzipPath release];
	

	[super dealloc];
}

-(BOOL) CreateZipFile2:(NSString*) zipFile
{
	_zipFile = zipOpen( (const char*)[zipFile UTF8String], 0 );
	if( !_zipFile ) 
		return NO;
	return YES;
}

-(BOOL) CreateZipFile2:(NSString*) zipFile Password:(NSString*) password
{
	_password = password;
	return [self CreateZipFile2:zipFile];
}

-(BOOL) addFileToZip:(NSString*) file newname:(NSString*) newname;
{
	if( !_zipFile )
		return NO;
//	tm_zip filetime;
	time_t current;
	time( &current );
	
	zip_fileinfo zipInfo = {0};
//	zipInfo.dosDate = (unsigned long) current;
	
	//NSDictionary* attr = [[NSFileManager defaultManager] fileAttributesAtPath:file traverseLink:YES];
	NSError* err = nil;
	NSDictionary *attr = [[NSFileManager defaultManager] attributesOfItemAtPath:file error:&err];
	if(nil == err && nil != attr)
	{
		NSDate* fileDate = (NSDate*)[attr objectForKey:NSFileModificationDate];
		if( fileDate )
		{
			// some application does use dosDate, but tmz_date instead
		//	zipInfo.dosDate = [fileDate timeIntervalSinceDate:[self Date1980] ];
			NSCalendar* currCalendar = [NSCalendar currentCalendar];
			uint flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | 
				NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ;
			NSDateComponents* dc = [currCalendar components:flags fromDate:fileDate];
			zipInfo.tmz_date.tm_sec = [dc second];
			zipInfo.tmz_date.tm_min = [dc minute];
			zipInfo.tmz_date.tm_hour = [dc hour];
			zipInfo.tmz_date.tm_mday = [dc day];
			zipInfo.tmz_date.tm_mon = [dc month] - 1;
			zipInfo.tmz_date.tm_year = [dc year];
		}
	}
	
	int ret ;
	NSData* data = nil;
	if( [_password length] == 0 )
	{
		ret = zipOpenNewFileInZip( _zipFile,
								  (const char*) [newname UTF8String],
								  &zipInfo,
								  NULL,0,
								  NULL,0,
								  NULL,//comment
								  Z_DEFLATED,
								  Z_DEFAULT_COMPRESSION );
	}
	else
	{
		data = [ NSData dataWithContentsOfFile:file];
		uLong crcValue = crc32( 0L,NULL, 0L );
		crcValue = crc32( crcValue, (const Bytef*)[data bytes], [data length] );
		ret = zipOpenNewFileInZip3( _zipFile,
								  (const char*) [newname UTF8String],
								  &zipInfo,
								  NULL,0,
								  NULL,0,
								  NULL,//comment
								  Z_DEFLATED,
								  Z_DEFAULT_COMPRESSION,
								  0,
								  15,
								  8,
								  Z_DEFAULT_STRATEGY,
								  [_password cStringUsingEncoding:NSASCIIStringEncoding],
								  crcValue );
	}
	if( ret!=Z_OK )
	{
		return NO;
	}
	if( data==nil )
	{
		data = [ NSData dataWithContentsOfFile:file];
	}
	unsigned int dataLen = [data length];
	ret = zipWriteInFileInZip( _zipFile, (const void*)[data bytes], dataLen);
	if( ret!=Z_OK )
	{
		return NO;
	}
	ret = zipCloseFileInZip( _zipFile );
	if( ret!=Z_OK )
		return NO;
	return YES;
}

-(BOOL) CloseZipFile2
{
	_password = nil;
	if( _zipFile==NULL )
		return NO;
	BOOL ret =  zipClose( _zipFile,NULL )==Z_OK?YES:NO;
	_zipFile = NULL;
	return ret;
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
			_unzipTotalFile = globalInfo.number_entry;
			_unzipCurFileId = 0;
		}
	}
	return _unzFile!=NULL;
}

-(BOOL) UnzipOpenFile:(NSString*) zipFile Password:(NSString*) password
{
	_password = password;
	return [self UnzipOpenFile:zipFile];
}

-(BOOL) UnzipFileTo:(NSString*) path overWrite:(BOOL) overwrite
{
	BOOL success = YES;
	int ret = unzGoToFirstFile( _unzFile );
	unsigned char		buffer[4096] = {0};
	NSFileManager* fman = [NSFileManager defaultManager];
	if( ret!=UNZ_OK )
	{
		[self OutputErrorMessage:@"Failed"];
	}
	
	do{
		_unzipCurFileId ++;
		
		if( [_password length]==0 )
			ret = unzOpenCurrentFile( _unzFile );
		else
			ret = unzOpenCurrentFilePassword( _unzFile, [_password cStringUsingEncoding:NSASCIIStringEncoding] );
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
		
		if(nil != _delegate && [_delegate respondsToSelector:@selector(unzipProgress:)]) {
			//[_delegate unzipProgressCurFileId:_unzipCurFileId Name:strPath Total:_unzipTotalFile];
			[_delegate performSelectorOnMainThread:@selector(unzipProgress:) withObject:self waitUntilDone:YES];
		}
		BOOL isDirectory = NO;
		if( filename[fileInfo.size_filename-1]=='/' || filename[fileInfo.size_filename-1]=='\\')
			isDirectory = YES;
		free( filename );
		if( [strPath rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"/\\"]].location!=NSNotFound )
		{// contains a path
			strPath = [strPath stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
		}
		NSString* fullPath = [path stringByAppendingPathComponent:strPath];
		
		if( isDirectory )
			[fman createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:nil error:nil];
		else
			[fman createDirectoryAtPath:[fullPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
		if( [fman fileExistsAtPath:fullPath] && !isDirectory && !overwrite )
		{
			if( ![self OverWrite:fullPath] )
			{
				unzCloseCurrentFile( _unzFile );
				ret = unzGoToNextFile( _unzFile );
				continue;
			}
		}
		FILE* fp = fopen( (const char*)[fullPath UTF8String], "wb");
		while( fp )
		{
			read=unzReadCurrentFile(_unzFile, buffer, 4096);
			if( read > 0 )
			{
				int wr = fwrite(buffer, read, 1, fp );
				if(wr < 0) {
					NSLog(@"Can't write to file: %@", fullPath);
					self.error = [NSError errorWithDomain:@"" code:NSURLErrorCannotWriteToFile userInfo:nil];
					success = NO;
					break;
				}
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
		if( fp )
		{
			fclose( fp );
			// set the orignal datetime property
			NSDate* orgDate = nil;
			
			//{{ thanks to brad.eaton for the solution
			NSDateComponents *dc = [[NSDateComponents alloc] init];
			
			dc.second = fileInfo.tmu_date.tm_sec;
			dc.minute = fileInfo.tmu_date.tm_min;
			dc.hour = fileInfo.tmu_date.tm_hour;
			dc.day = fileInfo.tmu_date.tm_mday;
			dc.month = fileInfo.tmu_date.tm_mon+1;
			dc.year = fileInfo.tmu_date.tm_year;
			
			NSCalendar *gregorian = [[NSCalendar alloc] 
									 initWithCalendarIdentifier:NSGregorianCalendar];
			
			orgDate = [gregorian dateFromComponents:dc] ;
			[dc release];
			[gregorian release];
			//}}
			
			
			NSDictionary* attr = [NSDictionary dictionaryWithObject:orgDate forKey:NSFileModificationDate]; //[[NSFileManager defaultManager] fileAttributesAtPath:fullPath traverseLink:YES];
			if( attr )
			{
				//		[attr  setValue:orgDate forKey:NSFileCreationDate];
				if( ![[NSFileManager defaultManager] setAttributes:attr ofItemAtPath:fullPath error:nil] )
				{
					// cann't set attributes 
					NSLog(@"Failed to set attributes");
				}
				
			}
		
			
			
		}
		
		if(!success) break;
		
		unzCloseCurrentFile( _unzFile );
		ret = unzGoToNextFile( _unzFile );
	}while( ret==UNZ_OK && ret!=UNZ_END_OF_LIST_OF_FILE );
	
	return success;
}

-(BOOL) UnzipCloseFile
{
	_password = nil;
	if( _unzFile ){
		BOOL ret = (unzClose( _unzFile )==UNZ_OK);
		_unzFile = nil;
		return ret;
	}
		
	return YES;
}

-(BOOL) UnzipFileInBackground:(NSString*) sZipFile To:(NSString*)path overWrite:(BOOL)overwrite {
	if(nil == sZipFile || nil == path) {
		NSLog(@"Invalid param zipFile: %@ path: %@", sZipFile, path);
		return NO;
	}
	
	self.zipFilePath = sZipFile;
	self.unzipPath = path;
	self.bOverwrite = overwrite;
	
	[self performSelectorInBackground:@selector(DoUnzipFileInBackground) withObject: nil];
	return YES;
}
-(void) DoUnzipFileInBackground {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	BOOL bS = [self UnzipOpenFile:_zipFilePath];
	
	if(!bS) {
		NSLog(@"Can't open file unzip: %@", _zipFilePath);
		self.error = [NSError errorWithDomain:@"" code:NSURLErrorCannotOpenFile userInfo:nil];
		if(nil != _delegate && [_delegate respondsToSelector:@selector(unzipFinished:)]) {
			//[_delegate unzipFinished:success];
			[_delegate performSelectorOnMainThread:@selector(unzipFinished:) withObject:self waitUntilDone:YES];
		}
	} else {
		bS = [self UnzipFileTo:_unzipPath overWrite:_bOverwrite];
		[self UnzipCloseFile];
	}	
	
	[pool drain];
	
	
	if(nil != _delegate && [_delegate respondsToSelector:@selector(unzipFinished:)]) {
		//[_delegate unzipFinished:success];
		[_delegate performSelectorOnMainThread:@selector(unzipFinished:) withObject:self waitUntilDone:YES];
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

-(BOOL) OverWrite:(NSString*) file
{
	//if( _delegate && [_delegate respondsToSelector:@selector(OverWriteOperation)] )
//		return [_delegate OverWriteOperation:file];
	return YES;
}

#pragma mark get NSDate object for 1980-01-01
-(NSDate*) Date1980
{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setDay:1];
	[comps setMonth:1];
	[comps setYear:1980];
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	NSDate *date = [gregorian dateFromComponents:comps];
	
	[comps release];
	[gregorian release];
	return date;
}


@end


