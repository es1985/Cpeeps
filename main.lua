require "noobhub"
require "onScreenKeyboard"
crypto = require("crypto")
local widget = require( "widget" )

chat = noobhub.new({ server = "178.62.30.161"; port = 1337; });

-- 
-- CHAT CHANNEL DEFINED HERE
-- 
CHAT_CHANNEL = 'Chatulim-chat'

-- 
-- HIDE STATUS BAR
-- 
display.setStatusBar( display.HiddenStatusBar )

local background = display.newImage ("back.png");

--textBox where the chat is displayed

local scrollView = widget.newScrollView
{
    left = 40,
    top = 180,
    width = 500,
    height = 320,
    bottomPadding = 50,
    id = "chat",
    horizontalScrollDisabled = true,
    verticalScrollDisabled = false,
    listener = scrollListener,
    hideScrollBar = false,
}

scrollView.alpha = 0.5

local scrollEmo = widget.newScrollView
{
    left = 120,
    top = 600,
    width = 400,
    height = 200,
    bottomPadding = 50,
    id = "emoticons",
    horizontalScrollDisabled = false,
    verticalScrollDisabled = true,
    listener = scrollListener,
    hideScrollBar = false,
}

scrollEmo.alpha = 0.5

--local input
input = native.newTextField( 40, 500, 480, 60 )
input.alpha = 0.5
input.font = native.newFont(native.systemFont,12)

--defaultField = native.newTextField( 80, 150, 180, 30 )

local chat_open = display.newImage("chat-open.png")
        chat_open.x = 570
        chat_open.y = 950

input.isVisible = false
chat_open.isVisible = true
        
local happy = display.newImage("emo-01.png")
      happy.x = 300
      happy.y = 550

scrollEmo:insert( happy )

local angry = display.newImage("emo-02.png")
      angry.x = 100
      angry.y = 550    

scrollEmo:insert(angry)

local sad = display.newImage("emo-03.png")  
      sad.x = 500
      sad.y = 550
    
scrollEmo:insert(sad) 

-- A FUNCTION THAT WILL OPEN NETWORK A CONNECTION TO NOOBHUB
--
new_y = 0
flag = 1

function connect()
    chat:subscribe({
        channel  = CHAT_CHANNEL,
        connect  = function()
            textout('Connected!')
        end,
        callback = function(message)
            print('Message is',message.msgtext)
            print(message.msgtext.name1)
            print ('new_y is now',new_y)
            if message.msgtext.text ~= null then
                new_y = new_y + 40*flag
                local text_new = message.msgtext.text                 
                text = display.newText(text_new,60,new_y,native.systemFont, 36)   
                text:setFillColor( 0 )
                scrollView:insert( text )
                --scrollView:scrollTo("bottom", { time = 800} )
                flag = 1
            end
            if message.msgtext.emo ~= null then
                new_y = new_y + 150
                flag = 2.25
                print ("message.msgtext.emo is",message.msgtext.emo)
                if tostring(message.msgtext.emo) == "happy" then
                    print("Happy emoticon received")
                    emo_new = "emo-01.png"
                end    
                if tostring(message.msgtext.emo) == "angry" then
                    print("Angry emoticon received")
                    emo_new = "emo-02.png"
                end    
                if tostring(message.msgtext.emo) == "sad"  then
                    print("Sad emotricon rereceived")
                    emo_new = "emo-03.png"       
                end
                print("emo_new is",emo_new)             
                emo = display.newImage( emo_new )
                emo.x = 140
                emo.y = new_y
                scrollView:insert( emo )
                --scrollView:scrollTo("bottom", { time = 800} )
                                    
            end
            scrollView:scrollToPosition{ y=-new_y,time=800 }    
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
        input.isVisible = true
        chat_open.isVisible = true
        --textBox.isVisible = true

end     

function happy:tap(event)
        local msg = {
        ["emo"] = "happy",
            }
        send_a_message(msg)
end  

function angry:tap(event)
        local msg = {
        ["emo"] = "angry",
            }
        send_a_message(msg)
end 

function sad:tap(event)
        local msg = {
        ["emo"] = "sad",
            }
        send_a_message(msg)
end 

local function textListener( event )

    if ( event.phase == "began" ) then

        -- user begins editing text field
        print('Phase began')
        print( event.text )

    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        print ('Phase ended')
        local msg = {
        ["text"] = tostring(input.text)      
                    }
        send_a_message(msg)
        input.text = ''
        --input.isVisible = false
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


--A function that will transmit emoticons via json



chat_open:addEventListener("tap",chat_open)

happy:addEventListener("tap",happy)

angry:addEventListener("tap",angry)

sad:addEventListener("tap",sad)

input:addEventListener( "userInput", textListener )

connect()
