#import "ThemeLoader.h"
#import "Theme.h"

@implementation ThemeLoader {
@private
    NSString *currentTheme;
    NSArray *themes;
    Theme *_theme;
}

#define ALL_RESULTS_KEY @"ALL"
#define WHITE [UIColor colorWithRed:1 green:1 blue:1 alpha:1]
#define BLACK [UIColor colorWithRed:(99/255.0) green:(99/255.0) blue:(99/255.0) alpha:1]
#define RAINBOW_PURPLE [UIColor colorWithRed:(221/255.0) green:(31/255.0) blue:(196/255.0) alpha:1]

@synthesize theme = _theme;
- (id)init {
    self = [super init];
    themes =
        @[
            @{
                @"id" : @"A",
                @"title" : @"All White",
                @"impl" : [[Theme alloc]
                    initWithLcdImage:@"lcd-white.png"
                     backgroundColor:WHITE
                     backgroundImage:NULL]
            },
            @{
                @"id" : @"B",
                @"title" : @"White Textured",
                @"impl" : [[Theme alloc]
                    initWithLcdImage:@"lcd-white-textured.png"
                     backgroundColor:WHITE
                     backgroundImage:NULL]
            },
            @{
                @"id" : @"C",
                @"title" : @"Grey over White",
                @"impl" : [[Theme alloc]
                    initWithLcdImage:@"lcd-grey.png"
                     backgroundColor:WHITE
                     backgroundImage:@"background-white-raised.png"]
            },
            @{
                @"id" : @"D",
                @"title" : @"Black over White",
                    @"impl" : [[Theme alloc]
                    initWithLcdImage:@"lcd.png"
                     backgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:1]
                     backgroundImage:NULL]
            },
            @{
                @"id" : @"E",
                @"title" : @"Dark",
                    @"impl" : [[Theme alloc]
                    initWithLcdImage:@"lcd.png"
                    backgroundColor:BLACK
                    backgroundImage:NULL]
            },
            @{
                @"id" : @"F",
                @"title" : @"Rainbow",
                @"impl" : [[Theme alloc]
                    initWithLcdImage:@"lcd-rainbow.png"
                     backgroundColor:RAINBOW_PURPLE
                     backgroundImage:@"background-rainbow.png"]
            }
        ];
    return self;
}

- (NSArray *)getAllThemes {
    return themes;
}

- (void)getThemeFromPreferences {
    currentTheme = ([[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] mutableCopy])[@"theme"];
    self.theme = [themes[[self getCurrentThemeIndex]] valueForKey:@"impl"];
}

- (void) saveThemeToPreferences {
    NSMutableDictionary *prefs = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] mutableCopy];
    if(!prefs) prefs = [[NSMutableDictionary alloc] init];
    prefs[@"theme"] = currentTheme;
    [[NSUserDefaults standardUserDefaults] setObject:prefs forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (ThemeLoader *)instance {
    static ThemeLoader *_instance = nil;
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
            [_instance getThemeFromPreferences];
        }
    }
    return _instance;
}

- (NSInteger)getCurrentThemeIndex {
    __block int returnValue = 0;
    [themes enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
        if ([[object valueForKey:@"id"] isEqualToString:currentTheme]) {
            returnValue = idx;
            return;
        }
    }];
    return returnValue;
}

- (void)setCurrentTheme:(NSString *)string {
    currentTheme = string;
    [self saveThemeToPreferences];
    self.theme = [themes[[self getCurrentThemeIndex]] valueForKey:@"impl"];
}
@end
