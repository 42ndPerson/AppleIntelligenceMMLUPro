//
//  main.swift
//  FoundationAccessUtility
//
//  Created by Omniscope on 6/12/25.
//

import Foundation
import Darwin
import FoundationModels

// Interrupt Trap
signal(SIGINT) { theSignal in
    fputs("\rInterrupted -- Halting\r\n", stderr)
    exit(EXIT_FAILURE)
}

// Get prompt
var prompt: String = ""
if CommandLine.arguments.count == 2 {
    prompt = CommandLine.arguments[1]
} else {
    fputs("\rInvalid Arguments -- Halting\r\n", stderr)
    exit(EXIT_FAILURE)
}

// Evaluate Prompt
let session = LanguageModelSession()
do {
    let response = try await session.respond(to: prompt)
    
    // Return
    print(response.content)
} catch LanguageModelSession.GenerationError.guardrailViolation {
    fputs("\rGuardrail Violation -- Halting\r\n", stderr)
    exit(EXIT_FAILURE)
} catch LanguageModelSession.GenerationError.exceededContextWindowSize {
    fputs("\rContext Window Length Exceeded -- Halting\r\n", stderr)
    exit(EXIT_FAILURE)
} catch LanguageModelSession.GenerationError.unsupportedLanguageOrLocale {
    fputs("\rIUnsupported Language -- Halting\r\n", stderr)
    exit(EXIT_FAILURE)
} catch {
    fputs("\rERROR: \(error) -- Halting\r\n", stderr)
    exit(EXIT_FAILURE)
}
