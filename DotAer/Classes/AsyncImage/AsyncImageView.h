//
//  AsyncImageView.M
//  Musiline
//
//  Created by fuacici on 10-5-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ImageManager.h"

@protocol AsyncImageViewGuestDelegate;

enum _EImageIndex
{
	kSCar66x44=0,
	
}EImageIndex;

@interface AsyncImageView : UIControl <NSFetchedResultsControllerDelegate,ImageLoaderDelegate>
{
	NSString *urlString; 
	int defaultImage;
	ImageManager * manager;
	UIImageView * imageView;
	int selectedRow;
	int selectedSection;
	BOOL isImage;	//判断是不是加载了除默认图以外的图
	BOOL autoImage;  //判断是不是根据图片本身的比例来展示。
    
    /*手势*/
    CGPoint tapLocation;         // Needed to record location of single tap, which will only be registered after delayed perform.
    BOOL multipleTouches;        // YES if a touch event contains more than one touch; reset when all fingers are lifted.
    BOOL twoFingerTapIsPossible; // Set to NO when 2-finger tap can be ruled out (e.g. 3rd finger down, fingers touch down too far apart, etc).
	
    
	int imageViewBorderWidth;
	UIColor * imageViewBorderColor;
	int imageViewCornerRadius;
	BOOL imageViewMasksToBounds;
}
@property (nonatomic, assign) id <AsyncImageViewGuestDelegate> delegate;
@property (nonatomic, retain) NSString *urlString;
@property (assign) int defaultImage;
@property (nonatomic,assign) ImageManager * manager;
@property (nonatomic,assign)int selectedRow;
@property (nonatomic,assign)int selectedSection;
@property int imageViewBorderWidth;
@property (nonatomic,retain) UIColor * imageViewBorderColor;
@property BOOL isImage;
@property BOOL autoImage;
@property 	int imageViewCornerRadius;
@property  BOOL imageViewMasksToBounds;

@property (nonatomic, retain) NSNumber *index; //属于哪一页


- (void)setImage:(UIImage*) _image;
- (UIImage*) image;

@end

@protocol AsyncImageViewGuestDelegate <NSObject>

@optional
- (void)imgDownload:(AsyncImageView *)sender img:(UIImage *)img ;

- (void)tapDetectingImageView:(AsyncImageView *)view gotSingleTapAtPoint:(CGPoint)tapPoint;
- (void)tapDetectingImageView:(AsyncImageView *)view gotDoubleTapAtPoint:(CGPoint)tapPoint;
- (void)tapDetectingImageView:(AsyncImageView *)view gotTwoFingerTapAtPoint:(CGPoint)tapPoint;

@end

