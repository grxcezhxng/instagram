//
//  User.h
//  Instagram
//
//  Created by gracezhg on 7/9/21.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) PFFileObject *profilePhoto;

+ (void) postNewUser: (PFUser *) user withImage:( UIImage * _Nullable )image withUsername: ( NSString * _Nullable )username withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
