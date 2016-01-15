module.exports = EpitechNormLinter =
  config:
    executablePath:
      type: 'string'
      description: 'Works only with the norminette made by duponc_j and all norminettes with same output. Must be executable.'
      default: '~/norminette'

  activate: ->
    require('atom-package-deps').install 'epitech-norm-linter'

  provideLinter: ->
    LinterProvider = require('./provider')
    @provider = new LinterProvider()
    return {
      name: "Epitech"
      grammarScopes: ['source.c']
      scope: 'file'
      lint: @provider.lint
      lintOnFly: true
    }
