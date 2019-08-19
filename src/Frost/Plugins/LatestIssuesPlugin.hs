{-# LANGUAGE TemplateHaskell #-}
module Frost.Plugins.LatestIssuesPlugin where

import Frost.Plugin
import Text.Pandoc
import Polysemy
import PolysemyContrib
import Data.Map.Strict
import Frost.Effects.Github
import Data.List

latestIssuesPlugin :: (Member Github r) => Plugin r
latestIssuesPlugin = justContentPlugin "issues:latest" (\repo -> do
      is <- issues repo
      return $ (renderBlock is, renderInline is))
  where
    renderBlock is = [BulletList [(fmap (Plain . wrap . Str . show) is)]]
    renderInline is = [Str $ intercalate ", " $ fmap show is]
    wrap :: c -> [c]
    wrap = return