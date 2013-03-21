//
//  UIBarButtonItem+Image.m
//  pangu
//
//  Created by Kyle on 12-10-26.
//
//

#import "CustomUIBarButtonItem.h"
#define kOrgX 13
#define kItemWidthMax 110

@implementation CustomUIBarButtonItem

- (void)dealloc
{
    [super dealloc];
}

+(UIBarButtonItem *)initWithImage:(UIImage *)image eventImg:(UIImage *)eventImage title:(NSString*)title target:(id)target action:(SEL)action{
    UIView *view;
    if (image) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont boldSystemFontOfSize:13];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.shadowOffset = CGSizeMake(0, -1);
        titleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
        titleLabel.textAlignment = UITextAlignmentLeft;
        titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
        CGFloat width = image.size.width;
        if (title) {
            CGSize titSize = [title sizeWithFont:titleLabel.font];
            if (titSize.width+ 2*kOrgX > width) {
                width = titSize.width+ 2*kOrgX ;
            }
            width = width > kItemWidthMax? kItemWidthMax: width;
        }
        titleLabel.frame = CGRectMake(kOrgX, 0, width-kOrgX, image.size.height);
        button.frame= CGRectMake(0.0, 0.0, width, image.size.height);
        [button addSubview:titleLabel];
        [titleLabel release];
        titleLabel.text = title;
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setBackgroundImage:eventImage forState:UIControlEventTouchDown];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
         view =[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, width, image.size.height) ];
        [view addSubview:button];

    }else{;
        view =[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50, 40) ];
    }
      
    UIBarButtonItem *itemButton = [[[UIBarButtonItem alloc] initWithCustomView:view] autorelease];
    
    [view release];
   
    
    return itemButton;
}

-(void)setEnabled:(BOOL)enabled {
    if (self.customView) {
        if ([[self.customView.subviews objectAtIndex:0] isKindOfClass:[UIButton class]]) {
            ((UIButton*)[self.customView.subviews objectAtIndex:0]).enabled = enabled;
        }
    }
}

@end
