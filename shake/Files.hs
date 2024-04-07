module Files where

import Control.Monad
--
import Development.Shake
import Development.Shake.FilePath

------------------- CONSTANTS -----------------

buildDir :: FilePath
buildDir = "docs"


------------------- FILES TO BUILD -----------------

htmlFiles :: Action [FilePath]
htmlFiles = do
    files <- getDirectoryFiles ("src" </> "contents") ["*.html"]
    return [buildDir </> file | file <- files]

fontFiles :: Action [FilePath]
fontFiles = do
    files <- getDirectoryFiles ("src") ["fonts" </> "*"]
    return [buildDir </> file | file <- files]

cssFiles :: Action [FilePath]
cssFiles = do
    files <- getDirectoryFiles "src" ["css" </> "*.css"]
    return [buildDir </> file | file <- files]

jsFiles :: Action [FilePath]
jsFiles = do
    files <- getDirectoryFiles "src" ["js" </> "*.js"]
    return [buildDir </> file | file <- files]

newsFiles :: Action [FilePath]
newsFiles = getDirectoryFiles "." ["src" </> "news" </> "*.html"]

otherFilesFromSrc :: [FilePath]
otherFilesFromSrc = [ "img/*"
                    , "resources/docs/*"
                    , "resources/docs/dissertation/*"
                    , "resources/talk_materials/*"
                    , "resources/talk_materials/MITCommencementWorkshop/*"
                    , "resources/talk_materials/MITCommencementWorkshop/build/*"
                    , "resources/talk_materials/MITCommencementWorkshop/tools/*"
                    , "resources/talk_materials/LINGUAE/*"
                    , "resources/talk_materials/Defense/*"
                    , "resources/talk_materials/Defense/build/*"
                    , "resources/docs/dissertation/defense/*"
                    , "resources/docs/dissertation/defense/resources/*"
                    , "resources/docs/dissertation/defense/build/*"
                    , "resources/shajara/*"
                    , "resources/files/*" ]

otherFiles :: Action [FilePath]
otherFiles = do
    otherFilesFromSrc_ <- getDirectoryFiles "src" otherFilesFromSrc
    return [buildDir </> file | file <- otherFilesFromSrc_]

allFiles :: Action [FilePath]
allFiles =  join <$> sequence [htmlFiles, cssFiles, jsFiles, fontFiles, otherFiles]

------------------- UTILS -----------------

toBuildDir :: FilePath -> FilePath
toBuildDir srcFile = buildDir </> dropDirectory1 srcFile

toSrcDir :: FilePath -> FilePath
toSrcDir buildFile = "src" </> dropDirectory1 buildFile

------------------- TEMPLATES -----------------

newsTemplate :: FilePath
newsTemplate = "src" </> "templates" </> "news.html"

defaultTemplate :: FilePath
defaultTemplate = "src" </> "templates" </> "template_black.html"

