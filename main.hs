module Main where

import Data.Maybe
import Network.HTTP
import Network.URI
import Text.Regex.PCRE

getLocation :: String -> IO (String)
getLocation url = do
  response <- simpleHTTP request
  case response of
    Left x -> return url
    Right r ->
      case rspCode r of
        (2,_,_) -> return url
        (3,_,_) -> return $ fromMaybe url $ findHeader HdrLocation r
  where request = Request { rqURI = uri
                          , rqMethod = HEAD
                          , rqHeaders = []
                          , rqBody = ""
                          }
        uri = case parseURI url of
          Nothing -> error $ url ++ " was not parsable"
          Just x -> x

pattern :: String
pattern = "^(\\[[^\\]]*\\]:\\s*)(http:.*)$"

hasMatch :: String -> Bool
hasMatch a = a =~ pattern

regexMatches :: String -> [[String]]
regexMatches a = a =~ pattern

urlMatch :: String -> String
urlMatch = head . tail . tail . head . regexMatches

titleMatch :: String -> String
titleMatch a = head . tail . head $ regexMatches a

processContents :: String -> IO (String)
processContents x
  | match == False = return x
  | match == True  = do
      newURL <- getLocation $ urlMatch x
      return $ (titleMatch x) ++ newURL
  where match = hasMatch x

main :: IO ()
main = do
  contents <- getContents
  let ls = lines contents
  nnList <- mapM processContents ls
  mapM_ putStrLn nnList
