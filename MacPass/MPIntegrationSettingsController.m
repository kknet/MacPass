//
//  MPServerSettingsController.m
//  MacPass
//
//  Created by Michael Starke on 17.06.13.
//  Copyright (c) 2013 HicknHack Software GmbH. All rights reserved.
//

#import "MPIntegrationSettingsController.h"
#import "MPSettingsHelper.h"
#import "MPIconHelper.h"

#import "DDHotKeyCenter.h"
#import "DDHotKey+MacPassAdditions.h"
#import "DDHotKeyTextField.h"

@interface MPIntegrationSettingsController ()

@property (nonatomic, strong) DDHotKey *hotKey;

@end

@implementation MPIntegrationSettingsController

- (NSString *)nibName {
  return @"IntegrationSettings";
}

- (NSString *)identifier {
  return @"Integration";
}

- (NSImage *)image {
  return [NSImage imageNamed:NSImageNameComputer];
}

- (NSString *)label {
  return NSLocalizedString(@"INTEGRATION_SETTINGS", "");
}

- (void)awakeFromNib {
  NSUserDefaultsController *defaultsController = [NSUserDefaultsController sharedUserDefaultsController];
  NSString *serverKeyPath = [MPSettingsHelper defaultControllerPathForKey:kMPSettingsKeyEnableHttpServer];
  NSString *enableGlobalAutotypeKeyPath = [MPSettingsHelper defaultControllerPathForKey:kMPSettingsKeyEnableGlobalAutotype];
  NSString *quicklookKeyPath = [MPSettingsHelper defaultControllerPathForKey:kMPSettingsKeyEnableQuicklookPreview];
  [self.enableServerCheckbutton bind:NSValueBinding toObject:defaultsController withKeyPath:serverKeyPath options:nil];
  [self.enableServerCheckbutton setEnabled:NO];
  [self.enableGlobalAutotypeCheckbutton bind:NSValueBinding toObject:defaultsController withKeyPath:enableGlobalAutotypeKeyPath options:nil];
  [self.enableQuicklookCheckbutton bind:NSValueBinding toObject:defaultsController withKeyPath:quicklookKeyPath options:nil];
  [self.hotKeyTextField bind:NSEnabledBinding toObject:defaultsController withKeyPath:enableGlobalAutotypeKeyPath options:nil];
  self.hotKeyTextField.delegate = self;
  
  [self _showWarning:NO];
}

- (void)willShowTab {
  _hotKey = [[DDHotKey alloc] initWithKeyData:[[NSUserDefaults standardUserDefaults] dataForKey:kMPSettingsKeyGlobalAutotypeKeyDataKey]];
  /* Change any invalid hotkeys to valid ones? */
  self.hotKeyTextField.hotKey = self.hotKey;
}

#pragma mark -
#pragma mark Properties
- (void)setHotKey:(DDHotKey *)hotKey {
  if([self.hotKey isEqual:hotKey]) {
    return; // Nothing of interest has changed;
  }
  _hotKey = hotKey;
  [[NSUserDefaults standardUserDefaults] setObject:self.hotKey.keyData forKey:kMPSettingsKeyGlobalAutotypeKeyDataKey];
}

#pragma mark -
#pragma mark NSTextFieldDelegate

- (void)controlTextDidChange:(NSNotification *)obj {
  BOOL validHotKey = self.hotKeyTextField.hotKey.valid;
  [self _showWarning:!validHotKey];
  if(validHotKey) {
    self.hotKey = self.hotKeyTextField.hotKey;
  }
}

- (void)_showWarning:(BOOL)show {
  self.hotkeyWarningTextField.hidden = !show;
}

@end
