/*
 * MessageHandler.j
 *
 * Created by Johannes Fahrenkrug on June 9, 2010.
 * Copyright 2010, Springenwerk All rights reserved.
 */

@import <Foundation/CPObject.j>

@implementation MessageHandler : CPObject
{
   int unreadMessages;
}

- (void)init 
{
    if (self = [super init])
    {
        unreadMessages = safari.extension.settings.unreadMessages;
        [CPTimer scheduledTimerWithTimeInterval:20
                                        target:self
                                      selector:@selector(newMessage)
                                      userInfo:nil
                                       repeats:YES];
    }
    
    return self;
}

- (void)performValidate:(JSObject)event
{
	// Switch based on the command of the event. You should always check the command.
	switch (event.command) {
	case "show-messages":
		// Set the badge of the target, if the target has a badge property.
		// Some targets that send commands, like context menu items, don't have badges.
		if ("badge" in event.target)
			event.target.badge = unreadMessages;
		break;
	}
}

- (void)performCommand:(JSObject)event
{
	// Switch based on the command of the event. You should always check the command.
	switch (event.command) {
	case "show-messages":
		// Show an alert with the number of messages.
		alert("You marked " + unreadMessages + " messages as read. Have a nice day!");

		// Reset the unread messages back to 0.
		[self updateUnreadMessageCount:0];
		break;
	}
}

- (void)validateToolbarItems
{
	// Iterate over all the toolbar items and tell them to validate, so their
	// badge will be updated.
	var toolbarItems = safari.extension.toolbarItems;
	for (var i = 0; i < toolbarItems.length; ++i) {
		// Skip any toolbar item that is not the messages item. You should always
		// check the identifier, even if your extension only has one toolbar item.
		if (toolbarItems[i].identifier !== "messages")
			continue;

		// Calling validate will dispatch a validate event, which will call
		// performValidate for each toolbar item. This is the recommended method
		// of updating items instead of directly setting a badge here, so multiple
		// event listeners have a chance to validate the item.
		toolbarItems[i].validate();
	}
}

// Function to update the unread messages count and toolbar item badges.
- (void)updateUnreadMessageCount:(int)count
{
	// Set the unread message count.
	unreadMessages = count;

	// Store the value in settings so it persists between launches.
	safari.extension.settings.unreadMessages = unreadMessages;

	// Make all the toolbar items validate to update their badge.
	[self validateToolbarItems];
}

// Function that simulates a new message coming in.
- (void)newMessage
{
	[self updateUnreadMessageCount:unreadMessages + 1];
	[self validateToolbarItems];
}

@end
