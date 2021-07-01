//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "DetailsViewController.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "User.h"
#import "ComposeViewController.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayOfTweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchTweets];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)fetchTweets {
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.arrayOfTweets = tweets;
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)didTweet:(Tweet*)tweet {
    [self.arrayOfTweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    Tweet *const tweet = self.arrayOfTweets[indexPath.row];
    
    cell.tweet = tweet;
    cell.nameLabel.text = tweet.user.name;
    cell.usernameLabel.text = tweet.user.screenName;
    cell.usernameLabel.text = tweet.user.screenName;
    cell.dateLabel.text = tweet.createdAgoAtString;
    cell.tweetLabel.text = tweet.text;
    cell.retweetLabel.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];;
    cell.favorLabel.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    
    NSString *const URLString = tweet.user.profilePicture;
    NSURL *const url = [NSURL URLWithString:URLString];
    [cell.profilePhoto setImageWithURL:url];
    [cell.profilePhoto.layer setCornerRadius:35];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfTweets.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)logOutHandler:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showCompose"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"showDetails"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.arrayOfTweets[indexPath.row];
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.tweet = tweet;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
