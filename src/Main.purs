module Main where

import Prelude

import Control.Promise (Promise, toAff)
import Data.Either (Either(..))
import Effect (Effect)
import Effect.Aff (Aff, attempt, launchAff_, message)
import Effect.Class.Console as CConsole

foreign import getHash :: String -> Promise String

printHash :: String -> Aff Unit
printHash text = do 
    msg <- attempt $ toAff $ getHash text

    case msg of 
        Left e -> CConsole.log $ "Something went wrong: " <> message e
        Right m -> CConsole.log m

main :: Effect Unit
main = launchAff_ $ printHash "INSERT FLAG HERE"

answers :: Array String
answers = [
    "58f998155cbd12c2e3812f47f3bd4bf44b571c100048416fa9277abd5d0183c4",
    "38d4467b57ef9c6c4fb2960111635f657be9038c1aa9c99ad77f34df789eba36",
    "1220157f50d806c46f2c1cf380b8957922b41fcd4d80c6be6a4df517c2cbdeda",
    "1e23ecd6ed7ce7022c52e235e790377c93c729e82d9e533395e98f80b8b93d15",
    "5642f1b7dff8094ce51e7b55dd31e61c101f7bc84eb515d28c6f36828b451ff2"
]
