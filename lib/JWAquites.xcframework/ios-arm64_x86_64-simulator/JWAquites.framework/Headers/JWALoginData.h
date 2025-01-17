
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JWALoginData : NSObject

/// 是否登录状态
@property (nonatomic, assign) BOOL      isLogin;
/// 用户id
@property (nonatomic, assign) NSInteger userId;
/// 登录手机号
@property (nonatomic, copy) NSString    *phone;
/// 登录标识
@property (nonatomic, copy) NSString    *token;

@end

NS_ASSUME_NONNULL_END
