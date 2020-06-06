document.addEventListener('DOMContentLoaded', function (event) {
  function updateCounterFromRange (range) {
    $(range).parent().find('.counter').text(range.value)

    const question = $(range).parents('.question')
    const totalValue = question.find('.custom-range')
      .map(function (i, e) { return e.value })
      .toArray()
      .reduce(function (acc, v) { return acc + parseInt(v) }, 0)
    question.find('.total-votes-counter').text(totalValue + '/' + question.find('.total-votes-counter').data('total'))
  }

  $('.custom-range').change(function (e) {
    updateCounterFromRange(e.target)
  })

  $('.custom-range').change()
})
