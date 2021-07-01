//
//  DetailsViewController.m
//  twitter
//
//  Created by gracezhg on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameLabel.text = self.tweet.user.name;
    self.usernameLabel.text = self.tweet.user.screenName;
    self.tweetLabel.text = self.tweet.text;
    self.dateLabel.text = self.tweet.createdAtString;
    self.timeLabel.text = self.tweet.createdTimeAtString;
    self.retweetLabel.text = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
    self.favorLabel.text = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
    
    self.profilePhoto.layer.cornerRadius = 35;
    NSString *const URLString = self.tweet.user.profilePicture;
    NSURL *const url = [NSURL URLWithString:URLString];
    [self.profilePhoto setImageWithURL:url];
    self.profilePhoto.layer.cornerRadius = 35;
}

@end
