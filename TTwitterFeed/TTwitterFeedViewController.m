//
//  TTwitterFeedViewController.m
//  TTwitterFeed
//
//  Created by Praveen on 8/24/13.
//  Copyright (c) 2013 Praveen. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  1. The above copyright notice and this permission notice shall be included
//     in all copies or substantial portions of the Software.
//
//  2. This Software cannot be used to archive or collect data such as (but not
//     limited to) that of events, news, experiences and activities, for the
//     purpose of any concept relating to diary/journal keeping.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "TTwitterFeedViewController.h"
#import "TTweetModel.h"
#import "TwitterFeedCell.h"

@interface TTwitterFeedViewController ()
@property (nonatomic, strong) ISRefreshControl *refreshControl;
@end

@implementation TTwitterFeedViewController

@synthesize mTweetList = _mTweetList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mConnectionManager = [TConnectionManager sharedConnectionManager];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup pull to refresh
    self.refreshControl = [[ISRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self
                            action:@selector(fetchTwitterData)
                  forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
    [self fetchTwitterData];
}

-(void)connectToTwitter{
    [mConnectionManager loginToTwitter:^{
        [self fetchTwitterData];
    } errorBlock:^(NSError *error) {
        // ignore
    }];
}

-(void) fetchTwitterData{
    self.startRefreshDate = [NSDate date];
    if(mConnectionManager.isAuthenticated){
        [mConnectionManager getTwitterTimeLine:^(NSArray *aTimeLine) {
            self.mTweetList = aTimeLine;
            [self.tableView reloadData];
            NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:_startRefreshDate];
            NSTimeInterval minimumInterval = 3;
            if (interval > minimumInterval) {
                [self.refreshControl endRefreshing];
            } else {
                [self.refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:(minimumInterval-interval)];
            }
        } errorBlock:^(NSError *error) {
            // ignore
        }];
    }else{
        [self connectToTwitter];
    }
    
}

#pragma mark -- UITableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_mTweetList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"TweetCell";
    TwitterFeedCell *cell = (TwitterFeedCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        NSArray *topLevelObjects;
        topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"TwitterFeedCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if([currentObject isKindOfClass:[TwitterFeedCell class]]){
                cell = (TwitterFeedCell*) currentObject;
                break;
            }
        }
    }
    cell.opaque=NO;    TTweetModel *lModel = [_mTweetList objectAtIndex:indexPath.row];
    cell.tweetText.text = lModel.mTweet;
    cell.tweetDate.text = lModel.mCreatedDate;
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
