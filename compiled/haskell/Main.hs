module Main (main) where

verifyKey :: String -> Maybe String
verifyKey key 
    | '7' `elem` key                    = Nothing
    | length key /= 8                   = Nothing
    | key == "00000000"                 = Nothing
    | not $ all (`elem` ['0'..'9']) key = Nothing
    | digitSum `mod` 7 /= 0             = Nothing 
    | digitSum <= 7                     = Nothing
    | otherwise                         = Just flag
        where digitSum = foldl (\acc x -> acc + (read [x] :: Int)) 0 key
              flag     = "INSERT FLAG HERE"

main :: IO ()
main = do
    putStrLn "Enter your verification key: "
    input <- getLine

    putStrLn $ case verifyKey input of 
        Nothing   -> "Your key is invalid."
        Just flag -> "Access granted! Here's your flag: " ++ flag


