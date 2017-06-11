//
//  OAMapLayers.m
//  OsmAnd
//
//  Created by Alexey Kulish on 08/06/2017.
//  Copyright © 2017 OsmAnd. All rights reserved.
//

#import "OAMapLayers.h"

#import "OAMapViewController.h"
#import "OAMapRendererView.h"

@implementation OAMapLayers
{
    OAMapViewController *_mapViewController;
    OAMapRendererView *_mapView;
    
    NSMapTable<NSString *, OAMapLayer *> *_layers;
}

- (instancetype)initWithMapViewController:(OAMapViewController *)mapViewController
{
    self = [super init];
    if (self)
    {
        _mapViewController = mapViewController;
        _mapView = mapViewController.mapView;
        _layers = [NSMapTable strongToStrongObjectsMapTable];
    }
    return self;
}

- (void) createLayers
{
    _favoritesLayer = [[OAFavoritesLayer alloc] initWithMapViewController:_mapViewController baseOrder:-160000];
    [self addLayer:_favoritesLayer];

    _destinationsLayer = [[OADestinationsLayer alloc] initWithMapViewController:_mapViewController baseOrder:-207000];
    [self addLayer:_destinationsLayer];

    _myPositionLayer = [[OAMyPositionLayer alloc] initWithMapViewController:_mapViewController baseOrder:-206000];
    [self addLayer:_myPositionLayer];

    _contextMenuLayer = [[OAContextMenuLayer alloc] initWithMapViewController:_mapViewController baseOrder:-210000];
    [self addLayer:_contextMenuLayer];

    _hillshadeMapLayer = [[OAHillshadeMapLayer alloc] initWithMapViewController:_mapViewController layerIndex:4];
    [self addLayer:_hillshadeMapLayer];
}

- (void) destroyLayers
{
    for (OAMapLayer *layer in _layers.objectEnumerator)
        [layer deinitLayer];

    [_layers removeAllObjects];
}

- (void) resetRasterLayers
{
    for (OAMapLayer *layer in _layers.objectEnumerator)
        if ([layer isKindOfClass:[OARasterMapLayer class]])
            [((OARasterMapLayer *)layer) resetLayer];
}

- (void) updateRasterLayers
{
    for (OAMapLayer *layer in _layers.objectEnumerator)
        if ([layer isKindOfClass:[OARasterMapLayer class]])
            [((OARasterMapLayer *)layer) updateLayer];
}

- (void) addLayer:(OAMapLayer *)layer
{
    [layer initLayer];
    [_layers setObject:layer forKey:layer.layerId];
}

- (void) showLayer:(NSString *)layerId
{
    OAMapLayer *layer = [_layers objectForKey:layerId];
    if (layer)
        [layer show];
}

- (void) hideLayer:(NSString *)layerId
{
    OAMapLayer *layer = [_layers objectForKey:layerId];
    if (layer)
        [layer hide];
}

- (void) onMapFrameRendered
{
    for (OAMapLayer *layer in _layers.objectEnumerator)
        [layer onMapFrameRendered];
}

@end