module Files where

import Control.Monad
--
import Development.Shake
import Development.Shake.Command
import Development.Shake.FilePath
import Development.Shake.Util

------------------- CONSTANTS -----------------

build_dir :: FilePath
build_dir = "build"


------------------- FILES TO BUILD -----------------

html_files :: Action [FilePath]
html_files = do
    files <- getDirectoryFiles ("src" </> "contents") ["*.html"]
    return [build_dir </> file | file <- files]

css_files :: Action [FilePath]
css_files = do
    files <- getDirectoryFiles "src" ["css" </> "*.css"]
    return [build_dir </> file | file <- files]

js_files :: Action [FilePath]
js_files = do
    files <- getDirectoryFiles "src" ["js" </> "*.js"]
    return [build_dir </> file | file <- files]

news_files :: Action [FilePath]
news_files = getDirectoryFiles "." ["src" </> "news" </> "*.html"]

other_files_from_src :: [FilePath]
other_files_from_src = [ "img/*"
                       , "resources/docs/*"
                       , "resources/docs/dissertation/*"
                       , "resources/talk_materials/*"
                       , "resources/talk_materials/build/*"
                       , "resources/docs/dissertation/defense/*"
                       , "resources/docs/dissertation/defense/resources/*"
                       , "resources/docs/dissertation/defense/build/*"
                       , "resources/shajara/*"
                       , "resources/files/*" ]

other_files :: Action [FilePath]
other_files = do
    other_files_from_src_ <- getDirectoryFiles "src" other_files_from_src
    return [build_dir </> file | file <- other_files_from_src_]

all_files :: Action [FilePath]
all_files =  join <$> sequence [html_files, css_files, js_files, other_files]

------------------- UTILS -----------------

toBuildDir :: FilePath -> FilePath
toBuildDir src_file = build_dir </> dropDirectory1 src_file

toSrcDir :: FilePath -> FilePath
toSrcDir build_file = "src" </> dropDirectory1 build_file

------------------- TEMPLATES -----------------

news_template :: FilePath
news_template = "src" </> "templates" </> "news.html"

default_template :: FilePath
default_template = "src" </> "templates" </> "template_black.html"

