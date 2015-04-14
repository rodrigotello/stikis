$(function(){
  $('#stikis').droppable({ scope: "stikis", greedy: true, tolerance: "fit" })
  $(".board-title").css("margin-left", "-"+$(".board-title").width()/2+"px" ).show()
  $('.stiki').each(function(){ 
    $(this).css("top", $(this).attr("py")+"px")
    $(this).css("left", $(this).attr("px")+"px")
    $(this).css("background", "#"+$(this).attr("c"))
    $(this).addClass($(this).attr("s"))
  })
  
  $('.stiki').show()
  
  $(".stiki").live({
    mouseenter:
      function(){ $(".hover",this).show() },
    mouseleave:
      function(){ $(".hover",this).hide() }
  });
    
  $('.stiki').draggable({ scope: "stikis", revert: "invalid" })
  $('.stiki').bind("dragstop", function(event, ui){
     var position = $(this).position();
     var id = $(this).attr('sid')
     var url = "/stikis/"+id
     $.ajax({
       url:url, 
       type : "PUT",
       data:{positionx: position.left, positiony:position.top, id:id, board_id: $("#board").val(), user_id: $("#stikis").attr("user") },
       dataTypeString:"json"
    })//End ajax 
  })
  
  $('.stiki .col li').live("click", function(){
    $('.stiki .col li').removeClass("active")
    $(this).addClass("active")
    $(this).closest(".stiki").attr("c", $(this).text()).css("background", "#"+$(this).text())
    var color = $(this).attr("num")
    var id =$(this).closest(".stiki").attr('sid')
    var url = "/stikis/"+id
    $.ajax({
      url:url, 
      type : "PUT",
      data:{color:color, id:id, board_id: $("#board").val(), user_id: $("#stikis").attr("user") },
      dataTypeString:"json"
    })//End ajax
  })
  
  $('.stiki .size li').live("click", function(){
    $('.stiki .size li').removeClass("active");
    $(this).addClass("active")
    $(this).closest(".stiki").removeClass("sml mid lrg")
    $(this).closest(".stiki").addClass($(this).text())
    var area = $(this).attr("num")
    var id =$(this).closest(".stiki").attr('sid')
    var url = "/stikis/"+id
    $.ajax({
      url:url, 
      type : "PUT",
      data:{area:area, id:id, board_id: $("#board").val(), user_id: $("#stikis").attr("user") },
      dataTypeString:"json"
    })//End ajax
  })
  
  $(".stiki .options").live({
    mouseenter:
      function(){ $("ul",this).show() },
    mouseleave:
      function(){ $("ul",this).hide() }
  });
  
  var stikisnum = 0;
  
  $("#addstiki").click(function(e){
    e.preventDefault()
    stikisnum += 1
    var colors = '';
    var sizes = '';
    for(i in available_colors){
      colors+= '<li style="background:#'+available_colors[i]+'" num="'+i+'">'+available_colors[i]+'</li>'
    }
    for(i in available_sizes){
      sizes+= '<li num="'+i+'">'+available_sizes[i]+'</li>'
    }
    var colors = '<div class="col options hover" style="display:none"><ul>'+colors+'</ul></div>';
    var sizes = '<div class="size options hover" style="display:none"><ul>'+sizes+'</ul></div>';
    var close = '<div class="close hover"><i class="icon-remove-sign"></i></div>';
    $("#stikis").append('<div class="stiki new draggable ui-widget-content ui-draggable" style="display:block; left:982px; top:540px">'+close+'<textarea name="stiki-'+stikisnum+'" class="newstiki stiki-'+stikisnum+'"></textarea>'+colors+sizes+'</div>')
    $('#stikis').find('.stiki.new').animate({ "top": "-=160px"}, 1000);
    $('.stiki-'+stikisnum).focus()
    $("textarea").limit(60)
    $('.stiki').draggable({ scope: "stikis", revert: "invalid" })
    //TODO Save stiki here!
    
    $('.stiki').bind("dragstop", function(event, ui){
       var position = $(this).position();
       var c = '.'+$(this).attr("name")
       var id = $(this).attr('sid')
       var url = "/stikis/"+id
       $.ajax({
         url:url, 
         type : "PUT",
         data:{positionx: position.left, positiony:position.top, id:id, board_id: $("#board").val(), user_id: $("#stikis").attr("user") },
         dataTypeString:"json"})//End post 
    })
  })
  
  $(".newstiki").live("blur",function(){
    var position = $(this).parent().position();
    var c = '.'+$(this).attr("name")
    var parent = $(this).parent()
    $.post('/stikis', {
      content: $(this).val(),
      positionx: position.left,
      positiony: position.top,
      area: 1,
      color: 0,
      board_id: $("#board").val(),
      user_id: $("#stikis").attr("user")
    },
    function(data){
      var text = data.content
      //TODO: Redirect if no text because of forgery
      $("#stikis").find(c).detach()
      parent.removeClass("new")
      parent.attr("sid",  data.id)
      parent.append('<span class="content">'+text+'</span>')
    }, "json")//End post
  })
  
  $(".stiki .content").live('click', function(){
    stikisnum += 1
    var t = $(this).text()
    var parent = $(this).parent()
    $(this).detach()
    parent.append('<textarea name="stiki-'+stikisnum+'" class="editingstiki stiki-'+stikisnum+'">'+t+'</textarea>')
    $("textarea").limit(60)
    $('.stiki-'+stikisnum).focus()
  })
  
  $('.editingstiki').live("blur", function(){
    var position = $(this).parent().position();
    var c = '.'+$(this).attr("name")
    var parent = $(this).parent()
    var id = $(this).parent().attr('sid')
    var url = "/stikis/"+id
    $.ajax({
      url:url, 
      type : "PUT",
      data:{content: $(this).val(), id:id, board_id: $("#board").val(), user_id: $("#stikis").attr("user") },
      success : function(data, textStatus, jqXHR){
        var d = eval('(' + data + ')')
        var text = d.content
        // TODO : Redirect if no data because of forgery
        parent.find(c).detach()
        parent.append('<span class="content">'+text+'</span>')
      }, 
      dataTypeString:"json"})//End post
  })
  
  $(".stiki .close").live("click",function(){
    stiki = $(this).closest(".stiki")
    if( stiki.hasClass("new"))
    {
      stiki.fadeOut("1000");
    }
    else{
      var id = stiki.attr('sid')
      var url = "/stikis/"+id
      $.ajax({
        url:url, 
        type : "DELETE",
        data:{ id:id, board_id: $("#board").val(), user_id: $("#stikis").attr("user") },
        success : function(){
          stiki.fadeOut("1000");
        },
        dataTypeString:"json"
      })//End ajax
    }
  })
  
})