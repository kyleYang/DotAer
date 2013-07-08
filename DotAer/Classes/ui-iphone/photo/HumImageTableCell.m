//
//  HumImageTableCell.m
//  DotAer
//
//  Created by Kyle on 13-3-14.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumImageTableCell.h"
#import "Env.h"
#import "HumDotaDataMgr.h"

#define kOrgX 13
#define kOrgY 5

#define kGapW 14
#define kWdith 140

#define kMptImageCell_ItemPaddingHori 5
#define kMPtImageCell_itemWidth 103
#define kMptImageCell_ItemGap 0

#define kDownMask_H 23


@interface HumDotaImage_ItemView()


@end

@implementation HumDotaImage_ItemView
@synthesize imageItem = _imageItem;
@synthesize icon = _icon;
@synthesize delegate = _delegate;
@synthesize favButton;

- (void)dealloc{
    [_imageItem release];
    self.icon = nil;
    self.delegate = nil;
    self.favButton = nil;
    [super dealloc];
    
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
               
        UIImageView *bg  = [[UIImageView alloc] initWithFrame:self.bounds];
        bg.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        bg.image = [[Env sharedEnv] cacheScretchableImage:@"image_Cell_bg.png" X:15 Y:15];
        [self addSubview:bg];
        [bg release];
        
        self.icon = [[[HumWebImageView alloc] initWithFrame:CGRectMake(8, kMptImageCell_iconPaddingVert, CGRectGetWidth(self.bounds)-15, kMptImageCell_iconHeith)] autorelease];
        self.icon.style = HUMWebImageStyleTopCentre;
        self.icon.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:self.icon];
        
        UIButton *play = [[UIButton alloc] initWithFrame:self.icon.bounds];
        [self.icon addSubview:play];
//        [play setBackgroundImage:[[Env sharedEnv] cacheImage:@"video_play_mask.png"] forState:UIControlStateNormal];
        [play addTarget:self action:@selector(palyImage:) forControlEvents:UIControlEventTouchUpInside];
        [play release];
        
        UIImageView *iconMask = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.icon.frame)-kDownMask_H, CGRectGetWidth(self.icon.frame), kDownMask_H)];
        iconMask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
        iconMask.userInteractionEnabled = YES;
        [self.icon addSubview:iconMask];
        [iconMask release];
        

        self.favButton = [[[UIButton alloc] initWithFrame:CGRectMake(5+5, 2, 22, 20)] autorelease];
        [iconMask addSubview:self.favButton];
        [self.favButton addTarget:self action:@selector(addFavVideo:) forControlEvents:UIControlEventTouchUpInside];
        [favButton setBackgroundImage:[[Env sharedEnv] cacheImage:@"video_addFav.png"] forState:UIControlStateNormal];
        [favButton setBackgroundImage:[[Env sharedEnv] cacheImage:@"video_addFav_did.png"] forState:UIControlStateSelected];
        
        
    }
    
    return self;
}

- (void)setImageItem:(Photo *)imageItem{
    if (_imageItem == imageItem) return;
    [_imageItem release];
    _imageItem = [imageItem retain];
    
    self.icon.imageView.image = [[Env sharedEnv] cacheImage:@"content_cell_dft.png"];
    self.icon.imgUrl = _imageItem.imageUrl;
    
    self.favButton.selected = [[HumDotaDataMgr instance] judgeFavImage:_imageItem];
}




#pragma mark
#pragma mark MptWebImageDelegate

- (void)palyImage:(id)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(humImageItemCell:didPlayImage:)]) {
        [self.delegate humImageItemCell:self didPlayImage:_imageItem];
    }
    
}

- (void)addFavVideo:(id)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(humImageItemCell:addFavImage:)]) {
        BOOL value = [self.delegate humImageItemCell:self addFavImage:_imageItem];
        if (value) {
            self.favButton.selected = !self.favButton.selected;
        }
    }
    
}



@end

@interface HumImageTableCell()<HumDotaImage_ItemView_delegate>{
@private
    NSArray *_arrItems;
    NSInteger _columnCnt;
    NSInteger _rowId;
    NSMutableArray *_columnViews;
    
}


@property (nonatomic, retain) NSArray *arrItems;
@property (nonatomic, assign) NSInteger columnCnt;
@property (nonatomic, assign) NSInteger rowId;
@property (nonatomic, retain) NSMutableArray *columnViews;

@end

@implementation HumImageTableCell
@synthesize delegate;

@synthesize arrItems = _arrItems;
@synthesize columnCnt = _columnCnt;
@synthesize rowId = _rowId;
@synthesize columnViews = _columnViews;


- (void)dealloc{
    self.delegate = nil;
    [_arrItems release];
    [_columnViews release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
          self.columnViews  = [NSMutableArray arrayWithCapacity:2];      
        
    }
    return self;
}



