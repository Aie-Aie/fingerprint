
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
				$('.section').show();
				$('.main').show();
			}
			else{
				$('#errorAlert').show();
				
			}
		},
		error: function(err){
			alert("Error");
		}

	})
}
