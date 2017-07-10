//
//  OffworldView.m
//  Offworld
//
//  Created by k1ds3ns4t10n on 4/11/17.
//  Copyright © 2017 Gameaholix. All rights reserved.
//

#import "OffworldView.h"

@implementation OffworldView

static NSString * const MyModuleName = @"com.gameaholix.Offworld";

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    
    if (self) {
        [self setAnimationTimeInterval:1/30.0];
    }
    
    mBundle=[NSBundle bundleWithIdentifier:MyModuleName];
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
    
    // draw large logo in an NSImageView and add to our main view as a subview
    // this will automatically scale and center the image to fit our main view
    // and, will also keep it on top of any drawing happening in the main view
    NSImage *logo = [[NSImage alloc] initWithContentsOfFile:[mBundle pathForResource:@"OffworldLogo" ofType:@"png"]];
    NSImageView *imageView=[[NSImageView alloc] initWithFrame:[self bounds]];
    imageView.image = logo;
    [self addSubview:imageView];
}

- (void)stopAnimation
{
    [super stopAnimation];
    
    // remove subview we created in startAnimation (not sure if this is needed really)
    
    // this will remove the last created subview
    //    [[[self subviews] lastObject] removeFromSuperview];
    
    // this will remove all subviews
    for (NSImageView *view in [self subviews]) {
        [view removeFromSuperview];
    }
}

- (void)drawRect:(NSRect)rect
{
//    [super drawRect:rect];
    
    // get size of main view
    NSRect viewBounds = [self bounds];
    
    if (mDrawBackground) {
        // draw background after our view is installed in a window for the first time
        [[NSColor colorWithDeviceRed:0.0 green:0.0 blue:0.0 alpha:1.0] set];
        [NSBezierPath fillRect:viewBounds];
        mDrawBackground = false;
    }
    
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:[mBundle pathForResource:@"OffworldLogo" ofType:@"png"]];
    
    // randomly scale the image
    NSSize newSize;
    float randomScale = SSRandomFloatBetween(2.0, 15.0);
    newSize.width = image.size.width/randomScale;
    newSize.height = image.size.height/randomScale;
    [image setSize:newSize];

    // ramdomly select an origin point for the image
    NSPoint imagePoint = SSRandomPointForSizeWithinRect(newSize, viewBounds);
    
    // slightly adjust random distribution of imagePoint to better fill in edges of view
    switch (SSRandomIntBetween(0, 3))
    {
        case 0:
            imagePoint.x -= newSize.width/randomScale;
            imagePoint.y -= newSize.height/randomScale;
            break;
        case 1:
            imagePoint.x += newSize.width/randomScale;
            imagePoint.y += newSize.height/randomScale;
            break;
        case 2:
            imagePoint.x -= newSize.width/randomScale;
            imagePoint.y += newSize.height/randomScale;
            break;
        case 3:
        default:
            imagePoint.x += newSize.width/randomScale;
            imagePoint.y -= newSize.height/randomScale;
    }
    
    NSColor *color;
    float red, green, blue, alpha;
    
    // randomlly select a color to apply to the image
    switch (SSRandomIntBetween(0,4))
    {
        case 0: // blue
            red = 120.0 / 255.0;
            green = 136.0 / 255.0;
            blue =  232.0 / 255.0;
            alpha = 1.0;
            break;
        case 1: // green
            red = 154.0 / 255.0;
            green = 232.0 / 255.0;
            blue =  120.0 / 255.0;
            alpha = 1.0;
            break;
        case 2: // red
            red = 239.0 / 255.0;
            green = 133.0 / 255.0;
            blue =  112.0 / 255.0;
            alpha = 1.0;
            break;
        case 3: // yellow
            red = 224.0 / 255.0;
            green = 222.0 / 255.0;
            blue =  14.0 / 255.0;
            alpha = 1.0;
            break;
        case 4: // random
        default:
            red = SSRandomFloatBetween(0.0, 255.0) / 255.0;
            green = SSRandomFloatBetween(0.0, 255.0) / 255.0;
            blue = SSRandomFloatBetween(0.0, 255.0) / 255.0;
            alpha = 1.0; //SSRandomFloatBetween(0.0, 255.0) / 255.0;
    }
    
    color = [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:alpha];

    // apply color to  the image
    [image lockFocus];
    [color set];
    NSRect tintRect = {NSZeroPoint, [image size]};
    NSRectFillUsingOperation(tintRect, NSCompositingOperationSourceAtop);
    [image unlockFocus];
    
    // and finally draw the image
    [image drawAtPoint:imagePoint fromRect:NSZeroRect operation:NSCompositingOperationSourceAtop fraction:1.0];
}

- (void)animateOneFrame
{
    [self setNeedsDisplay: true];
}

- (BOOL)hasConfigureSheet
{
    return false;
}

- (NSWindow*)configureSheet
{
//    ScreenSaverDefaults *defaults;
//    defaults = [ScreenSaverDefaults defaultsForModuleWithName:MyModuleName];
//    
//    if(!configSheet)
//    {
//        if(![NSBundle loadNibNamed:@"ConfigureSheet" owner:self])
//        {
//            NSLog(@"Failed to load configure sheet.");
//            NSBeep();
//        }
//    }
//    
//    [drawFilledShapesOption setState:[defaults boolForKey:@"DrawFilledShapes"]];
//    [drawOutlinedShapesOption setState:[defaults boolForKey:@"DrawOutlinedShapes"]];
//    [drawBothOption setState:[defaults boolForKey:@"DrawBoth"]];
//    
    return configSheet;
}

- (IBAction)cancelClick:(id)sender
{
    [[NSApplication sharedApplication] endSheet:configSheet];
}

- (IBAction)okClick:(id)sender
{
    ScreenSaverDefaults *defaults;
    defaults = [ScreenSaverDefaults defaultsForModuleWithName:MyModuleName];
    
    // update our defaults
    [defaults setBool:[drawFilledShapesOption state] forKey:@"DrawFilledShapes"];
    [defaults setBool:[drawOutlinedShapesOption state] forKey:@"DrawOutlinedShapes"];
    [defaults setBool:[drawBothOption state] forKey:@"DrawBoth"];
    
    // save our settings to disk
    [defaults synchronize];
    
    // close the sheet
    [[NSApplication sharedApplication] endSheet:configSheet];
}

- (void)viewDidMoveToWindow {
    mDrawBackground = true;
}


- (BOOL)isOpaque {
    // this keeps Cocoa from unneccessarily redrawing our superview
    return true;
}

@end
