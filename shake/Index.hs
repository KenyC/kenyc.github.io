module Index where

import Text.StringTemplate
--
import Control.Monad
--
import Data.Maybe (fromMaybe)
import Data.Time.Format
import Data.Time
import Data.List
import Data.Ord
--
import Development.Shake
import Development.Shake.Command
import Development.Shake.FilePath
import Development.Shake.Util

import Files
import Template

indexAction :: FilePath -> Action ()
indexAction out =  do
    let original_file = "src" </> "contents" </> dropDirectory1 out 
    news_items <- news_files

    need $ [original_file, news_template, default_template] ++ news_items

    liftIO $ do
        news_content  <- buildNews news_items news_template
        main_template <- newSTMP <$> readFile original_file

        let main_content = render $ setAttribute "news" news_content main_template

        content <- applyTemplate default_template main_content "index"
        renderTemplateToFile content out 


buildNews :: [FilePath] -> FilePath -> IO String
buildNews news_items news_template_file = do
    -- news_contents :: [(Date, String)]
    -- news_contents = [(day_of_news1, "<li>May 1, 2020: Something happened to me</li>"), ...]
    news_contents <- forM news_items $ \news_file -> do

        -- An ugly hack: the date is extracted  by replacing dashes with spaces and using `words` on it
        let year:month:day:_ = words $ repl <$> takeBaseName news_file
                               where repl '-' = ' '
                                     repl x   = x
            date = fromGregorian (read year) (read month) (read day)
            date_formatted = fromMaybe "No Date" $ prettifyDate date

        news <- readFile news_file
        let bulletListTemplate = newSTMP "<li>\n$date$:\n$body$\n</li>" :: StringTemplate String
        return $ (,) date $ render $
                    setAttribute "date" date_formatted $
                    setAttribute "body" news           $
                    bulletListTemplate


    -- Sort the news item with most recent first then join all news content strings
    let combined_news_content = join $ map snd $ sortOn (Down . fst) $ news_contents

    -- Template for news content (essentially a <ul> tag) and render
    news_template <- newSTMP <$> readFile news_template_file
    return $ render $ setAttribute "news" combined_news_content $ news_template 


prettifyDate :: Day -> Maybe String
prettifyDate plain_date = Just $ formatTime defaultTimeLocale "%B %e, %_Y" plain_date