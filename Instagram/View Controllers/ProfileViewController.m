//
//  ProfileViewController.m
//  Instagram
//
//  Created by gracezhg on 7/9/21.
//

#import "ProfileViewController.h"
#import <Parse/PFImageView.h>
#import "UIImageView+AFNetworking.h"
#import "PostCollectionCell.h"
#import "Post.h"

@interface ProfileViewController () <UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *arrayOfPosts;
@property (weak, nonatomic) IBOutlet UILabel *postCountLabel;

@end

@implementation ProfileViewController

#pragma mark - Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _updateViews];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self _fetchUserPosts];
    self.profilePhoto.userInteractionEnabled = YES;
    
    UICollectionViewFlowLayout *const layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    
    const CGFloat margin = 24;
    const CGFloat postersPerLine = 3;
    const CGFloat itemWidth = (self.collectionView.frame.size.width - margin * 2)/postersPerLine ;
    const CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

#pragma mark - Collection View Data Source Methods

- (void)_fetchUserPosts {
    PFQuery *const userQuery = [PFQuery queryWithClassName:@"Post"];
    [userQuery whereKey:@"author" equalTo:[PFUser currentUser]];
    [userQuery orderByDescending:@"createdAt"];
    [userQuery includeKey:@"author"]; // pointers
    userQuery.limit = 30;
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.arrayOfPosts = posts;
            self.postCountLabel.text = [NSString stringWithFormat:@"%i", self.arrayOfPosts.count];
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

#pragma mark - Collection View Delegate Methods

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayOfPosts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PostCollectionCell *const cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionCell" forIndexPath:indexPath];
    Post *const post = self.arrayOfPosts[indexPath.row];
    
    PFFileObject *const postFile = post[@"image"];
    NSURL *const postUrl = [NSURL URLWithString: postFile.url];
    [cell.postView setImageWithURL:postUrl];
    
    return cell;
}

#pragma mark - IB Actions

- (IBAction)handleChangeProfilePhoto:(UITapGestureRecognizer *)sender {
    UIImagePickerController *const imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

#pragma mark - UIImagePickerController Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *const editedImage = info[UIImagePickerControllerEditedImage];
    UIImage *const resizedImage = [self _resizeImage:editedImage withSize:CGSizeMake(100, 100)];
    self.profilePhoto.image = resizedImage;
    
    self.usernameLabel.text  = PFUser.currentUser[@"username"];
    self.profilePhoto.layer.cornerRadius = 50;
    
    UIImage *const latestPhoto = [self _resizeImage:self.profilePhoto.image withSize:CGSizeMake(100, 100)];
    
    // save new profile photo for user
    NSData *const imageData = UIImagePNGRepresentation(latestPhoto);
    PFFileObject *const file = [PFFileObject fileObjectWithName:@"image.png" data:imageData];
    [PFUser.currentUser setObject:file forKey:@"profilePhoto"];
    
    [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            NSLog(@"Sucessfully saved user photo");
        }
        else {
            NSLog(@"error: %@", error);
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private Image Helper Methods

- (UIImage *)_resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *const resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *const newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (PFFileObject *)_getPFFileFromImage: (UIImage * _Nullable)image {
    if (!image) {
        return nil;
    }
    NSData *const imageData = UIImagePNGRepresentation(image);
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

- (void)_updateViews {
    self.usernameLabel.text  = PFUser.currentUser.username;
    self.profilePhoto.layer.cornerRadius = 50;
    
    if(PFUser.currentUser[@"profilePhoto"]) {
        PFFileObject *const file = PFUser.currentUser[@"profilePhoto"];
        NSURL *const url = [NSURL URLWithString: file.url];
        [self.profilePhoto setImageWithURL:url];
    }
}

@end
