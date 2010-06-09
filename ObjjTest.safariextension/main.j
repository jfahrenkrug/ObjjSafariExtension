/*
 * main.j
 *
 * Created by Johannes Fahrenkrug on June 9, 2010.
 * Copyright 2010, Springenwerk All rights reserved.
 */

@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

@import "MessageHandler.j"


function main(args, namedArgs)
{
    var messageHandler = [[MessageHandler alloc] init];
    
    safari.application.addEventListener("validate", function(event) {[messageHandler performValidate:event];}, false);
    safari.application.addEventListener("command", function(event) {[messageHandler performCommand:event];}, false);
}
