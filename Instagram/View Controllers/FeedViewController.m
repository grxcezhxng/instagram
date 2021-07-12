//
//  FeedViewController.m
//  Instagram
//
//  Created by gracezhg on 7/6/21.
//

#import "FeedViewController.h"
#import "Parse/Parse.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "DetailViewController.h"
#import "PostCell.h"

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrayOfPosts;

@end

@implementation FeedViewController

#pragma mark - Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIRefreshControl *const refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self _fetchFeed];
}

#pragma mark - Table View Data Source Methods

- (void)_fetchFeed {
    PFQuery *const postQuery = [PFQuery queryWithClassName:@"Post"];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"]; // pointers
    postQuery.limit = 20;
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.arrayOfPosts = posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

#pragma mark - Table View Delegate Methods

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *const cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    Post *const post = self.arrayOfPosts[indexPath.row];
    cell.post = post;
    [cell setCellData];
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfPosts.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Refresh Control

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    NSURLSession *const session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                                delegate:nil
                                                           delegateQueue:[NSOperationQueue mainQueue]];
    session.configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [self _fetchFeed];
    [self.tableView reloadData];
    [refreshControl endRefreshing];
}

#pragma mark - Navigation and IBActions

- (IBAction)handleLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        UIStoryboard *const storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *const loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [[UIApplication sharedApplication].keyWindow setRootViewController:loginViewController];
    }];
}

- (IBAction)handleCompose:(id)sender {
    [self performSegueWithIdentifier:@"composeSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[DetailViewController class] ]){
        UITableViewCell *const tappedCell = sender;
        NSIndexPath *const indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *const post = self.arrayOfPosts[indexPath.row];
        DetailViewController *const detailsViewController = [segue destinationViewController];
        detailsViewController.post = post;
    }
}

@end
