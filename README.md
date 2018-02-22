# Pokédex

An example Pokédex and experiment with offline caching to localStorage (see it running here https://gigantic-copy.surge.sh)

## How it works

Currently the app will check if a local version of the 151 Pokédex is in localStorage, if it is the app loads it into state, otherwise it fetches it from a server and populates the cache with it.

## Run locally

```sh
> elm-live src/Main.elm --output=public/main.js --dir=public --open --debug --pushstate
```
