import XCTest

extension ArgumentTests {
    static let __allTests = [
        ("test_help", test_help),
        ("test_initializer", test_initializer),
        ("test_parse_invalidValue", test_parse_invalidValue),
        ("test_parse_noArguments", test_parse_noArguments),
        ("test_parse_validValue", test_parse_validValue),
        ("test_priority", test_priority),
        ("test_usage", test_usage),
    ]
}

extension ArgumentTypeTests {
    static let __allTests = [
        ("test_bool_invalidValue", test_bool_invalidValue),
        ("test_bool_noValue", test_bool_noValue),
        ("test_bool_validValue", test_bool_validValue),
        ("test_collections_invalidValue", test_collections_invalidValue),
        ("test_collections_noValue", test_collections_noValue),
        ("test_collections_validValue", test_collections_validValue),
        ("test_floatingPoints_invalidValue", test_floatingPoints_invalidValue),
        ("test_floatingPoints_noValue", test_floatingPoints_noValue),
        ("test_floatingPoints_validValue", test_floatingPoints_validValue),
        ("test_integers_invalidValue", test_integers_invalidValue),
        ("test_integers_noValue", test_integers_noValue),
        ("test_integers_validValue", test_integers_validValue),
        ("test_string_noValue", test_string_noValue),
        ("test_string_validValue", test_string_validValue),
    ]
}

extension CommandTests {
    static let __allTests = [
        ("test_generateHelp_argumentsWithDocumentation", test_generateHelp_argumentsWithDocumentation),
        ("test_generateHelp_argumentsWithoutDocumentation", test_generateHelp_argumentsWithoutDocumentation),
        ("test_generateHelp_minimal", test_generateHelp_minimal),
        ("test_generateHelp_optionsWithDocumentation", test_generateHelp_optionsWithDocumentation),
        ("test_generateHelp_optionsWithoutDocumentation", test_generateHelp_optionsWithoutDocumentation),
        ("test_generateHelp_subCommand", test_generateHelp_subCommand),
        ("test_generateHelp_withDocumentation", test_generateHelp_withDocumentation),
        ("test_generateUsage_minimal", test_generateUsage_minimal),
        ("test_generateUsage_parameters", test_generateUsage_parameters),
        ("test_generateUsage_subCommand", test_generateUsage_subCommand),
        ("test_parse", test_parse),
    ]
}

extension ExtensionsTests {
    static let __allTests = [
        ("test_levenshteinDistance", test_levenshteinDistance),
    ]
}

extension GroupCommandTests {
    static let __allTests = [
        ("test_generateHelp", test_generateHelp),
        ("test_generateUsage", test_generateUsage),
        ("test_parse", test_parse),
    ]
}

extension OptionTests {
    static let __allTests = [
        ("test_help", test_help),
        ("test_initializer", test_initializer),
        ("test_parse_boolean", test_parse_boolean),
        ("test_parse_invalidValue", test_parse_invalidValue),
        ("test_parse_multipleFlags", test_parse_multipleFlags),
        ("test_parse_noArguments", test_parse_noArguments),
        ("test_parse_noStart", test_parse_noStart),
        ("test_parse_noValue", test_parse_noValue),
        ("test_parse_upToNextOptional", test_parse_upToNextOptional),
        ("test_parse_validValue", test_parse_validValue),
        ("test_priority", test_priority),
        ("test_usage", test_usage),
    ]
}

extension SubCommandTests {
    static let __allTests = [
        ("test_help", test_help),
        ("test_parse_invalidValue", test_parse_invalidValue),
        ("test_parse_noArguments", test_parse_noArguments),
        ("test_parse_validCommand", test_parse_validCommand),
        ("test_usage", test_usage),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ArgumentTests.__allTests),
        testCase(ArgumentTypeTests.__allTests),
        testCase(CommandTests.__allTests),
        testCase(ExtensionsTests.__allTests),
        testCase(GroupCommandTests.__allTests),
        testCase(OptionTests.__allTests),
        testCase(SubCommandTests.__allTests),
        testCase(ToolTests.__allTests),
    ]
}
#endif
