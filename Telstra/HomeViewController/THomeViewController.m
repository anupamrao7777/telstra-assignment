//
//  THomeViewController.m
//  Telstra
//
//  Created by Anupam Rao on 22/03/18.
//  Copyright © 2018 AnupamRao. All rights reserved.
//

#import "THomeViewController.h"
#import "TFactsViewTableViewCell.h"
#import "TFactResponse.h"
#import "TFactModel.h"
#import "UIImageView+AFNetworking.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Reachability.h"
#import " TConstant.h"
static NSString *cellIdentifier = @"factCell";

@interface THomeViewController () {
    UITableView *homeTableView;
    TFactResponse *factRequestResponse;
    NSString *imageUrl;
    UIActivityIndicatorView *activityIndicator;
    UIRefreshControl *refreshControl;
    TFactModel *fact;
}
@property (nonatomic, strong) NSMutableArray *fetchedImages;
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@end

@implementation THomeViewController

- (id)init {
    if (self = [super init]) {
        factRequestResponse = [[TFactResponse alloc] init];
    }
    return(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
  
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
       // init table view
    // Load home screen data through service all.
    [self loadHomeScreenData];
    homeTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    // must set delegate & dataSource, otherwise the the table will be empty and not responsive
    homeTableView.delegate = self;
    homeTableView.dataSource = self;
    homeTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:homeTableView];
    homeTableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    
    //Add activity indicator to show till data get load
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.alpha = 1.0;
    activityIndicator.hidden = NO;
    activityIndicator.center = CGPointMake([[UIScreen mainScreen]bounds].size.width/2, [[UIScreen mainScreen]bounds].size.height/2 - 64);
    [activityIndicator startAnimating];
    [homeTableView addSubview:activityIndicator];
    
    //Add pull to refresh:
    refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.tintColor = [UIColor grayColor];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Updating data"];
    [homeTableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(loadHomeScreenData) forControlEvents:UIControlEventValueChanged];
    
    [self homeTableAutolayout]; // Autolayouting for homeTableview method
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    self.automaticallyAdjustsScrollViewInsets = false;
}

-(void)homeTableAutolayout {
    [homeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
}


#pragma mark - Home screen service call Methods

- (void)loadHomeScreenData {
    NetworkStatus myStatus = [[Reachability reachabilityWithHostName:K_TSERVICE_BASE_URL]currentReachabilityStatus];
    switch (myStatus) {
        case NotReachable:
            [self notReachableSetUp];
            break;
        case ReachableViaWWAN:
            [self setUpData];
            break;
        case ReachableViaWiFi:
            [self setUpData];
            break;
        default:
            break;
    }
}
-(void)setUpData
{
    [homeTableView bringSubviewToFront:activityIndicator];
        [factRequestResponse getFactsDataWithCompletionHandler:^(NSError *error) {
        //Dispatch to main queue
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if(!error) {
                [homeTableView reloadData];
                self.navigationItem.title = factRequestResponse.navTitleString;
            }
            [activityIndicator stopAnimating];
            activityIndicator.hidden = YES;
            [refreshControl endRefreshing];
            [homeTableView reloadData];
        });
    }];
}
#pragma mark - UITableViewDataSource
// number of section(s), now I assume there is only 1 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return factRequestResponse.factsArray.count;
}

// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFactsViewTableViewCell *cell = (TFactsViewTableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[TFactsViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    fact = [factRequestResponse.factsArray objectAtIndex:indexPath.row];
    imageUrl = fact.factImageURL;
    cell.titleLabel.text = fact.factTitle;
    cell.descriptionLabel.text = fact.factDescription;
    cell.thumbnailImage.image = nil;
    UIImage *image = fact.factImage;
    if (image) {
        // If there is image don't bother fetching the image.
        cell.thumbnailImage.image = image;
    }
    else {
        [cell.thumbnailImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"nil"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                TFactModel *factModel= [factRequestResponse.factsArray objectAtIndex:indexPath.row];
                factModel.factImage = image;
                [factRequestResponse.factsArray replaceObjectAtIndex:indexPath.row withObject:factModel];
                // [homeTableView beginUpdates];
                cell.thumbnailImage.image = factModel.factImage;
                [homeTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [homeTableView reloadData];
                // [homeTableView endUpdates];
            }
        }];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    fact = [factRequestResponse.factsArray objectAtIndex:indexPath.row];
    
    float titleHeight = [self calculateHeightOfCellForText:fact.factTitle fontSize:18.0];
    float descriptionHeight = [self calculateHeightOfCellForText:fact.factDescription fontSize:12.0];
    float totalLblsHeight = titleHeight + descriptionHeight;
    
    UIImage *image = fact.factImage;
    if (image) {
        return fact.factImage.size.height + 50.0 + totalLblsHeight;
    }
    else {
        return totalLblsHeight + 50.0; // Default value..
    }
}

//Calculate height of UIlabel based on string length
-(float)calculateHeightOfCellForText:(NSString*)string fontSize:(float)fontSize
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(self.view.frame.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Arial" size:fontSize]} context:nil];
    
    CGSize requiredSize = rect.size;
    return requiredSize.height; //finally u return your height
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(void)showAlertWithTitle:(NSString*)title andMessage:(NSString*)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Reachability Notification and Related Methods

- (void) reachabilityChanged:(NSNotification *)note
{
    NetworkStatus myStatus = [[Reachability reachabilityWithHostName:K_TSERVICE_BASE_URL]currentReachabilityStatus];
    switch (myStatus) {
        case NotReachable:
            [self notReachableSetUp];
            break;
        case ReachableViaWWAN:
            break;
        case ReachableViaWiFi:
            break;
        default:
            break;
    }
}

-(void)notReachableSetUp
{
    if (refreshControl.isRefreshing) {
        [refreshControl endRefreshing];
    }
    [activityIndicator stopAnimating];
    activityIndicator.hidden = YES;
    [homeTableView reloadData];
    [homeTableView scrollsToTop];
    [self showAlertWithTitle:@"Error!" andMessage:@"No Network Connection"];
}
@end
