//
// This file is part of Nabigeta
//
// Created by JC on 22/12/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import UIKit

public class PresentStrategy : NavigationStrategy {
    private let route: Route

    public init(route: Route) {
        self.route = route
    }

    @objc public func navigate(navigationContext: NavigationContext) {
        var destinationController = self.route.destination()
        var stackController: UINavigationController!

        switch(self.route.stack) {
        case .Custom(let customStackViewController) where (customStackViewController != nil):
            stackController = customStackViewController
        default:
            stackController = navigationContext.supplyStack()
        }

        navigationContext.updateContext(destinationController)

        stackController.pushViewController(destinationController, animated: false)
        self.buildAndAddDismissButton(navigationContext)
        navigationContext.sourceViewController.presentViewController(stackController, animated: true, completion: nil)
    }

    @objc public func navigateBack(sender: UIViewController) {
        sender.dismissViewControllerAnimated(true, completion: nil)
    }

    /// Build and add a dismiss/cancel button to the context destination controller if needed
    /// It is added when:
    /// - destination controller has no leftBarButtonItem setted on its navigationItem
    private func buildAndAddDismissButton(context: NavigationContext) {
        let controller = context.destinationViewController
        let dismissBtn = UIBarButtonItem(barButtonSystemItem: .Cancel, target: context.sourceViewController, action: "dismissModalCallback")

        if (controller.navigationItem.leftBarButtonItem == nil) {
            controller.navigationItem.leftBarButtonItem = dismissBtn
        }
    }
}