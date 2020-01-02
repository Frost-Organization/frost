module Effects.GithubSpec where

import qualified Frost.Effects.Github as FEG

import           Data.Function        ((&))
import           Polysemy
import           Polysemy.Error
import           Test.Hspec

spec :: Spec
spec =
  describe "Github effect" $
    it "should fetch a list of issues from a passed repo" $ do
  pendingWith "fails randomly due to a GH request rate limit (see issue #39)"
  res <- FEG.issues "dzajkowski/frost-issues-test"
        & FEG.runGithubIO
        & runError
        & runM
  res `shouldBe` Right ["Test issue three"]
