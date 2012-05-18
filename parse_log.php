<?php
function return_hour($t)
{
	$sub = substr($t,0,2);
	if($sub[0] == "0")
		return $sub[1];
	else
		return $sub;	
}

function return_day($d)
{
	return intval(date("w", strtotime($d)));
}

function parse_con($current_line)
{
	global $global_connect;
	$i = 0;$j = 0;$date = "";$time = "";$name = "";
	preg_match("/[0-9]{2}\/[0-9]{2}\/[0-9]{4}\s-\s[0-9]{2}:[0-9]{2}:[0-9]{2}/", $current_line, $matches);
	$date;$time;$i;$j;
    			foreach($matches as $match)
    			{
    				$date = substr($match, 0, 10);
    				$time = substr($match, 13, 8);
    			}
    			//$i = strpos($current_line,"[CON]");
    			//$j = strpos($current_line,"connected",$i+6);
    			//$name = substr($current_line, $i+6, $j-2-$i-5);
    			if(isset($global_connect[return_day($date)][return_hour($time)]))
    				$global_connect[return_day($date)][return_hour($time)]++;
    			else
    				$global_connect[return_day($date)][return_hour($time)] = 1;
}

function parse_thanks($current_line)
{
	global $global_thanks;
	$i = 0;$j = 0;$date = "";$time = "";$name = "";
	preg_match("/[0-9]{2}\/[0-9]{2}\/[0-9]{4}\s-\s[0-9]{2}:[0-9]{2}:[0-9]{2}/", $current_line, $matches);
    			foreach($matches as $match)
    			{
    				$date = substr($match, 0, 10);
    				$time = substr($match, 13, 8);
    			}
    			//got date and time. Now extract name
    			//preg_match("<\[VCHAT.*.\([0-9]\)>", $current_line , $matches);
				//$name = substr($matches[0], 8, -4);
				//this user said "thanks". Hence update count
				if(isset($global_thanks[return_day($date)][return_hour($time)]))
    				$global_thanks[return_day($date)][return_hour($time)]++;
    			else
    				$global_thanks[return_day($date)][return_hour($time)] = 1;
}

function parse_classchange($current_line)
{
	global $global_classchg;	
	preg_match("/T: (2|3) Cl: [0-9]+/",$current_line, $matches);
	$team = intval($matches[0][3]);
	$class = intval($matches[0][9]);

	if(isset($global_classchg[$team][$class]))
		$global_classchg[$team][$class]++;
	else
		$global_classchg[$team][$class] = 1;	
	//echo($global_classchg[$team][$class]."\n");
}

function parse_angry($current_line)
{
	global $global_angry;
	preg_match("/(ahole|anus|ash0le|ash0les|asholes|ass|Ass|Monkey|Assface|assh0le|assh0lez|asshole|assholes|assholz|asswipe|bastard|bastards|bastardz|basterds|basterdz|Biatch|bitch bitches|boffing|butthole|buttwipe|c0ck|c0cks|c0k|Clit|cock|cockhead|cocks|CockSucker|cocksucker|cum|cunt|cunts|dick|dild0|dild0s|dildo|dildo|dilld0|fuck|fucker|fag|fag1t|faget|fagg1t|faggit|faggot|fagit|fags|fagz|faig|faigs|fart|Fudge Packer|fuk|Fukah|gay|gayboy|gaygirl|gays|gayz|h00r|h0ar|h0re|hells|hoar|hoor|hoore|jackoff|jap|japs|jerkoff|jisim|jiss|jizm|jizz|knob|Lesbian|Lezzian|Lipshits|Lipshitz|masstrbate|masterbaiter|masterbate|masterbates n1gr|nast|nigger|nigur|niiger|niigr|orafis|orgasim|orgasm|orgasum|oriface|orifice|orifiss|packi|packie|packy|paki|pakie|paky|pecker|peeenus|peeenusss|peenus|peinus|pen1s|penas|penis|penus|penuus|Phuc|Phuck|Phuk|Phuker|Phukker|polac|polack|polak|Poonani|pr1c|pussee|pussy|puuke|puuker|recktum|rectum|retard|scank|schlong|screwing|semen|sex|sexy|sh1t|sh1ter|sh1ts|sh1tter|sh1tz|shit|shits|shitter|Shitty|Shity|shitz|Shyt|Shyte|Shytty|slut|sluts|Slutty|tit|turd|va1jina|vag1na|vagiina|vagina|vaj1na|vajina|vullva|vulva|w0p|wh00r|wh0re|whore|xrated|xxx)/", $current_line, $swear_matches);
	if(!(count($swear_matches)))
		return;
	$i = 0;$j = 0;$date = "";$time = "";$name = "";
	preg_match("/[0-9]{2}\/[0-9]{2}\/[0-9]{4}\s-\s[0-9]{2}:[0-9]{2}:[0-9]{2}/", $current_line, $matches);
    foreach($matches as $match)
    {
    				$date = substr($match, 0, 10);
    				$time = substr($match, 13, 8);
    				if(isset($global_angry[return_day($date)][return_hour($time)]))
    		$global_angry[return_day($date)][return_hour($time)]++;
    else
    		$global_angry[return_day($date)][return_hour($time)] = 1;
    }
}

