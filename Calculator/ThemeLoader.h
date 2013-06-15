#import <Foundation/Foundation.h>

@class Theme;

@interface ThemeLoader : NSObject

@property (nonatomic, retain) IBOutlet Theme *theme;

- (NSArray *)getAllThemes;

+ (ThemeLoader *)instance;

- (NSInteger)getCurrentThemeIndex;

- (void)setCurrentTheme:(NSString *)string;
@end
