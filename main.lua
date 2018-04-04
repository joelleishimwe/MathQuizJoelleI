-- Title: MathQuiz
-- Name: Joelle Ishimwe
-- Course: ICS2O
-- This program displays math promblems
-----------------------------------------------------------------------------------------------

-- Hide the status bar
display.setStatusBar (display.HiddenStatusBar)

-- change the backround colour
display.setDefault ("background", 90/255, 180/255, 160/255)

-----------------------------------------------------------------------------------------------
-- LOCAL VARIABLES
-----------------------------------------------------------------------------------------------

-- create local variables
local questionObject
local correctObject
local correctObject2
local incorrectObject

local numericField

-- 
local randomNumber1
local randomNumber2
local userAnswer
local correctAnswer
local correctAnswer2

-- variables for the points
local pointsObject
local points = 0

-- variables for the timer
local totalSeconds = 15
local secondsLeft = 15
local clockText 
local countDownTimer

-- variables for the lives
local lives = 3

local heart1
local heart2
local heart3
local gameOver
local gameCompleted


-----------------------------------------------------------------------------------------------
-- SOUNDS
-----------------------------------------------------------------------------------------------

-- sets a local variable for the correct sound
local correctSound = audio.loadSound("Sounds/correct.mp3")
local correctSoundChannel

local incorrectSound = audio.loadSound("Sounds/incorrect.mp3")
local incorrectSoundChannel

local gameOverSound = audio.loadSound("Sounds/gameOver.mp3")
local gameOverSoundChannel

local gameCompletedSound = audio.loadSound("Sounds/gameCompleted.mp3")
local gameCompletedSoundChannel
-----------------------------------------------------------------------------------------------
-- LOCAL FUNCTIONS
-----------------------------------------------------------------------------------------------

local function AskQuestion()
	-- generate 2 random numbers between max. and a min. number
	randomNumber1 = math.random (1, 20)
	randomNumber2 = math.random (1, 20)
	randomNumber3 = math.random (1, 10)
	randomNumber4 = math.random (1, 10)
	randomNumber5 = math.random (1, 100)
	randomNumber6 = math.random (1, 100)


	-- generate random number for the operator
	randomOperator = math.random(1, 5)



	if (randomOperator == 1) then
		--calculate the correct answer for addition
		correctAnswer = randomNumber1 + randomNumber2

		-- create question in text object for addition
		questionObject.text = randomNumber1 .. " + " .. randomNumber2 .. " = "

	elseif (randomOperator == 2) then
		--calculate the correct answer for subtraction
		correctAnswer = randomNumber3 * randomNumber3

		-- create question in text object for subtraction
		questionObject.text = randomNumber3 .. " ^2 " .. " = "

	elseif (randomOperator == 3) then
		--calculate the correct answer for subtraction
		correctAnswer = randomNumber1 - randomNumber2

		-- create question in text object for subtraction
		questionObject.text = randomNumber1 .. " - " .. randomNumber2 .. " = "

		if (correctAnswer < 0) then

			--calculate the correct answer for subtraction
			correctAnswer = randomNumber2 - randomNumber1

			-- create question in text object for subtraction
			questionObject.text = randomNumber2 .. " - " .. randomNumber1 .. " = "

		end

 
	elseif (randomOperator == 4) then
		--calculate the correct answer for multiplication
		correctAnswer = randomNumber3 * randomNumber4

		-- create question in text object for multiplication
		questionObject.text = randomNumber3 .. " x " .. randomNumber4 .. " = "



	elseif (randomOperator == 5) then
		--calculate the correct answer for division
		correctAnswer = math.floor ((randomNumber5 / randomNumber6)*10)*0.1
		print ("***correctAnswer = " .. correctAnswer)

		-- create question in text object for division
		questionObject.text = randomNumber5 .. " / " .. randomNumber6 .. " = "



	end

end
-----------------------------------------------------------------------------------------------

local function UpdateTime()

	-- decrement the number of seconds
	secondsLeft = secondsLeft - 1

	-- display the number of seconds left in the clock object
	clockText.text = secondsLeft .. ""

	-- handle the case when the timer runs out
	if (secondsLeft == 0 ) then

		-- reset the number of seconds left
		secondsLeft = totalSeconds
		lives = lives - 1

		

		if (lives == 2) then
			heart1.isVisible = false

			-- once the timer runs out ask a new question
			AskQuestion()

		elseif (lives == 1 ) then
			heart1.isVisible = false
			heart2.isVisible = false

			-- once the timer runs out ask a new question
			AskQuestion()


		elseif (lives == 0) then
			heart1.isVisible = false
			heart2.isVisible = false
			heart3.isVisible = false

			-- makes the clock invisible and  cancels the
			clockText.isVisible = false
			timer.cancel(countDownTimer)

			-- makes gameOver visible and other objects invisible
			gameOver.isVisible = true
			gameOverSoundChannel = audio.play(gameOverSound)
			questionObject.isVisible = false
			correctObject.isVisible = false
			incorrectObject.isVisible = false
			numericField.isVisible = false
			pointsObject.isVisible = false
		end

		
	end
	
end


-- function that calls the timer
local function StartTimer()
	-- create a countdown timer that loops for infinity
	countDownTimer = timer.performWithDelay( 1000, UpdateTime, 0)
end

local function HideCorrect()
	-- change the correct object to be invisible
	correctObject.isVisible = false

	-- call the function that ask the question
	AskQuestion()
end

local function HideIncorrect()
	-- change the incorrect object to be invisible
	incorrectObject.isVisible = false

	-- call the function that ask the question
	AskQuestion()
end

local function HideCorrectObject2()
	-- change the correctObject2 to be invisible
	correctObject2.isVisible = false

end


