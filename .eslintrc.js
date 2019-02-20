// https://eslint.org/docs/user-guide/configuring
// eslint-disable-next-line
/* eslint-disable */
module.exports = {
    env: {
        amd: true // defines require() and define() as global variables as per the amd spec.
    },
    plugins: [
        "docker",
        "json",
        "filenames",
        "markdown"
    ],
    root: true,
    extends: [
        "eslint:recommended"
    ],
    globals: {
        // Fill in the global variables for the project
        // The value of "false" indicates that this global variable is not re-assignable.
        // module: false
    },
    rules: {
        // "docker/rule-name": 2,
        'indent': [
            'error',
            4,
            {
                SwitchCase: 1,
                flatTernaryExpressions: true
            }
        ],
        // Following rules are defined with several values.
        // 0 = off, 1 = warn, 2 = error
        'no-undef-init': 1, // https://eslint.org/docs/rules/no-undef-init#disallow-initializing-to-undefined-no-undef-init
        'no-trailing-spaces': 1, // https://eslint.org/docs/rules/no-trailing-spaces#disallow-trailing-whitespace-at-the-end-of-lines-no-trailing-spaces
        'no-useless-escape': 2, // https://eslint.org/docs/rules/no-useless-escape#disallow-unnecessary-escape-usage-no-useless-escape
        'no-undefined': 2, // https://eslint.org/docs/rules/no-undefined#disallow-use-of-undefined-variable-no-undefined
        'no-undef': 1, // https://eslint.org/docs/rules/no-undef#disallow-undeclared-variables-no-undef
        'no-empty-pattern': 1, // https://eslint.org/docs/rules/no-empty-pattern#disallow-empty-destructuring-patterns-no-empty-pattern
        'no-case-declarations': 1, // https://eslint.org/docs/rules/no-case-declarations#disallow-lexical-declarations-in-casedefault-clauses-no-case-declarations
        'no-void': 1, // https://eslint.org/docs/rules/no-void#disallow-use-of-the-void-operator-no-void
        'no-dupe-keys': 2, // https://eslint.org/docs/rules/no-dupe-keys#disallow-duplicate-keys-in-object-literals-no-dupe-keys
        'no-unused-vars': 0, // https://eslint.org/docs/rules/no-unused-vars#disallow-unused-variables-no-unused-vars
        'no-param-reassign': 1, // https://eslint.org/docs/rules/no-param-reassign#disallow-reassignment-of-function-parameters-no-param-reassign
        'no-console': 1, // https://eslint.org/docs/rules/no-console#disallow-the-use-of-console-no-console
        'no-debugger': 2, // https://eslint.org/docs/rules/no-debugger#disallow-the-use-of-debugger-no-debugger
        'no-mixed-spaces-and-tabs': 2, // https://eslint.org/docs/rules/no-mixed-spaces-and-tabs#disallow-mixed-spaces-and-tabs-for-indentation-no-mixed-spaces-and-tabs
        'quotes': [
            2,
            'single',
            {
                'avoidEscape': true
            }
        ], // https://eslint.org/docs/rules/quotes#enforce-the-consistent-use-of-either-backticks-double-or-single-quotes-quotes
        'space-before-function-paren': [
            'error', {
                'anonymous': 'always',
                'named': 'always',
                'asyncArrow': 'always'
            }
        ],
        'filenames/match-regex': [
            2,
            "^[a-z_]+$",
            true
        ],
        'filenames/match-exported': 2,
        'filenames/no-index': 2
    },
};
