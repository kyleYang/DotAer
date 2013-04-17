//
//  MptRateViewController.m
//  TVGuide
//
//  Created by Kyle on 12-12-28.
//
//

#import "HumFeedbackViewController.h"
#import "Env.h"
#import "BqsRoundLeftArrowButton.h"
#import "Downloader.h"
#import "HumDotaUIOps.h"
#import "HumDotaNetOps.h"
#import "CustomUIBarButtonItem.h"
#import "Env.h"
#import "Question.h"
#import "PgLoadingFooterView.h"
#import "HMPopMsgView.h"
#import "Status.h"
#import "HumFeedbackCell.h"

#define kPlachTxtColor [UIColor colorWithRed:227.0f/255.0f green:227.0f/255.0f blue:227.0f/255.0f alpha:0.8f]
#define kTxtViewColor [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]

@interface HumFeedbackViewController ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,pgFootViewDelegate>
{
    Env *_env;
    BOOL _changed;
    int _taskid;
    int _page;
    BOOL _hasMore;
    BOOL _loadMore;
}

@property (nonatomic, retain) UITextView *ratFiled;
@property (nonatomic, retain) Downloader *downloader;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, retain) NSMutableArray *tempArray;
@property (nonatomic, retain) PgLoadingFooterView *loadingMoreFootView;

@end


@implementation HumFeedbackViewController
@synthesize ratFiled;
@synthesize downloader;
@synthesize tableView;
@synthesize dataArray = _dataArray;
@synthesize tempArray;
@synthesize loadingMoreFootView;

- (void)dealloc{
    self.ratFiled = nil;
    self.tableView = nil;
    [self.downloader cancelAll];
    self.downloader = nil;
    self.tempArray = nil;
    self.loadingMoreFootView = nil;
    [_dataArray release]; _dataArray = nil;
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


- (void)loadView{
    [super loadView];
    self.navigationItem.title = NSLocalizedString(@"setting.mian.use.feedback", nil);
    
    _env = [Env sharedEnv];
    

    //LeftBack Button;
    {
        
        NSString *leftBarName = NSLocalizedString(@"button.back", nil);
        self.navigationItem.leftBarButtonItem = [CustomUIBarButtonItem initWithImage:[[Env sharedEnv] cacheScretchableImage:@"pg_bar_back.png" X:kBarStrePosX Y:kBarStrePosY] eventImg:[[Env sharedEnv] cacheScretchableImage:@"pg_bar_backdown.png" X:kBarStrePosX Y:kBarStrePosY]  title:leftBarName target:self action:@selector(onLeftBackButtonClick)];
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"setting.mian.use.feedback.submit", nil)style:UIBarButtonItemStyleDone target:self action:@selector(onClickNavOK:)] autorelease];
    }
    
//    UIImageView *iv = [[[UIImageView alloc] initWithImage:[_env cacheImage:@"guide_frame_bg.png"]] autorelease];
//    iv.frame = self.view.bounds;
//    iv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [self.view addSubview:iv];
    
    self.view.backgroundColor = [UIColor colorWithRed:117.0f/255.0f green:96.0f/255.0f blue:81.0f/255.0f alpha:1.0f];
    
    CGRect rct = CGRectZero;
    UIImage *txtBg = [_env cacheImage:@"setting_badrate_txtview_bg.png"];
    rct.origin.x = (CGRectGetWidth(self.view.bounds) - txtBg.size.width)/2;
    rct.origin.y = 10;
    rct.size = txtBg.size;
    UIImageView *txtBgView = [[UIImageView alloc] initWithFrame:rct];
    txtBgView.image = txtBg;
    [self.view addSubview:txtBgView];
    [txtBgView release];
    
    self.ratFiled = [[[UITextView alloc] initWithFrame:CGRectMake(13, 15, CGRectGetWidth(self.view.frame)-26,CGRectGetHeight(txtBgView.frame)-20)] autorelease];
