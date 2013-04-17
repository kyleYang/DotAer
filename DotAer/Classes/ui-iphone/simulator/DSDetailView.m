//
//  DSDetailView.m
//  CoreDataSqlite
//
//  Created by Kyle on 12-9-14.
//  Copyright (c) 2012年 Kyle. All rights reserved.
//

#import "DSDetailView.h"
#import "Env.h"
#define kItemGap 5

@interface DSDetailView (){
    
}
@property (nonatomic, retain) NSMutableArray *itemArrary;
@end

@implementation DSDetailView
@synthesize item11,item12,item13,item14;
@synthesize item21,item22,item23,item24;
@synthesize item31,item32,item33,item34;
@synthesize delegate;
@synthesize itemArrary;

- (void)dealloc
{
    self.item11 = nil;self.item12 = nil;self.item13 = nil;self.item13 = nil;
    self.item21 = nil;self.item22 = nil;self.item23 = nil;self.item24 = nil;
    self.item31 = nil;self.item32 = nil;self.item33 = nil;self.item34 = nil;
    self.delegate = nil;
    self.itemArrary = nil;
    [_dataAry release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if(self){
        self.itemArrary = [NSMutableArray arrayWithCapacity:1];
        self.item11 = [[[DSItemImag alloc] init] autorelease];
        [self.item11 addTarget:self action:@selector(itemSelct:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.item11];
        
        self.item12 = [[[DSItemImag alloc] init] autorelease];
        [self.item12 addTarget:self action:@selector(itemSelct:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.item12];
        
        self.item13 = [[[DSItemImag alloc] init] autorelease];
        [self.item13 addTarget:self action:@selector(itemSelct:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.item13];
        
        self.item14 = [[[DSItemImag alloc] init] autorelease];
        [self.item14 addTarget:self action:@selector(itemSelct:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.item14];
        
        
        /**********************************/
        
        self.item21 = [[[DSItemImag alloc] init] autorelease];
        [self.item21 addTarget:self action:@selector(itemSelct:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.item21];
        
        self.item22 = [[[DSItemImag alloc] init] autorelease];
        [self.item22 addTarget:self action:@selector(itemSelct:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.item22];
        
        self.item23 = [[[DSItemImag alloc] init] autorelease];
        [self.item23 addTarget:self action:@selector(itemSelct:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.item23];
        
        self.item24 = [[[DSItemImag alloc] init] autorelease];
        [self.item24 addTarget:self action:@selector(itemSelct:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.item24];
        
        /**********************************/
        
        
        self.item31 = [[[DSItemImag alloc] init] autorelease];
        [self.item31 addTarget:self action:@selector(itemSelct:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.item31];
        
        self.item32 = [[[DSItemImag alloc] init] autorelease];
        [self.item32 addTarget:self action:@selector(itemSelct:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.item32];
        
        self.item33 = [[[DSItemImag alloc] init] autorelease];
        [self.item33 addTarget:self action:@selector(itemSelct:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.item33];
        
        self.item34 = [[[DSItemImag alloc] init] autorelease];
        [self.item34 addTarget:self action:@selector(itemSelct:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.item34];
        
        [self.itemArrary addObject:self.item11];
        [self.itemArrary addObject:self.item12];
        [self.itemArrary addObject:self.item13];
        [self.itemArrary addObject:self.item14];
        
        [self.itemArrary addObject:self.item21];
        [self.itemArrary addObject:self.item22];
        [self.itemArrary addObject:self.item23];
        [self.itemArrary addObject:self.item24];
        
        [self.itemArrary addObject:self.item31];
        [self.itemArrary addObject:self.item32];
        [self.itemArrary addObject:self.item33];
        [self.itemArrary addObject:self.item34];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:self.bounds];
        image.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        image.image = [[Env sharedEnv] cacheImage:@"doto_detail.png"];
        [self addSubview:image];
        [image release];
        
        self.itemArrary = [NSMutableArray arrayWithCapacity:1];
        float width = CGRectGetWidth(frame)/4 - 2*kItemGap;
        float height = CGRectGetHeight(frame)/3 - 2*kItemGap;
        
        self.item11 = [[[DSItemImag alloc] initWithFrame:CGRectMake(kItemGap, kItemGap, width, height)] autorelease];
        [self.item11 addTarget:self action:@selector(itemSelct:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.item11];
        
        self.item12 = [[[DSItemImag alloc] initWithFrame:CGRectMake(self.item11.frame.origin.x+ self.item11.frame.size.width+2*kItemGap, self.item11.frame.origin.y, width, height)] autorelease];
        [self.item12 addTarget:self action:@selector(itemSelct:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.item12];
        
        self.item13 = [[[DSItemImag alloc] initWithFrame:CGRectMake(self.item12.frame.origin.x+self.item12.frame.size.width+2* kItemGap, self.item11.frame.origin.y, width, height)] autorelease];
        [self.item13 addTarget:self action:@selector(itemSelct:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.item13];
        
        self.item14 = [[[DSItemImag alloc] initWithFrame:CGRectMake(self.item13.frame.origin.x+self.item13.frame.size.width+2* kItemGap, self.item11.frame.origin.y, width, height)] autorelease];
        [self.item14 addTarget:self action:@selector(itemSelct:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.item14];
        
        
        /**********************************/
        
        self.item21 = [[[DSItemImag alloc] initWithFrame:CGRectMake(self.item11.frame.origin.x, self.item11.frame.origin.y+self.item12.frame.size.height+2*kItemGap, width, height)] autorelease];
        [self.item21 addTarget:self action:@selector(itemSelct:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.item21];
        
        self.item22 = [[[DSItemImag alloc] initWithFrame:CGRectMake(self.item21.frame.origin.x+ self.item21.frame.size.width+2*kItemGap, self.item21.frame.origin.y, width, height)] autorelease];
        [self.item22 addTarget:self action:@selector(itemSelct:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.item22];
        
        self.item23 = [[[DSItemImag alloc] initWithFrame:CGRectMake(self.item22.frame.origin.x+ self.item22.frame.size.width+2*kItemGap, self.item21.frame.origin.y, width, height)] autorelease];
        [self.item23 addTarget:self action:@selector(itemSelct:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.item23];
        
        self.item24 = [[[DSItemImag alloc] initWithFrame:CGRectMake(self.item23.frame.origin.x+ self.item23.frame.size.width+2*kItemGap, self.item21.frame.origin.y, width, height)] autorelease];
        [self.item24 addTarget:self action:@selector(itemSelct:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.item24];
        
        /**********************************/
        
        
        self.item31 = [[[DSItemImag alloc] initWithFrame:CGRectMake(self.item11.frame.origin.x, self.item21.frame.origin.y+self.item21.frame.size.height+2*kItemGap, width, height)] autorelease];
        [self.item31 addTarget:self action:@selector(itemSelct:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.item31];
        
        self.item32 = [[[DSItemImag alloc] initWithFrame:CGRectMake(self.item31.frame.origin.x+ self.item31.frame.size.width+2*kItemGap, self.item31.frame.origin.y, width, height)] autorelease];
        [self.item32 addTarget:self action:@selector(itemSelct:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.item32];
        
        self.item33 = [[[DSItemImag alloc] initWithFrame:CGRectMake(self.item32.frame.origin.x+ self.item32.frame.size.width+2*kItemGap, self.item31.frame.origin.y, width, height)] autorelease];
        [self.item33 addTarget:self action:@selector(itemSelct:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.item33];
        
        self.item34 = [[[DSItemImag alloc] initWithFrame:CGRectMake(self.item33.frame.origin.x+ self.item33.frame.size.width+2*kItemGap, self.item31.frame.origin.y, width, height)] autorelease];
        [self.item34 addTarget:self action:@selector(itemSelct:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.item34];

        
        [self.itemArrary addObject:self.item11];
        [self.itemArrary addObject:self.item12];
        [self.itemArrary addObject:self.item13];
        [self.itemArrary addObject:self.item14];
        
        [self.itemArrary addObject:self.item21];
        [self.itemArrary addObject:self.item22];
        [self.itemArrary addObject:self.item23];
        [self.itemArrary addObject:self.item24];
        
        [self.itemArrary addObject:self.item31];
        [self.itemArrary addObject:self.item32];
        [self.itemArrary addObject:self.item33];
        [self.itemArrary addObject:self.item34];

        
        
    }
    return self;
}

- (void)layoutSubviews
{
//    float width = CGRectGetWidth(self.frame)/4 - 2*kItemGap;
//    float height = CGRectGetHeight(self.frame)/3 - 2*kItemGap;
//    self.item11.frame = CGRectMake(kItemGap, kItemGap, width, height);
//    self.item12.frame = CGRectMake(CGRectGetMaxX(self.item11.frame)+2* kItemGap, CGRectGetMinY(self.item11.frame), width, height);
//    self.item13.frame = CGRectMake(CGRectGetMaxX(self.item12.frame)+2* kItemGap, CGRectGetMinY(self.item11.frame), width, height);
//    self.item14.frame = CGRectMake(CGRectGetMaxX(self.item13.frame)+2* kItemGap, CGRectGetMinY(self.item11.frame), width, height);
//       
//    /**********************************/
//    
//    self.item21.frame = CGRectMake(CGRectGetMinX(self.item11.frame), CGRectGetMaxY(self.item11.frame)+2*kItemGap, width, height);
//    self.item22.frame = CGRectMake(CGRectGetMaxX(self.item21.frame)+2* kItemGap, CGRectGetMinY(self.item21.frame), width, height);
//    self.item23.frame = CGRectMake(CGRectGetMaxX(self.item22.frame)+2* kItemGap, CGRectGetMinY(self.item21.frame), width, height);
//    self.item24.frame = CGRectMake(CGRectGetMaxX(self.item23.frame)+2* kItemGap, CGRectGetMinY(self.item21.frame), width, height);
//    
//    /**********************************/
//    
//    self.item21.frame = CGRectMake(CGRectGetMinX(self.item11.frame), CGRectGetMaxY(self.item21.frame)+2*kItemGap, width, height);
//    self.item22.frame = CGRectMake(CGRectGetMaxX(self.item31.frame)+2* kItemGap, CGRectGetMinY(self.item31.frame), width, height);
//    self.item23.frame = CGRectMake(CGRectGetMaxX(self.item32.frame)+2* kItemGap, CGRectGetMinY(self.item31.frame), width, height);
//    self.item24.frame = CGRectMake(CGRectGetMaxX(self.item33.frame)+2* kItemGap, CGRectGetMinY(self.item31.frame), width, height);
//    
}

- (void)setHeroArray:(NSMutableArray *)ary
{
    [_dataAry release];
    _dataAry = [ary retain];
    NSUInteger index = 0;
    for(HeroInfo *info in _dataAry){
        if(index < self.itemArrary.count){
            DSItemImag *item = [self.itemArrary objectAtIndex:index];
            item.hero = info;
        }
        index++;
    }
    for (; index<self.itemArrary.count;index++) {
        DSItemImag *item = [self.itemArrary objectAtIndex:index];
        item.hero = nil;
    }
}

- (void)setEquipArray:(NSMutableArray *)ary
{
    [_dataAry release];
    _dataAry = [ary retain];
    NSUInteger index = 0;
    for(Equipment *info in _dataAry){
        if(index < self.itemArrary.count){
            DSItemImag *item = [self.itemArrary objectAtIndex:index];
            item.equip = info;
        }
        index++;
    }
    for (; index<self.itemArrary.count;index++) {
        DSItemImag *item = [self.itemArrary objectAtIndex:index];
        item.equip = nil;
    }
}


- (void)itemSelct:(id)sender
{
    DSItemImag *item = (DSItemImag *)sender;
    if(item.hero){
        if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectHero:)])
            [self.delegate didSelectHero:item.hero];
    }else if(item.equip){
        if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectEquip:)])
            [self.delegate didSelectEquip:item.equip];
    }
}

@end
