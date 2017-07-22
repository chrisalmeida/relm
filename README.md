# Relm

Start a Node.js server using an Elm port and serve an Elm application.


### Up and Running

Compile & Start the server:


```
elm-package install
```

```
compile Server.elm
elm-make Server.elm --output=elm-server.js

compile Main.elm
elm-make Main.elm --output=elm-app.js
```

```
node main.js
```

Open http://localhost:4500 in your browser

### Versions 

```
node -v v6.9.5
elm  -v 0.18.0
```
