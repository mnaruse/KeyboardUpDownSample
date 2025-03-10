//
//  ViewController.swift
//  KeyboardUpDownSample
//
//  Created by Miharu Naruse on 2020/11/15.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var textFields: [UITextField]!

    /// 編集中のテキストフィールド
    private var editingTextField: UITextField?

    /// キーボードが登場する前のスクロール量
    private var lastOffsetY: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

//        // スクロールビューがドラッグが開始されると、キーボードが閉じられるように設定する。
//        scrollView.keyboardDismissMode = .onDrag

        // 全てのテキストフィールドのデリゲートになる。
        for textField in textFields {
            textField.delegate = self
        }
        // テキストフィールドとキーボード関連の処理について、通知センターの設定をする。
        setNotificationCenter()

        // 対象のテキストフィールドがアクティブなとき、キーボードのツールバーに、前後ボタンや完了ボタンを設定する。
        addPreviousNextableDoneButtonOnKeyboard(textFields: textFields, previousNextable: true)
    }

    /// ビューがタップされた時に実行される処理
    @IBAction func tapView(_ sender: UITapGestureRecognizer) {
        // キーボードを下げる。
        view.endEditing(true)
    }
}

// MARK: - Extensions テキストフィールドとキーボード関連の処理

extension ViewController {
    /// テキストフィールドとキーボード関連の処理について、通知センターの設定をする。
    private func setNotificationCenter() {
        /// デフォルトの通知センターを取得
        let notification = NotificationCenter.default

        // キーボードのframeが変化した時のイベントハンドラーを登録する。
        notification.addObserver(self, selector: #selector(keyboardChangeFrame(_:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)

        // キーボードが登場する時のイベントハンドラーを登録する。
        notification.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        // キーボードが退場する時のイベントハンドラーを登録する。
        notification.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    /// キーボードのサイズが変化すると実行されるイベントハンドラー
    /// テキストフィールドが隠れたならスクロールする。
    ///
    /// キーボードの退場でも同じイベントが発生するので、編集中のテキストフィールドがnilの時は処理を中断する。
    @objc private func keyboardChangeFrame(_ notification: Notification) {
        // 編集中のテキストフィールドがnilの時は処理を中断する。
        guard let textField = editingTextField else {
            return
        }

        // キーボードのframeを調べる。
        let userInfo = notification.userInfo
        let keyboardFrame = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        // テキストフィールドのframeをキーボードと同じウィンドウの座標系にする。
        guard let textFieldFrame = view.window?.convert(textField.frame, from: textField.superview) else {
            return
        }

        /// テキストフィールドとキーボードの間の余白(自由に変更してください。)
        let spaceBetweenTextFieldAndKeyboard: CGFloat = 8

        // 編集中のテキストフィールドがキーボードと重なっていないか調べる。
        // 重なり = (テキストフィールドの下端 + 余白) - キーボードの上端
        var overlap = (textFieldFrame.maxY + spaceBetweenTextFieldAndKeyboard) - keyboardFrame.minY
        if overlap > 0 {
            // 重なっている場合、キーボードが隠れている分だけスクロールする。
            overlap = overlap + scrollView.contentOffset.y
            scrollView.setContentOffset(CGPoint(x: 0, y: overlap), animated: true)
        }
    }

    /// キーボードが登場する通知を受けると実行されるイベントハンドラー
    @objc private func keyboardWillShow(_ notification: Notification) {
        // キーボードが登場する前のスクロール量を保存しておく。
        lastOffsetY = scrollView.contentOffset.y
    }

    /// キーボードが退場する通知を受けると実行されるイベントハンドラー
    @objc private func keyboardWillHide(_ notification: Notification) {
        // スクロール量をキーボードが登場する前の位置に戻す。
        scrollView.setContentOffset(CGPoint(x: 0, y: lastOffsetY), animated: true)
    }
}

// MARK: - Extensions UITextFieldDelegate テキストフィールドとキーボード関連の処理

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // テキストフィールドの編集が開始された時に実行される処理。
        // どのテキストフィールドが編集中か保存しておく。
        editingTextField = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // テキストフィールドの編集が終了した時に実行される処理。
        // 編集中のテキストフィールドをnilにする。
        editingTextField = nil
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 改行キーが入力された時に実行される処理。
        // キーボードを下げる。
        view.endEditing(true)
        // 改行コードは入力しない。
        return false
    }
}
