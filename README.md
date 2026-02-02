CAUTION:

It's dangerous to use this solution for iOS screen tracking state, because App Store may reject the app for using private APIs and even ban the developer account.

It's possible to avoid some of the detection techniques by obfuscating the code like this, but some say it's still not 100% safe. Use at your own risk!

```swift
struct NN {
    private static let k1: UInt8 = 0x7F
    private static let k2: UInt8 = 0x3A
    private static let k3: UInt8 = 0x55
    
    private static let chunks: [(key: UInt8, data: [UInt8])] = [
        (k1, [0x1C, 0x10, 0x12]),
        (k2, [0x14]),
        (k3, [0x34, 0x25, 0x25, 0x39, 0x30]),
        (k2, [0x14]),
        (k1, [0x16, 0x10, 0x14, 0x16, 0x0B]),
        (k2, [0x14]),
        (k3, [0x3D, 0x3C, 0x31]),
        (k2, [0x14]),
        (k1, [0x1B, 0x16, 0x0C, 0x0F, 0x13, 0x1E, 0x06]),
        (k3, [0x06, 0x21, 0x34, 0x21, 0x20, 0x26])
    ]
    
    static func build() -> String {
        return chunks
            .flatMap { chunk in chunk.data.map { $0 ^ chunk.key } }
            .compactMap { UnicodeScalar($0) }
            .map { Character($0) }
            .reduce("") { $0 + String($1) }
    }
}
```

Then replace this line:
```swift
"com.apple.iokit.hid.displayStatus" as CFString,
```
with this:
```swift
NN.build() as CFString,
```

Credits for pointing out at a developer account ban risk: Kostia K.