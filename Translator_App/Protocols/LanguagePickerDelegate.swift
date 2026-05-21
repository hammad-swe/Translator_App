//
//  LanguagePickerDelegate.swift
//  Translator_App
//
//  Created by Hammad Ali on 21/05/2026.
//

import Foundation

protocol LanguagePickerDelegate: AnyObject {
    func didSelectLanguage(_ language: Language, isSource: Bool)
}
