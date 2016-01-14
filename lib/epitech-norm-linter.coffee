module.exports = EpitechNormLinter =
  config:
    executablePath:
      type: 'string'
      description: 'Works only with the norminette of duponc_j. Must be executable.'
      default: '~/norminette'
    arguments:
      type: 'string'
      default: ''

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
