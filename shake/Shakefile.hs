import Control.Monad
--
import Development.Shake
import Development.Shake.Command
import Development.Shake.FilePath
import Development.Shake.Util

import Files
import Template
import Index

options :: ShakeOptions
options = shakeOptions {
    shakeFiles = ".shake",
    shakeColor = True
}

main :: IO ()
main = shakeArgs options $ do

    want ["main"]

    phony "main" $ do
        need =<< all_files

    ------------------- HTML FILES -----------------
    build_dir </> "*.html" %> \out -> do
        let sourceFile = "src" </> "contents" </> dropDirectory1 out 
        need [sourceFile, default_template]
        putInfo $ "#replaceName " ++ sourceFile ++ " " ++ out
        liftIO $ do
            body_text <- readFile sourceFile
            template  <- applyTemplate default_template body_text $ takeBaseName sourceFile
            renderTemplateToFile template out


    -- index.html is special ; it has the news item
    priority 2 $ build_dir </> "index.html" %> indexAction


    ------------------- CSS & JS FILES -----------------

    let css_js_files = [ build_dir </> "css" </> "*.css"
                       , build_dir </> "js"  </> "*.js" ]

    css_js_files |%> \out -> do
           -- from "build/css/custom.css" to "src/css/custom.css"
           -- from "build/js/script.js" to "src/js/script.js"
        let sourceFile = toSrcDir out
        need [sourceFile]
        cmd_ "yui-compressor" sourceFile "-o" out

    ------------------- OTHER FILES THAT JUST NEED COPYING -----------------

    [build_dir </> file | file <- other_files_from_src] |%> \out -> do
        let sourceFile = toSrcDir out
        need [sourceFile]
        cmd_ "cp" "-f" sourceFile out


    ------------------- PHONIES -----------------

    phony "clean" $ do
        putInfo "Cleaning files in build..."
        removeFilesAfter build_dir ["*"]


