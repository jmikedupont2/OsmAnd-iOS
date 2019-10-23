//
//  OARoutingSettingsCell.m
//  OsmAnd
//
//  Created by Paul on 02/10/2019.
//  Copyright © 2019 OsmAnd. All rights reserved.
//

#import "OARoutingSettingsCell.h"
#import "OARootViewController.h"
#import "OAMapPanelViewController.h"
#import "OAUtilities.h"
#import "OAAppSettings.h"
#import "OAColors.h"
#import "Localization.h"

@implementation OARoutingSettingsCell
{
    CALayer *_divider;
}

- (void) awakeFromNib
{
    [super awakeFromNib];

    _divider = [CALayer layer];
    _divider.backgroundColor = [[UIColor colorWithWhite:0.50 alpha:0.3] CGColor];
    [self.contentView.layer addSublayer:_divider];
    
    [_optionsButton setTitle:OALocalizedString(@"shared_string_options") forState:UIControlStateNormal];
    
    [self setupButton:_optionsButton];
    [self setupButton:_soundButton];
    [self refreshSoundButton];
}

- (void) setupButton:(UIButton *)btn
{
    btn.layer.cornerRadius = 6.;
    btn.layer.borderWidth = 1.;
    btn.layer.borderColor = UIColorFromRGB(color_bottom_sheet_secondary).CGColor;
}

- (void) layoutSubviews
{
    [super layoutSubviews];

    _divider.frame = CGRectMake(0.0, self.contentView.frame.size.height - 0.5, self.contentView.frame.size.width, 0.5);
    [self adjustButtonSize];
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void) adjustButtonSize
{
    CGFloat textWidth = [OAUtilities calculateTextBounds:_soundButton.titleLabel.text width:self.frame.size.width font:_soundButton.titleLabel.font].width;
    CGFloat btnWidth = 55. + textWidth;
    _soundButton.frame = CGRectMake(self.frame.size.width - 16. - btnWidth - OAUtilities.getLeftMargin, 9., btnWidth, 32.);
}

- (void) refreshSoundButton
{
    BOOL isMuted = [OAAppSettings sharedManager].voiceMute;
    [_soundButton setImage:isMuted ? [UIImage imageNamed:@"ic_custom_sound_off"] : [UIImage imageNamed:@"ic_custom_sound"]forState:UIControlStateNormal];
    [_soundButton setTitle:isMuted ? OALocalizedString(@"shared_string_off") : OALocalizedString(@"shared_string_on") forState:UIControlStateNormal];
    [self adjustButtonSize];
}

- (IBAction)optionsButtonPressed:(id)sender
{
    [[OARootViewController instance].mapPanel showRoutePreferences];
}

- (IBAction)soundButtonPressed:(id)sender
{
    OAAppSettings *settings = [OAAppSettings sharedManager];
    [settings setVoiceMute:!settings.voiceMute];
    [self refreshSoundButton];
}

@end
