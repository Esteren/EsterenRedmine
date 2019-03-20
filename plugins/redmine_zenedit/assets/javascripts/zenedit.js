function jsZenEdit(textArea, title, placeholder, previewURL, usersAutocompleteURL) {
  if (!document.createElement) { return; }

  if (!textArea) { return; }

  if ((typeof(document["selection"]) == "undefined")
  && (typeof(textArea["setSelectionRange"]) == "undefined")) {
    return;
  }

  this.$textArea = $(textArea);
  this.$textArea.attr('placeholder', placeholder);

  var $jstEditor = this.$textArea.parent('.jstEditor');
  this.$toolBar = $jstEditor.prev('.jstElements');

  var that = this;

  // Add the theme button
  var $themeButton = $('<button type="button" tabindex="200" class="jstb_zenedit theme"></button>');
  $themeButton.attr('title', title || 'Zen');
  $jstEditor.append($themeButton);
  $themeButton.on('click', function () {
    try {
      $jstEditor.toggleClass('dark-theme');
      that.$textArea.focus();
    } catch (e) {}
    return false;
  });

  // Add Zen button
  var $zenButton = $('<button type="button" tabindex="200" class="jstb_zenedit"></button>');
  $zenButton.attr('title', title || 'Zen');
  $jstEditor.append($zenButton);
  $zenButton.on('click', function () {
    try {
      $jstEditor.toggleClass('zen');
      $jstEditor.siblings('.jstElements').toggleClass('zen');
      that.$toolBar.removeAttr("style");
      that.$textArea.removeAttr("style");
      $('#zenPreview').remove();
      $('html').toggleClass('zen');
      that.$textArea.focus();
    } catch (e) {}
    return false;
  });

  // Add listener for "escape" key
  document.onkeydown = function (evt) {
    evt = evt || window.event;
    if (evt.keyCode == 27) {
      var $jstElements = $('.jstElements.zen').removeClass('zen');
      $jstElements.removeAttr("style");

      var $jstEditor = $('.jstEditor.zen');
      $jstEditor.removeClass('zen');

      var $textArea = $jstEditor.find('textarea');
      $textArea.removeAttr("style");
      $textArea.focus();

      $('html.zen').removeClass('zen');
      $('#zenPreview').remove();
    }
  };
}
