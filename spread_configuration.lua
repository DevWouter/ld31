SpreadConfiguration = 
  { single  = { {x =   0, vx =   0, y =   0, vy =   0} }

  , spread  = { {x = -10, vx =  -5, y =   0, vy =   0} 
              , {x =   0, vx =   0, y =   0, vy =   0} 
              , {x =  10, vx =   5, y =   0, vy =   0} }

  , blanket = { {x = -10, vx = -10, y =   0, vy =   0} 
              , {x =  -5, vx =  -5, y =   0, vy =   0} 
              , {x =   0, vx =   0, y =   0, vy =   0} 
              , {x =   5, vx =   5, y =   0, vy =   0} 
              , {x =  10, vx =  10, y =   0, vy =   0} }

  , overkill= { {x = -10, vx = -10, y =   0, vy =  10} 
              , {x =  -5, vx =  -5, y =   0, vy =  10} 
              , {x =   0, vx =   0, y =   0, vy =  10} 
              , {x =   5, vx =   5, y =   0, vy =  10} 
              , {x =  10, vx =  10, y =   0, vy =  10}
              , {x = -10, vx = -10, y =  -5, vy =   5} 
              , {x =  -5, vx =  -5, y =  -5, vy =   5} 
              , {x =   0, vx =   0, y =  -5, vy =   5} 
              , {x =   5, vx =   5, y =  -5, vy =   5} 
              , {x =  10, vx =  10, y = -10, vy =   5} 
              , {x = -10, vx = -10, y = -10, vy =   0} 
              , {x =  -5, vx =  -5, y = -10, vy =   0} 
              , {x =   0, vx =   0, y = -10, vy =   0} 
              , {x =   5, vx =   5, y = -10, vy =   0} 
              , {x =  10, vx =  10, y = -10, vy =   0} }

  , player_shields  = { {x = -25, vx =  -5, y =  -5, vy =   0 + 2} 
                      , {x =   0, vx =   0, y = -10, vy =   0 + 2}
                      , {x =  25, vx =   5, y =  -5, vy =   0 + 2}
                      -- , {x = -10, vx = -10, y =   0, vy =  -5 + 1} 
                      -- , {x =  10, vx =  10, y =   0, vy =  -5 + 1} 
                    }

  , building_shields= { nil
                      -- Move the right
                      , {x =  10, vx =  20, y =   0, vy =   0 + 1} 
                      , {x =  10, vx =  40, y =   0, vy =   0 + 1} 
                      -- Move to the left
                      , {x = -10, vx = -20, y =   0, vy =   0 + 1} 
                      , {x = -10, vx = -40, y =   0, vy =   0 + 1}
                      
                      -- Center
                      , {x = -25, vx =   0, y =   0, vy =   0 + 1} 
                      --, {x = -10, vx =   0, y =   0, vy =   0 + 1} 
                      --, {x =   0, vx =   0, y =   0, vy =   0 + 1}
                      --, {x =  10, vx =   0, y =   0, vy =   0 + 1}
                      , {x =  25, vx =   0, y =   0, vy =   0 + 1} }
}