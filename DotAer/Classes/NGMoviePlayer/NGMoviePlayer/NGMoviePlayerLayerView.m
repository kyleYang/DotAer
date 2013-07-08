#import "NGMoviePlayerLayerView.h"
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@implementation NGMoviePlayerLayerView

////////////////////////////////////////////////////////////////////////
#pragma mark - Class Methods
////////////////////////////////////////////////////////////////////////

+ (Class)layerClass {
    return [AVPlayerLayer class];
}
@end
