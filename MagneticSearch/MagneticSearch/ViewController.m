//
//  ViewController.m
//  MagneticApp
//
//  Created by xiaxia on 2016/11/27.
//  Copyright © 2016年 xiaxia. All rights reserved.
//

#import "ViewController.h"
#import "MagnetsCellTableViewCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "WBPopMenuModel.h"
#import "WBPopMenuSingleton.h"
//#import "HelpViewController.h"

typedef NS_ENUM(NSInteger, RequestType) {
    RequestTypeDefault = 0,
    RequestTypeSwitch,
};


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic, strong) NSMutableArray<movieModel*> *magnets;
@property (nonatomic, strong  ) NSMutableArray *sites;
@property (nonatomic,   strong) UITableView *tableView;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong)UIView *maskView;
@property (nonatomic,strong) NSString *movieName;
@property (assign, nonatomic) NSInteger page;
//@property (nonatomic, strong) NSMutableArray *dataLait;
@property (nonatomic,strong) NSString *beseURL;
@property (strong, nonatomic) MBProgressHUD *hudView;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) NSString *oldmovieName;
@property (strong, nonatomic) UIButton *promptView;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    NSArray *barSubViews = self.navigationController.navigationBar.subviews;
    for (id object in barSubViews) {
        if ([object isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)object;
            imageView.hidden = NO;
        }
    }
}

- (void)viewDidLoad {
    
    
    
    @WEAKSELF(self);
    NSArray*searchText = @[@"武媚娘传奇",
                           @"冰与火之歌",
                           @"心花路放",
                           @"猩球崛起",
                           @"行尸走肉",
                           @"分手大师",
                           @"敢死队",
                           @"血族",
                           @"金刚",
                           @"麻雀",
                           @"暗杀教室",
                           @"我的战争",
                           @"海底总动员",
                           @"咖啡公社",
                           @"变形金刚",
                           @"闪电侠",
                           @"绿箭侠",
                           @"越狱",
                           @"纸牌屋",
                           @"动作",
                           @"爱情",
                           @"喜剧",
                           @"美剧",
                           ];
    self.movieName = searchText[arc4random() % searchText.count];
    self.oldmovieName = self.movieName;
    
    [super viewDidLoad];
    self.title = @"当前车：";
    self.page = 1;
    
    self.imageView = [[UIImageView alloc]init];
    self.imageView.image = [UIImage imageNamed:[self images][0]];
    [self.imageView sizeToFit];
    self.imageView.frame = CGRectMake(ScreenWidth/2-self.imageView.width/2+40, 13, 0, 0);
    [self.imageView sizeToFit];
    [self.navigationController.navigationBar addSubview:self.imageView];
    
    
    UIButton *carBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [carBut addTarget:self action:@selector(itemAction) forControlEvents:UIControlEventTouchUpInside];
    [carBut setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [carBut sizeToFit];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:carBut];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton *BellBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [BellBut addTarget:self action:@selector(bellAction) forControlEvents:UIControlEventTouchUpInside];
    [BellBut setImage:[UIImage imageNamed:@"bell"] forState:UIControlStateNormal];
    [BellBut sizeToFit];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:BellBut];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.searchBar = [[UISearchBar alloc]init];
    
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"搜索";
    [self.view addSubview:self.searchBar];
    self.searchBar.sd_layout
    .leftSpaceToView(self.view,0)
    .topSpaceToView(self.view,64)
    .rightSpaceToView(self.view,0)
    .heightIs(35);
    
    
    
    self.tableView = [UITableView new];
    self.tableView.hidden = YES;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    
    self.tableView.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.searchBar,0)
    .bottomSpaceToView(self.view,0);
    
    self.sites = [NSMutableArray new];
    [self setupTableViewData];
    
    extern sideModel *selectSideRule;
    selectSideRule = self.sites[0];
    
    [self.view addSubview:self.maskView];
    self.maskView.sd_layout
    .topSpaceToView(self.searchBar,0)
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,0);
    
    [self config];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [selfWeak changeKeywordPage:self.page type:RequestTypeDefault];
    }];
    
    self.promptView.frame = CGRectMake(0, 0, ScreenWidth, 44);
    [self.navigationController.view insertSubview:self.promptView atIndex:1];
}

- (void)bellAction {
    
    NSArray *barSubViews = self.navigationController.navigationBar.subviews;
    for (id object in barSubViews) {
        if ([object isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)object;
            imageView.hidden = YES;
        }
    }
    
//    HelpViewController *help = [[HelpViewController alloc]init];
//    [self.navigationController pushViewController:help animated:YES];
}

