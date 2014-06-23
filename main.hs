module Main where

import Data.List
import Data.Maybe
import Network.HTTP
import Network.URI
import System.Directory
import System.IO
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
        -- uri = fromJust $ parseURI url
        uri = case parseURI url of
          Nothing -> error $ url ++ " was not parsable"
          Just x -> x

pattern :: String
pattern = "^\\[[^\\]]*\\]:\\s*(.*)$"

hasMatch :: String -> Bool
hasMatch a = a =~ pattern

match' :: String -> String
match' a = head . tail . head $ (a =~ pattern :: [[String]])

-- processContents :: [String] -> [String] -> IO ([String])
-- processContents [] newList = newList
-- -- processContents (x:xs) newList = processContents xs $ x:newList
-- processContents (x:xs) newList = do
--   case hasMatch x of
--     False -> processContents xs $ x:newList
--     -- True -> processContents xs $ x:newList
--     True -> do
--       -- let newURL = match' x
--       let ma = match' x
--       newURL <- getLocation ma
--       processContents xs $ newURL:newList

main :: IO ()
main = do
  contents <- getContents
  let ls = lines contents
  let newList = filter hasMatch ls
  print newList
  let nList = map match' newList
  print nList
  nnList <- mapM getLocation nList
  print nnList
  -- let newContents = processContents ls []
  -- print newContents
  putStrLn "foo"
  -- let a = filter hasMatch ls
  -- print a
  -- let url = match' $ head a
  -- newurl <- getLocation url
  -- putStrLn newurl
