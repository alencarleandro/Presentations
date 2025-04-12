//
//  Model.swift
//  Presentations
//
//  Created by Mateus Ottoni on 04/04/25.
//

import Foundation

// Struct básica da apresentação
struct Presentation: Codable {
    let _id:                    String?
    let _rev:                   String?
    let code:                   String
    let title:                  String
    let author:                 String
    let pdf_url:                String
}

// Struct básica texto da apresentação
struct Transcription: Codable {
    let _id:                    String?
    let _rev:                   String?
    let code:                   String
    let text_transcription:     String?
}

