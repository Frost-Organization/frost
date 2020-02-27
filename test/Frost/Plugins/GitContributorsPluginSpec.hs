module Frost.Plugins.GitContributorsPluginSpec where

import           Frost
import           Frost.Effects.Git
import           Frost.Plugin
import           Frost.Plugins.GitContributorsPlugin

import           Data.Function                       ((&))
import           Polysemy
import           Test.Hspec
import           Text.Pandoc

spec :: Spec
spec =
  describe "GitContributorsPlugin" $
    it "should substitute frost code blocks with content from the git plugin" $ do
  -- when
  let res = substitute gitContributorsPlugin ""
        & runGitPure ["Dev1", "Dev2"]
        & run
  -- then
  fst res `shouldBe` [BulletList [ [Plain [Str "Dev1"]], [Plain [Str "Dev2"]]]]
  snd res `shouldBe` [Str "Dev1", Str "Dev2"]
