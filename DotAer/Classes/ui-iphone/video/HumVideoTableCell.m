//
//  HumVideoTableCell.m
//  DotAer
//
//  Created by Kyle on 13-3-9.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumVideoTableCell.h"
#import "Env.h"
#import "HumDotaDataMgr.h"

#define kTitleColor [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]
#define kTimeColor [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]
#define kTypeColor [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]

#define kMptRcommonCell_ItemPaddingHori 8
#define kMPtRecommonCell_itemWidth 145
#define kMptRecommonCell_Heigh 130
#define kMptRcommonCell_ItemGap 5

#define kDownMask_H 23


#define kMptRecommoCell_iconnameGap 5


@interface HumDotaVideo_ItemView()


@end


@implementation HumDotaVideo_ItemView

@synthesize videoItem = _videoItem;
@synthesize icon = _icon;
@synthesize name = _name;
@synthesize delegate = _delegate;
@synthesize timeLab;
@synthesize downButton;
@synthesize favButton;

- (void)dealloc{
    self.videoItem = nil;
    self.icon = nil;
    self.name = nil;
    self.delegate = nil;
    self.timeLab = nil;
    self.downButton = nil;
    self.timeLab = nil;
    [super dealloc];
    
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _bIsHot = NO;
        _bIsLive = NO;
        _bIsNew = NO;
        
        UIImageView *bg  = [[UIImageView alloc] initWithFrame:self.bounds];
        bg.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        bg.image = [[Env sharedEnv] cacheScretchableImage:@"video_cell_itembg.png" X:15 Y:15];
        [self addSubview:bg];
        [bg release];
        
        self.icon = [[[HumWebImageView alloc] initWithFrame:CGRectMake(5, kMptRecommoCell_iconPaddingVert, CGRectGetWidth(self.bounds)-10, kMptRcommonCell_iconHeith)] autorelease];
        self.icon.style = HUMWebImageStyleTopCentre;
        self.icon.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:self.icon];
        
        UIButton *play = [[UIButton alloc] initWithFrame:self.icon.bounds];
        [self.icon addSubview:play];
        [play setBackgroundImage:[[Env sharedEnv] cacheImage:@"video_play_mask.png"] forState:UIControlStateNormal];
        [play setBackgroundImage:[[Env sharedEnv] cacheImage:@"video_play_mask_down.png"] forState:UIControlEventTouchDown];
        [play addTarget:self action:@selector(palyVideo:) forControlEvents:UIControlEventTouchUpInside];
        [play release];
        
        UIImageView *iconMask = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.icon.frame)-kDownMask_H, CGRectGetWidth(self.icon.frame), kDownMask_H)];
        iconMask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
        iconMask.userInteractionEnabled = YES;
        [self.icon addSubview:iconMask];
        [iconMask release];
        
        self.timeLab = [[[UILabel alloc] initWithFrame:CGRectMake(2, 0,75, CGRectGetHeight(iconMask.frame))] autorelease];
        self.timeLab.font = [UIFont systemFontOfSize:13.0f];
        self.timeLab.textAlignment = UITextAlignmentLeft;
        self.timeLab.lineBreakMode = NSLineBreakByCharWrapping;
        self.timeLab.backgroundColor = [UIColor clearColor];
        self.timeLab.textColor = [UIColor whiteColor];
        [iconMask addSubview:self.timeLab];
        
        self.favButton = [[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.timeLab.frame)+5, 2, 22, 20)] autorelease];
        [iconMask addSubview:self.favButton];
        [self.favButton addTarget:self action:@selector(addFavVideo:) forControlEvents:UIControlEventTouchUpInside];
        [favButton setBackgroundImage:[[Env sharedEnv] cacheImage:@"video_addFav.png"] forState:UIControlStateNormal];
        [favButton setBackgroundImage:[[Env sharedEnv] cacheImage:@"video_addFav_did.png"] forState:UIControlStateSelected];
        
        
        self.downButton = [[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.favButton.frame)+5, 2, 24, 20)] autorelease];
        [self.downButton addTarget:self action:@selector(downVideo:) forControlEvents:UIControlEventTouchUpInside];
        [iconMask addSubview:self.downButton];
        [self.downButton setBackgroundImage:[[Env sharedEnv] cacheImage:@"video_download.png"] forState:UIControlStateNormal];
        [self.downButton setBackgroundImage:[[Env sharedEnv] cacheImage:@"video_download_down.png"] forState:UIControlEventTouchDown];
        
        
        self.name = [[[UILabel alloc] initWithFrame:CGRectMake(2, CGRectGetMaxY(self.icon.frame)+kMptRecommoCell_iconnameGap, CGRectGetWidth(self.bounds)-4, kMptRecommnCell_nameHeigh)] autorelease];
        self.name.numberOfLines = 0;
        self.name.font = [UIFont systemFontOfSize:13.0f];
        self.name.textAlignment = UITextAlignmentCenter;
        self.name.backgroundColor = [UIColor clearColor];
//        self.name.textColor = [UIColor whiteColor];
        [self addSubview:self.name];
        
    }
    
    return self;
}