local function NumericFieldListener( event )
	
	-- User begins editing "numericField"
	if ( event.phase == "began" ) then

		-- clear text field
		event.target.text = ""

	elseif (event.phase == "submitted") then

		-- when the answer is submitted (enter key is pressed) set user input to user's answer
		userAnswer = tonumber(event.target.text)

		-- if the user answer and the correct answer are the same:
		if (userAnswer == correctAnswer) then
			correctObject.isVisible = true

			-- play a sound when the user gets it corrct
			correctSoundChannel = audio.play(correctSound, {channel = 1})

			-- when the user gets it correct add one point to the code and display it in text
			points = points + 1
			pointsObject.text = "Points : " .. points

			-- clear text field
			event.target.text = ""
			
			-- call the HideCorrect function after 1 second
			timer.performWithDelay(1000, HideCorrect)

			
			if (points == 5) then
				--make everything disapear but the game complete image
				gameCompleted.isVisible = true
				gameCompletedSoundChannel = audio.play(gameCompletedSound)
				questionObject.isVisible = false
				correctObject.isVisible = false
				incorrectObject.isVisible = false
				numericField.isVisible = false
				pointsObject.isVisible = false
				heart1.isVisible = false
			 	heart2.isVisible = false
			 	heart3.isVisible = false
			 	clockText.isVisible = false
			 	timer.cancel(countDownTimer)

			end


		 else

			incorrectObject.isVisible = true

			-- clear text field
			event.target.text = ""

			-- call the HideCorrectObject2 function after 1 second
			timer.performWithDelay(1000, HideCorrectObject2)

			-- play a sound when the user gets it incorrct
			incorrectSoundChannel = audio.play(incorrectSound, {channel = 2})
			
			-- display correct answer
			correctObject2.text = "Correct answer was: " .. correctAnswer
		
			-- take away a life
			lives = lives - 1

			
			if (lives == 2) then
			 	heart1.isVisible = false
			 	heart2.isVisible = true
			 	heart3.isVisible = true

			elseif (lives == 1) then
			 	heart1.isVisible = false
			 	heart2.isVisible = false
			 	heart3.isVisible = true

			elseif (lives == 0) then
			 	heart1.isVisible = false
			 	heart2.isVisible = false
			 	heart3.isVisible = false

			 -- makes the clock invisible and cancels the
			 	clockText.isVisible = false
			 	timer.cancel(countDownTimer)

			 -- makes gameOver visible and other objects invisible 
			 	gameOver.isVisible = true
			 	gameOverSoundChannel = audio.play(gameOverSound)
			 	questionObject.isVisible = false
			 	correctObject.isVisible = false
			 	incorrectObject.isVisible = false
			 	numericField.isVisible = false
			 	pointsObject.isVisible = false
			 	correctObject2.isVisible = false

			end

		 	-- call the HideInCorrect function after 1 second
			timer.performWithDelay(1000, HideIncorrect)

		end

		-- reset the number of seconds left
		secondsLeft = totalSeconds + 1
	end
end

-----------------------------------------------------------------------------------------------
-- OBJECT CREATION
-----------------------------------------------------------------------------------------------

-- creat the lives to display on the screen
heart1 = display.newImageRect("Images/heart.png", 100, 100)
heart1.x = display.contentWidth * 4 / 8
heart1.y = display.contentHeight * 1 / 7

heart2 = display.newImageRect("Images/heart.png", 100, 100)
heart2.x = display.contentWidth * 5 / 8
heart2.y = display.contentHeight * 1 / 7

heart3 = display.newImageRect("Images/heart.png", 100, 100)
heart3.x = display.contentWidth * 6 / 8
heart3.y = display.contentHeight * 1 / 7


-- create the text object to hold the countdowm timer
clockText = display.newText(secondsLeft, 150, 80, native.systemFontBold, 150)
clockText: setFillColor( 51/255, 43/255, 196/255 )


-- dispalys a question and sets the colour
questionObject = display.newText( "", 230, 250, "Arial", 60 )
questionObject:setTextColor(155/255, 14/255, 198/255)







-- display the correct answer
correctObject2 = display.newText( "", 600, 700, nil, 50 )
correctObject2.y = 600
correctObject2.x = 400
correctObject2:setTextColor(155/255, 14/255, 198/255)











-- create the correct text object and make it invisible
correctObject = display.newText( "Correct!", display.contentWidth/2, display.contentHeight*2/3, nil, 50 )
correctObject:setTextColor(10/255, 159/255, 19/255)
correctObject.isVisible = false

-- create the incorrect text object and make it invisible
incorrectObject = display.newText( "Incorrect", display.contentWidth/2, display.contentHeight*2/3, nil, 50 )
incorrectObject:setTextColor(255/255, 0/255, 0/255)
incorrectObject.isVisible = false

-- make the points object
pointsObject = display.newText( "Points : " .. points, display.contentWidth/2, display.contentHeight/2, nil, 60 )

-- change the colour of the "points" object
pointsObject: setTextColor(5/255, 0/255, 255/255)

-- create numeric feild 
numericField = native.newTextField( 475, 250, 200, 100 )
numericField.inputType = "decimal"

-- add event listener for the numeric field
numericField:addEventListener( "userInput", NumericFieldListener )

-- create the game over to display on the screen
gameOver = display.newImageRect("Images/gameOver.png", 1100, 900)
gameOver.x = 500
gameOver.y = 400
gameOver.isVisible = false

-- create the game completed to display on the screen
gameCompleted = display.newImageRect("Images/gameCompleted.png", 1100, 900)
gameCompleted.x = 500
gameCompleted.y = 400
gameCompleted.isVisible = false
-----------------------------------------------------------------------------------------------
-- FUNCTION CALLS
-----------------------------------------------------------------------------------------------

-- call the function to ask the question
AskQuestion()
StartTimer()