//    self.ratFiled.placeholder = NSLocalizedString(@"setting.mian.use.feedback.plac", nil);
    self.ratFiled.backgroundColor = [UIColor clearColor];
    self.ratFiled.text = NSLocalizedString(@"setting.mian.use.feedback.plac", nil);
    self.ratFiled.textColor = kPlachTxtColor;
    self.ratFiled.delegate = self;
    self.ratFiled.returnKeyType = UIReturnKeyDone;
    self.ratFiled.font = [UIFont systemFontOfSize:16.0f];
    self.ratFiled.selectedRange = NSMakeRange(0, 0);
    [self.view addSubview:self.ratFiled];
    
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.ratFiled.frame)+20, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-CGRectGetMaxY(self.ratFiled.frame)-55) style:UITableViewStylePlain] autorelease];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    {
        self.loadingMoreFootView = [[[PgLoadingFooterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame),35)] autorelease];
        self.loadingMoreFootView.backgroundColor = [UIColor clearColor];
        self.loadingMoreFootView.delegate = self;
        self.tableView.tableFooterView = self.loadingMoreFootView;;
    }

    
    _changed = FALSE;
    _taskid = -1;
    _page = 0;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.downloader = [[[Downloader alloc] init] autorelease];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload{
    [self.downloader cancelAll];
    self.downloader = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadNetworkData:NO];
}

-(void)loadNetworkData:(BOOL)bLoadMore {
    
    if (!bLoadMore) {
        _hasMore = YES;
        self.tempArray = nil;
        _page = 0;
        _taskid = [HumDotaNetOps questionMessageDownloader:self.downloader Target:self Sel:@selector(onLoadDataFinished:) Attached:nil page:_page];
    }else{
        _page++;
        [HumDotaNetOps questionMessageDownloader:self.downloader Target:self Sel:@selector(onLoadDataFinished:) Attached:nil page:_page];
    }
    
}

               

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onLeftBackButtonClick{
    [self.ratFiled resignFirstResponder];
    [HumDotaUIOps slideDismissModalViewController:self];
}


- (void)onClickNavOK:(id)sender{
    [self.ratFiled resignFirstResponder];
    if (!_changed) {
        return;
    }
    if (_taskid >0 ) {
        return;
    }
    
    if (!self.ratFiled.text || self.ratFiled.text.length == 0) {
        return;
    }
    NSString *content = self.ratFiled.text;
    if (content.length > 140) {
        content = [self.ratFiled.text substringWithRange:NSMakeRange(0, 139)];
    }
   
    _taskid = [HumDotaNetOps tskPostFeedback:content  Downloader:self.downloader Target:self Callback:@selector(finishCB:) Attached:nil];
    if (_taskid<0) {
        [HumDotaUIOps slideDismissModalViewController:self];
    }

}

- (void)finishCB:(DownloaderCallbackObj *)cb{
    _taskid = -1;
    
    if(nil == cb) return;
    
    if(nil != cb.error || 200 != cb.httpStatus) {
		BqsLog(@"Error: len:%d, http%d, %@", [cb.rspData length], cb.httpStatus, cb.error);
        [HMPopMsgView showPopMsgError:cb.error Msg:nil Delegate:nil];
        
        return;
	}
    
//    "setting.post.feedback.error" = "提交反馈出错,请重试";
//    "setting.post.feedback.success" = "提交反馈成功,谢谢您";
    
    Status *status = [Status parseXmlData:cb.rspData];
    if (!status.code) {
        [HMPopMsgView showPopMsgError:nil Msg:NSLocalizedString(@"setting.post.feedback.error", nil) Delegate:nil];
        return;
    }else{
        [HMPopMsgView showPopMsgError:nil Msg:NSLocalizedString(@"setting.post.feedback.success", nil) Delegate:nil];
        self.ratFiled.text = nil;
        self.ratFiled.selectedRange = NSMakeRange(0, 0);
        [self loadNetworkData:NO];
        _changed = NO;
    }

    
    

}


- (void)setDataArray:(NSArray *)dataArray{
    [_dataArray release]; _dataArray = nil;
    _dataArray = [dataArray retain];
    [self.tableView reloadData];
    _loadMore = NO;
    if (!_hasMore) {
        [self.loadingMoreFootView setState:PgFootRefreshAllDown];
    }else{
        [self.loadingMoreFootView setState:PgFootRefreshNormal];
    }
    
}


