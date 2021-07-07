//
//  PostCell.h
//  Instagram
//
//  Created by gracezhg on 7/6/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell

@property (strong, nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

- (void)setCellData:(Post *)post;

@end

NS_ASSUME_NONNULL_END
