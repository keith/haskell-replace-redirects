module Main where

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
        (3,_,_) ->
          case findHeader HdrLocation r of
            Nothing -> return url
            Just redirURL -> return redirURL
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
regexMatches a = a =~ pattern :: [[String]]

urlMatch :: String -> String
urlMatch a = head . tail . tail . head $ regexMatches a

titleMatch :: String -> String
titleMatch a = head . tail . head $ regexMatches a

processContents :: String -> IO (String)
processContents x = do
  case hasMatch x of
    False -> return x
    True -> do
      newURL <- getLocation $ urlMatch x
      return $ (titleMatch x) ++ newURL

main :: IO ()
main = do
  contents <- getContents
  let ls = lines contents
  nnList <- mapM processContents ls
  mapM_ putStrLn nnList
