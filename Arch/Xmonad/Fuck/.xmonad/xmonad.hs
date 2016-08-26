import XMonad
import XMonad.Actions.GridSelect
import XMonad.Actions.WithAll
import Control.Monad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.Script
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.SpawnOnce
import System.IO
import Control.Monad
import XMonad.Layout.Circle
import XMonad.Layout.Spiral
import XMonad.Layout.Spacing
import XMonad.Layout.Fullscreen
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders
import XMonad.Util.Loggers
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import qualified GHC.IO.Handle.Types as H


--------------------------------------------------------------------------
-- workspace --
--------------------------------------------------------------------------

myWorkspaces    :: [String]
myWorkspaces    = clickable $ [ "^i(/home/tiago/.xmonad/.icons/term.xbm)  Term "++fro++""
                              , "^i(/home/tiago/.xmonad/.icons/www.xbm)  Web "++fro++""
                              , "^i(/home/tiago/.xmonad/.icons/code.xbm)  Code "++fro++""
                              , "^i(/home/tiago/.xmonad/.icons/file1.xbm)  Archive "++fro++""
                              , "^i(/home/tiago/.xmonad/.icons/docs.xbm)  Docs "++fro++""
                              ]
                where clickable l       = [ "^ca(1,xdotool key super+" ++ show (n) ++ ")" ++ ws ++ "^ca()" |
                                            (i,ws) <- zip [1..] l,
                                            let n = i ]

--------------------------------------------------------------------------
-- style --
--------------------------------------------------------------------------
myLogHook h = do
	dynamicLogWithPP $ tryPP h
tryPP :: Handle -> PP
tryPP h = def
	{ ppOutput		= hPutStrLn h
	, ppCurrent 		= dzenColor "#f8f8f8" "#C12B4D" . pad
	, ppVisible		= dzenColor "#C5C8C6" "#1D1F21" . pad
	, ppHidden		= dzenColor "#C5C8C6" "#1D1F21" . pad
	, ppHiddenNoWindows	= dzenColor "#C5C8C6" "#1D1F21" . pad
	, ppWsSep		= ""
	, ppSep			= " "
	, ppLayout		= dzenColor "#b3b3b3" "#1D1F21" .
				  ( \x -> case x of
					"Spacing 10 Grid"      	-> "^ca(1,xdotool key super+space)^i("++laycon++"grid.xbm)^ca()"
					"Spacing 10 Spiral"	-> "^ca(1,xdotool key super+space)^i("++laycon++"spiral.xbm)^ca()"
					"Spacing 10 Circle" 	-> "^ca(1,xdotool key super+space)^i("++laycon++"circle.xbm)^ca()"
					"Spacing 10 Tall"	-> "^ca(1,xdotool key super+space)^i("++laycon++"sptall.xbm)^ca()"
					"Mirror Spacing10 Tall"	-> "^ca(1,xdotool key super+space)^i("++laycon++"mptall.xbm)^ca()"
				        "Full"                  -> "^ca(1,xdotool key super+space)^i("++laycon++"full.xbm)^ca()"
                                        )
	                                }


---------------------------------------------------------------------------
-- additional key --
---------------------------------------------------------------------------
myKeys = [ ((mod4Mask, xK_a), spawn "firefox")
        , ((mod4Mask, xK_p), spawn  "dmenu_run -i -x 415 -y 330 -w 450 -h 20 -l 4 -fn 'Lucida Grande-8' -nb '#1D1F21' -nf '#C5C8C6' -sb '#C12B4D' -sf '#C5C8C6'")
        , ((0, xK_Print), spawn "shoot")
        , ((mod4Mask, xK_f), sinkAll)
        , ((mod4Mask, xK_x), killAll)
        , ((mod4Mask, xK_q), spawn "killall dzen2; xmonad --recompile; xmonad --restart")]



---------------------------------------------------------------------------
-- layout tiling --
---------------------------------------------------------------------------

myLayout = avoidStruts $ smartBorders (  sGrid ||| sSpiral ||| sCircle ||| sTall ||| Mirror sTall ||| Full )
        where
         sTall = spacing 10 $ Tall 1 (1/2) (1/2)
         sGrid = spacing 10 $ Grid
         sCircle = spacing 10 $ Circle
         sSpiral = spacing 10 $ spiral (toRational (2/(1+sqrt(5)::Double)))

---------------------------------------------------------------------------
-- Myapps --
---------------------------------------------------------------------------

myApps = composeAll 
	[ className =? "Gimp" --> doFloat
	, className =? "mplayer2" --> doFloat 
--	, className =? "Oblogout" --> doFullFloat
	, className =? "Viewnior" --> doFullFloat 
    ]

---------------------------------------------------------------------------
-- main code --
---------------------------------------------------------------------------

main = do
	bar <- spawnPipe dzenbar
	bar2 <- spawnPipe "sh /home/tiago/.xmonad/dzenbar.sh"
	xmonad $ def
		{ manageHook = myApps <+>  manageDocks <+> manageHook def
		, layoutHook = myLayout 
		, borderWidth = 3
		, normalBorderColor = "#161616"
		, focusedBorderColor = "#161616"
		, terminal = "termite"
		, workspaces = myWorkspaces
		, modMask = mod4Mask
                , startupHook = setWMName "LG3D"
                , logHook = myLogHook bar
		} `additionalKeys` myKeys
		where
                dzenbar	= "dzen2 -p -ta l -e 'button3=' -fn '" ++ dzenFont  ++ "' -h 25 -w 650"


dzenFont = "Exo 2-7"
laycon   = "/home/tiago/.xmonad/.icons/"
fro = " ^i(/home/tiago/.xmonad/.icons/)"

