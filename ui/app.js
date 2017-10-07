
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
				showlistevent();
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

function addevent(){
	var eventname= $('#eventName').val();
	var eventdate=$('#eventDate').val();


/*
	$.ajax({
		url: 'http://127.0.0.1:5000/events/'+eventName+'/'+eventdate,
		dataType: 'json',
		type: 'GET',
		success: function(resp){

		},
		error: function(err){

		}

	});
*/
}

function showlistevent(){

}

var fileInput = $('#eventFile');
var uploadButton = $('#upload');

uploadButton.on('click', function() {
    if (!window.FileReader) {
        alert('Your browser is not supported')
    }
    var input = fileInput.get(0);
    
   
    var reader = new FileReader();
    if (input.files.length) {
        var textFile = input.files[0];
        reader.readAsText(textFile);
        $(reader).on('load', processFile);
    } else {
        alert('Please upload a file before continuing')
    } 
});

function processFile(e) {
    var file = e.target.result,
        results;
    if (file && file.length) {
        results = file.split("\n");
        console.log(results)
        //$('#name').val(results[0]);
       // $('#age').val(results[1]);
    }
}


function addRowHandlers() {
    var table = document.getElementById("data");
    var rows = table.getElementsByTagName("tr");
    for (i = 0; i < rows.length; i++) {
        var currentRow = table.rows[i];
        var createClickHandler = 
            function(row) 
            {
                return function() { 
                    var cell = row.getElementsByTagName("td")[0];
                    var id = cell.innerHTML;
                    alert("id:" + id);
             };
            };

        currentRow.onclick = createClickHandler(currentRow);
    }
}
window.onload = addRowHandlers();

