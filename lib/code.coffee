exec = require('child_process').exec
process = require('process')
path = require('path')
fs = require('fs')

module.exports =
  activate: ->
    atom.commands.add 'atom-workspace', 'open-shell:open', => @open_shell()
    atom.commands.add '.tree-view .selected', 'open-shell:open_path' : (event) => @open_shell(event.currentTarget)

  open_shell: (target) ->
    if target?
      select_file = target.getPath?() ? target.item?.getPath() ? target
    else
      select_file = atom.workspace.getActivePaneItem()?.buffer?.file?.getPath()
      select_file ?= atom.project.getPaths()?[0]

    if select_file? and fs.lstatSync(select_file).isFile()
      dir_path = path.dirname(select_file)
    else
      dir_path = select_file

    # exec "start cmd /k \"cd \"#{dir_path}\"\""
    # TODO: maximized as an option
    # TODO: detect os
    # TODO: ability to choose cmd/powershell/conemu etc.
    exec "start powershell -noexit -WindowStyle Maximized -NoLogo -ExecutionPolicy ByPass -command \"cd \"#{dir_path}\"\""
