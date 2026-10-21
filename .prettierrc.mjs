export default {
  semi: false,
  singleQuote: true,
  useTabs: false,
  tabWidth: 2,
  printWidth: 120,
  bracketSpacing: true,
  endOfLine: 'auto',
  overrides: [
    {
      files: ['*.json', '*.jsonc', '.prettierrc', '.eslintrc'],
      options: {
        parser: 'jsonc',
        trailingComma: 'none',
        singleQuote: false,
      },
    },
    {
      // Prettier ships no SVG language, so the parser cannot be inferred and
      // the file is skipped without an error. The html parser handles SVG
      // correctly, camelCase attributes (viewBox, stdDeviation) included.
      files: ['*.svg'],
      options: {
        parser: 'html',
      },
    },
  ],
}
