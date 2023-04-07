module Main where

import Prelude

import Control.Promise (Promise, toAff)

import Data.Array (elem)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))

import Effect (Effect)
import Effect.Aff (Aff, attempt, message, launchAff_)
import Effect.Class (liftEffect)
import Effect.Class.Console as CConsole
import Effect.Console as Console

import Web.DOM.Document (toNonElementParentNode)
import Web.DOM.Element (Element, toEventTarget, setClassName)
import Web.DOM.NonElementParentNode (getElementById)

import Web.Event.Event (Event)
import Web.Event.EventTarget (addEventListener, eventListener)

import Web.HTML (window)
import Web.HTML.Event.EventTypes (click)
import Web.HTML.HTMLDocument (toDocument)
import Web.HTML.HTMLInputElement (fromElement, value)
import Web.HTML.Window (document)

foreign import getHash :: String -> Promise String

printHash :: String -> Aff Unit
printHash text = do 
    msg <- attempt $ toAff $ getHash text

    case msg of 
        Left e -> CConsole.log $ "Something went wrong: " <> message e
        Right m -> CConsole.log m

verifyHash :: Element -> String -> Aff Unit
verifyHash element text = do 
    hash <- attempt $ toAff $ getHash text

    case hash of 
        Left e -> CConsole.log $ "Error calculating hash: " <> message e
        Right h -> (liftEffect $ setClassName className element)
            where className
                    | h `elem` answers = "correct"
                    | otherwise = "incorrect"

onButtonPress :: Event -> Effect Unit 
onButtonPress _ = do 
    win <- window 
    doc <- document win 

    asciiElem <- getElementById "ascii-logo" $ toNonElementParentNode $ toDocument doc
    textElem <- getElementById "submit-input" $ toNonElementParentNode $ toDocument doc

    text <- case fromElement =<< textElem of 
        Nothing -> pure "notext"
        Just x -> value x

    case asciiElem of 
        Nothing -> Console.log "Could not find ascii logo!"
        Just logo -> launchAff_ $ verifyHash logo text

main :: Effect Unit
main = do 
    win <- window
    doc <- document win

    elem <- getElementById "submit-button" $ toNonElementParentNode $ toDocument doc

    case elem of 
        Nothing -> Console.log $ "Could not find button!"
        Just button -> do 
           listener <- eventListener onButtonPress
           addEventListener click listener true (toEventTarget button)
    
--main = launchAff_ $ printHash "INSERT FLAG HERE"

answers :: Array String
answers = [
    --"58f998155cbd12c2e3812f47f3bd4bf44b571c100048416fa9277abd5d0183c4",
    --"38d4467b57ef9c6c4fb2960111635f657be9038c1aa9c99ad77f34df789eba36",
    --"1220157f50d806c46f2c1cf380b8957922b41fcd4d80c6be6a4df517c2cbdeda",
    --"1e23ecd6ed7ce7022c52e235e790377c93c729e82d9e533395e98f80b8b93d15",
    --"5642f1b7dff8094ce51e7b55dd31e61c101f7bc84eb515d28c6f36828b451ff2"
   "58f998155cbd12c2e3812f47f3bd4bf44b571c10048416fa9277abd5d183c4",
   "38d4467b57ef9c6c4fb296111635f657be938c1aa9c99ad77f34df789eba36",
   "1220157f50d86c46f2c1cf380b8957922b41fcd4d80c6be6a4df517c2cbdeda",
   "1e23ecd6ed7ce722c52e235e790377c93c729e82d9e533395e98f80b8b93d15",
   "5642f1b7dff894ce51e7b55dd31e61c101f7bc84eb515d28c6f36828b451ff2"
]
