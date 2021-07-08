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
#import "PostCell.h"

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrayOfPosts;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    [self fetchFeed];
    [self.tableView reloadData];

}

- (void)fetchFeed {
    // construct query
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Post"];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery includeKey:@"caption"];
    [postQuery includeKey:@"image"];
    postQuery.limit = 20;

    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.arrayOfPosts = posts;
            [self.tableView reloadData];
            NSLog(@"Works");
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)handleLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        //        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [[UIApplication sharedApplication].keyWindow setRootViewController:loginViewController];
    }];
}

- (IBAction)handleCompose:(id)sender {
    [self performSegueWithIdentifier:@"composeSegue" sender:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    Post *post = self.arrayOfPosts[indexPath.row];
    cell.post = post;
    [cell setCellData];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfPosts.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Makes a network request to get updated data
  // Updates the tableView with the new data
  // Hides the RefreshControl
- (void)beginRefresh:(UIRefreshControl *)refreshControl {

        // Create NSURL and NSURLRequest

        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                              delegate:nil
                                                         delegateQueue:[NSOperationQueue mainQueue]];
        session.configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    // ... Use the new data to update the data source ...
     [self fetchFeed];

    // Reload the tableView now that there is new data
     [self.tableView reloadData];

    // Tell the refreshControl to stop spinning
     [refreshControl endRefreshing];
}


@end
