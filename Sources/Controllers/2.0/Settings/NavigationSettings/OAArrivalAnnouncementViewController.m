//
//  OAArrivalAnnouncementViewController.m
//  OsmAnd Maps
//
//  Created by Anna Bibyk on 25.06.2020.
//  Copyright © 2020 OsmAnd. All rights reserved.
//

#import "OAArrivalAnnouncementViewController.h"
#import "OASettingsTitleTableViewCell.h"
#import "OAAppSettings.h"
#import "OAApplicationMode.h"

#import "Localization.h"
#import "OAColors.h"

#define kSidePadding 16
#define kCellTypeTitle @"OASettingsTitleCell"

@interface OAArrivalAnnouncementViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation OAArrivalAnnouncementViewController
{
    OAAppSettings *_settings;
    NSArray<NSArray *> *_data;
}

- (instancetype) initWithAppMode:(OAApplicationMode *)appMode
{
    self = [super initWithAppMode:appMode];
    if (self)
    {
        _settings = [OAAppSettings sharedManager];
        [self generateData];
    }
    return self;
}

- (void) generateData
{
    NSMutableArray *dataArr = [NSMutableArray array];
    NSArray<NSNumber *> *arrivalNames =  @[ OALocalizedString(@"arrival_distance_factor_early"),
        OALocalizedString(@"arrival_distance_factor_normally"),
        OALocalizedString(@"arrival_distance_factor_late"),
        OALocalizedString(@"arrival_distance_factor_at_last") ];
    NSArray<NSNumber *> *arrivalValues = @[ @1.5f, @1.f, @0.5f, @0.25f ];
    double selectedValue = [_settings.arrivalDistanceFactor get:self.appMode];
    for (int i = 0; i < arrivalNames.count; i++)
    {
        [dataArr addObject:
         @{
           @"name" : arrivalValues[i],
           @"title" : arrivalNames[i],
           @"isSelected" : @(arrivalValues[i].doubleValue == selectedValue),
           @"type" : kCellTypeTitle
         }];
    }
    _data = [NSArray arrayWithObject:dataArr];
}

-(void) applyLocalization
{
    self.titleLabel.text = OALocalizedString(@"arrival_distance");
    self.subtitleLabel.text = self.appMode.name;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setupTableHeaderViewWithText:OALocalizedString(@"arrival_announcement_frequency")];
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self setupTableHeaderViewWithText:OALocalizedString(@"arrival_announcement_frequency")];
        [self.tableView reloadData];
    } completion:nil];
}

#pragma mark - TableView

- (nonnull UITableViewCell *) tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSDictionary *item = _data[indexPath.section][indexPath.row];
    NSString *cellType = item[@"type"];
    if ([cellType isEqualToString:kCellTypeTitle])
    {
        static NSString* const identifierCell = kCellTypeTitle;
        OASettingsTitleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:identifierCell owner:self options:nil];
            cell = (OASettingsTitleTableViewCell *)[nib objectAtIndex:0];
            cell.iconView.image = [[UIImage imageNamed:@"ic_checkmark_default"]  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            cell.iconView.tintColor = UIColorFromRGB(color_primary_purple);
        }
        if (cell)
        {
            cell.textView.text = item[@"title"];
            cell.iconView.hidden = ![item[@"isSelected"] boolValue];
        }
        return cell;
    }
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 17.0;
}

- (NSInteger) tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data[section].count;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return _data.count;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectArrivalDistanceFactor:_data[indexPath.section][indexPath.row]];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) selectArrivalDistanceFactor:(NSDictionary *)item
{
    [_settings.arrivalDistanceFactor set:((NSNumber *)item[@"name"]).doubleValue mode:self.appMode];
    [self backButtonClicked:nil];
}

@end
