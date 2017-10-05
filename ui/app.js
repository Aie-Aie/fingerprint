function showevents1(){
    var data =$('#idnumber').val();
    alert(data);

}


function showevents()
{

	$.ajax({
		url:'http://127.0.0.1:5000/events/'+data,
		type:'GET',
		dataType:'json',
		success:function(resp)
		{
            $('#data').show();
			$('#eventdetails').html("");
			if(resp.status== 'ok')
			{
				for(i=0; i<resp.count; i++)
				{
					studid=resp.entries[i].studid;
					event=resp.entries[i].event;
					eventdate=resp.entries[i].eventdate;
					signin=resp.entries[i].signin;
					signout =resp.entries[i].signout;


					$('#eventdetails').append(rowdata(studid, event, eventdate, signin, signout));

				}
			}
		},
		error:function(err)
		{
			alert("Error in the programmer");
		}

	});
}


function rowdata(studid, event, eventdate, signin, signout)
{
	return '<tr class="table-success">'+
			'<td>'+studid+'</td>'+
			'<td>'+event+'</td>'+
			'<td>'+eventdate+'</td>'+
			'<td>'+signin+'</td>'+
			'<td>'+signout+'</td>'+
			'</tr>';
}