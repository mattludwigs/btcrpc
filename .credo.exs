%{
  configs: [
    %{
      name: "default",
      files: %{
        included: [
          "lib/"
        ]
      },
      checks: [
        {Credo.Check.Readability.LargeNumbers, only_greater_than: 86400},
        {Credo.Check.Readability.ParenthesesOnZeroArityDefs, parens: true},
        {Credo.Check.Readability.BlockPipe, priority: :normal}
      ]
    }
  ]
}
