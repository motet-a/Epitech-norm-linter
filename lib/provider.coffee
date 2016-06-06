child_process = require 'child_process'
path = require 'path'
fs = require 'fs'

module.exports = class LinterProvider

  useYan = () ->
    return atom.config.get 'epitech-norm-linter.g_useYan'

  getPythonPath = () ->
    return atom.config.get 'epitech-norm-linter.a_pythonPath'

  debug = () ->
    return atom.config.get 'epitech-norm-linter.f_showDebug'

  getYanArguments = (fileName) ->
    return [
      '../norminette/yan.py',
      '--json',
      '-W',
      fileName,
    ]

  parseYanOutputAndMark = (textEditor) ->
    return

  yanIssueToLinterIssues = (issue) ->
    severity = 'error'
    if issue.level == 'warn'
      severity = 'warning'
    if issue.level == 'info'
      severity = 'info'
    pos = issue.position
    return {
      severity: severity,
      type: "Norme",
      text: issue.message,
      range: [
        [pos.line - 1, pos.column - 1],
        [pos.line - 1, pos.column]
      ],
      filePath: pos.file_name
    }

  onYanExit = (error, stdout, stderr) ->
    yanIssues = JSON.parse(stdout)
    linterIssues = []
    for yanIssue, i in yanIssues
      if yanIssue.message == 'Yan comment directive'
        continue
      linterIssues.push(yanIssueToLinterIssues(yanIssue))
    return linterIssues



  lintFileWithYan = (textEditor) ->
    return new Promise (resolve) ->
      output = ''
      options = {cwd: __dirname}
      onExit = (error, stdout, stderr) ->
        resolve(onYanExit(error, stdout, stderr))
      process = child_process.execFile(getPythonPath(),
                                       getYanArguments(textEditor.getPath()),
                                       options, onExit)

  getCommand = (fileName) ->
    cmd = getPythonPath()
    cmd += " ../norminette/norm.py"
    cmd += " " + fileName
    cmd += " -nocheat -malloc"
    if (!atom.config.get 'epitech-norm-linter.c_verifyComment')
      cmd += " -comment"
    if (atom.config.get 'epitech-norm-linter.e_verifyLibc')
      cmd += " -libc"
    if (debug())
      console.log("Epitech-norm-linter: " + cmd)
    return cmd

  lintFileDefault = (textEditor) =>
    return new Promise (resolve) ->
      data = ''
      cmd = getCommand(textEditor.getPath())
      process = child_process.exec(cmd, {cwd: __dirname})
      process.stdout.on 'data', (d) -> data = d.toString()
      process.on 'close', ->
        toReturn = []
        if (debug())
          console.log("Norm checker output: " + data)
        for line in data.split('\n')
          if line.match(/^Erreur/i)
            linenb = (line.split(' ')[6]).split(':')[0];
            error = (line.split(':')[1]).split("=>")[0];
            toReturn.push(
              type: "Norme",
              text: "Faute de norme à la ligne " + linenb + " : " + error,
              range: [[parseInt(linenb) - 1, 0], [parseInt(linenb) - 1, 1000000]],
              filePath: textEditor.getPath())
        resolve toReturn

  lintFile = (textEditor) ->
    if (useYan())
      lintFileWithYan(textEditor)
    else
      lintFileDefault(textEditor)

  lintOnFly = (textEditor) =>
    lintFile(textEditor)

  lintOnSave = (textEditor) =>
    lintFile(textEditor)

  lint: (textEditor) =>
    if (atom.config.get('epitech-norm-linter.b_lintOnFly'))
      lintOnFly(textEditor)
    else
      lintOnSave(textEditor)
