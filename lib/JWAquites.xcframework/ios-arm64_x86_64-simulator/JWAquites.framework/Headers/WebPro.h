

#import <UIKit/UIKit.h>
#import <JWAquites/JWAConfigInfo.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebPro : NSObject

/**
 *  初始化方法
 *  @param configuration SDK配置回调
 */
+ (void)initWithConfiguration:(void (^)(JWAConfigInfo *config))configuration;

/**
 *  跳转到主页
 *  @param viewController 主页视图控制器
 */
+ (void)enterMainPage:(UIViewController *)viewController;

/**
 *  跳转到登录页
 *  @param viewController 登录页视图控制器
 */
+ (void)enterLoginPage:(UIViewController *)viewController;

/**
 *  发送验证码短信
 *  @param phone 手机号
 *  @param completion 发送结果回调，如果success为YES，则开始倒计时，否则无操作
 */
+ (void)sendSmsToPhone:(NSString *)phone completion:(void (^)(BOOL success))completion;

/**
 *  发送验证码短信
 *  @param phone 手机号
 *  @param toastHidden 隐藏toast
 *  @param completion 发送结果回调，如果success为YES，则开始倒计时，否则无操作
 */
+ (void)sendSmsToPhone:(NSString *)phone toastHidden:(BOOL)toastHidden completion:(void (^)(BOOL success))completion;

/**
 *  验证码登录
 *  @param phone 手机号
 *  @param code 验证码
 */
+ (void)loginPhone:(NSString *)phone withCode:(NSString *)code;

/**
 *  验证码登录
 *  @param phone 手机号
 *  @param code 验证码
 *  @param toastHidden 隐藏toast
 */
+ (void)loginPhone:(NSString *)phone withCode:(NSString *)code toastHidden:(BOOL)toastHidden;

/**
 *  退出登录
 */
+ (void)logoutAccount;

@end

NS_ASSUME_NONNULL_END
