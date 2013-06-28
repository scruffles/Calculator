#import "ViewController.h"
#import "ThemeLoader.h"
#import "Theme.h"

void keysFallOff();

@interface ViewController ()
    @property(nonatomic, strong) UIDynamicAnimator *animator;
@end


@implementation ViewController {
@private
    NSString *_currentTotal;
    NSString *_operation;
    NSString *_lastValue;
    bool _nextNumberIsNewValue;
    bool _uncalculated;
}

NSString *const Addition = @"Addition";
NSString *const Subtraction = @"Subtraction";
NSString *const Multiplication = @"Multiplication";
NSString *const Division = @"Division";

+ (ViewController *)instance {
    static ViewController *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ThemeLoader *themeLoader = [ThemeLoader instance];
    [themeLoader addObserver:self forKeyPath:@"theme" options:NSKeyValueObservingOptionNew context:NULL];
    [self reApplyTheme:[themeLoader theme]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self reApplyTheme: change[@"new"]];
}

- (void)reApplyTheme: (Theme*) theme {
    _lcdImage.image = [theme getLcdImage];
    self.view.backgroundColor = [theme getBackgroundColor];
    UIImage *bgImage = [theme getBackgroundImage];
    _backgroundImage.image = bgImage != NULL ? bgImage : nil;
}

- (bool)displayContainsDot {
    return [self string:_displayLabel.text contains:@"."];
}

- (bool)string:(NSString *)stringA contains:(NSString *)stringB {
    return [stringA rangeOfString:stringB].location != NSNotFound;
}

- (void)setDisplay:(NSString *)newCharacters {
    if ([newCharacters isEqualToString:@"666"]) {
        [self keysFallOff];
    }
    _displayLabel.text = newCharacters;
}

- (void)appendToDisplay:(NSString *)newCharacters {
    if ([newCharacters isEqualToString:@"."] && [self displayContainsDot]) {
        return;
    }

    [self numberKeyPressed];

    if ([_displayLabel.text isEqualToString:@"0"]) {
        [self setDisplay:newCharacters];
    } else if ([newCharacters isEqualToString:@"."]) {
        [self setDisplay:[NSString stringWithFormat:@"%@%@", _displayLabel.text, @"."]];
    } else {
        [self setDisplay:[NSString stringWithFormat:@"%@%@", _displayLabel.text, newCharacters]];
    }
    _lastValue = _displayLabel.text;
}

- (NSString *)performOperation:(NSString *)operation val1:(NSString *)val1 val2:(NSString *)val2 {
    if (operation == Addition) {
        return [NSString stringWithFormat:@"%g", [val1 doubleValue] + [val2 doubleValue]];
    } else if (operation == Subtraction) {
        return [NSString stringWithFormat:@"%g", [val1 doubleValue] - [val2 doubleValue]];
    } else if (operation == Multiplication) {
        return [NSString stringWithFormat:@"%g", [val1 doubleValue] * [val2 doubleValue]];
    } else if (operation == Division) {
        return [NSString stringWithFormat:@"%g", [val1 doubleValue] / [val2 doubleValue]];
    }
    return nil;
}

- (IBAction)buttonPressed:(id)sender {
    int tag = ((UIButton *) sender).tag;
    if (tag < 10) {
        [self appendToDisplay:[NSString stringWithFormat:@"%d", tag]];
    } else if (tag == 10) {
        [self appendToDisplay:@"0"];
    } else if (tag == 11) {
        [self equalsPressed];
    } else if (tag == 12) {
        [self appendToDisplay:@"."];
    } else if (tag == 13) {
        [self changeOperator:Subtraction];
    } else if (tag == 14) {
        [self changeOperator:Addition];
    } else if (tag == 15) {
        [self changeOperator:Multiplication];
    } else if (tag == 16) {
        [self changeOperator:Division];
    } else if (tag == 17) {
        NSLog(@"Delete pressed");
    } else if (tag == 18) {
        [self clearPressed];
    }
}

- (void)numberKeyPressed {
    _uncalculated = true;
    if (_nextNumberIsNewValue) {
        _displayLabel.text = @"0";
        _nextNumberIsNewValue = false;
    }
    _lastValue = _displayLabel.text;
}

- (void)changeOperator:(NSString * const)newOperator {
    if (_currentTotal == nil) {
        _currentTotal = _displayLabel.text;
    } else if (_uncalculated) {
        [self recalculateAndDisplayTotal];
    }
    _nextNumberIsNewValue = true;
    _operation = newOperator;
}

- (void)equalsPressed {
    [self recalculateAndDisplayTotal];
}

- (void)clearPressed {
    _displayLabel.text = @"0";
    _currentTotal = @"0";
    _nextNumberIsNewValue = false;
    _currentTotal = nil;
    _lastValue = nil;
    _uncalculated=true;
}

- (void)recalculateTotal {
    _currentTotal = [self performOperation:_operation val1:_currentTotal val2:_lastValue];
    _uncalculated=false;
}

- (void)recalculateAndDisplayTotal {
    [self recalculateTotal];
    [self setDisplay:_currentTotal];
}

- (void)keysFallOff {
    UIDynamicAnimator* animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    NSMutableArray * array = [[NSMutableArray alloc] init];
    for (UIView *subview in [self view].subviews) {
        if ([subview isKindOfClass:UIButton.class]) {
            [array addObject:subview];
        }
    }

    UIGravityBehavior* gravityBehavior = [[UIGravityBehavior alloc] initWithItems:array];
    UICollisionBehavior* collisionBehavior = [[UICollisionBehavior alloc] initWithItems:array];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [animator addBehavior:gravityBehavior];
    [animator addBehavior:collisionBehavior];
    collisionBehavior.collisionDelegate = self;
    self.animator = animator;
}

@end
