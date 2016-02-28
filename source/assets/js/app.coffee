sizeImage = () ->
  $(".media").each( () ->
    mediaImage = $(this).find('.image-container')
    mediaContent = $(this).find('.content-block')
    offset = 10
    if mediaImage.hasClass('image-container-left')
      contentPadding = parseInt(mediaContent.css('padding-left'), 10)
      mediaContent.css('padding-left', mediaImage.width() + offset + 'px')
    else if mediaImage.hasClass('image-container-right')
      contentPadding = parseInt(mediaContent.css('padding-right'), 10)
      mediaContent.css('padding-right', mediaImage.width() + offset + 'px')
  )
(($) ->
  $(window).on('load', () ->
    sizeImage()
  )
  $(window).on('resize', () ->
    sizeImage()
  )
)(jQuery)
