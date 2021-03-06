//
//  OADefaultSpeedViewController.m
//  OsmAnd Maps
//
//  Created by Anna Bibyk on 30.06.2020.
//  Copyright © 2020 OsmAnd. All rights reserved.
//

#import "OADefaultSpeedViewController.h"
#import "OATimeTableViewCell.h"
#import "OACustomPickerTableViewCell.h"

#import "Localization.h"
#import "OAColors.h"

#define kCellTypeSpeed @"time_cell"
#define kCellTypePicker @"pickerCell"
#define kMinSpeedSection 0
#define kDefaultSpeedSection 1
#define kMaxSpeedSection 2

@interface OADefaultSpeedViewController() <OACustomPickerTableViewCellDelegate>

@end

@implementation OADefaultSpeedViewController
{
    NSArray<NSArray *> *_data;
    OAApplicationMode *_applicationMode;
    NSString *_vehicleParameter;
    NSIndexPath *_pickerIndexPath;
    NSArray<NSNumber *> *_possibleSpeedValues;
    NSArray<NSString *> *_possibleSpeedValuesString;
    NSNumber *_minSpeedValue;
    NSNumber *_defaultSpeedValue;
    NSNumber *_maxSpeedValue;
    NSInteger _selectedSection;
}

- (instancetype)initWithApplicationMode:(OAApplicationMode *)ap
{
    self = [super init];
    if (self)
    {
        _applicationMode = ap;
    }
    return self;
}

- (void) commonInit
{
    [self generateData];
}

- (void) applyLocalization
{
    self.titleLabel.text = OALocalizedString(@"default_speed");
    self.subtitleLabel.text = _applicationMode.name;
    [self.cancelButton setTitle:OALocalizedString(@"shared_string_cancel") forState:UIControlStateNormal];
    [self.doneButton setTitle:OALocalizedString(@"shared_string_done") forState:UIControlStateNormal];
}

- (void) generateData
{
    _possibleSpeedValues = @[ @5, @10, @15, @20, @25, @30, @35, @40, @45, @50, @55, @60, @120, @130, @140, @150 ];
    NSMutableArray *array = [NSMutableArray array];
    for (NSNumber *val in _possibleSpeedValues)
        [array addObject:[NSString stringWithFormat:@"%d %@", val.intValue, OALocalizedString(@"units_kmh")]];
    _possibleSpeedValuesString = [NSArray arrayWithArray:array];
    _minSpeedValue = [NSNumber numberWithInteger:20]; // needs to be changed
    _defaultSpeedValue = [NSNumber numberWithInteger:45]; // needs to be changed
    _maxSpeedValue = [NSNumber numberWithInteger:130]; // needs to be changed
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setupTableHeaderViewWithText:@"Change me"]; // needs to be changed
    [self setupView];
}

- (void) setupView
{
    NSMutableArray *tableData = [NSMutableArray array];
    NSMutableArray *minSpeedArr = [NSMutableArray array];
    NSMutableArray *defaultSpeedArr = [NSMutableArray array];
    NSMutableArray *maxSpeedArr = [NSMutableArray array];
    [minSpeedArr addObject:@{
        @"type" : kCellTypeSpeed,
        @"title" : OALocalizedString(@"min_speed"),
        @"value" : _minSpeedValue,
    }];
    [minSpeedArr addObject:@{
        @"type" : kCellTypePicker,
    }];
    [defaultSpeedArr addObject:@{
        @"type" : kCellTypeSpeed,
        @"title" : OALocalizedString(@"default_speed"),
        @"value" : _defaultSpeedValue,
    }];
    [defaultSpeedArr addObject:@{
        @"type" : kCellTypePicker,
    }];
    [maxSpeedArr addObject:@{
        @"type" : kCellTypeSpeed,
        @"title" : OALocalizedString(@"max_speed"),
        @"value" : _maxSpeedValue,
    }];
    [maxSpeedArr addObject:@{
        @"type" : kCellTypePicker,
    }];
    [tableData addObject:minSpeedArr];
    [tableData addObject:defaultSpeedArr];
    [tableData addObject:maxSpeedArr];
    _data = [NSArray arrayWithArray:tableData];
}

- (IBAction)doneButtonPressed:(id)sender {
}

