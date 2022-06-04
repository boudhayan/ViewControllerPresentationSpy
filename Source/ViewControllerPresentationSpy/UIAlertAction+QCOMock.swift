// ViewControllerPresentationSpy by Jon Reid, https://qualitycoding.org
// Copyright 2022 Jonathan M. Reid. https://github.com/jonreid/ViewControllerPresentationSpy/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

import UIKit

extension UIAlertAction {
    class func qcoMock_swizzle() {
        Self.qcoMockAlerts_replaceClassMethod(
            #selector(Self.init(title:style:handler:)),
            withMethod: #selector(Self.qcoMock_action(withTitle:style:handler:))
        )
    }

    @objc class func qcoMock_action(withTitle title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?) -> UIAlertAction {
        let action = Self.qcoMock_action(withTitle: title, style: style, handler: handler)
        let extraProperties = UIAlertActionExtraProperties(handler: handler)
        objc_setAssociatedObject(action, UIAlertActionExtraProperties.associatedObjectKey, extraProperties, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return action
    }

    func qcoMock_handler() -> ((UIAlertAction) -> Void)? {
        guard let extraProperties: UIAlertActionExtraProperties = objc_getAssociatedObject(self, UIAlertActionExtraProperties.associatedObjectKey)
            as? UIAlertActionExtraProperties
        else {
            return nil
        }
        return extraProperties.handler
    }
}

public final class UIAlertActionExtraProperties: NSObject {
    public static let associatedObjectKey = "extraProperties"

    public let handler: ((UIAlertAction) -> Void)?

    init(handler: ((UIAlertAction) -> Void)?) {
        self.handler = handler
        super.init()
    }
}
