//
//  OffworldView.h
//  Offworld
//
//  Created by k1ds3ns4t10n on 4/11/17.
//  Copyright © 2017 Gameaholix. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>

@interface OffworldView : ScreenSaverView
{
    IBOutlet id configSheet;
    IBOutlet id drawFilledShapesOption;
    IBOutlet id drawOutlinedShapesOption;
    IBOutlet id drawBothOption;
    
    BOOL mDrawBackground;
    NSBundle *mBundle;
}

@end
