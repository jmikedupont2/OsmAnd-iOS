//
//  OANavReplaceDestinationAction.m
//  OsmAnd
//
//  Created by Paul on 8/13/19.
//  Copyright © 2019 OsmAnd. All rights reserved.
//

#import "OANavReplaceDestinationAction.h"
#import "OARootViewController.h"
#import "OAMapPanelViewController.h"
#import "OAMapRendererView.h"
#import "OATargetPoint.h"
#import "OATargetPointsHelper.h"
#import "OAPointDescription.h"
#import "OAMapActions.h"
#import "OsmAndApp.h"

#include <OsmAndCore/Utilities.h>

@implementation OANavReplaceDestinationAction

- (instancetype)init
{
    return [super initWithType:EOAQuickActionTypeReplaceDestination];
}

- (void)execute
{
    OAMapPanelViewController *mapPanel = [OARootViewController instance].mapPanel;
    const auto& latLon = OsmAnd::Utilities::convert31ToLatLon(mapPanel.mapViewController.mapView.target31);
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latLon.latitude longitude:latLon.longitude];
    
    OATargetPointsHelper *targetPointsHelper = [OATargetPointsHelper sharedInstance];
    [targetPointsHelper navigateToPoint:location updateRoute:YES intermediate:-1 historyName:[[OAPointDescription alloc] initWithType:POINT_TYPE_LOCATION name:@""]];
    if (![[OsmAndApp instance].data restorePointToStart])
        [mapPanel.mapActions enterRoutePlanningModeGivenGpx:nil from:nil fromName:nil useIntermediatePointsByDefault:YES showDialog:YES];
}

@end
