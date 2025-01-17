

#import <Foundation/Foundation.h>
#import <JWAquites/JWALoginData.h>

@protocol WebProDelegate <NSObject>

/**
 *  即将进入登录页的回调
 *  @param showGuestLogin 是否显示游客按钮
 */
- (void)appWillEnterLoginPage:(BOOL)showGuestLogin;

/**
 *  即将进入主页的回调
 *  @param data 登录信息
 */
- (void)appWillEnterMainPage:(JWALoginData *)data;

@end
