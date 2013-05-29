//
//  HumDotaSimuViewController.m
//  DotAer
//
//  Created by Kyle on 13-5-26.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaSimuViewController.h"
#import "HumDotaSimuCateTwoView.h"


@interface HumDotaSimuViewController ()

@property (nonatomic, retain) HumDotaSimuCateTwoView *simuTable;

@end

@implementation HumDotaSimuViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize simuTable;

- (void)dealloc{
    self.simuTable = nil;
    [_managedObjectContext release]; _managedObjectContext = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"dota.categor.simulator", nil);
    self.view.backgroundColor = [UIColor colorWithRed:75.0f/255.0f green:64.0f/255.0f blue:59.0f/255.0f alpha:1.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kUmeng_simulatorPage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [MobClick endLogPageView:kUmeng_simulatorPage];
    [super viewWillDisappear:animated];
}


- (NSUInteger)numberOfItemFor:(MptContentScrollView *)scrollView{ // must be rewrite
    return 1;
}

- (MptCotentCell*)cellViewForScrollView:(MptContentScrollView *)scrollView frame:(CGRect)frame AtIndex:(NSUInteger)index{
    static NSString *identifier = @"cell";
    HumDotaSimuCateTwoView *cell = (HumDotaSimuCateTwoView *)[scrollView dequeueCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[HumDotaSimuCateTwoView alloc] initWithFrame:frame withIdentifier:identifier withController:self] autorelease];
    }
    cell.managedObjectContext = self.managedObjectContext;
    self.simuTable = cell;
    return cell;
    
}


#pragma mark 
#pragma mark 

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext == managedObjectContext) return;
    [_managedObjectContext release];
    _managedObjectContext = [managedObjectContext retain];
    if (self.simuTable) {
        self.simuTable.managedObjectContext = _managedObjectContext;
    }
}

-(void)didSelectHero:(HeroInfo *)hero{
    if (self.simuTable) {
         [self.simuTable didSelectHero:hero];
    }
   
    
}

-(void)didSelectEquip:(Equipment *)equip{
    if (self.simuTable) {
        [self.simuTable didSelectEquip:equip];
    }
    
}


@end