-(void)layoutSubviews {
    [super layoutSubviews];
    
    float w = CGRectGetWidth(self.bounds);
    
    // check column cnt
    int nColumnCnt = [HumImageTableCell columnCntForWidth:w];
    if(nColumnCnt == self.columnCnt) return;
    
    self.columnCnt = nColumnCnt;
    
    // create new view
    int pos = _rowId * nColumnCnt;
    int cnt = [self.arrItems count] - pos;
    cnt = MAX(0, MIN(cnt, nColumnCnt));
    
    int vcnt = [self.columnViews count];
    for(; vcnt > cnt; vcnt --) {
        UIView *v = [self.columnViews lastObject];
        [v removeFromSuperview];
        [self.columnViews removeLastObject];
    }
    for(; vcnt < cnt; vcnt ++) {
        HumDotaImage_ItemView *v = [[HumDotaImage_ItemView alloc] initWithFrame:CGRectMake(0, 0, kMPtImageCell_itemWidth, kMptImageCell_Heigh)];
        v.backgroundColor = [UIColor clearColor];
        [self.columnViews addObject:v];
        [v release];
    }
    
    // assign view content
    for(HumDotaImage_ItemView *v in self.columnViews) {
        v.imageItem =  [self.arrItems objectAtIndex:pos];
        v.delegate = self;
        pos ++;
    }
    
    // position subviews
    int x = kMptImageCell_ItemPaddingHori;
    int y = CGRectGetMidY(self.bounds);
    int gap = kMptImageCell_ItemGap;
    
    float contentW = CGRectGetWidth(self.bounds) - 2 * kMptImageCell_ItemPaddingHori;
    if(nColumnCnt > 1) {
        // adjust gap
        float totalW = kMPtImageCell_itemWidth * nColumnCnt + kMptImageCell_ItemGap * (nColumnCnt - 1);
        
        if(totalW < contentW) {
            float d = (contentW - totalW) / (2*nColumnCnt - 1);
            gap += floor(2*d);
            x += floor(d);
        }
    } else {
        // center book
        float totalW = kMPtImageCell_itemWidth * nColumnCnt;
        if(totalW < contentW) {
            float d = floor((contentW - totalW) / 2.0);
            x += d;
        }
    }
    
    for(HumDotaImage_ItemView *v in self.columnViews) {
        v.center = CGPointMake(x + CGRectGetWidth(v.frame)/2, y);
        x += kMPtImageCell_itemWidth + gap;
        if(![self.subviews containsObject:v]) {
            [self addSubview:v];
        }
    }
}


-(void)setItemArr:(NSArray*)arr Row:(NSInteger)rowid {
    self.arrItems = arr;
    self.rowId = rowid;
    self.columnCnt = 0; // trigger re-set book
    
    [self setNeedsLayout];
}

-(NSArray*)getItemViews {
    return self.columnViews;
}




#pragma mark
#pragma mark calculate
+(int)rowCntForItemCnt:(int)itemCnt ColumnCnt:(int)columnCnt { //caculator number of row for columncnt
    if(columnCnt <= 0) return 0;
    
    int rowCnt = itemCnt / columnCnt;
    if(rowCnt * columnCnt < itemCnt) rowCnt ++;
    
    return rowCnt;
}


+(int)columnCntForWidth:(float)tableWidth {
    float w = tableWidth - 2 * kMptImageCell_ItemPaddingHori;
    int cnt = w / (kMPtImageCell_itemWidth + kMptImageCell_ItemGap);
    
    int left = w - cnt * (kMPtImageCell_itemWidth + kMptImageCell_ItemGap);
    if(left >= kMPtImageCell_itemWidth) cnt ++;
    
    return cnt;
}

+(int)rowIdForIndex:(int)idx ColumnCnt:(int)columnCnt {
    if(columnCnt <= 0) return -1;
    
    int row = idx / columnCnt;
    
    return row;
}


- (void)humImageItemCell:(HumDotaImage_ItemView *)cell didPlayImage:(Photo *)photo{
    BqsLog(@"humImageCell didPlayImage:%@",photo);
    if (self.delegate && [self.delegate respondsToSelector:@selector(humItemCell:didPlayImage:) ]) {
        [self.delegate humItemCell:self didPlayImage:photo];
    }
    
}
- (BOOL)humImageItemCell:(HumDotaImage_ItemView *)cell addFavImage:(Photo *)photo{
     BqsLog(@"humImageCell didPlayImage:%@",photo);
    if (self.delegate && [self.delegate respondsToSelector:@selector(humItemCell:addFavImage:) ]) {
       return [self.delegate humItemCell:self addFavImage:photo];
    }
    
    return FALSE;
}

@end
