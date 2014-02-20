function show_statusbar(p_id,resource){
$('.btn.btn-sm.btn-default').addClass('disabled');
$('.download').html("");
$('.error').html("");
$('.loadbar').show();
  path = (resource=="customers/get_users") ? "/customers/"+p_id+"/get_users" : '/'+resource+'?project_id='+p_id

  $.ajax({
      type: 'GET',
      url: site_url+path,
      dataType : 'json',
      success: function(data){
        $('.btn.btn-sm.btn-default').removeClass('disabled');
      if (data.failure){
           $('.error').html(data.failure)
      }
      else{
        window.location.reload();
        if (data.resource=="customers_get_users"){
          //$('.download').html("<a href="+site_url+"/customers/"+data.project_id+"?get_user=true>Click here to download</a>")
        }
        else{
          //$('.download').html("<a href="+site_url+"/"+data.resource+"/"+data.project_id+">Click here to download</a>")
        }

      }
       $('.loadbar').hide();
      }
    });
    return false;
  }
