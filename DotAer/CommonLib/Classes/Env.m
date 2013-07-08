//
//  Env.m
//  iMobee
//
//  Created by ellison on 10-9-13.
//  Copyright 2010 borqs. All rights reserved.
//

#import "Env.h"
#import "BqsUtils.h"

#define kCfgEnvServerSE @"env.serverSE"

@interface Env() 

@property (nonatomic, copy, readwrite) NSString *sPhoneType;
@property (nonatomic, copy, readwrite) NSString *macUdid;
@property (nonatomic, copy, readwrite) NSString *sDevId; // device id generated from udid
@property (nonatomic, copy, readwrite) NSString *host;
@property (nonatomic, copy, readwrite) NSString *sServiceEntryUrl; // /phone/tvguide.xml
@property (nonatomic, copy, readwrite) NSString *sScreenSize;
@property (nonatomic, copy, readwrite) NSString *sScreenScale;
@property (nonatomic, assign, readwrite) MptDeviceScreenType deviceType;
@property (nonatomic, assign, readwrite) BOOL bIsPad;
@property (nonatomic, copy, readwrite) NSString *swVersion;
@property (nonatomic, copy, readwrite) NSString *swVersionCode;
@property (nonatomic, copy, readwrite) NSString *sAppDownloadUrlForWeibo;
@property (nonatomic, copy, readwrite) NSString *swType;
@property (nonatomic, copy, readwrite) NSString *itunesAppId;
@property (nonatomic, copy, readwrite) NSString *umengId;
@property (nonatomic, copy, readwrite) NSString *market;
@property (nonatomic, copy, readwrite) NSString *dirDocuments;
@property (nonatomic, copy, readwrite) NSString *dirCache;
@property (nonatomic, copy, readwrite) NSString *dirTmp;
@property (nonatomic, copy, readwrite) NSString *hdrClientType;
@property (nonatomic, retain, readwrite) BkSvc *bkSvc;
@property (nonatomic, retain, readwrite) NSDictionary *dicNetAppAppendHeader;

@end;

@implementation Env

@synthesize sPhoneType;
@synthesize macUdid = _macUdid;
@synthesize sDevId;
@synthesize deviceType;
@synthesize bIsPad;
@synthesize screenSize = _screenSize;
@synthesize sScreenSize = _sScreenSize;
@synthesize screenScale = _screenScale;
@synthesize sScreenScale = _sScreenScale;
@synthesize host = _host;
@synthesize sServiceEntryUrl;
@synthesize swVersion=_swVersion, swVersionCode;
@synthesize sAppDownloadUrlForWeibo;
@synthesize swType=_swType;
@synthesize itunesAppId;
@synthesize umengId = _umengId;
@synthesize market=_market;
@synthesize dirDocuments = _dirDocuments;
@synthesize dirCache = _dirCache;
@synthesize dirTmp = _dirTmp;
@synthesize runtimeData = _runtimeData;
@synthesize hdrClientType=_hdrClientType;
@synthesize bkSvc=_bkSvc;
@synthesize dicNetAppAppendHeader;

+ (Env*)sharedEnv {
    id del = [UIApplication sharedApplication].delegate;
    if(nil != del && [del respondsToSelector:@selector(getEnv)]) {
        return [del performSelector:@selector(getEnv)];
    }
    return nil;
}

+(UIViewController*)getRootViewController {
    id del = [UIApplication sharedApplication].delegate;
    if(nil != del && [del respondsToSelector:@selector(getRootViewController)]) {
        return [del performSelector:@selector(getRootViewController)];
    }
    return nil;
}

-(id) init {
	self = [super init];
	if(nil == self) return nil;
    
	// create runtime data
	_runtimeData = [[NSMutableDictionary alloc] initWithCapacity:10];
    _bkSvc = [[BkSvc alloc] init];
	
	// get dirs
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	self.dirDocuments = [paths objectAtIndex:0];
	BqsLog(@"dirDocuments: %@", _dirDocuments);
	
	paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); 
	self.dirCache = [paths objectAtIndex:0];
	BqsLog(@"dirCache: %@", _dirCache);
	
	self.dirTmp = NSTemporaryDirectory();
	BqsLog(@"dirTmp: %@", _dirTmp);
    
    //load saved cfg
    _serverServiceEntry = [[[NSUserDefaults standardUserDefaults] objectForKey:kCfgEnvServerSE] retain];
    BqsLog(@"serverSE: %@", _serverServiceEntry);
	
	// get udid (get mac instead, udid is deprecated)
	UIDevice *myDevice = [UIDevice currentDevice];
