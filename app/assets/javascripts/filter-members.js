$('#selectize-field-1').change(function() {
  var filter = $(this).val()
  filterList_1(filter);
});

$('#selectize-field-2').change(function() {
  var filter = $(this).val()
  filterList_2(filter);
});

$('#selectize-field-3').change(function() {
  var filter = $(this).val()
  filterList_3(filter);
});

$('#selectize-field-4').change(function() {
  var filter = $(this).val()
  filterList_4(filter);
});

function filterList_1(value) {
  var list = $(".members-grid .square");
  $(list).addClass("hide");
  if (value == "all" || value == "" ) {
    $(".members-grid").find(".square").each(function (i) {
      $(this).removeClass("hide");
    });
  } else {
    $(".members-grid").find(".square[data-name*=" + value + "]").each(function (i) {
      $(this).removeClass("hide");
    });
  }
}

function filterList_2(value) {
  var list = $(".members-grid .square");
  $(list).addClass("hide");
  if (value == "all") {
    $(".members-grid").find(".square").each(function (i) {
      $(this).removeClass("hide");
    });
  } else {
    $(".members-grid").find(".square[date-industries*=" + value + "]").each(function (i) {
      $(this).removeClass("hide");
    });
  }
}

function filterList_3(value) {
  var list = $(".members-grid .square");
  $(list).addClass("hide");
  if (value == "all") {
    $(".members-grid").find(".square").each(function (i) {
      $(this).removeClass("hide");
    });
  } else {
    $(".members-grid").find(".square[date-regions*=" + value + "]").each(function (i) {
      $(this).removeClass("hide");
    });
  }
}

function filterList_4(value) {
  var list = $(".members-grid .square");
  $(list).addClass("hide");
  if (value == "all") {
    $(".members-grid").find(".square").each(function (i) {
      $(this).removeClass("hide");
    });
  } else {
    $(".members-grid").find(".square[data-companies*=" + value + "]").each(function (i) {
      $(this).removeClass("hide");
    });
  }
}