function parse_wins($current_line)
{
	global $global_wins;
	global $global_time;
	preg_match("/Winner: [0-9]/",$current_line, $matches);
	$win_team = intval($matches[0][8]);
	unset($matches);
	preg_match("/Time: [0-9]*/",$current_line, $matches);
	$completion_time = intval(substr($matches[0], 6));
	if(isset($global_wins[$win_team]))
		$global_wins[$win_team]++;
	else
		$global_wins[$win_team] = 1;
	unset($matches);
	preg_match("/[0-9]{2}\/[0-9]{2}\/[0-9]{4}\s-\s[0-9]{2}:[0-9]{2}:[0-9]{2}/", $current_line, $matches);
    $date = substr($matches[0], 0, 10);
    $time = substr($matches[0], 13, 8);
    if(isset($global_time[return_day($date)][return_hour($time)]))
    	array_push($global_time[return_day($date)][return_hour($time)], $completion_time);
    else
    {
    	$global_time[return_day($date)][return_hour($time)] = array();
    	array_push($global_time[return_day($date)][return_hour($time)], $completion_time);
    }
}

function average_timings()
{
	global $global_time, $global_time_2;
    //now calculate average:
    
    for($i=0; $i<7; $i++)
    	for($j = 0; $j < 24; $j++)
    	{
    		//$global_time[$i][$j] = array_sum($dummy[$i][$j])/count($dummy[$i][$j]);
    		if(isset($global_time[$i][$j]))
    			$global_time_2[$i][$j] = round(array_sum($global_time[$i][$j])/count($global_time[$i][$j]));
    		else
    			$global_time_2[$i][$j] = 0;	
    	}	
}  

function wrap_it_up()
{

		global $global_connect, $global_thanks, $global_classchg, $global_angry, $global_wins, $global_time, $global_time_2, $global_jsonify;	
		$numeric_classchg; $numeric_connect; $numeric_thanks; $numeric_angry; $numeric_wins;
		
		for($i=0;$i<2;$i++)
			for($j=0;$j<9;$j++)
					$numeric_classchg[$i][$j] = $global_classchg[$i+2][$j+1];
		unset($global_classchg);
			for($i=0;$i<7;$i++)
				for($j=0;$j<24;$j++)
					$numeric_connect[$i][$j] = (isset($global_connect[$i][$j])?$global_connect[$i][$j]:0);
		unset($global_connect);		
		for($i=0;$i<7;$i++)
				for($j=0;$j<24;$j++)
					$numeric_thanks[$i][$j] = (isset($global_thanks[$i][$j])?$global_thanks[$i][$j]:0);
		unset($global_thanks);		
		for($i=0;$i<7;$i++)
				for($j=0;$j<24;$j++)
					$numeric_angry[$i][$j] = (isset($global_angry[$i][$j])?$global_angry[$i][$j]:0);
		unset($global_angry);
		$numeric_wins[0] = $global_wins[2];
		$numeric_wins[1] = $global_wins[3];				
		$global_jsonify['logins'] = $numeric_connect;
		$global_jsonify['thanks'] = $numeric_thanks;
		$global_jsonify['angry'] = $numeric_angry;
		$global_jsonify['classchange'] = $numeric_classchg;
		$global_jsonify['wins'] = $numeric_wins;
		$global_jsonify['time'] = $global_time_2;
}  			
	
?>

<?php
	//global variables
	$global_connect = array(); 
	$global_thanks = array(); 
	$global_classchg = array(); 
	$global_angry = array(); 
	$global_wins = array(); 
	$global_time = array(); 
	$global_time_2 = array(); 
	$global_jsonify = array();
	
	
    
    	$file_text = file("/srv/cs467.perryhuang.com/public_html/server12.tf2newbs.com/slog_test.log", FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    	foreach ($file_text as $line_num => $line) {	
    	//each line of the current log file
    	
    		//CON
    		if(strpos($line,"[CON]"))
    			{ parse_con($line);	
    			  continue;
    			}  
    		
    		//VCHAT - msg 0 1
    		if(strpos($line,"[VCHAT]") && strpos($line,"Msg:  0 1"))
    			{ parse_thanks($line);
    			  continue;
    			} 
    			
    		//CLASSCHNG	
    		if(strpos($line, "[CLASSCHNG]"))
    			{ parse_classchange($line);
    		      continue;
    		    } 
    		     
    		//CHAT - swears
    		if(strpos($line, "[CHAT]"))
    			{ parse_angry($line);	
    			  continue;
    			}  
    			
    		//WINS and COMPLETION TIME
    		if(strpos($line, "[ROUND WIN]"))
    			{ parse_wins($line);
    			  continue;
    			} 
    				
    			
    	}
    	
    
    
    average_timings();
    wrap_it_up();
    
   /*
    for($i = 0; $i < 7; $i++)
    {
    	$output_array[7][$i] = count($global_connect[$i],COUNT_RECURSIVE);
    	$output_array_2[7][$i] = count($global_thanks[$i],COUNT_RECURSIVE);	
    	for($j = 0; $j < 24; $j++)
    	{
    		if(isset($global_connect[$i][$j]))
    			$output_array[$i][$j] = count($global_connect[$i][$j],COUNT_RECURSIVE);
    		else
    			$output_array[$i][$j] = 0;
    			
    		if(isset($global_thanks[$i][$j]))
    			$output_array_2[$i][$j] = count($global_thanks[$i][$j],COUNT_RECURSIVE);
    		else
    			$output_array_2[$i][$j] = 0;	
    	}
    }
    file_put_contents("logins.txt",json_encode($output_array),LOCK_EX);
    file_put_contents("thanks.txt",json_encode($output_array_2),LOCK_EX);
  */
  
    file_put_contents("/srv/cs467.perryhuang.com/public_html/tf2-stats/sodarktheconofman.txt",json_encode($global_jsonify), LOCK_EX);
    
?>
