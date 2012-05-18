var $j = jQuery.noConflict();

function resetButton(divname){
	$j('#' + divname).parent().find('.button').css('backgroundColor',"#2E2B29");
}

function drawGraph(divname, day, color, arr){
	$j('#' + divname).html('');
    $j('#' + divname).parent().find('.button[day="'+day+'"]').css('backgroundColor',"#a69588");
	
	
	var expArr = {"thanks": arr};
	
	var areagraph4 = new Grafico.BarGraph($(divname),
		expArr,
		{
		  background_color: "2b2623",
		  colors:				{thanks: color},
		  label_color: 			"#ece3cb",
		  font_size:				12,
		  grid :                    false,
		  draw_axis :               true,
		  plot_padding:			0,
		  right_padding :            0,
		  show_vertical_labels :    true,
		  show_horizontal_labels :  true,
		  show_ticks: 					false,
		  show_vertical_grid:	true,
		  labels:			['12AM','1', '2', '3', '4','5','6','7','8','9','10','11','12PM','1','2','3','4','5','6','7','8','9','10','11'],
		  datalabels:	{thanks: arr}
		});
		
}

/***********THANKS************************/
function thanksSunday(){
	resetButton("thanksgraph");
	drawGraph("thanksgraph", "sun", '#385c78' , json.thanks[0]);
}
function thanksMonday(){
	resetButton("thanksgraph");
	drawGraph("thanksgraph", "mon", '#385c78' , json.thanks[1]);
}
function thanksTuesday(){
	resetButton("thanksgraph");
	drawGraph("thanksgraph", "tue", '#385c78' , json.thanks[2]);
}
function thanksWednesday(){
	resetButton("thanksgraph");
	drawGraph("thanksgraph", "wed", '#385c78' , json.thanks[3]);
}
function thanksThursday(){
	resetButton("thanksgraph");
	drawGraph("thanksgraph", "thu", '#385c78' , json.thanks[4]);
}
function thanksFriday(){
	resetButton("thanksgraph");
	drawGraph("thanksgraph", "fri", '#385c78' , json.thanks[5]);
}
function thanksSaturday(){
	resetButton("thanksgraph");
	drawGraph("thanksgraph", "sat", '#385c78' , json.thanks[6]);
}

/***************SWEARS**************************/
function swearSunday(){
	resetButton("sweargraph");
	drawGraph("sweargraph", "sun", '#9d302f' , json.angry[0]);
}
function swearMonday(){
	resetButton("sweargraph");
	drawGraph("sweargraph", "mon", '#9d302f' , json.angry[1]);
}
function swearTuesday(){
	resetButton("sweargraph");
	drawGraph("sweargraph", "tue", '#9d302f' , json.angry[2]);
}
function swearWednesday(){
	resetButton("sweargraph");
	drawGraph("sweargraph", "wed", '#9d302f' , json.angry[3]);
}
function swearThursday(){
	resetButton("sweargraph");
	drawGraph("sweargraph", "thu", '#9d302f' , json.angry[4]);
}
function swearFriday(){
	resetButton("sweargraph");
	drawGraph("sweargraph", "fri", '#9d302f' , json.angry[5]);
}
function swearSaturday(){
	resetButton("sweargraph");
	drawGraph("sweargraph", "sat", '#9d302f' , json.angry[6]);
}



