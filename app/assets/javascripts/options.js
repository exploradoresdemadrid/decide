document.addEventListener("DOMContentLoaded", function(event) {
  function updateCounterFromRange(range){
    $(range).parent().find(".counter").text(range.value);
  }

  $(".custom-range").change(function(e){
    updateCounterFromRange(e.target);
  });

  $(".custom-range").change();
});