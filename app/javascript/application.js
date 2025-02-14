var working = false;

$('.login').on('submit', function(e) {
  e.preventDefault();
  if (working) return;

  working = true;
  var $this = $(this);
  var $state = $this.find('button > .state');

  $this.addClass('loading');
  $state.html('Authenticating');

  setTimeout(function() {
    $this.addClass('ok');
    $state.html('Welcome back!');

    setTimeout(function() {
      $state.html('Log in');
      $this.removeClass('ok loading');
      working = false;
    }, 4000);
  }, 3000);
});

$(document).ready(function() {
  $('.file-input').on('change', function() {
    var input = this;
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function(e) {
        $('.current-avatar-container img').attr('src', e.target.result);
      };
      reader.readAsDataURL(input.files[0]);
    }
  });
});


$(function(){
  setTimeout("$('.flash').fadeOut('slow')", 3000);
});

$(function(){
  setTimeout("$('.alert').fadeOut('slow')", 3000);
});

$(document).ready(function() {
  const $imageUpload = $('#image-upload');
  const $previewContainer = $('#image-preview');
  const $form = $('#onsen-form');
  const $waterQualityCheckboxes = $('input[name="onsen[water_quality_ids][]"]');

  $imageUpload.on('change', function(event) {
    const files = event.target.files;

    for (let i = 0; i < files.length; i++) {
      const file = files[i];
      const reader = new FileReader();

      if (!file.type.startsWith('image/')) {
        alert('画像ファイルを選択してください。');
        continue;
      }

      reader.onload = function(e) {
        const $imgContainer = $('<div class="img-container"></div>');

        const $img = $('<img>', {
          src: e.target.result,
          class: 'img-preview'
        });

        $imgContainer.append($img);

        const $descriptionInput = $('<input>', {
          type: 'text',
          name: 'onsen[descriptions][]',
          placeholder: '画像の説明',
          class: 'form-control mt-2 description-input'
        });
        $imgContainer.append($descriptionInput);

        const $removeBtn = $('<button>', {
          html: '&times;',
          class: 'remove-btn',
          click: function() {
            $imgContainer.remove();
          }
        });
        $imgContainer.append($removeBtn);

        $previewContainer.append($imgContainer);
      };

      reader.readAsDataURL(file);
    }
  });

  $form.on('submit', function(event) {
    const anyChecked = $waterQualityCheckboxes.is(':checked');

    if (!anyChecked) {
      event.preventDefault();
      alert('泉質を選択してください。');
      $waterQualityCheckboxes.first().focus();
    }
  });
});
