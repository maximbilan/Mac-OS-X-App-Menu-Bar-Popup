//
//  AppDelegate.swift
//  Popup
//
//  Created by Maxim on 10/21/15.
//  Copyright © 2015 Maxim. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
	let popover = NSPopover()
	var eventMonitor: EventMonitor?

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		
		if let button = statusItem.button {
			button.image = NSImage(named: "StatusBarButtonImage")
			button.action = #selector(AppDelegate.togglePopover(_:))
		}
		
		let mainViewController = NSStoryboard(name: "Main", bundle: nil).instantiateControllerWithIdentifier("ViewControllerId") as! ViewController
		
		popover.contentViewController = mainViewController
		
		eventMonitor = EventMonitor(mask: [.LeftMouseDownMask, .RightMouseDownMask]) { [unowned self] event in
			if self.popover.shown {
				self.closePopover(event)
			}
		}
		eventMonitor?.start()
	}

	func applicationWillTerminate(aNotification: NSNotification) {
	}

	func togglePopover(sender: AnyObject?) {
		if popover.shown {
			closePopover(sender)
		} else {
			showPopover(sender)
		}
	}
	
	func showPopover(sender: AnyObject?) {
		if let button = statusItem.button {
			popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
		}
		eventMonitor?.start()
	}
	
	func closePopover(sender: AnyObject?) {
		popover.performClose(sender)
		eventMonitor?.stop()
	}

}

