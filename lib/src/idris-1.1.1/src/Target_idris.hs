module Target_idris where

import System.FilePath
import System.Environment
getDataDir :: IO String
getDataDir = do 
   expath <- getExecutablePath
   execDir <- return $ dropFileName expath
   return $ execDir ++ "./libs"
getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
   dir <- getDataDir
   return (dir ++ "/" ++ name)