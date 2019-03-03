import XCTest

extension ArgumentTests {
    static let __allTests = [
        ("testHelp", testHelp),
        ("testInitializer", testInitializer),
        ("testParseInvalidValue", testParseInvalidValue),
        ("testParseNoArguments", testParseNoArguments),
        ("testParseOption", testParseOption),
        ("testParseValidValue", testParseValidValue),
        ("testPriority", testPriority),
        ("testUsage", testUsage),
    ]
}

extension ArgumentTypeTests {
    static let __allTests = [
        ("testBoolInvalidValue", testBoolInvalidValue),
        ("testBoolNoValue", testBoolNoValue),
        ("testBoolValidValue", testBoolValidValue),
        ("testCollectionsInvalidValue", testCollectionsInvalidValue),
        ("testCollectionsNoValue", testCollectionsNoValue),
        ("testCollectionsValidValue", testCollectionsValidValue),
        ("testFloatingPointsInvalidValue", testFloatingPointsInvalidValue),
        ("testFloatingPointsNoValue", testFloatingPointsNoValue),
        ("testFloatingPointsValidValue", testFloatingPointsValidValue),
        ("testIntegersInvalidValue", testIntegersInvalidValue),
        ("testIntegersNoValue", testIntegersNoValue),
        ("testIntegersValidValue", testIntegersValidValue),
        ("testStringNoValue", testStringNoValue),
        ("testStringValidValue", testStringValidValue),
    ]
}

extension CommandTests {
    static let __allTests = [
        ("testParse", testParse),
        ("testParseAndRunError", testParseAndRunError),
        ("testParseUnexpectedArgument", testParseUnexpectedArgument),
    ]
}

extension ExtensionsTests {
    static let __allTests = [
        ("testLevenshteinDistance", testLevenshteinDistance),
    ]
}

extension HelpTests {
    static let __allTests = [
        ("testGenerateHelpArgumentsWithDocumentation", testGenerateHelpArgumentsWithDocumentation),
        ("testGenerateHelpArgumentsWithoutDocumentation", testGenerateHelpArgumentsWithoutDocumentation),
        ("testGenerateHelpMinimal", testGenerateHelpMinimal),
        ("testGenerateHelpOptionsWithDocumentation", testGenerateHelpOptionsWithDocumentation),
        ("testGenerateHelpOptionsWithoutDocumentation", testGenerateHelpOptionsWithoutDocumentation),
        ("testGenerateHelpSubCommand", testGenerateHelpSubCommand),
        ("testGenerateHelpWithDocumentation", testGenerateHelpWithDocumentation),
        ("testGenerateUsageMinimal", testGenerateUsageMinimal),
        ("testGenerateUsageParameters", testGenerateUsageParameters),
        ("testGenerateUsageSubCommand", testGenerateUsageSubCommand),
        ("testValidate", testValidate),
        ("testValidateCustomNameAndShorthand", testValidateCustomNameAndShorthand),
    ]
}

extension OptionTests {
    static let __allTests = [
        ("testHelp", testHelp),
        ("testInitializer", testInitializer),
        ("testParseBoolean", testParseBoolean),
        ("testParseInvalidValue", testParseInvalidValue),
        ("testParseMultipleFlags", testParseMultipleFlags),
        ("testParseNoArguments", testParseNoArguments),
        ("testParseNoStart", testParseNoStart),
        ("testParseNoValue", testParseNoValue),
        ("testParseUpToNextOptional", testParseUpToNextOptional),
        ("testParseValidValue", testParseValidValue),
        ("testPriority", testPriority),
        ("testUsage", testUsage),
    ]
}

extension SubCommandTests {
    static let __allTests = [
        ("testHelp", testHelp),
        ("testParseInvalidValue", testParseInvalidValue),
        ("testParseNoArguments", testParseNoArguments),
        ("testParseValidCommand", testParseValidCommand),
        ("testPriority", testPriority),
        ("testUsage", testUsage),
    ]
}

extension VersionTests {
    static let __allTests = [
        ("testValidate", testValidate),
        ("testValidateCustomNameAndShorthand", testValidateCustomNameAndShorthand),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ArgumentTests.__allTests),
        testCase(ArgumentTypeTests.__allTests),
        testCase(CommandTests.__allTests),
        testCase(ExtensionsTests.__allTests),
        testCase(HelpTests.__allTests),
        testCase(OptionTests.__allTests),
        testCase(SubCommandTests.__allTests),
        testCase(VersionTests.__allTests),
    ]
}
#endif
