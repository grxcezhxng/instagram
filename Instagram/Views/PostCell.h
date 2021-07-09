//
//  PostCell.h
//  Instagram
//
//  Created by gracezhg on 7/6/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "User.h"
#import "Parse/Parse.h"

@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell

@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) User *user;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet PFImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;

- (void)setCellData;

@end

NS_ASSUME_NONNULL_END
