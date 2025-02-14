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
    const files = Array.from(event.target.files);

    $previewContainer.empty();

    const promises = files.map((file) => {
      return new Promise((resolve, reject) => {
        const reader = new FileReader();

        reader.onload = function(e) {
          resolve(e.target.result);
        };

        reader.onerror = function() {
          reject(new Error('File reading error'));
        };

        reader.readAsDataURL(file);
      });
    });

    Promise.all(promises)
      .then((results) => {
        results.forEach((result, index) => {
          const $imgContainer = $('<div class="img-container"></div>');

          const $img = $('<img>', {
            src: result,
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
        });
      })
      .catch((error) => {
        console.error(error);
      });
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

$(document).ready(function() {
  $('.post-link').on('click', function(event) {
    if ($(this).data('guest') === true) {
      alert("ゲストユーザーは投稿フォームにアクセスできません。");
      event.preventDefault();
    }
  });

  $('.btn-post-onsen').on('click', function(event) {
    if ($(this).data('guest') === true) {
      alert("ゲストユーザーは投稿フォームにアクセスできません。");
      event.preventDefault();
    }
  });

  $('.user-dropdown-link').on('click', function(event) {
    if ($(this).data('guest') === true) {
      alert("ゲストユーザーはこの機能を使用できません。");
      event.preventDefault();
    }
  });

  $('.edit-link').on('click', function(event) {
    if ($(this).data('guest') === true) {
      alert("ゲストユーザーはこの機能を使用できません。");
      event.preventDefault();
    }
  });
});
