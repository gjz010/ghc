{-# LANGUAGE NoImplicitPrelude #-}

module Expression.Settings (
    Settings,

    -- Primitive settings elements
    arg, args,
    argConfig, argStagedConfig, argConfigList, argStagedConfigList,
    -- argBuilderPath, argStagedBuilderPath,
    -- argWithBuilder, argWithStagedBuilder,
    -- argPackageKey, argPackageDeps, argPackageDepKeys, argSrcDirs,
    -- argIncludeDirs, argDepIncludeDirs,
    -- argConcat, argConcatPath, argConcatSpace,
    -- argPairs, argPrefix, argPrefixPath,
    -- argPackageConstraints,
    ) where

import Base hiding (Args, arg, args)
import Oracles hiding (not)
import Expression

type Settings m = Expression m [String]

-- A single argument
arg :: Monad m => String -> Settings m
arg = return . return

-- A list of arguments
args :: Monad m => [String] -> Settings m
args = return

argConfig :: String -> Settings Action
argConfig = lift . fmap return . askConfig

argConfigList :: String -> Settings Action
argConfigList = lift . fmap words . askConfig

stagedKey :: Stage -> String -> String
stagedKey stage key = key ++ "-stage" ++ show stage

argStagedConfig :: String -> Settings Action
argStagedConfig key = do
    stage <- asks getStage
    argConfig (stagedKey stage key)

argStagedConfigList :: String -> Settings Action
argStagedConfigList key = do
    stage <- asks getStage
    argConfigList (stagedKey stage key)

-- packageData :: Arity -> String -> Settings
-- packageData arity key =
--     return $ EnvironmentParameter $ PackageData arity key Nothing Nothing

-- -- Accessing key value pairs from package-data.mk files
-- argPackageKey :: Settings
-- argPackageKey = packageData Single "PACKAGE_KEY"

-- argPackageDeps :: Settings
-- argPackageDeps = packageData Multiple "DEPS"

-- argPackageDepKeys :: Settings
-- argPackageDepKeys = packageData Multiple "DEP_KEYS"

-- argSrcDirs :: Settings
-- argSrcDirs = packageData Multiple "HS_SRC_DIRS"

-- argIncludeDirs :: Settings
-- argIncludeDirs = packageData Multiple "INCLUDE_DIRS"

-- argDepIncludeDirs :: Settings
-- argDepIncludeDirs = packageData Multiple "DEP_INCLUDE_DIRS_SINGLE_QUOTED"

-- argPackageConstraints :: Packages -> Settings
-- argPackageConstraints = return . EnvironmentParameter . PackageConstraints

-- -- Concatenate arguments: arg1 ++ arg2 ++ ...
-- argConcat :: Settings -> Settings
-- argConcat = return . Fold Concat

-- -- </>-concatenate arguments: arg1 </> arg2 </> ...
-- argConcatPath :: Settings -> Settings
-- argConcatPath = return . Fold ConcatPath

-- -- Concatene arguments (space separated): arg1 ++ " " ++ arg2 ++ ...
-- argConcatSpace :: Settings -> Settings
-- argConcatSpace = return . Fold ConcatSpace

-- -- An ordered list of pairs of arguments: prefix |> arg1, prefix |> arg2, ...
-- argPairs :: String -> Settings -> Settings
-- argPairs prefix settings = settings >>= (arg prefix |>) . return

-- -- An ordered list of prefixed arguments: prefix ++ arg1, prefix ++ arg2, ...
-- argPrefix :: String -> Settings -> Settings
-- argPrefix prefix = fmap (Fold Concat . (arg prefix |>) . return)

-- -- An ordered list of prefixed arguments: prefix </> arg1, prefix </> arg2, ...
-- argPrefixPath :: String -> Settings -> Settings
-- argPrefixPath prefix = fmap (Fold ConcatPath . (arg prefix |>) . return)