- (nonnull UITableViewCell *) tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSDictionary *item = _data[indexPath.section][indexPath.row];
    NSString *cellType = item[@"type"];
    if ([cellType isEqualToString:kCellTypeSpeed])
    {
        static NSString* const identifierCell = @"OATimeTableViewCell";
        OATimeTableViewCell* cell;
        cell = (OATimeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifierCell];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OATimeCell" owner:self options:nil];
            cell = (OATimeTableViewCell *)[nib objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.lbTitle.text = item[@"title"];
        cell.lbTime.text = [NSString stringWithFormat:@"%@ %@", item[@"value"], OALocalizedString(@"units_kmh")];
        cell.lbTime.textColor = UIColorFromRGB(color_text_footer);

        return cell;
    }
    else if ([cellType isEqualToString:kCellTypePicker])
    {
        static NSString* const identifierCell = @"OACustomPickerTableViewCell";
        OACustomPickerTableViewCell* cell;
        cell = (OACustomPickerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifierCell];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OACustomPickerCell" owner:self options:nil];
            cell = (OACustomPickerTableViewCell *)[nib objectAtIndex:0];
        }
        cell.dataArray = _possibleSpeedValuesString;
        NSInteger rowValue = 0;
        if (indexPath.section == kMinSpeedSection)
            rowValue = [_possibleSpeedValues indexOfObject:_minSpeedValue];
        else if (indexPath.section == kDefaultSpeedSection)
            rowValue = [_possibleSpeedValues indexOfObject:_defaultSpeedValue];
        else if (indexPath.section == kMaxSpeedSection)
            rowValue = [_possibleSpeedValues indexOfObject:_maxSpeedValue];
        [cell.picker selectRow:rowValue inComponent:0 animated:NO];
        cell.picker.tag = indexPath.section;
        cell.delegate = self;
        return cell;
    }
    return nil;
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self setupTableHeaderViewWithText:@"Change me"]; // needs to be changed
        [self.tableView reloadData];
    } completion:nil];
}

#pragma mark - TableView

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    // needs to be changed
    return @"Change me";
}

- (NSInteger) tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == _selectedSection)
    {
        if ([self pickerIsShown])
            return 2;
        return 1;
    }
    return 1;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath isEqual:_pickerIndexPath])
        return 162.0;
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 17.;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedSection = indexPath.section;
    NSDictionary *item = _data[indexPath.section][indexPath.row];
    if ([item[@"type"] isEqualToString:kCellTypeSpeed])
    {
        [self.tableView beginUpdates];

        if ([self pickerIsShown] && (_pickerIndexPath.section == indexPath.section))
            [self hideExistingPicker];
        else
        {
            NSIndexPath *newPickerIndexPath = [self calculateIndexPathForNewPicker:indexPath];
            if ([self pickerIsShown])
                [self hideExistingPicker];

            [self showNewPickerAtIndex:newPickerIndexPath];
            _pickerIndexPath = [NSIndexPath indexPathForRow:newPickerIndexPath.row + 1 inSection:indexPath.section];
        }
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.tableView endUpdates];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark - Picker

- (BOOL) pickerIsShown
{
    return _pickerIndexPath != nil;
}

- (void) hideExistingPicker {
    
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_pickerIndexPath.row inSection:_pickerIndexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
    _pickerIndexPath = nil;
}

- (void) hidePicker
{
    [self.tableView beginUpdates];
    if ([self pickerIsShown])
        [self hideExistingPicker];
    [self.tableView endUpdates];
}

- (void) updatePickerCell:(NSNumber *)value
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_pickerIndexPath];
    if ([cell isKindOfClass:OACustomPickerTableViewCell.class])
    {
        OACustomPickerTableViewCell *cellRes = (OACustomPickerTableViewCell *) cell;
        [cellRes.picker selectRow:[_possibleSpeedValues indexOfObject:value] inComponent:0 animated:NO];
    }
}

- (NSIndexPath *) calculateIndexPathForNewPicker:(NSIndexPath *)selectedIndexPath
{
   return [NSIndexPath indexPathForRow:selectedIndexPath.row inSection:_selectedSection];
}

- (void) showNewPickerAtIndex:(NSIndexPath *)indexPath
{
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:_selectedSection]];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (void) zoomChanged:(NSString *)zoom tag:(NSInteger)pickerTag
{
    NSInteger value = [zoom intValue];
    if (pickerTag == kMinSpeedSection)
    {
        if (value <= _defaultSpeedValue.intValue)
            _minSpeedValue = [NSNumber numberWithInteger:value];
        else
        {
            _minSpeedValue = _defaultSpeedValue;
            [self updatePickerCell:_defaultSpeedValue];
        }
    }
    else if (pickerTag == kDefaultSpeedSection)
    {
        if (value <= _maxSpeedValue.intValue && value >= _minSpeedValue.intValue)
            _defaultSpeedValue = [NSNumber numberWithInteger:value];
        else if (value > _maxSpeedValue.intValue)
        {
            _defaultSpeedValue = _maxSpeedValue;
            [self updatePickerCell:_maxSpeedValue];
        }
        else if (value < _minSpeedValue.intValue)
        {
            _defaultSpeedValue = _minSpeedValue;
            [self updatePickerCell:_minSpeedValue];
        }
    }
    else if (pickerTag == kMaxSpeedSection)
    {
        if (value >= _minSpeedValue.intValue)
            _maxSpeedValue = [NSNumber numberWithInteger:value];
        else
        {
            _maxSpeedValue = _defaultSpeedValue;
            [self updatePickerCell:_defaultSpeedValue];
        }
    }
    [self setupView];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_pickerIndexPath.row - 1 inSection:_pickerIndexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
}

@end
