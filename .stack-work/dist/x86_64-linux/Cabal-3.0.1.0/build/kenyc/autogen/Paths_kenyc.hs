{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_kenyc (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/keny/Documents/Programmation/Website/kenyc.github.io/.stack-work/install/x86_64-linux/b581eebee4e94fbcfca54c704271527f58ea619eba16034d25b17d2bc7159241/8.8.4/bin"
libdir     = "/home/keny/Documents/Programmation/Website/kenyc.github.io/.stack-work/install/x86_64-linux/b581eebee4e94fbcfca54c704271527f58ea619eba16034d25b17d2bc7159241/8.8.4/lib/x86_64-linux-ghc-8.8.4/kenyc-0.1.0.0-JoCYjQVpevtExpXp7Zyhvu-kenyc"
dynlibdir  = "/home/keny/Documents/Programmation/Website/kenyc.github.io/.stack-work/install/x86_64-linux/b581eebee4e94fbcfca54c704271527f58ea619eba16034d25b17d2bc7159241/8.8.4/lib/x86_64-linux-ghc-8.8.4"
datadir    = "/home/keny/Documents/Programmation/Website/kenyc.github.io/.stack-work/install/x86_64-linux/b581eebee4e94fbcfca54c704271527f58ea619eba16034d25b17d2bc7159241/8.8.4/share/x86_64-linux-ghc-8.8.4/kenyc-0.1.0.0"
libexecdir = "/home/keny/Documents/Programmation/Website/kenyc.github.io/.stack-work/install/x86_64-linux/b581eebee4e94fbcfca54c704271527f58ea619eba16034d25b17d2bc7159241/8.8.4/libexec/x86_64-linux-ghc-8.8.4/kenyc-0.1.0.0"
sysconfdir = "/home/keny/Documents/Programmation/Website/kenyc.github.io/.stack-work/install/x86_64-linux/b581eebee4e94fbcfca54c704271527f58ea619eba16034d25b17d2bc7159241/8.8.4/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "kenyc_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "kenyc_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "kenyc_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "kenyc_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "kenyc_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "kenyc_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
