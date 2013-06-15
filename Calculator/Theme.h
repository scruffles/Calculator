#import <Foundation/Foundation.h>


@interface Theme : NSObject

- (Theme*)initWithLcdImage:(NSString *)lcdImage backgroundColor:(UIColor *)backgroundColor backgroundImage:(NSString*) backgroundImage;

- (UIImage *)getLcdImage;

- (UIColor *)getBackgroundColor;

- (UIImage *)getBackgroundImage;
@end