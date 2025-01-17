
#import <Foundation/Foundation.h>
#import <JWAquites/WebProDelegate.h>

NS_ASSUME_NONNULL_BEGIN

@interface JWAConfigInfo : NSObject

/// 包名
@property (nonatomic, copy) NSString            *bundleID;
/// 域名
@property (nonatomic, copy) NSString            *host;
/// 代理
@property (nonatomic, weak) id<WebProDelegate>  delegate;
/// 开发环境
@property (nonatomic, assign) BOOL              isDev;

@end

NS_ASSUME_NONNULL_END
