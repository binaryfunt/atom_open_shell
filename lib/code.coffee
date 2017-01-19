exec = require('child_process').exec
process = require('process')
path = require('path')
fs = require('fs')

module.exports =
    config:
        defaultShell:
            title: 'Choose the default shell'
            type: 'string'
            default: 'Powershell'
            enum: ['Powershell', 'cmd', 'Git shell']
        # maximize:
        #     title: 'Maximize the shell window on opening'
        #     type: 'boolean'
        #     default: false
        
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

        # TODO: maximized as an option
        # TODO: detect os

        if atom.config.get('open_shell.defaultShell') is 'Powershell'
            exec "start powershell -noexit -executionpolicy bypass -command \"cd \"#{dir_path}\"\""
        else if atom.config.get('open_shell.defaultShell') is 'cmd'
            exec "start cmd /k \"cd \"#{dir_path}\"\""
        else if atom.config.get('open_shell.defaultShell') is 'Git shell'
            exec "\"%LOCALAPPDATA%\\GitHub\\GitHub.appref-ms\" --open-shell -command \"cd \"#{dir_path}\"\""
            # FIXME: doesn't cd
