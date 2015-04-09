$ ->
  $image      = $('.new #image-rotation-box img')
  $remote_url = $('input[type="hidden"].image_url')

  imageAttached = ->
    url = $remote_url.val()
    $image.prop('src', url) if url
    $('#image-editor').trigger('imageDidShow')

  $remote_url.on 'imageFileAdded', imageAttached

  logData = (data) ->
    $('#user_image_angle').val(data.angle)
    $('#user_image_scale').val(data.scale)
    $('#user_image_w').val(data.w)
    $('#user_image_h').val(data.h)
    $('#user_image_x').val(data.x)
    $('#user_image_y').val(data.y)

  $('[data-action]').on 'click', (e) ->
    e.preventDefault()
    $image.guillotine $(this).data('action')

  $image.on 'imageDidChange', (e, data, action) -> logData(data)

  $image.on 'load', ->
    $image.guillotine 'remove'
    $image.guillotine { width: 180, height: 180, eventOnChange: 'imageDidChange' }
    $image.guillotine 'fit'

    logData $image.guillotine('getData')

    $('#image-editor .progress').hide()
    $image.closest('#image-rotation-box').show()

  if $remote_url.val() && $remote_url.val().length
    $remote_url.trigger('imageFileAdded')
  else if $("#image-editor").data('show')
    $image.trigger('load')
    $("#image-editor").show()