--  ____________________ ___  __ _____ __ 5m__
--  \      \  !   |   _/^\  \|  |     |  \_/  |
--  <_  />  | :   |  _>__|      |  :  |       |
--   |   __/      |     <|      |  !  |  \_/  |
--   |___\|___|___|_____/___\___|_ ___|___|___|
--  --------------------------------------------------------------------------
--                p r o d u c t i o n s 
--  --------------------------------------------------------------------------
--
-- TALISMAN LOGIN MATRIX v1.0 by aLPHA
--
-- Place this script in /bbs/scripts
-- Place art files in /bbs/gfiles. This script uses the following art:
--
--      matrix_bg.ans                   Initial conenct screen
--      login_screen.ans                [L] Login screen w/o password field
--      password.ans                    [L] Login screen password field
--      eye1.ans, eye2.ans, eye3.ans    Animation states triggered by arrow keys
--      lightbar.ans                    "On" state for menu items
--

local lOn = true
local nOn = false
local qOn = false

local clear = true
local clearNav = false
local loop = true

local hasAnsi = false


function newuser()
    bbs_clear_screen()
    local uname = "new"
    local pass = "new"
    loop = false
    return uname, pass
end

function logon()
    bbs_clear_screen()
    bbs_display_gfile("login_screen") 
    bbs_write_string("\x1b[?25h") --show cursor
    bbs_write_string("\x1b[12;37f")
    local uname = bbs_read_string(16)
    bbs_write_string("\x1b[14;26f")
    bbs_display_gfile("password") 
    bbs_write_string("\x1b[15;37f")
    local pass = bbs_read_password(16)
    loop = false
    return uname, pass
end

function login()
    hasAnsi = bbs_user_has_ansi()
    if hasAnsi == false then
        bbs_write_string("No ANSI detected, things may be weird!")
    end 

    bbs_write_string("\x1b[?25l") --hide the cursor
    while loop do
        if clear == true then --only clear the screen on initial load
            bbs_clear_screen()
            bbs_display_gfile("matrix_bg") 
            clear = false
            bbs_write_string("\x1b[24;17f")
            bbs_write_string("Your service to The Computer will be rewarded.")
        end

        if clearNav == true then
            if lOn == true then --lightbar, "Login" option on
                bbs_display_gfile("eye1") 
                bbs_write_string("\x1b[12;45f")
                bbs_display_gfile("light_bar") 
                bbs_write_string("\x1b[12;46f|18  |04|18L|10ogin  |07")
                bbs_write_string("\x1b[13;45f")
                bbs_write_string("           ") 
                bbs_write_string("\x1b[13;46f  |04N|10ew     |07")
                bbs_write_string("\x1b[14;45f")
                bbs_write_string("           ") 
                bbs_write_string("\x1b[14;46f  |04Q|10uit   |07") 
            end

            if nOn == true then --lightbar, "New" option on
                bbs_display_gfile("eye2") 
                bbs_write_string("\x1b[12;45f")
                bbs_write_string("           ") 
                bbs_write_string("\x1b[12;46f  |04L|10ogin  |07")
                bbs_write_string("\x1b[13;45f")
                bbs_display_gfile("light_bar") 
                bbs_write_string("\x1b[13;46f|18  |04|18N|10ew    |07")
                bbs_write_string("\x1b[14;45f")
                bbs_write_string("           ") 
                bbs_write_string("\x1b[14;46f  |04Q|10uit   |07") 
            end

            if qOn == true then --lightbar, "Quit" option on
                bbs_display_gfile("eye3") 
                bbs_write_string("\x1b[12;45f")
                bbs_write_string("           ") 
                bbs_write_string("\x1b[12;46f  |04L|10ogin  |07")
                bbs_write_string("\x1b[13;45f")
                bbs_write_string("           ") 
                bbs_write_string("\x1b[13;46f  |04N|10ew    |07")
                bbs_write_string("\x1b[14;45f")
                bbs_display_gfile("light_bar") 
                bbs_write_string("\x1b[14;46f|18  |04|18Q|10uit   |07") 
            end
        end

        local c = bbs_getchar() --get key input

        if c == 'l' or c == 'L' then
            uname, pass = logon()
            return uname, pass
        elseif c == 'n' or c == 'N' then
            uname, pass = newuser()
            return uname, pass
        elseif c == 'b' or c == 'B' then --down arrow
            if lOn then
                lOn = false
                nOn = true
                qOn = false
                clearNav = true
                loop = true
            elseif nOn then
                lOn = false
                nOn = false
                qOn = true
                clearNav = true
                loop = true
            elseif qOn then
                lOn = false
                nOn = false
                qOn = true
                clearNav = true
                loop = true
        end
        elseif c == 'a' or c == 'A' then --up arrow
            if lOn then
                lOn = true
                nOn = false
                qOn = false
                clearNav = true
                loop = true
        
            elseif nOn then
                lOn = true
                nOn = false
                qOn = false
                clearNav = true
                loop = true

            elseif qOn then
                lOn = false
                nOn = true
                qOn = false
                clearNav = true
                loop = true
        end
        elseif c == '\r' then --enter key
            if lOn == true then
                uname, pass = logon()
                return uname, pass
            
            elseif nOn == true then
                uname, pass = newuser()
                return uname, pass

            elseif qOn == true then
                loop = false     
        end
        elseif c == 'q' or c == 'Q' then
            loop = false
        else
            clear = false
            loop = true
        end
        end 
        bbs_write_string("\x1b[?25h") --show the cursor
    end