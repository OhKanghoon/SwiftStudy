//
//  ViewController.swift
//  RxColor
//
//  Created by KanghoonOh on 2018. 8. 5..
//  Copyright © 2018년 kanghoon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var colorView2: UIView!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rxInit()
    }
    
    private func rxInit() {
        let colorObservable = Observable.combineLatest(redSlider.rx.value,
                                                       greenSlider.rx.value,
                                                       blueSlider.rx.value) { (red, green, blue) -> UIColor in
                                                        UIColor(red: CGFloat(red),
                                                                green: CGFloat(green),
                                                                blue: CGFloat(blue),
                                                                alpha: 1.0)
            }
            
        colorObservable
            .subscribe(onNext: { [weak self] color in
                self?.colorView.backgroundColor = color
            }).disposed(by: disposeBag)
        
        colorObservable
            .bind(to: colorView2.rx.backgroundColor)
            .disposed(by: disposeBag)
    }

}

