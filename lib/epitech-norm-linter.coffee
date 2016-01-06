module.exports = EpitechNormLinter =
  config:
    arguments:
      type: 'string'
      default: ''
    executablePath:
      type: 'string'
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
