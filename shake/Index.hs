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
import Development.Shake.FilePath

import Files
import Template

indexAction :: FilePath -> Action ()
indexAction out =  do
    let originalFile = "src" </> "contents" </> dropDirectory1 out 
    newsItems <- newsFiles

    need $ [originalFile, newsTemplate, defaultTemplate] ++ newsItems

    putInfo $ "# renderTemplateToFile " ++ originalFile ++ " " ++ out
    liftIO $ do
        newsContent  <- buildNews newsItems newsTemplate
        mainTemplate <- newSTMP <$> readFile originalFile

        let mainContent = render $ setAttribute "news" newsContent mainTemplate

        content <- applyTemplate defaultTemplate mainContent "index"
        renderTemplateToFile content out 


buildNews :: [FilePath] -> FilePath -> IO String
buildNews newsItems newsTemplateFile = do
    -- newsContents :: [(Date, String)]
    -- newsContents = [(day_of_news1, "<li>May 1, 2020: Something happened to me</li>"), ...]
    newsContents <- forM newsItems $ \newsFile -> do

        -- An ugly hack: the date is extracted  by replacing dashes with spaces and using `words` on it
        let year:month:day:_ = words $ repl <$> takeBaseName newsFile
                               where repl '-' = ' '
                                     repl x   = x
            date = fromGregorian (read year) (read month) (read day)
            dateFormatted  = fromMaybe "No Date" $ prettifyDate date

        news <- readFile newsFile
        let bulletListTemplate = newSTMP "<li>\n$date$:\n$body$\n</li>" :: StringTemplate String
        return $ (,) date $ render $
                    setAttribute "date" dateFormatted  $
                    setAttribute "body" news           $
                    bulletListTemplate


    -- Sort the news item with most recent first then join all news content strings
    let combinedNewsContent = join $ map snd $ sortOn (Down . fst) $ newsContents

    -- Template for news content (essentially a <ul> tag) and render
    newsTemplate_ <- newSTMP <$> readFile newsTemplateFile
    return $ render $ setAttribute "news" combinedNewsContent $ newsTemplate_ 


prettifyDate :: Day -> Maybe String
prettifyDate plainDate = Just $ formatTime defaultTimeLocale "%B %e, %_Y" plainDate