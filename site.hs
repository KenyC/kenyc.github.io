--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Control.Monad
import           Hakyll
import           System.FilePath.Posix


number_of_news_items :: Int
number_of_news_items = 5

--------------------------------------------------------------------------------
main :: IO ()
main = website  


website :: IO ()
website = hakyll $ do

    -- create ["news.html"] $ do
    --     compile $ do 
    --         news <- (take 5) <$> (recentFirst =<< (loadAll "src/news/*" :: Compiler [Item String]))
    --         let news_context = listField "news" news_context $ return news 
    --         makeItem ""
    --             >>= (loadAndApplyTemplate "src/templates/news.html" news_context)
    --             >>= relativizeUrls

    match "src/contents/*" $ do

        route $ gsubRoute "src/contents/" $ const ""
        compile $ do
            template  <- templateBodyCompiler
            news_feed <- news_feed_context
            contents  <- applyTemplate (itemBody template) (news_feed `mappend` defaultContext) =<< makeItem ""
            name_page <- (takeBaseName . toFilePath) <$> getUnderlying
            full      <- loadAndApplyTemplate 
                             "src/templates/template_black.html" 
                             (context_page name_page) 
                             contents
            -- >>= loadAndApplys  Template "template.html" defaultContext
            relativizeUrls full


    match "src/news/*" $ compile $ getResourceBody


    let folders_simple_compile = ["fonts", "resources/docs", "resources/files", "resources/shajara", "img", "js"]
        to_glob_pattern folder = fromGlob $ "src/" ++ folder ++ "/*"

    forM_ folders_simple_compile $ \folder -> do
        match (to_glob_pattern folder) $ do
            route   removeSrc
            compile copyFileCompiler

    match "src/css/*.css" $ do 
        route   removeSrc
        compile compressCssCompiler

    match "src/templates/*" $ compile templateBodyCompiler


-----------------------------------------------------------------------------------

removeSrc :: Routes
removeSrc = gsubRoute "src/" $ const ""


news_feed_context :: Compiler (Context String)
news_feed_context = do
    news <- (take number_of_news_items) <$> (recentFirst =<< (loadAll "src/news/*" :: Compiler [Item String]))
    return $ listField "news" news_context $ return news 


context_page :: FilePath -> Context String
context_page name_page = mconcat $ [
      field name_page (const $ return "") 
    , defaultContext ]

news_context :: Context String
news_context = 
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext
