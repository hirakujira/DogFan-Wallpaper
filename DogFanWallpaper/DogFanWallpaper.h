#import <UIKit/UIKit.h>
#import "SBFProceduralWallpaper.h"

@interface DogFanWallpaper : UIView <SBFProceduralWallpaper> {
    UIImageView* cover;
    UIImageView *fan;
    BOOL isAnimating;
    float x;
    float y;
    float offset;
    float rpm;
    NSDictionary* plistDict;
}
@property (nonatomic, retain)NSTimer* fanSpinTimer;
@property (nonatomic, retain)NSTimer* shakeTimer;
- (void)shake1;
- (void)shake2;
- (void)shake3;
- (void)shake4;
- (void)spin;
@end