- (void)itemAction {
    
    
    NSMutableArray *obj = [NSMutableArray array];
    
    for (NSInteger i = 0; i < [self titles].count; i++) {
        
        WBPopMenuModel * info = [WBPopMenuModel new];
        info.image = [self images][i];
        info.title = [self titles][i];
        [obj addObject:info];
    }
    
    @WEAKSELF(self);
    
    [[WBPopMenuSingleton shareManager]showPopMenuSelecteWithFrame:120
                                                             item:obj
     
                                                           action:^(NSInteger index) {
                                                               selfWeak.hud = [MBProgressHUD showHUDAddedTo:selfWeak.navigationController.view animated:YES];
                                                               selfWeak.hud.labelText = NSLocalizedString(@"已换车....", @"HUD loading title");
                                                               selectSideRule = selfWeak.sites[index];
                                                               selfWeak.imageView.image = [UIImage imageNamed:[self images][index]];
                                                               [selfWeak.magnets removeAllObjects];
                                                               [selfWeak.tableView reloadData];
                                                               [selfWeak changeKeywordPage:0 type:RequestTypeSwitch];
                                                               
                                                           }];
    
}

- (NSArray *) titles {
    return @[@"公交车",
             @"汽车",
             @"自行车",
             @"摩托车",
             @"飞机",
             @"火箭",
             @"卫星",
             @"小毛驴",
             @"出租车",
             @"火车",
             @"货车"];
}

- (NSArray *) images {
    return @[@"bus",
             @"Car",
             @"Funny",
             @"Motorcycle",
             @"paper_plane",
             @"rocket",
             @"satellite",
             @"Scooter",
             @"Taxi",
             @"train",
             @"truck"];
}

//点击键盘上的search按钮时调用

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar

{
    if (searchBar.text.length > 0) {
        self.movieName= searchBar.text;
        self.maskView.hidden = YES;
        self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        self.hud.labelText = NSLocalizedString(@"拼命加载中...", @"HUD loading title");
        [self changeKeywordPage:0 type:RequestTypeSwitch];
        [self.searchBar resignFirstResponder];
    }else {
        [self showProgressViewWithText:@"输入不能为空!"];
    }
    
}

//点击搜索框时调用

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar

{
    //    [self refreshData];
    self.maskView.hidden = NO;
    
}


- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    
    self.maskView.hidden = YES;
    [self.searchBar resignFirstResponder];
    
    return YES;
}




- (void)showView {
    
    self.maskView.hidden = YES;
    [self.searchBar resignFirstResponder];
    
}

#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.magnets.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    movieModel *model = self.magnets[indexPath.row];
    
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:model.cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:model.cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([model.cellID isEqualToString:@"MagnetsCellTableViewCell"]) {
        [cell setValue:self.movieName forKey:@"movieName"];
    }
    [cell setValue:self.magnets[indexPath.row] forKey:@"model"];
    
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    movieModel *model = self.magnets[indexPath.row];
    id class = [[NSClassFromString(model.cellID) alloc] init];
    CGFloat height = [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[class class] contentViewWidth:[self cellContentViewWith]];
    return height;
    
    
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    movieModel *model = self.magnets[indexPath.row];
    if (![model.cellID isEqualToString:@"MagnetsCellTableViewCell"]) {
        return;
    }
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = model.magnet;
    [self showProgressViewWithText:@"复制磁力成功"];
    
    
    if (model.isShow == NO) {
        model.isShow = YES;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}


- (void)setupTableViewData{
    NSString *url = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/rule-master/rule.json"];
    NSData *data = [NSData dataWithContentsOfFile:url];
    
    
    if (data==nil) {
        url = [[NSBundle mainBundle] pathForResource:@"rule" ofType:@"json"];
        data = [NSData dataWithContentsOfFile:url];
    }
    
    NSArray*array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    [self.sites removeAllObjects];
    
    for (NSDictionary *dic in array) {
        sideModel *side = [sideModel new];
        side.site = dic[@"site"];
        side.group= dic[@"group"];
        side.name = dic[@"name"];
        side.size = dic[@"size"];
        side.waiting= dic[@"waiting"];
        side.count  = dic[@"count"];
        side.source = dic[@"source"];
        side.magnet = dic[@"magnet"];
        side.mark = dic[@"mark"];
        [self.sites addObject:side];
    }
}


- (void)config{
    self.magnets = [NSMutableArray new];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.hud.labelText = NSLocalizedString(@"拼命加载中...", @"HUD loading title");
    [self setupSearchText];
}


- (void)setupSearchText{
    
    [self changeKeywordPage:0 type:RequestTypeDefault];
}