//    if([myDevice respondsToSelector:@selector(uniqueIdentifier)]) {
//        self.udid = [[myDevice uniqueIdentifier] stringByReplacingOccurrencesOfString: @"-" withString: @""];
//    }
    if(nil == self.macUdid || [self.macUdid length] < 1) {
        self.macUdid = [@"ios" stringByAppendingString:[BqsUtils calcMD5forString:[BqsUtils readDevMACAddress]]];
        //    BqsLog(@"mac=%@, macmd5:%@", [BqsUtils readDevMACAddress], [BqsUtils calcMD5forString:[BqsUtils readDevMACAddress]]);
    }
    
    self.sDevId = [NSString stringWithFormat:@"%d", abs((int)[self.macUdid hash])];
	BqsLog(@"udid=%@,devid=%@", _macUdid,self.sDevId);
    
	// get screen size
	_screenSize = [[UIScreen mainScreen] bounds].size;
    self.sScreenSize = [NSString stringWithFormat:@"%dx%d", (int)_screenSize.width, (int)_screenSize.height];
	BqsLog(@"screenSize=%@",_sScreenSize);
    
	_screenScale = [BqsUtils getScreenScale];
    self.sScreenScale = [NSString stringWithFormat:@"%.1f", _screenScale];
	BqsLog(@"screenScale=%@", _sScreenScale);
	
	NSString *bqsOS = [NSString stringWithFormat:@"%@_%@", myDevice.systemName, myDevice.systemVersion];
	bqsOS = [bqsOS stringByReplacingOccurrencesOfString:@" " withString:@"_"];
	BqsLog(@"bqsOS=%@", bqsOS);
	
	NSString *bqsPT = [myDevice.model stringByReplacingOccurrencesOfString:@" " withString:@"_"];
	BqsLog(@"bqsPT=%@", bqsPT);
    self.sPhoneType = bqsPT;

    // check iPad
    self.bIsPad = [BqsUtils isIPad];
    
    CGFloat pixelHeight = (_screenSize.height * _screenScale);

    
    if (self.bIsPad) {   //check device for iPhone  iPhoneRetina3.5  iPhoneRetina4 iPad iPadRetaina
        if (_screenScale == 2.0f && pixelHeight == 2048.0f) {
            self.deviceType = MptDeviceResolution_iPadRetina;
            
        } else if (_screenScale == 1.0f && pixelHeight == 1024.0f) {
            self.deviceType = MptDeviceResolution_iPadStandard;
        }
    }else {
        if (_screenScale == 2.0f) {
            if (pixelHeight == 960.0f)
                self.deviceType = MptDeviceResolution_iPhoneRetina35;
            else if (pixelHeight == 1136.0f)
                self.deviceType = MptDeviceResolution_iPhoneRetina4;
            
        } else if (_screenScale == 1.0f && pixelHeight == 480.0f)
            self.deviceType = MptDeviceResolution_iPhoneStandard;
    }
    
    

	NSError *err = nil;
	self.market = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"market" ofType:@"txt"] 
						   encoding:NSUTF8StringEncoding error:&err];
	if(nil == self.market) {
		self.market = @"";
	}
	
	// get default host from property.plist	
	NSDictionary *properties = [NSDictionary dictionaryWithContentsOfFile:
								[[NSBundle mainBundle] pathForResource:@"property" ofType:@"plist"]];
	if(nil != properties) {
        self.host = [properties objectForKey:@"host"];
        self.sServiceEntryUrl = [properties objectForKey:@"service_entry_url"];
		self.swType = [properties objectForKey:@"swtype"];
        self.sAppDownloadUrlForWeibo = [properties objectForKey:@"app_download_url_forweibo"];
        self.itunesAppId = [properties objectForKey:@"itunes_app_id"];
        self.umengId = [properties objectForKey:@"umeng_app_id"];
        self.dicNetAppAppendHeader = [properties objectForKey:@"app_net_append_header"];
	}
    
	if(nil == _host || [_host length] < 1) {
		self.host = kDefaultHost;
	}
	
	self.hdrClientType = [NSString stringWithFormat:@"iOS%@/%@/apple/%@", myDevice.systemVersion, self.swType, bqsPT]; 
	
	BqsLog(@"host=%@, service_entry_url=%@",self.host, self.sServiceEntryUrl);
	BqsLog(@"market=%@", self.market);
	BqsLog(@"swtype=%@", self.swType);
	BqsLog(@"hdrClientType=%@", self.hdrClientType);
	
    self.swVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    self.swVersionCode = [self.swVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    BqsLog(@"swVersion=%@, swVersionCode=%@", _swVersion, self.swVersionCode);
	    
	return self;
}

-(void)dealloc {
	self.dirDocuments = nil;
	self.dirCache = nil;
	self.dirTmp = nil;
	self.runtimeData = nil;
    self.sPhoneType = nil;
	self.macUdid = nil;
    self.sDevId = nil;
	self.host = nil;
    self.swVersion = nil;
    self.swVersionCode = nil;
    self.sAppDownloadUrlForWeibo = nil;
    self.swType = nil;
    self.itunesAppId = nil;
	self.market = nil;
    [_serverServiceEntry release];
    self.hdrClientType = nil;
    self.bkSvc = nil;
    self.sScreenScale = nil;
    self.sScreenSize = nil;
    self.sServiceEntryUrl = nil;
    
    [_memImgCache release];
    
    self.dicNetAppAppendHeader = nil;
	
	[super dealloc];
}

