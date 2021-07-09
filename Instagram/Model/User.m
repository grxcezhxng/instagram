//
//  User.m
//  Instagram
//
//  Created by gracezhg on 7/9/21.
//

#import "User.h"

@implementation User

@dynamic userID;
@dynamic user;
@dynamic username;
@dynamic profilePhoto;

+ (nonnull NSString *)parseClassName {
    return @"User";
}

+ (void) postNewUser: (PFUser *) user withImage:( UIImage * _Nullable )image withUsername: ( NSString * _Nullable )username withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    User *newUser = [User new];
    newUser.profilePhoto = [self getPFFileFromImage:image];
    newUser.user = [PFUser currentUser];
    newUser.username = username;
    
    [newUser saveInBackgroundWithBlock: completion];
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

@end
