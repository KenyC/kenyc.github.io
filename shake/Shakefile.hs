import Development.Shake
import Development.Shake.FilePath

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
        need =<< allFiles

    ------------------- HTML FILES -----------------
    buildDir </> "*.html" %> \out -> do
        let sourceFile = "src" </> "contents" </> dropDirectory1 out 
        need [sourceFile, defaultTemplate]
        putInfo $ "# renderTemplateToFile " ++ sourceFile ++ " " ++ out
        liftIO $ do
            bodyText  <- readFile sourceFile
            template  <- applyTemplate defaultTemplate bodyText $ takeBaseName sourceFile
            renderTemplateToFile template out


    -- index.html is special ; it has the news item
    priority 2 $ buildDir </> "index.html" %> indexAction


    ------------------- CSS & JS FILES -----------------

    let cssJsFiles = [ buildDir </> "css" </> "*.css"
                     , buildDir </> "js"  </> "*.js" ]

    cssJsFiles |%> \out -> do
           -- from "build/css/custom.css" to "src/css/custom.css"
           -- from "build/js/script.js" to "src/js/script.js"
        let sourceFile = toSrcDir out
        need [sourceFile]
        cmd_ "yui-compressor" sourceFile "-o" out

    buildDir </> "fonts"  </> "*" %> \out -> do
        let sourceFile = toSrcDir out
        need [sourceFile]
        cmd_ "cp" "-f" sourceFile out

    ------------------- OTHER FILES THAT JUST NEED COPYING -----------------

    [buildDir </> file | file <- otherFilesFromSrc] |%> \out -> do
        let sourceFile = toSrcDir out
        need [sourceFile]
        cmd_ "cp" "-f" sourceFile out


    ------------------- PHONIES -----------------

    phony "clean" $ do
        putInfo "Cleaning files in build..."
        removeFilesAfter buildDir ["*"]


