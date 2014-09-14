--
-- INIT CHAT:
-- This initializes the pubnub networking layer.
--
--require "pubnub"
--require "PubnubUtil"
require "noobhub"
require "onScreenKeyboard"
crypto = require("crypto")



--chat = pubnub.new({
 --   publish_key   = "demo",
 --   subscribe_key = "demo",
 --  secret_key    = nil,
 --   ssl           = nil,
 --   origin        = "pubsub.pubnub.com"
--})

--chat = noobhub.new({ server = "141.20.102.231"; port = 8080; });
chat = noobhub.new({ server = "178.62.30.161"; port = 1337; });

-- 
-- CHAT CHANNEL DEFINED HERE
-- 
CHAT_CHANNEL = 'Chatulim-chat'

-- 
-- HIDE STATUS BAR
-- 
display.setStatusBar( display.HiddenStatusBar )


--local myText = display.newText( "Hello World!", 100, 200, display.contentWidth, display.contentHeight * 0.5, native.systemFont, 16 )
--myText:setFillColor( 0, 0.5, 1 )

local bg = display.newImage ("back.png");

--local output = display.newText( '', 130, 10, "Arial", 30, display.contentWidth, display.contentHeight * 0.5, native.systemFont, 16 )
--output:setFillColor( 0, 0.5, 1 )
--output.isEditable = false

local textBox = native.newTextBox( 20, 280, 380, 200 )
textBox.font = native.newFont( "Helvetica-Bold", 18 )
textBox:setTextColor( 0.8, 0.8, 0.8 )
textBox.alpha = 0.5
textBox.hasBackground = true
textBox.size = 18


--local input
input = native.newTextField( 20, 500, 220, 40 )
input.alpha = 0.5

--defaultField = native.newTextField( 80, 150, 180, 30 )

local chat_open = display.newImage("chat-open.png")
        chat_open.x = 570
        chat_open.y = 950


        --create an instance of the onScreenKeyboard class without any parameters. This creates a keyboard
        --with the default values. You can manipulate the visual representation of the keyboard by passing a table to the new() function.
        --Read more about this in the section "customizing the keyboard style"

        --create a listener function that receives the events of the keyboard
--local listener = function(event)
--if(event.phase == "ended")  then
--input.text=keyboard:getText()  --update the textfield with the current text of the keyboard

                --check whether the user finished writing with the keyboard. The inputCompleted
                --flag of  the keyboard is set to true when the user touched its "OK" button
--if(event.target.inputCompleted == true) then
--print("Input of data complete...")
--send_a_message(tostring(input.text))
--input.text=''
--keyboard:destroy()
--chat_open.isVisible = true
--end
--end
--end

--

-- A FUNCTION THAT WILL OPEN NETWORK A CONNECTION TO NOOBHUB
--
function connect()
    chat:subscribe({
        channel  = CHAT_CHANNEL,
--        connect  = function()
--            textout('Connected!')
--        end,
        callback = function(message)
            print('Message is',message)
            --output.text = output.text.."\n"..message.msgtext 
            textBox.text = textBox.text .. "\n" .. message.msgtext
        end,       
    })
end

--
-- A FUNCTION THAT WILL CLOSE A NETWORK CONNECTION TO NOOBHUB
--
function disconnect()
    chat:unsubscribe({
        channel = CHAT_CHANNEL
    })
    textout('Disconnected!')
    --output.text = "Disconnected"
end

--
-- A FUNCTION THAT WILL SEND A MESSAGE
--
function send_a_message(text)
    chat:publish({
        channel  = CHAT_CHANNEL,
        message  = { msgtext = text },
        callback = function(info)
        end
    })
end

function chat_open:tap(event)
        native.setKeyboardFocus( input )  
        event.phase = "began"
       -- keyboard = onScreenKeyboard:new() 
       -- keyboard:setListener(  listener  )
       -- keyboard:drawKeyBoard(keyboard.keyBoardMode.letters_small)
        chat_open.isVisible = false
--        input.isVisible = true
end     

local function textListener( event )

    if ( event.phase == "began" ) then

        -- user begins editing text field
        print( event.text )

    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        
        send_a_message(tostring(input))
        input = ''
        chat_open.isVisible = true
        
        -- text field loses focus
        -- do something with defaultField's text

    elseif ( event.phase == "editing" ) then

        print( event.newCharacters )
        print( event.oldText )
        print( event.startPosition )
        print( event.text )

    end
end

chat_open:addEventListener("tap",chat_open)

--input:addEventListener( "userInput", textListener )

connect()
