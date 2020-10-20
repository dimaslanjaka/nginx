## install no gui (replace with your node and nssm location path)
```batch
nssm.exe install NodeNgrok "D:\Program Files\nodejs\node.exe" "D:\Workspaces\Android\Android\Gradle Plugin\scripts\ngrok.js"
nssm set nodengrok AppDirectory "D:\Workspaces\Android\Android\Gradle Plugin\scripts"
nssm set nodengrok AppParameters ngrok.js
nssm start nodengrok
"sc.exe" start nodengrok

rem to edit
nssm stop nodengrok
nssm edit nodengrok
```

### Deploy with ngrok
- edit port on config.json same as nginx port

[source](https://stackoverflow.com/questions/41517201/making-a-node-js-service-using-nssm)
