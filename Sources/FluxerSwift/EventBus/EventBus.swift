public class EventBus {
    private var subs: [String: [(Any) -> Void]] = [:]

    public func sub<T>(_ key: Events, handler: @escaping (T) -> Void) {
        let fn: (Any) -> Void = { payload in
            handler(payload as! T)
        }
        subs[key.rawValue, default: []].append(fn)
    }

    public func pub<T>(_ key: Events, _ payload: T) {
        subs[key.rawValue]?.forEach { $0(payload) }
    }
}
