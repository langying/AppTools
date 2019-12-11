//
//  ATWebPluginAction.h
//  AppTools
//
//  Created by 韩琼 on 2018/11/3.
//  Copyright © 2018 Amaze. All rights reserved.
//

#import "ATWebCmd.h"
#import "ATWebPlugin.h"

NS_ASSUME_NONNULL_BEGIN

@interface ATWebPluginAction : ATWebPlugin

- (void)pop:(ATWebCmd*)command;

- (void)popToRoot:(ATWebCmd*)command;

- (void)pushURL:(ATWebCmd*)command;

- (void)openBrowser:(ATWebCmd*)command;

- (void)setNavLeftTitle:(ATWebCmd*)command;

- (void)setNavCenterTitle:(ATWebCmd*)command;

- (void)setNavRightTitle:(ATWebCmd*)command;

- (void)hideNavBar:(ATWebCmd*)command;

- (void)hideStatusBar:(ATWebCmd*)command;

@end

NS_ASSUME_NONNULL_END