function classRed(){
	resetButton("classgraph");
	$j('#classgraph').html('');
	$j('#classgraph').parent().find('.button[team="red"]').css('backgroundColor',"#a69588");

	
	var expArr = {"thanks": json.classchange[0]};
	
	var areagraph4 = new Grafico.BarGraph($("classgraph"),
		expArr,
		{
		  background_color: "2b2623",
		  colors:				{thanks:  '#9d302f'},
		  label_color: 			"#ece3cb",
		  font_size:				12,
		  grid :                    false,
		  draw_axis :               true,
		  plot_padding:			0,
		  right_padding :            0,
		  show_vertical_labels :    true,
		  show_horizontal_labels :  true,
		  show_ticks: 					false,
		  show_vertical_grid:	true,
		  labels:			['Scout','Sniper','Soldier','Demo','Medic','Heavy','Pyro','Spy','Engie'],
		  datalabels:	{thanks:json.classchange[0]}
		});

}
function classBlu(){
	resetButton("classgraph");
	$j('#classgraph').html('');
	$j('#classgraph').parent().find('.button[team="blu"]').css('backgroundColor',"#a69588");

	
	var expArr = {"thanks": json.classchange[1]};
	
	var areagraph4 = new Grafico.BarGraph($("classgraph"),
		expArr,
		{
		  background_color: "2b2623",
		  colors:				{thanks:  '#385c78'},
		  label_color: 			"#ece3cb",
		  font_size:				12,
		  grid :                    false,
		  draw_axis :               true,
		  plot_padding:			0,
		  right_padding :            0,
		  show_vertical_labels :    true,
		  show_horizontal_labels :  true,
		  show_ticks: 					false,
		  show_vertical_grid:	true,
		  labels:			['Scout','Sniper','Soldier','Demo','Medic','Heavy','Pyro','Spy','Engie'],
		  datalabels:		{thanks: json.classchange[1]}
		});
}


function wins(){

	var expArr = {"thanks": json.wins};
	var areagraph4 = new Grafico.BarGraph($("wingraph"),
		expArr,
		{
		  background_color: "2b2623",
		  color:			'#9d302f',
		  bargraph_lastcolor: '#385c78',
		  label_color: 			"#ece3cb",
		  font_size:				16,
		  grid :                    false,
		  draw_axis :               true,
		  plot_padding:			0,
		  right_padding :            0,
		  show_vertical_labels :    true,
		  show_horizontal_labels :  true,
		  show_ticks: 					false,
		  show_vertical_grid:	true,
		  labels:			['red','blu'],
		  datalabels:		{thanks: json.wins} 
		});


}
/*******************TIME********************************/
function timeSunday(){
	resetButton("timegraph");
	drawGraph("timegraph", "sun", '#385c78' , json.time[0]);
}
function timeMonday(){
	resetButton("timegraph");
	drawGraph("timegraph", "mon", '#385c78' , json.time[1]);
}
function timeTuesday(){
	resetButton("timegraph");
	drawGraph("timegraph", "tues", '#385c78' , json.time[2]);
}
function timeWednesday(){
	resetButton("timegraph");
	drawGraph("timegraph", "wed", '#385c78' , json.time[3]);
}
function timeThursday(){
	resetButton("timegraph");
	drawGraph("timegraph", "thu", '#385c78' , json.time[4]);
}
function timeFriday(){
	resetButton("timegraph");
	drawGraph("timegraph", "fri", '#385c78' , json.time[5]);
}
function timeSaturday(){
	resetButton("timegraph");
	drawGraph("timegraph", "sat", '#385c78' , json.time[6]);
}


/***************LOGINS**************************/
function loginSunday(){
	resetButton("logingraph");
	drawGraph("logingraph", "sun", '#9d302f',  json.logins[0]);
}
function loginMonday(){
	resetButton("logingraph");
	drawGraph("logingraph", "mon", '#9d302f' , json.logins[1]);
}
function loginTuesday(){
	resetButton("logingraph");
	drawGraph("logingraph", "tue", '#9d302f' , json.logins[2]);
}
function loginWednesday(){
	resetButton("logingraph");
	drawGraph("logingraph", "wed", '#9d302f' , json.logins[3]);
}
function loginThursday(){
	resetButton("logingraph");
	drawGraph("logingraph", "thu", '#9d302f' , json.logins[4]);
}
function loginFriday(){
	resetButton("logingraph");
	drawGraph("logingraph", "fri", '#9d302f' , json.logins[5]);
}
function loginSaturday(){
	resetButton("logingraph");
	drawGraph("logingraph", "sat", '#9d302f', json.logins[6]);
}




	var json = {};
	
$j(document).ready(function() {



	$j.getJSON('sodarktheconofman.txt', function(data) {
			json = data;
	}).success(function() {


		thanksSaturday();
	    swearSaturday();
		classRed();
		wins();
		timeSaturday();
		loginSaturday();
		
		
	});



  });