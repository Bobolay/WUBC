$document.on("ready page:load", function() {
  //return;
  $(".datepicker").datepicker({
      dateFormat: "dd.mm.yy",
      monthNames: [ "Січень", "Лютий", "Березень", "Квітень", "Травень", "Червень", "Липень", "Серпень", "Вересень", "Жовтень", "Листопад", "Грудень" ],
      dayNames: [ "Понеділок", "Вівторок", "Середа", "Четвер", "П'ятниця", "Субота", "Неділя" ],
      dayNamesMin: [ "Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Нд" ],
      dayNamesShort: [ "Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Нд" ],
      prevText: 'Попередній',
      nextText: 'Наступний',
      changeMonth: true,
      changeYear: true,
      //yearRange: '1900:2010',
    onSelect: function(){
      $input_wrap = $(this).closest(".input")
      $input_wrap.addClass("not-empty")
    }
  });


});