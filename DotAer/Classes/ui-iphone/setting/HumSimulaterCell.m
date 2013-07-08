//
//  HumSimulaterCell.m
//  DotAer
//
//  Created by Kyle on 13-6-5.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumSimulaterCell.h"
#import "Env.h"
#import "BqsUtils.h"
#import "DSItemImag.h"
#import "HeroInfo.h"
#import "EquipInfo.h"
#import "Equipment.h"

#define kSimuCell_ItemPaddingHori 5
#define kSimuCell_ItemGap 5

#define kItemWidth 60
#define kItemHeigh 60

@interface HumSimulaterCell(){
    
@private
    NSArray *_arrHeroItems;
    NSArray *_arrEquipItems;
    NSInteger _columnCnt;
    NSInteger _rowId;
    NSMutableArray *_columnViews;
    
}

@property (nonatomic, retain) NSArray *arrHeroItems;
@property (nonatomic, retain) NSArray *arrEquipItems;
@property (nonatomic, assign) NSInteger columnCnt;
@property (nonatomic, assign) NSInteger rowId;
@property (nonatomic, retain) NSMutableArray *columnViews;

@end

@implementation HumSimulaterCell
@synthesize arrHeroItems = _arrHeroItems;
@synthesize arrEquipItems = _arrEquipItems;
@synthesize columnCnt = _columnCnt;
@synthesize rowId = _rowId;
@synthesize columnViews = _columnViews;
@synthesize delegate;


- (void)dealloc{
    self.columnViews = nil;
    self.arrHeroItems = nil;
    self.arrEquipItems = nil;
    [super dealloc];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
         self.columnViews = [NSMutableArray arrayWithCapacity:4];
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}





-(void)layoutSubviews {
    [super layoutSubviews];
    
    float w = CGRectGetWidth(self.bounds);
    
    // check column cnt
    int nColumnCnt = [HumSimulaterCell columnCntForWidth:w];
    if(nColumnCnt == self.columnCnt) return;
    
    self.columnCnt = nColumnCnt;
    
    // create new view
    int pos = _rowId * nColumnCnt;
    int cnt = 0 ;
    if (self.arrHeroItems) {
       cnt = [self.arrHeroItems count] - pos;
    }else if(self.arrEquipItems){
        cnt = [self.arrEquipItems count] - pos;
    }
    
    cnt = MAX(0, MIN(cnt, nColumnCnt));
    
    int vcnt = [self.columnViews count];
    for(; vcnt > cnt; vcnt --) {
        UIView *v = [self.columnViews lastObject];
        [v removeFromSuperview];
        [self.columnViews removeLastObject];
    }
    for(; vcnt < cnt; vcnt ++) {
        DSItemImag *v = [[DSItemImag alloc] initWithFrame:CGRectMake(0, 0, kItemWidth, kItemHeigh)];
        [v addTarget:self action:@selector(itemRemove:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:v];
        v.backgroundColor = [UIColor clearColor];
        [self.columnViews addObject:v];
        [v release];
    }
    
    // assign view content
    for(DSItemImag *v in self.columnViews) {
        if (self.arrHeroItems) {
            HeroInfo *heroInfo = [self.arrHeroItems objectAtIndex:pos];
            v.hero = heroInfo;
        }else if(self.arrEquipItems){
            Equipment *quipInfo = [self.arrEquipItems objectAtIndex:pos];
            v.equip = quipInfo;
        }
        
        pos ++;
    }
    
    // position subviews
    int x = kSimuCell_ItemPaddingHori;
    int y = CGRectGetMidY(self.bounds);
    int gap = kSimuCell_ItemGap;
    
    float contentW = CGRectGetWidth(self.bounds) - 2 * kSimuCell_ItemPaddingHori;
    if(nColumnCnt > 1) {
        // adjust gap
        float totalW = kItemWidth * nColumnCnt + kSimuCell_ItemGap * (nColumnCnt - 1);
        
        if(totalW < contentW) {
            float d = (contentW - totalW) / (2*nColumnCnt - 1);
            gap += floor(2*d);
            x += floor(d);
        }
    } else {
        // center book
        float totalW = kItemWidth * nColumnCnt;
        if(totalW < contentW) {
            float d = floor((contentW - totalW) / 2.0);
            x += d;
        }
    }
    
    for(DSItemImag *v in self.columnViews) {
        v.center = CGPointMake(x + CGRectGetWidth(v.frame)/2, y);
        x += kItemWidth + gap;
        if(![self.subviews containsObject:v]) {
            [self addSubview:v];
        }
    }
}

- (void)setHeroArr:(NSArray *)arr Row:(NSInteger)rowid{
    self.arrHeroItems = arr;
    self.arrEquipItems = nil;
    self.rowId = rowid;
    self.columnCnt = 0; // trigger re-set book
    
    [self setNeedsLayout];

}

- (void)setEquipArr:(NSArray *)arr Row:(NSInteger)rowid{
    self.arrHeroItems = nil;
    self.arrEquipItems = arr;
    self.rowId = rowid;
    self.columnCnt = 0; // trigger re-set book
    
    [self setNeedsLayout];

}


-(NSArray*)getItemViews {
    return self.columnViews;
}


#pragma mark
#pragma mark MptRecommon_ItemView_delegate

- (void)itemRemove:(id)sender{
    DSItemImag *item = (DSItemImag *)sender;
    if (item.hero) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(humSimulateCell:didSelectHero:)]) {
            [self.delegate humSimulateCell:self didSelectHero:item.hero];
        }
    }else if(item.equip){
        if (self.delegate && [self.delegate respondsToSelector:@selector(humSimulateCell:didSelectEquip:)]) {
            [self.delegate humSimulateCell:self didSelectEquip:item.equip];
        }
    }
    

}

//- (void)mptRecommonItemViewDidTap:(MptRecommon_ItemView *)item{
//    BqsLog(@"mptRecommonItemViewDidTap");
//    if (self.delegate && [self.delegate respondsToSelector:@selector(mptRecommonCell:DidClickItem:)]) {
//        [self.delegate mptRecommonCell:self DidClickItem:item];
//    }
//    
//}


#pragma mark
#pragma mark calculate
+(int)rowCntForItemCnt:(int)itemCnt ColumnCnt:(int)columnCnt { //caculator number of row for columncnt
    if(columnCnt <= 0) return 0;
    
    int rowCnt = itemCnt / columnCnt;
    if(rowCnt * columnCnt < itemCnt) rowCnt ++;
    
    return rowCnt;
}


+(int)columnCntForWidth:(float)tableWidth {
    return 4;
}

+(int)rowIdForIndex:(int)idx ColumnCnt:(int)columnCnt {
    if(columnCnt <= 0) return -1;
    
    int row = idx / columnCnt;
    
    return row;
}



@end
