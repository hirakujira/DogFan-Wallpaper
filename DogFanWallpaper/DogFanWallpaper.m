#import "DogFanWallpaper.h"
#define _4inch  [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568.0

@interface _UILegibilitySettings : NSObject {
@private
	int _style;
	UIColor* _contentColor;
	UIColor* _primaryColor;
	UIColor* _secondaryColor;
	UIColor* _shadowColor;
	float _shadowRadius;
	float _shadowAlpha;
	float _imageOutset;
	NSString* _shadowCompositingFilterName;
}
@property(copy, nonatomic) NSString* shadowCompositingFilterName;
@property(assign, nonatomic) float imageOutset;
@property(assign, nonatomic) float shadowAlpha;
@property(assign, nonatomic) float shadowRadius;
@property(retain, nonatomic) UIColor* shadowColor;
@property(retain, nonatomic) UIColor* secondaryColor;
@property(retain, nonatomic) UIColor* primaryColor;
@property(retain, nonatomic) UIColor* contentColor;
@property(assign, nonatomic) int style;
+(id)sharedInstanceForStyle:(int)style;
-(BOOL)isEqual:(id)equal;
-(void)setPropertiesForStyle:(int)style;
-(void)dealloc;
-(id)initWithStyle:(int)style primaryColor:(id)color secondaryColor:(id)color3 shadowColor:(id)color4;
-(id)initWithStyle:(int)style contentColor:(id)color;
-(id)initWithContentColor:(id)contentColor contrast:(float)contrast;
-(id)initWithContentColor:(id)contentColor;
-(id)initWithStyle:(int)style;
@end


@interface DogFanWallpaper ()
@end

@implementation DogFanWallpaper


@synthesize delegate = _delegate;

+ (NSString *)identifier
{
    return @"DogFanWallpaper";
}

+ (BOOL)colorChangesSignificantly
{
    return YES;
}

+ (NSArray *)presetWallpaperOptions
{
    return @[
             @{ @"kSBUIMagicWallpaperThumbnailNameKey": @"Preview",@"info": @"" },
             ];
}

- (void)setWallpaperOptions:(NSDictionary *)options
{

}

- (void)setWallpaperVariant:(int)variant
{
    
}

- (UIView *)view
{
    return self;
}

-(_UILegibilitySettings *)legibilitySettings
{
    //NSLog(@"%@", [NSThread callStackSymbols]);
    _UILegibilitySettings* setting = [[_UILegibilitySettings alloc] initWithStyle:2];
    return setting;
}

#pragma mark - Wallpaper implementation

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"legibilitySettingsBlack" object:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    if (_4inch) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"LockBackground-568@2x" ofType:@"png"]]];
    }
    else
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"LockBackground@2x" ofType:@"png"]]];
    
    
    plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/tw.hiraku.dogfan.plist"];
    
    rpm = [[plistDict objectForKey:@"rpm"] floatValue];
    offset = [[plistDict objectForKey:@"offset"] floatValue];
    if (rpm < 10)
        rpm = 150;
    
    fan = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"fan@2x" ofType:@"png"]]];
    fan.frame = CGRectMake(self.frame.size.width/2-64, self.frame.size.height/2-40, 128, 128);
    [self addSubview:fan];
    
    cover = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"cover@2x" ofType:@"png"]]];
    cover.frame = CGRectMake(self.frame.size.width/2-101, self.frame.size.height/2-87, 200, 200);
    x = cover.frame.origin.x;
    y = cover.frame.origin.y;
    [self addSubview:cover];
    
    return self;
}

- (void)spin
{
    [UIView animateWithDuration: 15/rpm
                          delay: 0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations: ^{fan.transform = CGAffineTransformRotate(fan.transform, M_PI / 2);}
                     completion:nil];
}

-(void)shake1
{
    [UIView animateWithDuration:0.05f delay:0.00f options: UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAutoreverse animations:^{cover.frame = CGRectMake(x - offset, y , cover.frame.size.width, cover.frame.size.height);} completion:^(BOOL finished){[self shake2]; }];
}

-(void)shake2
{
    [UIView animateWithDuration:0.05f delay:0.00f options: UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAutoreverse animations:^{cover.frame = CGRectMake(x, y + offset, cover.frame.size.width, cover.frame.size.height);} completion:^(BOOL finished){[self shake3]; }];
}

-(void)shake3
{
    [UIView animateWithDuration:0.05f delay:0.00f options: UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAutoreverse animations:^{cover.frame = CGRectMake(x + offset, y, cover.frame.size.width, cover.frame.size.height);} completion:^(BOOL finished){[self shake4]; }];
}

-(void)shake4
{
    [UIView animateWithDuration:0.05f delay:0.00f options: UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAutoreverse animations:^{cover.frame = CGRectMake(x, y - offset, cover.frame.size.width, cover.frame.size.height);} completion:nil];
}

- (void)setAnimating:(BOOL)animating
{
    if (animating)
        NSLog(@"Should Spin now");
    else
        NSLog(@"Should Stop now");
    if (!lock && animating) {
        lock = YES;
        NSLog(@"Spining now");
        self.fanSpinTimer = [NSTimer scheduledTimerWithTimeInterval:(15/rpm) target:self selector:@selector(spin) userInfo:nil repeats:YES];
        if (offset > 0 && rpm > 256) {
            self.shakeTimer = [NSTimer scheduledTimerWithTimeInterval:(0.2) target:self selector:@selector(shake1) userInfo:nil repeats:YES];
        }
        
    }
    else if (lock && !animating)
    {
        NSLog(@"Stopping now");
        lock = NO;
        [self.fanSpinTimer invalidate];
        self.fanSpinTimer = nil;
        [self.shakeTimer invalidate];
        self.shakeTimer = nil;
        //cover.frame = CGRectMake(self.frame.size.width/2-101, self.frame.size.height/2-87, 200, 200);
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
