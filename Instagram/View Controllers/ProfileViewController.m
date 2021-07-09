//
//  ProfileViewController.m
//  Instagram
//
//  Created by gracezhg on 7/9/21.
//

#import "ProfileViewController.h"
#import "User.h"
#import <Parse/PFImageView.h>

@interface ProfileViewController () <UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profilePhoto;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchUser];
    [self renderView];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    
    
    self.profilePhoto.userInteractionEnabled = YES;
}

- (void) fetchUser {
    PFQuery *userQuery = [PFQuery queryWithClassName:@"User"];
    [userQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    [userQuery includeKey:@"username"];
    [userQuery includeKey:@"profilePhoto"];
    userQuery.limit = 1;
    
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (users != nil) {
            self.user = users[0];
            NSLog(@"%@", self.user);
            [self renderView];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
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
    
    self.usernameLabel.text  = self.user[@"username"];
    self.profilePhoto.layer.cornerRadius = 50;
    
    UIImage *latestPhoto = [self resizeImage:self.profilePhoto.image withSize:CGSizeMake(100, 100)];
    self.user.profilePhoto = [self getPFFileFromImage:latestPhoto];
    NSLog(@"Profile photo %@", self.user.profilePhoto);
    NSURL * imageURL = [NSURL URLWithString:self.user.profilePhoto.url];
    NSLog(@"Profile page photo link %@", imageURL);
    [self.profilePhoto loadInBackground];
    
    // [[PFUser currentUser] setObject:<#(nonnull id)#> forKey:@"profilePhtoto"];
    
    
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            NSLog(@"succeeded %@", imageURL);
        }
        else {
            NSLog(@"error: %@", error);
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) renderView {
    self.usernameLabel.text  = self.user[@"username"];
    self.profilePhoto.layer.cornerRadius = 50;
    
    UIImage *latestPhoto = [self resizeImage:self.profilePhoto.image withSize:CGSizeMake(100, 100)];
    self.user.profilePhoto = [self getPFFileFromImage:latestPhoto];
    NSLog(@"Profile photo %@", self.user.profilePhoto);
    NSURL * imageURL = [NSURL URLWithString:self.user.profilePhoto.url];
    NSLog(@"Profile page photo link %@", imageURL);
    [self.profilePhoto loadInBackground];
    [self.user saveInBackgroundWithBlock:nil];
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