#pragma mark
#pragma mark downloadercallback
-(void)onLoadDataFinished:(DownloaderCallbackObj*)cb {
    BqsLog(@"HumDotaNewsCateTwoView onLoadDataFinished:%@",cb);
    _taskid = -1;
    if(nil == cb) return;
    
    if(nil != cb.error || 200 != cb.httpStatus) {
		BqsLog(@"Error: len:%d, http%d, %@", [cb.rspData length], cb.httpStatus, cb.error);
       [HMPopMsgView showPopMsgError:cb.error Msg:nil Delegate:nil];
        
        return;
	}
    if (nil == self.tempArray) {
        self.tempArray = [[[NSMutableArray alloc] initWithCapacity:15] autorelease];
    }
    NSArray *arry = [Question parseXmlData:cb.rspData];
    if (!arry||[arry count] == 0) {
        _hasMore = FALSE;
    }
    
    for (Question *question in arry) {
        [self.tempArray addObject:question];
    }
    self.dataArray = self.tempArray;
   
    
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    HumFeedbackCell *cell = (HumFeedbackCell *)[aTableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[HumFeedbackCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
    }
    
    Question *qestion = [self.dataArray objectAtIndex:indexPath.row];
    
    CGFloat heigh = kOrgY;
    
    
    
    CGRect frame = cell.userImage.frame;
    frame.origin.y = heigh;
    cell.userImage.frame = frame;
    
    frame = cell.userLb.frame;
    frame.origin.y = heigh;
    cell.userLb.frame = frame;
    
    NSString *userName = @"";
    if (!qestion.userName || qestion.userName.length == 0) {
        userName = [NSString stringWithFormat:NSLocalizedString(@"setting.feedback.nousername.format", nil),qestion.questId];
    }else{
        userName = [NSString stringWithFormat:NSLocalizedString(@"setting.feedback.username.format", nil),qestion.userName];
    }
    cell.userLb.text = userName;
    
    frame = cell.timeLb.frame;
    frame.origin.y = heigh;
    cell.timeLb.frame = frame;
    cell.timeLb.text = [NSString stringWithFormat:NSLocalizedString(@"setting.feedback.time.format", nil),qestion.time];
    
    heigh += kNameHeigh;
    heigh += kAUGap;
    
    frame = cell.answerImage.frame;
    frame.origin.y = heigh;
    cell.answerImage.frame = frame;
    
    frame = cell.questSign.frame;
    frame.origin.y = heigh;
    cell.questSign.frame = frame;
    
    NSString *descript = [NSString stringWithFormat:NSLocalizedString(@"setting.feedback.qeestion.fromat", nil),qestion.descript];
    CGSize size = [descript sizeWithFont:cell.questionLb.font constrainedToSize:CGSizeMake(CGRectGetWidth(cell.questionLb.frame), 1000) lineBreakMode:NSLineBreakByWordWrapping];
    frame = cell.questionLb.frame;
    frame.origin.y = heigh;
    frame.size.height = size.height;
    cell.questionLb.frame = frame;
    cell.questionLb.text = descript;
    

    
    heigh +=size.height;
    heigh +=kQAGap;
    
    frame = cell.adminImage.frame;
    frame.origin.y = heigh;
    cell.adminImage.frame = frame;

    
    NSString *answer = qestion.answer;
    if (!answer || answer.length == 0) {
        answer = NSLocalizedString(@"setting.feedback.noanswer", nil);
    }else{
        answer = [NSString stringWithFormat:NSLocalizedString(@"setting.feedback.answer.format", nil),answer];
    }
    
    size = [answer sizeWithFont:cell.answerLb.font constrainedToSize:CGSizeMake(CGRectGetWidth(cell.answerLb.frame), 1000) lineBreakMode:NSLineBreakByWordWrapping];
    frame = cell.answerLb.frame;
    frame.size.height = size.height;
    frame.origin.y = heigh;
    cell.answerLb.frame = frame;
    cell.answerLb.text = answer;
    
    frame = cell.answerSign.frame;
    frame.origin.y = heigh;
    cell.answerSign.frame = frame;
    
    heigh +=size.height;
    heigh +=kAUGap;
    
    
    frame = cell.frame;
    frame.size.height = heigh;
    cell.frame = frame;

    return cell;

}


//"setting.feedback.noanswer" = "回复: 你好,我们会尽快回复您的建议";
//"setting.feedback.answer.format" = "回复: %@";
//"setting.feedback.qeestion.fromat" = "建议: %@";
//"setting.feedback.username.format" = "用户: %@";
//"setting.feedback.nousername.format" = "用户: 匿名%d";
//"setting.feedback.time.format" = "时间: ";

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Question *qestion = [self.dataArray objectAtIndex:indexPath.row];
    
    CGFloat heigh = kOrgY;
    NSString *descript = [NSString stringWithFormat:NSLocalizedString(@"setting.feedback.qeestion.fromat", nil),qestion.descript];
    CGSize size = [descript sizeWithFont:kQuestFont constrainedToSize:CGSizeMake(kWidht, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    heigh +=size.height;
    heigh +=kQAGap;
    
    NSString *answer = qestion.answer;
    if (!answer || answer.length == 0) {
        answer = NSLocalizedString(@"setting.feedback.noanswer", nil);
    }else{
        answer = [NSString stringWithFormat:NSLocalizedString(@"setting.feedback.answer.format", nil),answer];
    }
    
    size = [answer sizeWithFont:kAnswerFont constrainedToSize:CGSizeMake(kWidht, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    heigh +=size.height;
    heigh +=kAUGap;
    
    heigh += kNameHeigh;
    heigh += kOrgY;
    
    return heigh;
    
}


#pragma mark
#pragma mark PgFootMore
- (void)footLoadMore
{
    if (self.loadingMoreFootView.state == PgFootRefreshAllDown) {
        return;
    }
    [self loadMoreData];
    
}

- (void)loadMoreData{
    
    if(self.loadingMoreFootView.state == PgFootRefreshAllDown){
        return;
    }
    
    _loadMore = YES;
    
    [self.loadingMoreFootView setState:PgFootRefreshLoading];
    
    [self loadNetworkData:YES];
}

#pragma mark
#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(!_loadMore) {
        float maxoffset = scrollView.contentSize.height - CGRectGetHeight(scrollView.frame)+30;
        if(maxoffset > 0 && scrollView.contentOffset.y >= maxoffset) {
            BqsLog(@"trigger load more!, offsety: %.1f, contentsize.h: %.1f, maxoffset:%.1f", scrollView.contentOffset.y, scrollView.contentSize.height, maxoffset);
            [self loadMoreData];
        }
        
    }
}

// called on start of dragging (may require some time and or distance to move)


#pragma mark pgFootViewDelegate
- (NSString *)messageTxtForState:(PgFootRefreshState)state
{
    int itemNum = [self.dataArray count];
    
    if (state == PgFootRefreshNormal) {
        if (itemNum == 0) {
            return [NSString stringWithFormat:NSLocalizedString(@"dota.more.noresult", nil)];
        }else{
            return [NSString stringWithFormat:NSLocalizedString(@"dota.more.normal", nil),itemNum];
        }
    }else if(state == PgFootRefreshLoading){
        return NSLocalizedString(@"dota.more.loading", nil);
    }else if(state ==  PgFootRefreshAllDown){
        if (itemNum == 0) {
            return [NSString stringWithFormat:NSLocalizedString(@"dota.more.noresult", nil)];
        }else{
            return [NSString stringWithFormat:NSLocalizedString(@"dota.more.done", nil),itemNum];
        }
    }
    return @"";
}



#pragma -
#pragma mark UITextViewDelegate;
- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text = @"";
    textView.textColor = kTxtViewColor;
    textView.selectedRange = NSMakeRange(0, 0);
    _changed = YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    [self.ratFiled resignFirstResponder];
}


@end