- (void)changeKeywordPage:(NSInteger)page type:(RequestType)type{
    
    if (self.magnets.count == 0) {
        [self addHearcell];
    }
    
    
    if (page>1) {
        
        if ([selectSideRule.mark isEqualToString:@""]) {
            
            self.beseURL =[selectSideRule.source stringByReplacingOccurrencesOfString:@"1" withString:[NSString stringWithFormat:@"%ld",(long)self.page]];
            
        }else if([selectSideRule.mark isEqualToString:@"X/"])  {
            self.beseURL = [NSString stringWithFormat:@"%@%ld/",selectSideRule.source,(long)self.page];
            
        }else if ([selectSideRule.mark isEqualToString:@"_rel_X"]) {
            
            NSMutableString* source = [[NSMutableString alloc]initWithString:selectSideRule.source];
            [source insertString:@"_rel_1"atIndex:source.length - 5];
            self.beseURL = [source stringByReplacingOccurrencesOfString:@"1" withString:[NSString stringWithFormat:@"%ld",(long)self.page]];
            
        }else if ([selectSideRule.mark isEqualToString:@"_X"]) {
            
            NSMutableString* source = [[NSMutableString alloc]initWithString:selectSideRule.source];
            [source insertString:@"_1"atIndex:source.length - 5];
            self.beseURL = [source stringByReplacingOccurrencesOfString:@"1" withString:[NSString stringWithFormat:@"%ld",(long)self.page]];
            
        }
    }
    
    self.beseURL = [selectSideRule.source stringByReplacingOccurrencesOfString:@"XXX" withString:self.movieName];
    
    NSString*url = [self.beseURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    @WEAKSELF(self);
    [[breakDownHtml downloader] downloadHtmlURLString:url willStartBlock:^{
        
    } success:^(NSData*data) {
        
        NSArray *dataArr = [movieModel HTMLDocumentWithData:data];
        if (type == RequestTypeSwitch) {
            [selfWeak.magnets removeAllObjects];
            [selfWeak addHearcell];
        }
        [selfWeak.magnets addObjectsFromArray:dataArr];
        if (dataArr.count == 0) {
            selfWeak.movieName = selfWeak.oldmovieName;
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_async(mainQueue,^{
                [selfWeak showProgressViewWithText:@"源网站没有数据,切换其它源试试！"];
                return;
                
            });
        }
        
        
        if (selfWeak.magnets.count>0) {
            
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_async(mainQueue,^{
                
                [UIView animateWithDuration:1.2 animations:^{
                    self.promptView.alpha = 1;
                    [self.promptView setTitle:[NSString stringWithFormat:@"更新了%ld条数据",(unsigned long)dataArr.count] forState:UIControlStateNormal];
                    self.promptView.frame = CGRectMake(0, 64, ScreenWidth, 44);
                    
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:1.2 animations:^{
                        self.promptView.alpha = 0;
                        self.promptView.frame = CGRectMake(0, 0, ScreenWidth, 44);
                        
                    }];
                }];
                
                [selfWeak.hud hide:YES];
                selfWeak.tableView.hidden = NO;
                [selfWeak.tableView reloadData];
                selfWeak.page++;
                
            });
        }else{
            [selfWeak.hud hide:YES];
            
            [selfWeak showProgressViewWithText:@"源网站没有数据,切换其它源试试！"];
            
        }
    } failure:^(NSError *error) {
        [selfWeak.hud hide:YES];
        
        [selfWeak showProgressViewWithText:@"请检查网络，或者等一下再刷新！"];
        
    }];
    
    
    [selfWeak.tableView.mj_footer endRefreshing];
    
}

- (void)addHearcell {
    
    movieModel *model = [[movieModel alloc]init];
    model.cellID = @"RemindCell";
    [self.magnets addObject:model];
    
}

- (void)refreshData {
    
    [self.magnets removeAllObjects];
}
-(void)showProgressViewWithText:(NSString*)text {
    
    self.hudView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hudView.mode = MBProgressHUDModeText;
    self.hudView.labelText = text;
    self.hudView.removeFromSuperViewOnHide = YES;
    [self.hudView hide:YES afterDelay:1];
}

- (UIView *)maskView {
    
    if (!_maskView) {
        _maskView = [UIView new];
        _maskView.hidden = YES;
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.2;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showView)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

- (UIButton *)promptView {
    
    if (!_promptView) {
        _promptView = [UIButton new];
        _promptView.alpha = 0;
        _promptView.backgroundColor = RGB(255, 136, 29);
    }
    return _promptView;
    
}


@end
