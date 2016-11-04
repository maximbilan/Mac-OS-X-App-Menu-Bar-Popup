# Mac OS X Application like a menu bar popup message

Simple tutorial which explains how to create Mac OS X application as a menu bar popup message.
Like that:

![alt tag](https://raw.github.com/maximbilan/Mac-OS-X-App-Menu-Bar-Popup/master/screenshots/1.png)

For that, we need to create <i>EventMonitor</i> class for handling monitor events.

<pre>
import Cocoa

open class EventMonitor {
	
	fileprivate var monitor: AnyObject?
	fileprivate let mask: NSEventMask
	fileprivate let handler: (NSEvent?) -> ()
	
	public init(mask: NSEventMask, handler: @escaping (NSEvent?) -> ()) {
		self.mask = mask
		self.handler = handler
	}
	
	deinit {
		stop()
	}
	
	open func start() {
		monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler) as AnyObject?
	}
	
	open func stop() {
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

	let statusItem = NSStatusBar.system().statusItem(withLength: -2)
	let popover = NSPopover()
	var eventMonitor: EventMonitor?

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		
		if let button = statusItem.button {
			button.image = NSImage(named: "StatusBarButtonImage")
			button.action = #selector(AppDelegate.togglePopover(_:))
		}
		
		let mainViewController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "ViewControllerId") as! ViewController
		
		popover.contentViewController = mainViewController
		
		eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [unowned self] event in
			if self.popover.isShown {
				self.closePopover(event)
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
		}
		eventMonitor?.start()
	}
	
	func closePopover(_ sender: AnyObject?) {
		popover.performClose(sender)
		eventMonitor?.stop()
	}

}
</pre>

It’s really simple and I think no sense to describe details, just see the code.

Full code of this example you can found in this repository.
