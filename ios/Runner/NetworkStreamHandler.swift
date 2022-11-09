import Reachability


class NetworkStreamHandler: NSObject, FlutterStreamHandler {
    let reachability: Reachability
    private var eventSink: FlutterEventSink? = nil

    init(reachability: Reachability) {
        self.reachability = reachability
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        NotificationCenter.default.addObserver(self, selector: #selector(connectionChanged(notification:)), name: Notification.Name.reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
           return FlutterError(code: "1", message: "Could not start notififer", details: nil)
        }
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
        eventSink = nil
        return nil
    }
    
    @objc func connectionChanged(notification: NSNotification) {
        let reachability = notification.object as! Reachability
        switch reachability.connection {
        case .wifi:
            eventSink?(Constants.wifi)
        case .cellular:
            eventSink?(Constants.mobile)
        case .unavailable:
            eventSink?(Constants.disconnected)
        }
    }

    
}