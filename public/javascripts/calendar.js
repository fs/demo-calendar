$previousDayLoading = false;
$nextDayLoading = false;

Element.addMethods({
  scrollTo: function(element, left, top){
    var element = $(element);
    if (arguments.length == 1){
      var pos = element.cumulativeOffset();
      window.scrollTo(pos[0], pos[1]);
    } else {
      element.scrollLeft = left;
      element.scrollTop  = top;
    }
    return element;
  }
});

var editEvent = function(id){
  new Ajax.Updater('event_form', '/events/'+id+'/edit', {
    asynchronous:true,
    evalScripts:true,
    method:'get',
    onComplete:function(request){
      document.body.down('.panel.form .header').update('Edit Event');
      new Effect.Highlight('event_form');
    }
  });
};

var showDay = function(date, complete){
  var day = $(date);
  if (day) {
    var content = document.body.down('.panel.calendar .content');
    content.scrollTo(0, day.cumulativeOffset().top - content.cumulativeOffset().top);
    if (typeof(complete) == 'function') {complete()};
  }else{
    loadDay(date, function(){
      showDay(date);
      if (typeof(complete) == 'function') {complete()};
    });
  };
};


var loadDay = function(date, complete){
  new Ajax.Request('/calendar/day/'+date, {
    asynchronous:true,
    evalScripts:false,
    method:'get',
    onComplete:function(request){
      var day = $(date);
      if (day) {
        day.replace(request.responseText);
      }else{
        next = $(nextDate(date));
        if (next) {
          var scrollTop = document.body.down('.panel.calendar .content').scrollTop;
          next.insert({before: request.responseText});
          var height = $(date).getHeight();
          document.body.down('.panel.calendar .content').scrollTop = scrollTop + height;
        }else{
          previous = $(previousDate(date));
          if (previous) {
            previous.insert({after: request.responseText});
          }else{
            document.body.down('.panel.calendar .content').update(request.responseText);
            loadDay(previousDate(date));
            loadDay(nextDate(date));
          };
        };
      };
      if (typeof(complete) == 'function') {complete()};
    }
  });
};

var previousDate = function(date){
  newDate = new Date(Date.parse(date.gsub('-', '/')) - 86400000);
  var day = newDate.getDate();
  if (day < 10) {day = '0'+day};
  var month = newDate.getMonth()+1;
  if (month < 10) {month = '0'+month};
  var year = newDate.getFullYear();
  return month+'-'+day+'-'+year;
};

var nextDate = function(date){
  newDate = new Date(Date.parse(date.gsub('-', '/')) + 86400000);
  var day = newDate.getDate();
  if (day < 10) {day = '0'+day};
  var month = newDate.getMonth()+1;
  if (month < 10) {month = '0'+month};
  var year = newDate.getFullYear();
  return month+'-'+day+'-'+year;
};

var showEvent = function(id, date){
  var evnt = $$('.event.'+id);
  if (evnt.length > 0) {
    var content = document.body.down('.panel.calendar .content');
    content.scrollTo(0, evnt[0].cumulativeOffset().top - content.cumulativeOffset().top);
    evnt.invoke('highlight');
  }else{
    loadEvent(id, date, function(){
      showEvent(id, date);
    });
  };
};

var loadEvent = function(id, date, complete){
  var day = $(date);
  if (day) {
    new Ajax.Request('/events/'+id, {
      asynchronous:true,
      evalScripts:false,
      method:'get',
      onComplete:function(request){
        var evnt = $$('.event.'+id);
        if (evnt.length > 0) {
          evnt.invoke('remove');
        };
        for (var i=0; i < request.responseJSON.length; i++) {
          var dayId = request.responseJSON[i][0]
          if ($(dayId)) {
            $(dayId).insert(request.responseJSON[i][1]);
          };
        };
        if (typeof(complete) == 'function') {complete()};
      }
    });
  }else{
    loadDay(date, complete);
  };
};

var insertEvent = function(id, events){
  var firstDayExists = true;
  for (var i=0; i < events.length; i++) {
    var day = $(events[i][0]);
    if (day) {
      day.insert({bottom: events[i][1]});
    }else{
      if (i == 0) {
        firstDayExists = false;
        showEvent(id, events[i][0]);
      };
    };
  };
  if (firstDayExists) {showEvent(id)};
  editEvent(id);
};

var showNotice = function(notice){
  $('flash_notice').update(notice).show();
  new Effect.Highlight('flash_notice');
};

document.observe('dom:loaded', function(){
  document.body.down('.content').observe('scroll', function(){
    if ((this.scrollTop <= 400)&&(!$previousDayLoading)) {
      $previousDayLoading = true;
      loadDay(previousDate(this.down('.day').id), function(){$previousDayLoading = false});
    };
    if ((this.scrollHeight - this.offsetHeight - this.scrollTop <= 400)&&(!$nextDayLoading)) {
      $nextDayLoading = true;
      loadDay(nextDate(this.select('.day').last().id), function(){$nextDayLoading = false});
    };
  });
  $$('.upload').each(function(el){
    new Draggable(el, {revert: true});
  });
});