- (void)setVideoItem:(Video *)videoItem{
    if (_videoItem == videoItem) return;
    [_videoItem release];
    _videoItem = [videoItem retain];
    
    self.icon.imageView.image = [[Env sharedEnv] cacheImage:@"content_cell_dft.png"];
    
    self.icon.imgUrl = _videoItem.imageUrl;
    self.name.text = _videoItem.title;
    
    self.timeLab.text = _videoItem.time;
    
    self.favButton.selected = [[HumDotaDataMgr instance] judgeFavVideo:_videoItem];
}




#pragma mark
#pragma mark MptWebImageDelegate

- (void)palyVideo:(id)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(humVideoCell:didPlayVideo:)]) {
        [self.delegate humVideoCell:self didPlayVideo:_videoItem];
    }
    
}

- (void)addFavVideo:(id)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(humVideoCell:addFavVideo:)]) {
       BOOL value  =  [self.delegate humVideoCell:self addFavVideo:_videoItem];
        if (value) {
            self.favButton.selected = !self.favButton.selected;
        }
    }
    
}

- (void)downVideo:(id)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(humVideoCell:downloadVideo:)]) {
        [self.delegate humVideoCell:self downloadVideo:_videoItem];
    }
    
}



@end



@interface HumVideoTableCell()<HumDotaVideo_ItemView_delegate>{
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

@implementation HumVideoTableCell

@synthesize arrItems = _arrItems;
@synthesize columnCnt = _columnCnt;
@synthesize rowId = _rowId;
@synthesize columnViews = _columnViews;

- (void)dealloc{
    [_arrItems release];
    [_columnViews release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        UIImageView *bg  = [[UIImageView alloc] initWithFrame:self.bounds];
//        bg.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//        bg.image = [[Env sharedEnv] cacheScretchableImage:@"video_cell_background.png" X:15 Y:5];
//        [self addSubview:bg];
//        [bg release];

        
        self.columnViews  = [NSMutableArray arrayWithCapacity:2];
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
    float w = CGRectGetWidth(self.bounds);
    
    // check column cnt
    int nColumnCnt = [HumVideoTableCell columnCntForWidth:w];
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
        HumDotaVideo_ItemView *v = [[HumDotaVideo_ItemView alloc] initWithFrame:CGRectMake(0, 0, kMPtRecommonCell_itemWidth, kMptRecommonCell_Heigh)];
        v.backgroundColor = [UIColor clearColor];
        [self.columnViews addObject:v];
        [v release];
    }
    
    // assign view content
    for(HumDotaVideo_ItemView *v in self.columnViews) {
        v.videoItem =  [self.arrItems objectAtIndex:pos];
        v.delegate = self;
        pos ++;
    }
    
    // position subviews
    int x = kMptRcommonCell_ItemPaddingHori;
    int y = CGRectGetMidY(self.bounds);
    int gap = kMptRcommonCell_ItemGap;
    
    float contentW = CGRectGetWidth(self.bounds) - 2 * kMptRcommonCell_ItemPaddingHori;
    if(nColumnCnt > 1) {
        // adjust gap
        float totalW = kMPtRecommonCell_itemWidth * nColumnCnt + kMptRcommonCell_ItemGap * (nColumnCnt - 1);
        
        if(totalW < contentW) {
            float d = (contentW - totalW) / (2*nColumnCnt - 1);
            gap += floor(2*d);
            x += floor(d);
        }
    } else {
        // center book
        float totalW = kMPtRecommonCell_itemWidth * nColumnCnt;
        if(totalW < contentW) {
            float d = floor((contentW - totalW) / 2.0);
            x += d;
        }
    }
    
    for(HumDotaVideo_ItemView *v in self.columnViews) {
        v.center = CGPointMake(x + CGRectGetWidth(v.frame)/2, y);
        x += kMPtRecommonCell_itemWidth + gap;
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
    float w = tableWidth - 2 * kMptRcommonCell_ItemPaddingHori;
    int cnt = w / (kMPtRecommonCell_itemWidth + kMptRcommonCell_ItemGap);
    
    int left = w - cnt * (kMPtRecommonCell_itemWidth + kMptRcommonCell_ItemGap);
    if(left >= kMPtRecommonCell_itemWidth) cnt ++;
    
    return cnt;
}

+(int)rowIdForIndex:(int)idx ColumnCnt:(int)columnCnt {
    if(columnCnt <= 0) return -1;
    
    int row = idx / columnCnt;
    
    return row;
}


#pragma mark
#pragma mark  HumDotaVideo_ItemView_delegate

- (void)humVideoCell:(HumDotaVideo_ItemView *)cell didPlayVideo:(Video *)video{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(humVideoCell:didPlayVideo:)]) {
        [self.delegate humVideoCell:self didPlayVideo:video];
    }
    
}
- (void)humVideoCell:(HumDotaVideo_ItemView *)cell downloadVideo:(Video *)video{
    if (self.delegate && [self.delegate respondsToSelector:@selector(humVideoCell:downloadVideo:)]) {
        [self.delegate humVideoCell:self downloadVideo:video];
    }
}
- (BOOL)humVideoCell:(HumDotaVideo_ItemView *)cell addFavVideo:(Video *)video{
    if (self.delegate && [self.delegate respondsToSelector:@selector(humVideoCell:addFavVideo:)]) {
       return  [self.delegate humVideoCell:self addFavVideo:video];
    }
    return FALSE;
}

@end