- (NSString*)getSEKey:(NSString*)key Def:(NSString*)defValue {
    if([key length] < 1) return defValue;
    
    NSString *v = nil;
    
    if(nil == _serverServiceEntry) {
        _serverServiceEntry = [[[NSUserDefaults standardUserDefaults] objectForKey:kCfgEnvServerSE] retain];
    }
    v = [_serverServiceEntry objectForKey:key];
    if([v length] > 0) return v;
        
    return defValue;
}

- (void)updateServerSE:(NSDictionary*)newServerSE {
    if(nil == newServerSE) return;
    
    [_serverServiceEntry release];
    _serverServiceEntry = nil;
    
    _serverServiceEntry = [[NSDictionary alloc] initWithDictionary: newServerSE];
    
    [[NSUserDefaults standardUserDefaults] setObject:_serverServiceEntry forKey:kCfgEnvServerSE];
}

-(NSString*)getProperty:(NSString*)name {
    if(nil == name || [name length] < 1) return nil;
    
    // get value from property.plist	
	NSDictionary *properties = [NSDictionary dictionaryWithContentsOfFile:
								[[NSBundle mainBundle] pathForResource:@"property" ofType:@"plist"]];
	if(nil != properties) {
        
        return [properties objectForKey:name];
	}
    return nil;
}

-(UIImage*)resImageWithName:(NSString*)fileName {
    float scale = self.screenScale;
    UIImage *img = nil;
    
    NSBundle *mainBnd = [NSBundle mainBundle];
    
    NSString *ext = [fileName pathExtension];
    NSString *bod = [fileName stringByDeletingPathExtension];
    
    if(self.screenSize.height == 568) {
        bod = [bod stringByAppendingString:@"-568h"];
    }

    //float scale = 2.0;
    if(scale >= 2.0f) {
        NSString *sFName = [NSString stringWithFormat:@"%@@%dx.%@", bod, (int)scale, ext];
        //BqsLog(@"sFName=%@", sFName);
        
        NSString *imgPath = [NSString stringWithFormat:@"%@/%@", [mainBnd resourcePath], sFName];
        if([[NSFileManager defaultManager] fileExistsAtPath:imgPath]) {
            img = [UIImage imageWithContentsOfFile:imgPath];
        } else {
            BqsLog(@"%@ not exist, fall back to %@.", sFName, fileName);
        }
    } else {
        NSString *sFName = [NSString stringWithFormat:@"%@.%@", bod, ext];
        //BqsLog(@"sFName=%@", sFName);
        
        NSString *imgPath = [NSString stringWithFormat:@"%@/%@", [mainBnd resourcePath], sFName];
        if([[NSFileManager defaultManager] fileExistsAtPath:imgPath]) {
            img = [UIImage imageWithContentsOfFile:imgPath];
        } else {
            BqsLog(@"%@ not exist, fall back to %@.", sFName, fileName);
        }

    }
    
    if(nil == img) {
        NSString *imgPath = [NSString stringWithFormat:@"%@/%@", [mainBnd resourcePath], fileName];
        img = [UIImage imageWithContentsOfFile:imgPath];
    }
    
    return img;

}
-(UIImage*)cacheImage:(NSString*)fileName {
	if(nil == _memImgCache) {
		_memImgCache = [[NSMutableDictionary alloc] initWithCapacity:1];
	}
	UIImage *img = [_memImgCache objectForKey:fileName];
	
	if (nil == img)
	{
        
        if(self.bIsPad) {
			NSString *ext = [fileName pathExtension];
			NSString *bod = [fileName stringByDeletingPathExtension];
			NSString *sFName = [NSString stringWithFormat:@"%@-iPad.%@", bod, ext];
            img = [self resImageWithName:sFName];
        }
        
        if(nil == img) {
            // check iphone img
            img = [self resImageWithName:fileName];
        }
        
		if(nil != img) {
			[_memImgCache setObject:img forKey:fileName];
		}
	}
	return img;
}
- (UIImage*)cacheScretchableImage:(NSString*)fileName X:(float)x Y:(float)y {
	if(nil == _memImgCache) {
		_memImgCache = [[NSMutableDictionary alloc] initWithCapacity:1];
	}
	UIImage *img = [_memImgCache objectForKey:fileName];
	
	if (nil == img)
	{
        if(self.bIsPad) {
			NSString *ext = [fileName pathExtension];
			NSString *bod = [fileName stringByDeletingPathExtension];
			NSString *sFName = [NSString stringWithFormat:@"%@-iPad.%@", bod, ext];
            img = [self resImageWithName:sFName];
        }
        
        if(nil == img) {
            // check iphone img
            img = [self resImageWithName:fileName];
        }
        
		if(nil != img) {
            
            UIImage *imgC = [img stretchableImageWithLeftCapWidth:x topCapHeight:y];
			[_memImgCache setObject:imgC forKey:fileName];
            img = imgC;
		}
	}
	return img;
    
}


- (void)onReceiveMemoryWarning {
    [_memImgCache removeAllObjects];
}


@end
