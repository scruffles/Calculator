#import "Theme.h"


@implementation Theme {
@private
    NSString *_lcdImage;
    NSString *_backgroundImage;
    UIColor *_backgroundColor;
}

- (Theme*)initWithLcdImage:(NSString *)lcdImage backgroundColor:(UIColor *)backgroundColor backgroundImage:(NSString*) backgroundImage {
    self = [super init];
    if (self) {
        _lcdImage = lcdImage;
        _backgroundColor = backgroundColor;
        _backgroundImage = backgroundImage;
    }
    return self;
}

- (UIImage*)getLcdImage {
    return [UIImage imageNamed:_lcdImage];
}

- (UIColor*)getBackgroundColor {
    return _backgroundColor;
}

- (UIImage*)getBackgroundImage {
    if (_backgroundImage)
        return [UIImage imageNamed:_backgroundImage];
    else
        return NULL;
}

@end