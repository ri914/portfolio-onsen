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

$(function() {
  setTimeout("$('.flash').fadeOut('slow')", 3000);
});

$(function() {
  setTimeout("$('.alert').fadeOut('slow')", 3000);
});

$(document).ready(function() {
  const $imageUpload = $('#image-upload');
  const $previewContainer = $('#image-preview');
  const $form = $('#onsen-form');
  const $waterQualityCheckboxes = $('input[name="onsen[water_quality_ids][]"]');

  let imageIndex = $('.img-container').length;
  const dataTransfer = new DataTransfer();

  $('.existing-image').each(function() {
    const imageId = $(this).data('id');
    const $imgContainer = $('<div class="img-container"></div>').attr('data-id', imageId);
    
    const $img = $('<img>', { src: $(this).find('img').attr('src'), class: 'img-preview' });
    $imgContainer.append($img);

    const $descriptionInput = $('<input>', {
      type: 'text',
      name: `onsen[descriptions][${imageId}]`,
      placeholder: '画像の説明',
      class: 'form-control mt-2 description-input',
      value: $(this).find('.description-input').val() || ''
    });
    $imgContainer.append($descriptionInput);

    const $removeBtn = $('<button>', {
      html: '&times;',
      class: 'remove-btn',
      click: function() {
        $('<input>').attr({
          type: 'hidden',
          name: 'onsen[remove_image_ids][]',
          value: imageId
        }).appendTo($form);
        $imgContainer.remove();
      }
    });
    $imgContainer.append($removeBtn);

    $previewContainer.append($imgContainer);
  });

  $imageUpload.on('change', function(event) {
    const files = Array.from(event.target.files);

    files.forEach((file) => {
      const reader = new FileReader();
      reader.onload = function(e) {
        const $imgContainer = $('<div class="img-container new-image"></div>').attr('data-index', imageIndex);
        
        const $img = $('<img>', { src: e.target.result, class: 'img-preview' });
        $imgContainer.append($img);

        const $descriptionInput = $('<input>', {
          type: 'text',
          name: 'onsen[new_descriptions][]',
          placeholder: '画像の説明',
          class: 'form-control mt-2 description-input'
        });
        $imgContainer.append($descriptionInput);

        const $removeBtn = $('<button>', {
          html: '&times;',
          class: 'remove-btn',
          click: function() {
            $imgContainer.remove();
            updateFileList(file);
          }
        });
        $imgContainer.append($removeBtn);

        $previewContainer.append($imgContainer);
        dataTransfer.items.add(file);
        $imageUpload[0].files = dataTransfer.files;

        imageIndex++;
      };
      reader.readAsDataURL(file);
    });
  });

  function updateFileList(fileToRemove) {
    const updatedFiles = Array.from(dataTransfer.files).filter(file => file.name !== fileToRemove.name);
    dataTransfer.items.clear();
    updatedFiles.forEach(file => dataTransfer.items.add(file));
    $imageUpload[0].files = dataTransfer.files;
  }

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

$(document).ready(function() {
  $('.save-button').on('click', function(event) {
    event.preventDefault();
    
    const onsenId = $(this).data('onsen-id');
    const form = $(`#bookmark-form-${onsenId}`);
    
    $.ajax({
      url: form.attr('action'),
      method: form.attr('method'),
      data: form.serialize(),
      headers: {
        'X-Requested-With': 'XMLHttpRequest'
      },
      success: function(data) {
        const button = $(`#bookmark-button-${onsenId}`);
        if (data.saved) {
          button.addClass('saved');
          button.find('i').removeClass('fa-bookmark-o').addClass('fa-bookmark');
        } else {
          button.removeClass('saved');
          button.find('i').removeClass('fa-bookmark').addClass('fa-bookmark-o');
        }
      },
      error: function(error) {
        console.error('Error:', error);
      }
    });
  });
});

$(document).ready(function() {
  $('.delete-onsen-btn').on('click', function(event) {
    if (!confirm('この温泉を削除しますか？')) {
      event.preventDefault();
    }
  });
});


$(document).ready(function() {
  $('.btn-primary, .search-button').on('click', function(event) {
    var keyword = $('.search-input').val().trim();

    if (keyword === '') {
      event.preventDefault();
      alert('キーワードを入力してください。');
    }
  });
});

$(document).ready(function() {
  const searchBtn = $('#search-btn');
  const guestLoginLink = $('#guest-login-link');

  if (searchBtn.length) {
    searchBtn.on('click', function(e) {
      const isGuest = searchBtn.data('guest') === false;
      const keyword = $('#search-keyword').val().trim();

      if (isGuest && keyword !== '') {
        e.preventDefault();
        const url = `/guest_login?keyword=${encodeURIComponent(keyword)}`;
        window.location.href = url;
      }
    });
  }
});

$(document).ready(function() {
  $('#detail-search-form').on('submit', function(e) {
    var keyword = $('#detail-search-form input[name="keyword"]').val().trim();
    var location = $('select[name="location"]').val(); 
    var waterQualityIds = $('input[name="water_quality_ids[]"]:checked').length;

    console.log("Keyword:", keyword);
    console.log("Location:", location);
    console.log("Water Quality IDs:", waterQualityIds);

    if (keyword === '' && (!location || location === '選択してください') && waterQualityIds === 0) {
      e.preventDefault();
      alert('キーワード、都道府県、または泉質のいずれかを入力してください。');
    }
  });
});
