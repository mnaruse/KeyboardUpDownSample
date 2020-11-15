//
//  ViewController+ToolBar.swift
//  KeyboardUpDownSample
//
//  Created by Miharu Naruse on 2020/11/15.
//

import Foundation
import UIKit

extension UIViewController {
    /// 対象のテキストフィールドがアクティブなとき、キーボードのツールバーに、前後ボタンや完了ボタンを設定する処理。
    /// - Parameters:
    ///   - textFields: 設定したいテキストフィールドの配列
    ///   - previousNextable: 前後ボタンを有効にするか否か
    ///
    /// 使い方
    /// =============================================
    ///     // テキストフィールドのキーボードのツールバーの設定
    ///     addPreviousNextableDoneButtonOnKeyboard(textFields: [textField1], previousNextable: false)
    ///     addPreviousNextableDoneButtonOnKeyboard(textFields: [textField2, textField3], previousNextable: true)
    ///
    func addPreviousNextableDoneButtonOnKeyboard(textFields: [UITextField], previousNextable: Bool = false) {
        for (index, textField) in textFields.enumerated() {
            // テキストフィールドごとにループ処理を行う。
            let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
            toolBar.barStyle = .default
            /// バーボタンアイテム
            var items = [UIBarButtonItem]()

            // MARK: 前後ボタンの設定

            if previousNextable {
                // 前後ボタンが有効な場合
                /// 上矢印ボタン
                let previousButton = UIBarButtonItem(image: UIImage(systemName: "chevron.up"), style: .plain, target: self, action: nil)
                if textField == textFields.first {
                    // 設定したいテキストフィールドの配列のうち、一番上のテキストフィールドの場合、不活性化させる。
                    previousButton.isEnabled = false
                } else {
                    // 上記以外の場合
                    // １つ前のテキストフィールドをターゲットに設定する。
                    previousButton.target = textFields[index - 1]
                    // ターゲットにフォーカスを当てる。
                    previousButton.action = #selector(UITextField.becomeFirstResponder)
                }

                /// 固定スペース
                let fixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: self, action: nil)
                fixedSpace.width = 8

                /// 下矢印ボタン
                let nextButton = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .plain, target: self, action: nil)
                if textField == textFields.last {
                    // 設定したいテキストフィールドの配列のうち、一番下のテキストフィールドの場合、不活性化させる。
                    nextButton.isEnabled = false
                } else {
                    // 上記以外の場合
                    // １つ後のテキストフィールドをターゲットに設定する。
                    nextButton.target = textFields[index + 1]
                    // ターゲットにフォーカスを当てる。
                    nextButton.action = #selector(UITextField.becomeFirstResponder)
                }

                // バーボタンアイテムに前後ボタンを追加する。
                items.append(contentsOf: [previousButton, fixedSpace, nextButton])
            }

            // MARK: 完了ボタンの設定

            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(title: "完了", style: .done, target: view, action: #selector(UIView.endEditing))
            // バーボタンアイテムに完了ボタンを追加する。
            items.append(contentsOf: [flexSpace, doneButton])

            toolBar.setItems(items, animated: false)
            toolBar.sizeToFit()

            textField.inputAccessoryView = toolBar
        }
    }
}
