//
//  AppIntent.swift
//  AppComplications
//
//  Created by Paulo Henrique Costa Alves on 18/08/26.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Abrir app" }
    static var description: IntentDescription { "Esse widget abre o app ao apertar." }
}
