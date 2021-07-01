//
//  Tweet.m
//  twitter
//
//  Created by gracezhg on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "Tweet.h"
#import "User.h"
#import "NSDate+DateTools.h"

@implementation Tweet

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        
        // Is this a re-tweet?
        NSDictionary *const originalTweet = dictionary[@"retweeted_status"];
        if (originalTweet != nil){
            NSDictionary *const userDictionary = dictionary[@"user"];
            self.retweetedByUser = [[User alloc] initWithDictionary:userDictionary];
            
            // Change tweet to original tweet
            dictionary = originalTweet;
        }
        self.idStr = dictionary[@"id_str"];
        self.text = dictionary[@"text"];
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        
        // Initialize user
        NSDictionary *const user = dictionary[@"user"];
        self.user = [[User alloc] initWithDictionary:user];
        
        // Date
        NSString *const createdAtOriginalString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
        NSDate *const date = [formatter dateFromString:createdAtOriginalString];
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        self.createdAtString = [formatter stringFromDate:date];
        self.createdAgoAtString = date.shortTimeAgoSinceNow;
        
        // Time
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
        timeFormatter.dateFormat = @"HH:mm:ss";
        NSString *timeString = [timeFormatter stringFromDate: date];
        self.createdTimeAtString = timeString;
    }
    return self;
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries{
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Tweet *const tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    return tweets;
}

@end
