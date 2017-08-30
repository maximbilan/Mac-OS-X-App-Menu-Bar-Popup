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

	let statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
	let popover = NSPopover()
	var eventMonitor: EventMonitor?

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		
		if let button = statusItem.button {
			button.image = NSImage(named: "StatusBarButtonImage")
			button.action = #selector(AppDelegate.togglePopover(_:))
		}
		
		let mainViewController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "ViewControllerId") as! ViewController
		
		popover.contentViewController = mainViewController
		
		eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
			if let popover = self?.popover {
				if popover.isShown {
					self?.closePopover(event)
				}
			}
		}
		eventMonitor?.start()
	}

	func applicationWillTerminate(_ aNotification: Notification) {
	}

	func togglePopover(_ sender: AnyObject?) {
		if popover.isShown {
			closePopover(sender)
		} else {
			showPopover(sender)
		}
	}
	
	func showPopover(_ sender: AnyObject?) {
		if let button = statusItem.button {
			popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
			eventMonitor?.start()
		}
	}
	
	func closePopover(_ sender: AnyObject?) {
		popover.performClose(sender)
		eventMonitor?.stop()
	}

}

