//
//  OANavAutoZoomMapAction.m
//  OsmAnd
//
//  Created by Paul on 8/13/19.
//  Copyright © 2019 OsmAnd. All rights reserved.
//

#import "OANavAutoZoomMapAction.h"
#import "OAAppSettings.h"

@implementation OANavAutoZoomMapAction

- (instancetype)init
{
    return [super initWithType:EOAQuickActionTypeAutoZoomMap];
}

- (void)execute
{
    OAAppSettings *settings = [OAAppSettings sharedManager];
    [settings.autoZoomMap set:![settings.autoZoomMap get]];
}

@end
