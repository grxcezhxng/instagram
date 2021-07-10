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

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self renderView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self fetchUserPosts];
    self.profilePhoto.userInteractionEnabled = YES;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
  
    CGFloat const margin = 24;
    CGFloat const postersPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - margin * 2)/postersPerLine ;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}


- (void)fetchUserPosts {
    PFQuery *userQuery = [PFQuery queryWithClassName:@"Post"];
    [userQuery whereKey:@"author" equalTo:[PFUser currentUser]];
    [userQuery orderByDescending:@"createdAt"];
    [userQuery includeKey:@"author"]; // pointers
    userQuery.limit = 30;
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.arrayOfPosts = posts;
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayOfPosts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PostCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionCell" forIndexPath:indexPath];
    Post *post = self.arrayOfPosts[indexPath.row];
    
    PFFileObject *postFile = post[@"image"];
    NSURL *postUrl = [NSURL URLWithString: postFile.url];
    [cell.postView setImageWithURL:postUrl];
    
    return cell;
}


- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

- (IBAction)handleChangeProfilePhoto:(UITapGestureRecognizer *)sender {
        UIImagePickerController *imagePickerVC = [UIImagePickerController new];
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    UIImage *resizedImage = [self resizeImage:editedImage withSize:CGSizeMake(100, 100)];
    self.profilePhoto.image = resizedImage;
    
    self.usernameLabel.text  = PFUser.currentUser[@"username"];
    self.profilePhoto.layer.cornerRadius = 50;
    
    UIImage *latestPhoto = [self resizeImage:self.profilePhoto.image withSize:CGSizeMake(100, 100)];
    
    
    // save new profile photo for user
    NSData *imageData = UIImagePNGRepresentation(latestPhoto);
    PFFileObject *file = [PFFileObject fileObjectWithName:@"image.png" data:imageData];
    [PFUser.currentUser setObject:file forKey:@"profilePhoto"];
    
    [PFUser.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            NSLog(@"succeeded %@");
        }
        else {
            NSLog(@"error: %@", error);
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) renderView {
    self.usernameLabel.text  = PFUser.currentUser.username;
    self.profilePhoto.layer.cornerRadius = 50;
    
    // display new profile photo
    if(PFUser.currentUser[@"profilePhoto"]) {
        PFFileObject *file = PFUser.currentUser[@"profilePhoto"];
        NSURL *url = [NSURL URLWithString: file.url];
        [self.profilePhoto setImageWithURL:url];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
