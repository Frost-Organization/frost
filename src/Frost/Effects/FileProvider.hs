{-# LANGUAGE TemplateHaskell #-}
module Frost.Effects.FileProvider where

import           Polysemy
import           Polysemy.State

import           Data.Map
import qualified Data.Text      as T
import qualified Data.Text.IO   as TIO

data FileProvider m a where
  ReadFile :: FilePath -> FileProvider m T.Text
  WriteFile :: FilePath -> T.Text -> FileProvider m ()

makeSem ''FileProvider

type InMemFileSystem = Map FilePath T.Text

runFileProviderPure :: (Member (State InMemFileSystem) r) => Sem (FileProvider ': r) a -> Sem r a
runFileProviderPure = interpret $ \case
  ReadFile path -> do
    m <- get @InMemFileSystem
    pure $ m ! path
  WriteFile path content -> do
    m <- get @InMemFileSystem
    put $ insert path content m

runFileProviderIO :: (Member (Embed IO) r) => Sem (FileProvider ': r) a -> Sem r a
runFileProviderIO = interpret $ \case
  ReadFile path -> embed $ TIO.readFile path
  WriteFile path content -> embed $ TIO.writeFile path content
