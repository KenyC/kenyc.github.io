module Template where

import Text.StringTemplate
--
import Control.Monad
--
import Development.Shake
import Development.Shake.Command
import Development.Shake.FilePath
import Development.Shake.Util


renderTemplateToFile :: StringTemplate String -> FilePath -> IO ()
renderTemplateToFile template file = writeFile file $ render template


applyTemplate :: FilePath -- template file 
              -> String   -- body file
              -> String   -- page name
              -> IO (StringTemplate String)
applyTemplate templateFile bodyText pageName = do
    templateString <- readFile templateFile  
    -- bodyText       <- readFile body_file

    let template  = newSTMP templateString
        
    return $
         setAttribute "body"     bodyText  $ 
         setAttribute pageName   ""        $ 
         template

    
