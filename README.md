# Mac OS X Application like a menu bar popup message

Simple tutorial which explains how to create Mac OS X application as a menu bar popup message. Like that:

![alt tag](https://raw.github.com/maximbilan/Mac-OS-X-App-Menu-Bar-Popup/master/screenshots/1.png)

For that, we need to create <i>EventMonitor</i> class for handling monitor events.

<pre>
import Cocoa

public class EventMonitor {
	
	private var monitor: AnyObject?
	private let mask: NSEventMask
	private let handler: NSEvent? -> ()
	
	public init(mask: NSEventMask, handler: NSEvent? -> ()) {
		self.mask = mask
		self.handler = handler
	}
	
	deinit {
		stop()
	}
	
	public func start() {
		monitor = NSEvent.addGlobalMonitorForEventsMatchingMask(mask, handler: handler)
	}
	
	public func stop() {
		if monitor != nil {
			NSEvent.removeMonitor(monitor!)
			monitor = nil
		}
	}
}
</pre>

And example of <i>AppDelegate</i>:

<pre>
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
	let popover = NSPopover()
	var eventMonitor: EventMonitor?

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		
		if let button = statusItem.button {
			button.image = NSImage(named: "StatusBarButtonImage")
			button.action = Selector("togglePopover:")
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
</pre>

It’s really simple and I think no sense to describe details, just see the code.

Full code of this example you can found in this repository.
