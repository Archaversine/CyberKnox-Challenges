module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)

import Node.Buffer as Buffer
import Node.Crypto.Hash (createHash, update, digest)
import Node.Encoding (Encoding(..))

import Web.HTML (window)
import Web.HTML.Window (document)

-- Return the SHA-256 hash of a string
getHash :: String -> Effect String
getHash str = do 
    buf      <- Buffer.fromString str UTF8
    hash     <- createHash "sha256" 
    updated  <- update buf hash
    digested <- digest updated

    Buffer.toString Hex digested

main :: Effect Unit
main = do 
    win <- window
    doc <- document win

    log "Hello, World!"

answers :: Array String
answers = [
    "58f998155cbd12c2e3812f47f3bd4bf44b571c100048416fa9277abd5d0183c4",
    "38d4467b57ef9c6c4fb2960111635f657be9038c1aa9c99ad77f34df789eba36",
    "1220157f50d806c46f2c1cf380b8957922b41fcd4d80c6be6a4df517c2cbdeda",
    "1e23ecd6ed7ce7022c52e235e790377c93c729e82d9e533395e98f80b8b93d15",
    "5642f1b7dff8094ce51e7b55dd31e61c101f7bc84eb515d28c6f36828b451ff2"
]
