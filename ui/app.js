$(function(){
	$('#event').click(function(){
		$('.sform').hide();
		$('.section').show();
		$('.main').show();
	});

});

var opendata;
var editdata;
var deletedata;
 
function showevents()
{
     var data =$('#idnumber').val();
    
   	$.ajax({
   		url:'http://127.0.0.1:5000/events/'+data,
   		type: 'GET',
   		dataType :'json',

   		success : function(resp){
   			if(resp.status == 'ok'){

   				$('#eventdetails').html("");
   				for(i=0; i<resp.count; i++)
				{
	   				firstname = resp.entries[i].firstname;
	   				lastname =resp.entries[i].lastname;
	   				event =resp.entries[i].event;
	   				eventdate = resp.entries[i].eventdate;
	   				signin = resp.entries[i].signin;
	   				signout = resp.entries[i].signout;


	   				$('#eventdetails').append(rowattendancedata(event, eventdate, signin, signout));	   
	   			}
	   			$('#attendedTB').show();
	   			$('#studname').html('Hi, '+ firstname +' '+lastname);
   			}
   			else{
   				alert("Status not ok");
   			}

   			
   		},
   		error :function (err)
   		{
   			$('#errorAlert').show();
   			$('#idnumber').html('');
	   		$('#attendedTB').hide();


   		}

   	});
}


function rowattendancedata( event, eventdate, signin, signout)
{
	return '<tr class="table-success">'+
			'<td>'+event+'</td>'+
			'<td>'+eventdate+'</td>'+
			'<td>'+signin+'</td>'+
			'<td>'+signout+'</td>'+
			'</tr>';
}



function signin(){
	var uname=$('#admin').val();
	var pwd= $('#password').val();
	
	$.ajax({
		url:'http:127.0.0.1:5000/access',
		dataType: 'json',
		type:'POST',
		data:
		{
			admin: uname,
			password:pwd
		},
		success: function(resp){
			
			if(resp.status == 'Granted'){
				$('#sform').hide();
				
				showlistevent();
				
				$('.section').show();
				$('.main').show();
			}
			
			else{
			
				
			}
		},
		error: function(err){
			alert("Error");
		}

	});
}

function showlistevent(){

	$.ajax({
		url: 'http://127.0.0.1:5000/eventlist',
		type: 'GET',
		dataType: 'json',
		success: function(resp)
		{
			$('#eventlist').html("");
			if(resp.status == 'ok'){
				for(i=0;  i<resp.count; i++)
				{
					event = resp.entries[i].event;
					eventdate= resp.entries[i].eventdate;

					$('#eventlist').append(roweventlist(event, eventdate));
				}
			}
			else{
				$('#eventlist').html("");
			}
		},
		error: function(err)
		{
			alert("error1");
		}
	});
}

function roweventlist(event, eventdate)
{
	return '<tr onclick ="clickabletable(this)">'+
			'<td>'+event+'</td>'+
			'<td>'+eventdate+'</td>'+
			'<td ><button type="button"  class="btn btn-simple btn-sm" id="modalopendata"  data-toggle="modal" data-target="#myModal_openEvent" style="font-size: 12px;">'+				
				'Open</button>'+
				'<button type="button" class="btn btn-simple btn-sm" id="modaleditdata" data-toggle="modal" data-target="#myModal_editEvent" style="font-size: 12px;">'+									
				'Edit</button>'+
				'<button type="button" class="btn btn-simple btn-sm"  id= "deletedata" style="font-size: 12px;">'+			
				'Delete</button>'+
			'</td>'+
			'</tr>';
}




function clickabletable(x){

	var n= x.rowIndex;

	var data =document.getElementById("data").rows[n].cells[0].innerHTML;
	
	opendata = document.getElementById('modalopendata');
	editdata =document.getElementById('modaleditdata');
	deletedata =document.getElementById('deletedata');


	var divopenevent = document.getElementById('myModal_openEvent');
	divopenevent.style.display ='none';
	opendata.onclick =function(){

		if (divopenevent.style.display !== 'none'){
            div.style.display = 'none';
        }

        else {
        	$.ajax({
			//url:'http://127.0.0.1/'
			success :function(resp){
				alert(data);
			},
			error: function(err){
				alert("Error");
			}

			});
            divopenevent.style.display = 'block';
        }


		
	}

	editdata.onclick =function(){
		$.ajax({
  			success : function(resp){
  				alert("editdata");
  			},

  			error: function(err){
  				alert("edit error");
  			}
		});
	}

	deletedata.onclick=function () {
		$.ajax({
			success : function(resp){
				alert("delete");
			},
			error:function(err){
				alert("delete error");
			}
		});
	}
/*
	$(document).ready(function(){
		$('#modalopendata').live('click', function(){

			alert("data");
		});
	});
*/

}






