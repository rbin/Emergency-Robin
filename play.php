<?php 
	header('Content-type: text/xml');
	echo '<?xml version="1.0" encoding="UTF-8"?>';
	echo '<Response>';

	//Create variable with user input.
	$user_pushed = (int) $_REQUEST['Digits'];

	if ($user_pushed == 1)
	{
		echo '<Play>/sounds/love.mp3</Play>';
	}
	elseif ($user_pushed == 2)
	{
		echo '<Play>URL OF YOUR SECOND FILE TO PLAY</Play>';
	}
	elseif ($user_pushed ==3)
	{
		echo '<Play>URL OF YOUR THRD FILE TO PLAY</Play>';
	}
	elseif ($user_pushed ==4)
	{
		echo '<Play>URL OF YOUR FORTH FILE TO PLAY</Play>';
	}
	else
	{
		echo '<Redirect>/record</Redirect>';
	}
	echo '</Response>';
?>