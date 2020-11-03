document.addEventListener('turbolinks:load', function (event) {
  $('.countdown-timer.open').change(function (e) {
    const raw = $(e.target).data('finishes-at')
    const finishesAt = Date.parse(raw)
    const current = new Date().getTime()

    let totalSeconds = Math.round((finishesAt - current) / 1000)

    if (totalSeconds < -2 && totalSeconds > -5) {
      location.reload()
    }

    if (totalSeconds < 0) { totalSeconds = 0 }

    const minutes = Math.floor(totalSeconds / 60)
    const seconds = totalSeconds - (60 * minutes)

    $(e.target).find('.countdown-min').text(('00' + minutes).slice(-2))
    $(e.target).find('.countdown-sec').text(('00' + seconds).slice(-2))
  })

  setInterval(function () { $('.countdown-timer').change() }, 1000)
})