//
//  DataManager.h
//  iMagazine
//
//  Created by Yang Jayce on 11-9-7.
//  Copyright 2011年 Achievo. All rights reserved.
//

#ifndef iMagazine_Constants_h
#define iMagazine_Constants_h

#define kDeviceModel      @"deviceModel"
#define kDeviceModelPad   @"iPad"
#define kDeviceModelPhone @"iPhone"
#define kDeviceModelPod   @"iPod touch"


#define kNormalTips       @"请稍后..."

#define kReadText       0

// Custom Debug flag
#define DEBUG   1

#if DEBUG
#define CLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define CLog(format, ...)
#endif

// Layout Constant
#define kContentFrameXOffset 25
#define kContentFrameYOffset 20
#define kContentBottomHeigh 46

// Main API
#define kServerURLAPI     @"http://10.50.0.146:9000/api."
#define kFetchLimit       10

// -------------JSON keys

#define kJSONData                    @"data"
#define kErrorCode                   @"errorcode"
#define kErrorCodeSuccess            0
#define kErrorCodeFailure            -1
#define kUserInfo                    @"myUserInfo"

// -------------Extra keys

#define kLoadingImageName            @"loadingImageName"
#define kArticleHeaderNameAll        @"全部"
#define kArticleHeaderNameUndefined  @"未定义"
#define kArticleCategoryIDAll        @"-1"
#define kArticleCategoryIDUndefined  @"-1987"

// -------------Public keys

#define kID                          @"id"
#define kName                        @"name"
#define kVersion                     @"version"
#define kLogoImageID                 @"logoImageId"
#define kScore                       @"score"
#define kOrder                       @"order"
#define kCount                       @"count"
#define kSettings                    @"setting"
#define kStatus                      @"status"
#define kFlag                        @"flag"
#define kImageData                   @"imageData"
#define kMarkedAsFavourites          @"markedAsFavourites"

#define kMagazine                    @"magazine"
#define kCategories                  @"categories"
#define kJournal                     @"journal"
#define kArticle                     @"article"
#define kArticleCategory             @"articleCategory"
#define kArticleCategoryServer       @"catetory"            //server's spelling errors
#define kArticleCategories           @"articleCategorys"    //server's spelling errors
// -------------Magazine

#define kMagazineID                  @"magazineID"

// -------------ArticleCategory

#define kArticleCategoryID           @"articleCategoryID"
#define kIntroduction                @"introduce"
#define kClientType                  @"clientType"

// -------------Hero
#define kHeroTavern @"heroTavern"
#define kHeroOrder @"heroOrder"

/*********Equipment*******/
#define kShopNumber @"shopNumber"
#define kEquipOrder @"equipOrder"
#define kEquipSN @"equipSN"
#define kMaterialSN @"materialSN"
#define kUpgradSN @"upgradSN"



#endif

