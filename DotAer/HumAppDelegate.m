//
//  HumAppDelegate.m
//  DotAer
//
//  Created by Kyle on 13-1-20.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumAppDelegate.h"
#import "Env.h"
#import "HumDotaDataMgr.h"
#import "iRate.h"
#import "iVersion.h"
#import "Reachability.h"
#import "HumDotaUserCenterOps.h"
#import "Downloader.h"
#import "HumDotaNetOps.h"
#import "News.h"


@interface HumAppDelegate()<EnvProtocol>{
    Reachability  *_hostReach;
}

@property (nonatomic, retain) Env *theEnv;
@property (nonatomic, retain) Downloader *downloader;

@end



@implementation HumAppDelegate

- (void)dealloc
{
    [_window release];
    [_managedObjectContext release];
    [_managedObjectModel release];
    [_persistentStoreCoordinator release];
    [self.downloader cancelAll];
    self.downloader = nil;
    self.theEnv = nil;
    self.viewController = nil;
    [super dealloc];
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize viewController;
@synthesize theEnv;
@synthesize downloader;


+ (void)initialize
{
    
    
	[iRate sharedInstance].onlyPromptIfLatestVersion = NO;
   
    
    //enable preview mode
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.theEnv = [[[Env alloc] init] autorelease];
    [iRate sharedInstance].appStoreID = [[Env sharedEnv].itunesAppId intValue];
    [iVersion sharedInstance].appStoreID = [[Env sharedEnv].itunesAppId intValue];
    
    self.downloader = [[[Downloader alloc] init] autorelease];
    self.downloader.bSearialLoad = YES;
    
    
    NSDictionary* payload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (payload)
    {
        [self startDownloadingDataFromProvider];
    }

    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  
    
    if (!self.theEnv.bIsPad) {
        HumDotaBaseViewController *ctl = [[HumDotaBaseViewController alloc] initWithNibName:nil bundle:nil];
        ctl.managedObjectContext = self.managedObjectContext;
        self.viewController = ctl;
        [ctl release];
    }else{
        HumPadDotaBaseViewController *ctl = [[HumPadDotaBaseViewController alloc] initWithNibName:nil bundle:nil];
        ctl.managedObjectContext = self.managedObjectContext;
        self.viewController = ctl;
        [ctl release];
    }
    
    
    self.window.rootViewController = self.viewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //register for push notificcations....
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    _hostReach = [[Reachability reachabilityWithHostName:@"www.baidu.com"] retain];
    [_hostReach startNotifier];
    

        
    application.applicationIconBadgeNumber = 0;
    
    return YES;
}


//data from provide
- (void)startDownloadingDataFromProvider{
    [HumDotaNetOps lastPushNotificationDownloader:self.downloader Target:self PkgFile:nil Sel:@selector(didFinishDownload:) Attached:nil];
}

- (void)sendProviderDeviceToken:(NSString *)token{
    [HumDotaNetOps uploadToken:token Downloader:self.downloader Target:self PkgFile:nil Sel:@selector(didFinishedPost:) Attached:nil];
}

#pragma mark 
#pragma mark download callback
- (void)didFinishDownload:(DownloaderCallbackObj *)cb{
    if(nil == cb) return;
    
    if(nil != cb.error || 200 != cb.httpStatus) {
		BqsLog(@"Error: len:%d, http%d, %@", [cb.rspData length], cb.httpStatus, cb.error);
        return;
	}
    NSArray *arry = [News parseXmlData:cb.rspData];
    if (!arry|| arry.count == 0) {
        BqsLog(@"!arry|| arry.count == 0");
        return;
    }
    News *news = [arry objectAtIndex:0];
    
    if (!self.theEnv.bIsPad) {
        HumDotaBaseViewController *ctl = (HumDotaBaseViewController *)self.viewController;
        [ctl pushNotificationNews:news];
        
    }else {
//        HumPadDotaBaseViewController *ctl =(HumPadDotaBaseViewController *)self.viewController;
       
    }

}


- (void)didFinishedPost:(DownloaderCallbackObj *)cb{
    if(nil == cb) return;
    
    if(nil != cb.error || 200 != cb.httpStatus) {
		BqsLog(@"Error: len:%d, http%d, %@", [cb.rspData length], cb.httpStatus, cb.error);
        return;
	}
}




//notification

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
   
    NSString *newString =  [[[deviceToken description]
                             stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                            stringByReplacingOccurrencesOfString:@" "
                            withString:@""];
    [self sendProviderDeviceToken:newString]; // custom method
     NSLog(@"devicetoken : %@",newString);
    
}


-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
     NSLog(@"didFailToRegisterForRemoteNotificationsWithError");
    
}


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError");
    
    NSLog(@"remote notification: %@",[userInfo description]);
    NSString* alertStr = nil;
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    NSObject *alert = [apsInfo objectForKey:@"alert"];
    if ([alert isKindOfClass:[NSString class]])
    {
        alertStr = (NSString*)alert;
    }
    else if ([alert isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* alertDict = (NSDictionary*)alert;
        alertStr = [alertDict objectForKey:@"body"];
    }
    application.applicationIconBadgeNumber = application.applicationIconBadgeNumber+[[apsInfo objectForKey:@"badge"] integerValue];
    if ([application applicationState] == UIApplicationStateActive && alertStr != nil)
    {
//        "button.cancle" = "取消";
//        "button.sure" = "确定";
       
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:alertStr delegate:self cancelButtonTitle:NSLocalizedString(@"button.sure", nil) otherButtonTitles:NSLocalizedString(@"button.cancle", nil),nil];
        [alertView show];
        [alertView release];
    }
    
}


//alter delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        [self startDownloadingDataFromProvider];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [HumDotaDataMgr instance]; //dataInit
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;

}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DotAer" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DotAer.sqlite"];
    
    // Put down default db if it doesn't already exist
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:[storeURL path]]) {
		NSString *defaultStorePath = [[NSBundle mainBundle]
									  pathForResource:@"DotAer" ofType:@"sqlite"];
		if ([fileManager fileExistsAtPath:defaultStorePath]) {
			[fileManager copyItemAtPath:defaultStorePath toPath:[storeURL path] error:NULL];
		}
	}
    
    // Data format transform option
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             NSFileProtectionCompleteUntilFirstUserAuthentication,NSFileProtectionKey,
                             nil];
    
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}


- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    [HumDotaUserCenterOps saveBoolVaule:TRUE forKye:kDftHaveNetWork];
    if (status == NotReachable) {
        [HumDotaUserCenterOps saveBoolVaule:FALSE forKye:kDftHaveNetWork];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"title.error.nonetwork", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"button.sure", nil) otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if(status == ReachableViaWiFi) {
        [HumDotaUserCenterOps saveBoolVaule:TRUE forKye:kDftNetTypeWifi];
    }else {
        [HumDotaUserCenterOps saveBoolVaule:FALSE forKye:kDftNetTypeWifi];
    }
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - for env
-(Env*)getEnv {
    return self.theEnv;
}

-(UIViewController*)getRootViewController {
    return self.viewController;
}





@end
