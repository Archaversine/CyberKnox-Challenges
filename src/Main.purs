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
import Effect.Timer (setTimeout)

import Web.DOM.Document (toNonElementParentNode)
import Web.DOM.Element (Element, toEventTarget, setClassName, toNode)
import Web.DOM.Node (setTextContent)
import Web.DOM.NonElementParentNode (getElementById)

import Web.Event.Event (Event, EventType(..))
import Web.Event.EventTarget (addEventListener, eventListener)

import Web.UIEvent.KeyboardEvent as KE

import Web.HTML (window)
import Web.HTML.Event.EventTypes as EType
import Web.HTML.HTMLDocument (toDocument)
import Web.HTML.HTMLInputElement (fromElement, value)
import Web.HTML.Window (document)

foreign import getHash :: String -> Promise String

verifyHash :: Element -> Element -> String -> Aff Unit
verifyHash asciiElem resultElem text = do 
    hash <- attempt $ toAff $ getHash text

    let resultLabel = toNode resultElem

    case hash of 
        Left e -> CConsole.log $ "Error calculating hash: " <> message e
        Right h -> liftEffect (setClassName className asciiElem) 
                *> liftEffect (setTextContent labelText resultLabel)
                *> liftEffect (setTimeout 1000 (setClassName "" asciiElem *> setTextContent "Enter a flag!" resultLabel) *> pure unit)
            where isCorrect = h `elem` answers
                  className
                    | isCorrect = "correct"
                    | otherwise = "incorrect"
                  labelText 
                    | isCorrect = "You got the flag!"
                    | otherwise = "Couldn't find a matching flag."

onButtonPress :: Event -> Effect Unit 
onButtonPress _ = do 
    win <- window 
    doc <- document win 

    asciiElem <- getElementById "ascii-logo" $ toNonElementParentNode $ toDocument doc
    textElem <- getElementById "submit-input" $ toNonElementParentNode $ toDocument doc
    resultElem <- getElementById "flag-results" $ toNonElementParentNode $ toDocument doc

    text <- case fromElement =<< textElem of 
        Nothing -> pure "notext"
        Just x -> value x

    case verifyHash <$> asciiElem <*> resultElem <*> pure text of 
        Nothing -> Console.log "Could not verify hash successfully."
        Just x -> launchAff_ x

onInputKeyPress :: Event -> Effect Unit
onInputKeyPress event = do 
    case KE.fromEvent event of 
        Nothing -> Console.log "Error"
        Just e -> if KE.key e == "Enter" then onButtonPress event else pure unit

-- {javascript_typescript_purescript}
main :: Effect Unit
main = do 
    win <- window
    doc <- document win

    buttonElem <- getElementById "submit-button" $ toNonElementParentNode $ toDocument doc
    inputElem <- getElementById "submit-input" $ toNonElementParentNode $ toDocument doc

    case buttonElem of 
        Nothing -> Console.log $ "Could not find button!"
        Just element -> do 
           listener <- eventListener onButtonPress
           addEventListener EType.click listener true (toEventTarget element)

    case inputElem of 
        Nothing -> Console.log $ "Could not find input!"
        Just element -> do 
            listener <- eventListener onInputKeyPress
            addEventListener (EventType "keypress") listener true (toEventTarget element)

answers :: Array String
answers = [
   "58f998155cbd12c2e3812f47f3bd4bf44b571c10048416fa9277abd5d183c4",
   "38d4467b57ef9c6c4fb296111635f657be938c1aa9c99ad77f34df789eba36",
   "1220157f50d86c46f2c1cf380b8957922b41fcd4d80c6be6a4df517c2cbdeda",
   "1e23ecd6ed7ce722c52e235e790377c93c729e82d9e533395e98f80b8b93d15",
   "5642f1b7dff894ce51e7b55dd31e61c101f7bc84eb515d28c6f36828b451ff2",
   "444329bb3220eac4fdb6f68ca3fbbba07d8ac4d9badc5a20b8fa7749fff33750",
   "026f1639cd89b6f771bd12184e0161cffabd75f6f3f47983043db99e288e7df"
]
