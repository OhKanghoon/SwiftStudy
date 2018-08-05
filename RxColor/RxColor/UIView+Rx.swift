//
//  UIView+Rx.swift
//  RxColor
//
//  Created by KanghoonOh on 2018. 8. 5..
//  Copyright © 2018년 kanghoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIView {
    public var backgroundColor: Binder<UIColor> {
        return Binder(self.base) { view, bgColor in
            view.backgroundColor = bgColor
        }
    }
}
