child_process = require 'child_process'
path = require 'path'

module.exports = class LinterProvider

  getCommand = (textEditor) ->
    cmd = atom.config.get 'epitech-norm-linter.executablePath'
    cmd += " " + textEditor.getPath()
    cmd += " " + atom.config.get 'epitech-norm-linter.arguments'
    return cmd

  lint: (textEditor) =>
    return new Promise (resolve) ->
      projectPath = atom.project.getPaths()[0]
      data = ''
      process = child_process.exec(getCommand(textEditor), {cwd: projectPath})
      process.stdout.on 'data', (d) -> data = d.toString()
      process.on 'close', ->
        toReturn = []
        for line in data.split('\n')
          if line.match(/^\(\'Erreur/i)
            linenb = line.split(', ')[3]
            error = (line.split(', ')[5]).split("\"")[1] || (line.split(', ')[5]).split("\'")[1];
            toReturn.push(
              type: "Trace",
              text: "Faute de norme à la ligne " + linenb + ": " + error,
              range: [[parseInt(linenb, 10) - 1, 0], [parseInt(linenb, 10) - 1, 1000000]],
              filePath: textEditor.getPath())
        resolve toReturn
