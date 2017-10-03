function showevents()
{
	var data=$('').val();


	$.ajax({
		url:'http://127.0.0.1:5000/events/'+data,
		type:'GET',
		dataType:'json',
		success:function(resp)
		{
			$('#eventdetails').html("");
			if(resp.status== 'ok')
			{
				for(i=0; i<resp.count; i++)
				{
					studid=resp.entries[i].studid;
					fname=resp.entries[i].firstname;
					lname=resp.entries[i].lastname;
					course=resp.entries[i].course;

					$('#eventdetails').append(rowdata(studid, fname, lname, course));

				}
			}
		},
		error:function(err)
		{
			alert("Error in the programmer");
		}

	});
}


function rowdata(studid, fname, lname, course)
{
	return '<tr class="table-success">'+
			'<td>'+studid+'</td>'+
			'<td>'+fname+'</td>'+
			'<td>'+lname+'</td>'+
			'<td>'+course+'</td>'+
			'</tr>';
}