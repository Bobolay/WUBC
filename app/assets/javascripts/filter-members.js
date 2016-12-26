$('#selectize-field-1, #selectize-field-2, #selectize-field-3, #selectize-field-4').change(function() {
  var filter = $(this).val()
  filterList_1(filter);
  filterList_2(filter);
  filterList_3(filter);
  filterList_4(filter);
});

function filterList_1(value) {
  var list = $(".members-grid .square");
  $(list).addClass("hide");
  if (value == "all") {
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